//
//  WalletCreateSeedRetrieveView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI

struct WalletCreateSeedRetrieveView: View {

    @State private var passwordOn: Bool = false
    var seedPhrase: [String]
    var setPhase: (WalletCreateView.CreationPhase) -> Void
    private let gridItems = [ GridItem(.adaptive(minimum: 131.0)), GridItem(.adaptive(minimum: 131.0)) ]

    @State private var redacted = true
    var body: some View {
        VStack {

            VStack(spacing: 8.0) {
                Text("Your Seed Phrase")
                    .font(.system(size: 18.0, weight: .bold))
                    .foregroundColor(.primaryOrange)
                Text("Safeguard your seed phrase by storing it in the correct order in a secure location. You'll be prompted to input this phrase (in order) in the upcoming step.")
                    .font(.system(size: 14, weight: .regular))
                    .lineSpacing(10.0)
                    .foregroundColor(.secondaryOrange)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 24)

            LazyVGrid(columns: gridItems, spacing: 16.0) {
                // TODO:
                ForEach((0...11), id: \.self) {index in
                    HStack {
                        Spacer()
                        Text("\(index + 1). \(seedPhrase[index])")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.textForeground)
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.textBackground)
                    .cornerRadius(8.0)
                }
            }
            .padding(24)
            .cornerRadius(8.0)
            .border(Color.cardBorder, width: 1)
            .privacySensitive(redacted)
            .padding(.horizontal, 24)
            Spacer()
            WalletButton(title: "Next") {
                setPhase(.seedConfirmation)
            }
            .padding(.bottom, 42)
        }
        .background(Color.background)
        .blur(radius: redacted ? 8 : 0)
        .overlay(
            VStack {
                if redacted {
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Text("What Does 'Seed Phrase' Mean?")
                                    .font(.system(size: 16, weight: .regular))
                                    .padding(.top)
                                    .padding(.bottom, 40)
                                    .foregroundColor(.primaryOrange)
                                Text("A seed phrase is akin to a master key, composed of twelve distinct words, granting complete access to your wallet details and funds. Think of it as an exclusive passcode to your financial abode.\n\nIt's imperative to keep your seed phrase under wraps and securely stored. Safeguarding your seed phrase is crucial as it’s the only way to restore your wallet if you get locked out or switch to a new device. Without it, your funds are at risk. Should it fall into the wrong hands, they could seize control of your accounts.\n\nEnsure it's tucked away in a spot only you have access to. If misplaced, it's beyond recovery, with no one able to assist in retrieving it.\n\nThis phrase is your sole lifeline to regain wallet access, should you find yourself locked out of the app or Apple Services.")
                                    .font(.system(size: 14.0, weight: .regular))
                                    .lineSpacing(10.0)
                                    .foregroundColor(.textForeground)
                                    .padding(.bottom)
                            }
                            .padding()
                        }
                        WalletButton(title: "Reveal & Check Seed Phrase") {
                            redacted = false
                        }
                        .padding(.vertical)
                        WalletButton(title: "Complete Account Setup") {
                            setPhase(.creationSuccess)
                        }
                        .padding(.bottom, 42)
                    }
                    .background(Color.background)
                    .cornerRadius(16)
                    .padding(24)
                }
            }
        )
    }
}
