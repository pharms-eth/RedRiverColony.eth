//
//  ContentView.swift
//  testWalletConnectCompBuild
//
//  Created by Daniel Bell on 4/10/23.
//

import SwiftUI

struct ConnectWalletSheetView: View {
    enum WalletAction: String, CaseIterable, Identifiable  {
        case switchChain
        case addChain
        var id: String {
            self.rawValue
        }
    }

    @State private var actions: [WalletAction] = [.switchChain, .addChain]
    @StateObject private var walletLinkViewModel = WalletLinkerViewModel()
    @Binding var account:  Wallet.Address?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ConnectWalletSheetHeaderView()
            Divider()
            ConnectWalletSheetWalletsView(walletLinkViewModel: walletLinkViewModel)
            Divider()
            List(actions) { action in
//TODO: complete
//TODO: PixelQuantum
                if action == .addChain {
                    Text("hello")
                } else if action == .switchChain {
                    Text("hello")
                } else {
                    Text("hello")
                }
            }
            .listStyle(.insetGrouped)
            Spacer()
        }
        .background {
            Color(UIColor.systemGroupedBackground)
        }
        .onChange(of: walletLinkViewModel.account) { newValue in
            guard let newValue else {
                return
            }
            self.account = newValue
        }
    }
}

struct ConnectWalletSheetWalletsView: View {
    @ObservedObject var walletLinkViewModel: WalletLinkerViewModel

    var body: some View {
        ScrollView(.horizontal) {
            //TODO: PixelQuantum
            HStack(spacing: 25) {
                VStack(spacing: 6) {
                    AsyncImage(url: walletLinkViewModel.wallet.iconUrl) { img in
                        img
                            .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(maxWidth: 60, maxHeight: 60, alignment: .center)
                    } placeholder: {
                        Rectangle()
                            .fill(.orange)
                            .frame(width: 60, height: 60)
                            .cornerRadius(13)
                    }
                    .cornerRadius(13)
                    Text(walletLinkViewModel.wallet.name)
                        .font(.caption)
                }
                .onTapGesture {
                    walletLinkViewModel.initiateHandshakeWithCoinbase()
                }


                VStack(spacing: 6) {
                    Image("metamask-fox")
                        .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(maxWidth: 60, maxHeight: 60, alignment: .center)
                        .cornerRadius(13)
                    Text("MetaMask")
                        .font(.caption)
                }
                .onTapGesture {
                    walletLinkViewModel.connectMetaMask()
                }
//TODO: PixelQuantum
//-----------------------------------------------------------------------


                VStack(spacing: 6) {
                    Rectangle()// Image("")
                        .fill(.blue)
                        .frame(width: 60, height: 60)
                        .cornerRadius(13)
                    Text("wallet")
                }

                VStack(spacing: 6) {
                    Rectangle()// Image("")
                        .fill(.blue)
                        .frame(width: 60, height: 60)
                        .cornerRadius(13)
                    Text("wallet")
                }

            }
        }
        .padding(.vertical, 21)
        .padding(.horizontal)
    }
}

struct ConnectWalletSheetHeaderView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            Rectangle()// Image("")
                .fill(.blue)
                .frame(width: 41, height: 41)
                .cornerRadius(8)
                .padding(.trailing, 8)
            VStack(alignment: .leading, spacing: 0) {
                Text("Select Your Wallet")
                    .lineLimit(0)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(.black)
                VStack(alignment: .leading, spacing: 0) {
                    Text("RedRiverColony.ETH")
                        .fontWeight(.light)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("RedRiverColony.XYZ")
                        .fontWeight(.light)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack {
                Image(systemName: "x.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .font(.system(size: 24))
                    .padding()
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .padding(.vertical, 4)
    }
}

//struct ConnectWalletSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectWalletSheetView()
//    }
//}
