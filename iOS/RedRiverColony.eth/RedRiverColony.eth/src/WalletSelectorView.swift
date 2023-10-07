//
//  WalletSelectorView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 9/29/23.
//

import SwiftUI
import Web3Core


struct WalletSelectorView: View {
    @Binding var account: Wallet.Address?
    @Binding var wallet: AbstractKeystore?
    enum WalletSource {
        case importKey
        case create
    }
    @State private var path: [WalletSource] = []
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack(alignment: .leading) {
                    Text("Your Asset, Your Style")
                        .font(.subheadline)
                        .padding(.bottom)
                    Text("Select your style of asset management: ")
                        .font(.title2)
                    Text("Choose a trusted external wallet, tailored for the seasoned crypto citizen who doesn’t compromise on security, or choose our sleek embedded wallet, ideal for crypto newcomers or returnees. It's more than asset management—it's a blend of quality and simplicity, ensuring a seamless, secure experience.")
                        .font(.body)
                }
                .padding([.leading,.top])
                .navigationTitle("Wallet Choice" )
                Spacer()
                if let walletViewModel = wallet {
                    Text(walletViewModel.addresses?.first?.address ?? "--")
                } else {
                    Text("Choose Embedded Wallet")
                        .font(.title2)
                    VStack {
                        NavigationLink(value: WalletSource.importKey) {
                            WalletSetupStyledButton(title: "Import Your Wallet", background: Color(red: 32/255, green: 40/255, blue: 50/255))
                        }
                        NavigationLink(value: WalletSource.create) {
                            WalletSetupStyledButton(title: "Create a New Wallet", background: Color.primaryOrange)
                        }
                    }
                    .padding(.bottom, 56)
                    .navigationDestination(for: WalletSource.self) { source in
                        switch source {
                            case .create:
                                WalletCreateView(ethWallet: $wallet)
                            case .importKey:
                                WalletImportView(wallet: $wallet)
                        }
                    }
                }
                Text("Choose External Wallet")
                    .font(.title2)
                ConnectWalletButton(account: $account)
                    .padding()
                    .background(Color.ethereumLightBlue)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .tint(.primaryOrange)
    }
}
