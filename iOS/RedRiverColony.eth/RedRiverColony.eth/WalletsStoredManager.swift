//
//  WalletsStoredManager.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 9/6/23.
//


import Foundation
import web3swift
import Web3Core
import Combine
import SwiftData

class WalletsStoredManager: NSObject, ObservableObject {

//    let container = try? ModelContainer(for: Keystore.self, KdfParams.self, CryptoParams.self, CipherParams.self, Address.self, configurations: ModelConfiguration())

    @Published var wallet: AbstractKeystore?
    @Published var currentWallet: AbstractKeystoreParams?
    @Published var wallets: [Keystore]?

    private var cancellables: [AnyCancellable] = []

    override init() {
//        fetchRequest.fetchBatchSize = 10
//
//        let sort = NSSortDescriptor(key: #keyPath(Keystore.version), ascending: true)
//        fetchRequest.sortDescriptors = [sort]
//
//        super.init()
//        Task {
//            await fetchWallets()
//        }
//
//
//        $wallet.sink { newWallet in
//            guard let newWallet = newWallet else {
//                return
//            }
//            Task {
//                await self.save(keystore: newWallet)
//                await self.fetchWallets()
//            }
//        }
//        .store(in: &cancellables)

    }

    func setCurrent(keystore: Keystore) {

        let keystoreVersion = keystore.version

        guard let keystoreID = keystore.id,
              let keystoreCrypto = keystore.crypto,
              let keystoreCipher = keystore.crypto?.cipherparams,
              let keystoreKdf = keystore.crypto?.kdfparams else {
            return
        }

        let kdf = KdfParamsV3(salt: keystoreKdf.salt ?? "",
                              dklen: Int(keystoreKdf.dklen ?? .zero),
                              n: Int(keystoreKdf.n ?? .zero),
                              p: Int(keystoreKdf.p ?? .zero),
                              r: Int(keystoreKdf.r ?? .zero),
                              c: Int(keystoreKdf.c ?? .zero),
                              prf: keystoreKdf.prf)

        let crypto = CryptoParamsV3(ciphertext: keystoreCrypto.ciphertext ?? "",
                                    cipher: keystoreCrypto.cipher ?? "",
                                    cipherparams: CipherParamsV3(iv: keystoreCipher.iv ?? ""),
                                    kdf: keystoreCrypto.kdf ?? "",
                                    kdfparams: kdf,
                                    mac: keystoreCrypto.mac ?? "",
                                    version: keystoreCrypto.version)

        if keystore.isHDWallet ?? false {
            var crrnt = KeystoreParamsBIP32(crypto: crypto, id: keystoreID, version: Int(keystoreVersion ?? 32), rootPath: keystore.rootPath)

            let addressValues: [PathAddressPair] = (keystore.address ?? []).compactMap {
                guard let path = $0.path, let address = $0.address else { return nil }
                return PathAddressPair(path: path, address: address)
            }
            crrnt.pathAddressPairs = addressValues

            self.currentWallet = crrnt

        } else {
            let addressValue: Address? = keystore.address?.first(where: { $0.address != nil })

            let crrnt = KeystoreParamsV3(address: addressValue?.address, crypto: crypto, id: keystoreID, version: Int(keystoreVersion ?? 32))
            self.currentWallet = crrnt
        }

    }

    func save(keystore addr: AbstractKeystore, mc: ModelContext) {
        let model: AbstractKeystoreParams? = (addr as? BIP32Keystore)?.keystoreParams ?? (addr as? EthereumKeystoreV3)?.keystoreParams
        guard let model  else {
            fatalError("Failed to build wallet")
        }
        guard KeyChain().store(wallet: addr) else {
            return
        }

        let addressBIP32 = (model as? KeystoreParamsBIP32)?.pathAddressPairs.compactMap({ EthereumAddress($0.address) != nil ? $0 : nil }).first
        var addressV3: PathAddressPair? = nil

        if let address = (model as? KeystoreParamsV3)?.address {
            addressV3 = PathAddressPair(path: "", address: address)
        }
        guard let address = addressBIP32 ?? addressV3  else {
            return
        }

        let newWallet = Keystore()
        newWallet.isHDWallet = model.isHDWallet
        newWallet.version = Int16(model.version)
        newWallet.id = model.id
        newWallet.rootPath = (model as? KeystoreParamsBIP32)?.rootPath

        let newCrypto = CryptoParams()
        newCrypto.ciphertext = model.crypto.ciphertext
        newCrypto.cipher = model.crypto.cipher
        newCrypto.kdf = model.crypto.kdf
        newCrypto.mac = model.crypto.mac
        newCrypto.version = model.crypto.version
        newCrypto.keystore = newWallet

        let cipherparams = model.crypto.cipherparams
        let kdfparams = model.crypto.kdfparams

        let newCipher = CipherParams()
        newCipher.crypto = newCrypto
        newCipher.iv = cipherparams.iv

        let newKDFParams = KdfParams()
        newKDFParams.crypto = newCrypto
        newKDFParams.c = Int64(kdfparams.c ?? 0)
        newKDFParams.dklen = Int64(kdfparams.dklen)
        newKDFParams.n = Int64(kdfparams.n ?? 0)
        newKDFParams.p = Int64(kdfparams.p ?? 0)
        newKDFParams.prf = kdfparams.prf
        newKDFParams.r = Int64(kdfparams.r ?? 0)
        newKDFParams.salt = kdfparams.salt

        let newAddress = Address()
        newAddress.address = address.address
        newAddress.path = address.path

        newWallet.address?.append(newAddress)

        mc.insert(newWallet)
    }

    func fetchWallets(mc: ModelContext) {

        var descriptor = FetchDescriptor<Keystore>()
        //                //        fetchRequest.predicate
        //                //        fetchRequest.sortDescriptors
//        let tripName = trip.name
//        let upcomingTrips = FetchDescriptor<Trip>(
//            predicate: #Predicate { $0.startDate > Date.now },
//            sort: \.startDate
//        )
//        upcomingTrips.fetchLimit = 50
//        upcomingTrips.includePendingChanges = true
//        descriptor.predicate = #Predicate { item in
//            item.title.contains(searchText) && tripName == item.trip?.name
//        }
        let directKeystores = try? mc.fetch(descriptor)

        DispatchQueue.main.async {
            self.wallets = directKeystores
            if (directKeystores?.isEmpty ?? true) {
                self.wallet = nil
            }
        }

    }

    func deleteKeystores(at offsets: IndexSet, mc: ModelContext) {

        offsets.forEach { offset in
            guard let keyStore = self.wallets?[offset] else {
                return
            }
            mc.delete(keyStore)
        }

        try? mc.save()

        fetchWallets(mc: mc)
        if wallets?.isEmpty ?? true {
            wallet = nil
        }
    }

    func delete(keyStore: Keystore, mc: ModelContext) {
        mc.delete(keyStore)
        fetchWallets(mc: mc)
        if wallets?.isEmpty ?? true {
            wallet = nil
        }
    }

}
