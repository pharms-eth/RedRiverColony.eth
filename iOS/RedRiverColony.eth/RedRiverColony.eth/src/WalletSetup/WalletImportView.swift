//
//  WalletImportView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI
import Web3Core
struct WalletImportView: View {
    @Binding public var ethWallet: AbstractKeystore?
    @StateObject private var viewModel = WalletImportViewModel()
    @Environment(\.dismiss) var dismiss

    init(wallet: Binding<AbstractKeystore?>) {
        #if os(iOS)
        UITextView.appearance().backgroundColor = .clear // First, remove the UITextView's backgroundColor.
        #endif
        _ethWallet = wallet
    }

    var body: some View {
        VStack(alignment: .center, spacing: nil) {
            Text("Import Account")
                .padding(10)
                .foregroundColor(Color.secondaryOrange)
                .font(.system(size: 24.0, weight: .heavy))
            VStack {
                Text("Seed Phrase/Private Key")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.secondaryOrange)
                if let errorMessage = viewModel.error {
                    Text(errorMessage)
                        .importCard()
                        .foregroundColor(Color.secondaryOrange)
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Import Type")
                        if let importTYpe = viewModel.source {
                            Text(importTYpe.rawValue)
                        }
                    }
                        .foregroundColor(Color.secondaryOrange)
                        .font(.system(size: 12, weight: .light))
                        .padding(.bottom, 2)
                    TextEditor(text: $viewModel.editText)
                        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                        .background(Color.textBackground)
                        .foregroundColor(Color.textForeground)
                }
                .importCard()

                Spacer()

                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor( .primaryOrange)
                    .importCard()
            }
            .padding(.horizontal, 24)

//            if viewModel.showPasswordEntry {
                WalletTextField(label: "Password", text: $viewModel.password1Text, validate: false)
                .importCard()
                .textContentType(.password)

                WalletTextField(label: "Confirm Password", text: $viewModel.password2Text, validate: false)
                .importCard()
                #if os(iOS)
                .textContentType(.newPassword)
                #endif
//            }

            HStack {
                Text("sign in with face ID")
                    .foregroundColor(Color.secondaryOrange)
                    .font(.system(size: 16, weight: .heavy))
                Spacer()
                Toggle("Face ID", isOn: $viewModel.faceIsOn)
                    .tint(Color.primaryOrange)
                            .labelsHidden()
//                            .onChange(of: viewModel.faceIsOn) { newValue in
//                                guard newValue else { return }
//                                let context = LAContext()
//                                var error: NSError?
//
//                                // check whether biometric authentication is possible
//                                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//                                    // it's possible, so go ahead and use it
//                                    let reason = "We need to unlock your data."
//
//                                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                                        // authentication has now completed
//                                        if !success {
//                                            // there was a problem
//                                            DispatchQueue.main.async {
//                                                viewModel.faceIsOn = false
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    // no biometrics
//                                }
//                            }
            }
            .importCard()
            Spacer()
            WalletButton(title: "Import") {
                Task {
                    let newWallet = await viewModel.importWallet()
                    DispatchQueue.main.async {
                        ethWallet = newWallet
                    }
                    dismiss()
                }
            }
            .padding(.bottom, 42)
        }
        .background(Color.background)
    }
}
