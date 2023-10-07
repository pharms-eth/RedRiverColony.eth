////
////  WalletSetupMenuView.swift
////  RedRiverColony.eth
////
////  Created by Daniel Bell on 9/29/23.
////
//
//import SwiftUI
//import Web3Core
//
//struct WalletSetupMenuView: View {
//
//    @State private var showingCreatePopover = false
//    @State private var showingImportPopover = false
//    @Binding public var wallet: AbstractKeystore?
//
//    var body: some View {
//        if let wallet {
//            Text(wallet.addresses?.first?.address ?? "")
//        } else if showingImportPopover {
//            WalletImportView(wallet: $wallet, showView: $showingImportPopover)
//        } else if showingCreatePopover {
//            WalletCreateView(ethWallet: $wallet, showView: $showingCreatePopover)
//        } else {
//            VStack {
//                WalletSetupStyledButton(showingPopover: $showingImportPopover, title: "Import Your Wallet", background: Color(red: 32/255, green: 40/255, blue: 50/255))
//
//                WalletSetupStyledButton(showingPopover: $showingCreatePopover, title: "Create a New Wallet", background: Color.primaryOrange)
//            }
//            .padding(.bottom, 56)
//        }
//
//    }
//}
