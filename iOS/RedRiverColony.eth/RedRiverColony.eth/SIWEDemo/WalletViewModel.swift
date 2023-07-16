////
////  WalletViewModel.swift
////  RedRiverColony.eth
////
////  Created by Daniel Bell on 3/19/23.
////
//
//import Foundation
//import ExSoul_Eth
//import Web3Core
//import web3swift
//
//class WalletViewModel: ObservableObject {
//    private var web3: Web3?
//    @Published var expectedAddress: EthereumAddress? = nil
//    @Published var chainId: Int? = nil
//    @Published var showLoading: Bool = false
//
//    init(web3: Web3? = nil) {
//        self.web3 = web3
//        chainId = 1
//
//        Task {
//            self.web3 = try? await Web3.new(URL(string: "http://127.0.0.1:8545")!)
//        }
//
//    }
//
//    func createAccount() {
//        showLoading = true
//        let tempKeystore = try! EthereumKeystoreV3(password: "")
//        let keystoreMgr = KeystoreManager([tempKeystore!])
//        web3?.addKeystoreManager(keystoreMgr)
//        showCurrentAddress()
//    }
//
//    func showCurrentAddress() {
//        let keystoreManager = web3?.provider.attachedKeystoreManager
//        expectedAddress = keystoreManager?.addresses?[0]
//        showLoading = false
//    }
//
//    func sign(message: SIWEMessage, password: String = "") async throws -> String? {
//        guard let web3 = web3 else {
//            return nil
//        }
//        guard let expectedAddress else { return nil }
//
//        let personalMessage = try message.toMessage()
//        guard let data = personalMessage.data(using: .utf8) else {
//            return nil
//        }
//        let signature = try await web3.personal.signPersonalMessage(message: data, from: expectedAddress, password: password)
//        return signature.toHexString().addHexPrefix()
//    }
//
//}
