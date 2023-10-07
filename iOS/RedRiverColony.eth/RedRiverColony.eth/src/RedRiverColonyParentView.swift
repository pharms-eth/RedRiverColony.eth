//
//  RedRiverColonyParentView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/6/23.
//

import SwiftUI
import SwiftData

struct RedRiverColonyParentView: View {
    enum Features {
        case settings
        case home
    }

    @Environment(\.modelContext) private var mc
    @Query(sort: \Keystore.nickName, order: .forward) private var keystores: [Keystore]
    @State var mainFeature: Features = .home
    @State var account: Wallet.Address?
    @StateObject private var viewModel = WalletsStoredManager()

    var hasSelectedWallet: Bool {
        return viewModel.wallet != nil || !keystores.isEmpty
    }

    var body: some View {
        if !hasSelectedWallet {
            WalletSelectorView(account: $account, wallet: $viewModel.wallet)
        } else {
            switch mainFeature {
                case .settings:
                    VStack {
                        Text("Home")
                            .onTapGesture {
                                mainFeature = .home
                            }
                        if account != nil {
                            VStack {
                                Text("account found")
                                WalletLinkedView(account: $account)
                            }
                        } else {
                            VStack {
                                Text("Get Started")
                                Text("Passport/Pocket")
                                List {
                                    ForEach(keystores) {
                                        Text($0.nickName ?? "--")
                                    }.onDelete { indexSet in
                                        for index in indexSet {
                                            mc.delete(keystores[index])
                                        }
                                    }
                                }
                                Text("External/Third party")
                                ConnectWalletButton(account: $account)
                                    .padding()
                                    .background(Color.ethereumLightBlue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                case .home:
                    VStack {
                        Text("Settings")
                            .onTapGesture {
                                mainFeature = .settings
                            }
                        List {
                            ForEach(keystores) { keystore in
                                VStack {
                                    Text(keystore.nickName ?? "--")
                                    HStack {
                                        Text(keystore.rootPath ?? "--")
                                        Text(keystore.address?.first?.address ?? "--")
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    mc.delete(keystores[index])
                                }
                            }
                        }
                    }
            }
        }
    }
}
#Preview {
    RedRiverColonyParentView()
}
