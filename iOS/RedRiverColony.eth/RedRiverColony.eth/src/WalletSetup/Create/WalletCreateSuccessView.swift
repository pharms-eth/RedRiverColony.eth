//
//  WalletCreateSuccessView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI
import Web3Core

struct WalletCreateSuccessView: View {
    @Binding public var ethWallet: AbstractKeystore?
    @Environment(\.dismiss) var dismiss
    @ObservedObject public var model: WalletCreateViewModel
    var body: some View {
        VStack {

            // check mark
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.primaryOrange)
                .frame(width: 160, height: 160)
                .padding(.top, 72)

            Text("Success!")
                .font(.system(size: 40.0, weight: .regular))
                .foregroundColor(.primaryOrange)
                .padding(.vertical, 40)

            Spacer()
            VStack(spacing: 24) {
                Text("Your wallet is now securely protected. Remember, keeping your seed phrase safe is your responsibility!")
                    .font(.system(size: 14.0, weight: .regular))
                    .lineSpacing(10.0)
                    .multilineTextAlignment(.center)
                Text("We cannot retrieve your wallet if it's lost. You can find your private key under Settings > Security & Privacy.")
                    .font(.system(size: 14.0, weight: .regular))
                    .lineSpacing(10.0)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .padding(.bottom, 65)
            WalletButton(title: "Next") {
                if let wallet = model.wallet {
                    DispatchQueue.main.async {
                        ethWallet = wallet
                        dismiss()
                    }
                }
            }
            .padding(.bottom, 42)
        }
        .background(Color.background)
    }
}
