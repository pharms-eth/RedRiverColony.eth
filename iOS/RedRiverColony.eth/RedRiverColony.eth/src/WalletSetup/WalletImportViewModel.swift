//
//  WalletImportViewModel.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import Foundation
import Combine
import Web3Core
class WalletImportViewModel: ObservableObject {

    enum ImportSource: String {
        case seed = "Seed Phrase"
        case privateKey = "Private Key"
    }

    @Published var error: String?
    @Published var editText: String = ""
    @Published var password1Text: String = ""
    @Published var password2Text: String = ""
    @Published var faceIsOn = false
    @Published var source: ImportSource?
    var textCancellable: AnyCancellable?

    public init() {
        textCancellable = $editText.sink { value in
            self.source = self.sourceType(from: value)
        }
    }

    func sourceType(from value: String) -> ImportSource? {
        guard !value.isEmpty else {
            return nil
        }

        if value.count >= 64 && isHexStringIgnorePrefix(value: value) {
            return .privateKey
        } else if isValidSeedPhrase(value) {
            return .seed
        }

        return nil
    }

    func isHexStringIgnorePrefix(value: String) -> Bool {
        guard !value.isEmpty else {
            return false
        }
        let updatedValue = value.hasPrefix("0x") ? value : "0x" + value
        return isHexString(value: updatedValue)
    }

    func isHexString(value: String) -> Bool {
        value.range(of: #"^0x[0-9A-Fa-f]*$"#, options: .regularExpression) != nil
    }

    func isValidSeedPhrase(_ seedPhrase: String) -> Bool {
        let sanitizedSeedPhrase = seedPhrase.components(separatedBy: .whitespacesAndNewlines)
        return sanitizedSeedPhrase.count >= 12 && isValidMnemonic(sanitizedSeedPhrase)
    }

    func isValidMnemonic(_ mnemonic: [String]) -> Bool {
        mnemonic.map { value in BIP39Language.english.words.contains(value)}.filter { $0 }.count == 12
    }

    func isValidAddress(_ address: String) -> Bool {
        address.range(of: #"^0x[0-9a-fA-F]{40}$"#, options: .regularExpression) != nil
    }

    let supportedUnstoppableDomains = ["888", "bitcoin", "coin", "crypto", "dao", "nft", "wallet", "x", "zil"]
    func isUnstoppableAddress(_ address: String) -> Bool {
        hasTLDs(address: address, tlds: supportedUnstoppableDomains)
    }

    func isENSAddress(_ address: String) -> Bool {
        hasTLDs(address: address, tlds: ["eth"])

    }

    func hasTLDs(address: String, tlds: [String]) -> Bool {
        guard let addressURL = URL(string: address) else { return false }
        let host = addressURL.path
        guard let parts = host.split(separator: ".").last?.lowercased() else { return false }

        return tlds.contains(parts)
    }

    func importWallet() async -> AbstractKeystore? {
        var password: String?

//        editText = "5be307eed5a14f93eccb720abb9febaeeefcae43609566920ac573864fe294e0"
//        editText = "goddess cook glass fossil shrug tree rule raccoon useless phone valley frown"

        if !password1Text.isEmpty && !password2Text.isEmpty {
            if password1Text != password1Text {
                DispatchQueue.main.async {
                    self.error = "It looks like you attempted to create a password, please complete"
                }
                return nil
            } else {
                password = password1Text
            }
        } else if !password1Text.isEmpty || !password2Text.isEmpty {
            DispatchQueue.main.async {
                self.error = "It looks like you attempted to create a password, please complete or clear"
            }
            return nil
        }

        let accountSource = sourceType(from: editText)
        DispatchQueue.main.async {
            self.source = accountSource
        }
        guard let keySource = accountSource else { return nil }
        switch keySource {
        case .seed:
            return importWalletWithMnemonics(password: password ?? "web3swift")
        case .privateKey:
            return importWalletWithPrivateKey(password: password ?? "web3swift")
        }
    }

    func importWalletWithPrivateKey(password: String = "web3swift") -> AbstractKeystore? {

        let privateKey = editText

        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataKey = Data.fromHex(formattedKey) else {
            self.error = "Please enter a valid Private key"
            return nil
        }

        do {
            guard let keystore =  try EthereumKeystoreV3(privateKey: dataKey, password: password) else {
                self.error = "Please enter correct Private key"
                return nil
            }

            guard (try? JSONEncoder().encode(keystore.keystoreParams)) != nil, keystore.addresses?.first != nil else {
                return nil
            }

            return keystore
        } catch {
            self.error = "Please enter correct Private key"
        }

        return nil
    }

    func importWalletWithMnemonics(password: String = "web3swift") -> AbstractKeystore? {
        let mnemonics = editText.components(separatedBy: .whitespaces)

        guard
            let bip32keystore = try? BIP32Keystore(mnemonicsPhrase: mnemonics, password: password, prefixPath: "m/44'/77777'/0'/0"),
            ((try? JSONEncoder().encode(bip32keystore.keystoreParams)) != nil),
            bip32keystore.addresses?.first != nil
        else {
            return nil
        }

        return bip32keystore
    }
}
