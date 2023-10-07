//
//  WalletCreateViewModel.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import Foundation
import Web3Core
import SwiftData

class WalletCreateViewModel: ObservableObject {
    @Published var password1 = "web3swift_0"
    @Published var password2 = "web3swift_0"

    @Published var iCloudOn = true
    @Published var faceIDOn = true

    @Published var progress: EllipticalProgress.Progress = .start
    @Published var phase: WalletCreateView.CreationPhase = .password
    @Published var seedAck = false
    @Published var creatingWalletInProgress = false
    @Published var showPasswordEntry = true//KeyChain().getWalletData() == nil

    public var seedPhrase: [String] = []
    private var creatingWallet: Bool = false
    private var viewModel = WalletsStoredManager()
    public var wallet: AbstractKeystore?

    func setPhase(_ phase: WalletCreateView.CreationPhase, with mc: ModelContext?) {
        switch phase {
        case .password:
            progress = .start
            self.phase = phase
        case .seedRetrieve:
            guard !password1.isEmpty else {
                passwordError = "password is empty"
                return
            }

            guard password1 == password2 else {
                passwordError = "passwords do not match"
                return
            }

            let password = password1

            guard validate(password: password) else {
                return
            }
            generateSeed()
            progress = .mid
            self.phase = phase
        case .seedConfirmation:
            progress = .mid
            self.phase = phase
        case .creationSuccess:
            progress = .end
            creatingWallet = true
            creatingWalletInProgress = true
            accountCreation(phase: phase, with: mc)
        }
    }

    func accountCreation(phase: WalletCreateView.CreationPhase, with mc: ModelContext?) {
        guard creatingWallet else {
            return
        }
        creatingWallet = false
        do {
            try createAccountWallet()
            if let mc = mc {
                saveAccount(with: mc)
            }
            creatingWallet = false
            creatingWalletInProgress = false
            self.phase = phase
        } catch let error {
            print(error)
        }
    }

    func saveAccount(with mc: ModelContext) {
        guard let walletViewModel = wallet else { return }
        viewModel.save(keystore: walletViewModel, mc: mc)
    }

    func generateSeed() {
        seedPhrase = (try? BIP39.generateMnemonics(entropy: 128)) ?? []
    }

    enum WalletInitialization: Error {
        case passwordFailed
    }
    func createAccountWallet() throws {
        guard !password1.isEmpty else {
            throw WalletInitialization.passwordFailed
        }

        guard password1 == password2 else {
            throw WalletInitialization.passwordFailed
        }

        let password = password1

        guard validate(password: password) else {
            throw WalletInitialization.passwordFailed
        }
        guard let keystore = try? BIP32Keystore(mnemonicsPhrase: seedPhrase, password: password, mnemonicsPassword: "", language: .english) else {
            fatalError("Failed to build wallet")
        }

//============================================================
        // TODO: Store Face ID
        // TODO: Cleanup Face ID code
//============================================================
        // TODO: save password to keychain or sign in with apple object

        self.wallet = keystore

    }

    var passwordError: String?
    func validate(password: String) -> Bool {

        guard !password.isEmpty else {
            passwordError = nil
            return false
        }

        //At least 8 characters
        if password.count < 8 {
            passwordError = "Must Be Min Length 8"
            return false
        }

        //At least one digit
        if password.range(of: #".*[0-9]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 digit"
            return false
        }

        //At least one letter
        if password.range(of: #".*[a-zA-Z]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 Letter"
            return false
        }

        //At least one special Character
        if password.range(of: #".*[!&^%$#@()._-]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 of !&^%$#@()._-"
            return false
        }

        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            passwordError = "Must Not Contain Spaces"
            return false
        }

        passwordError = nil
        return true
    }
}
