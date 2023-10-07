//
//  WalletCreateView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI
import Web3Core
struct WalletCreateView: View {
    enum CreationPhase {
        case password
        case seedRetrieve
        case seedConfirmation
        case creationSuccess
    }

    @StateObject var model = WalletCreateViewModel()
    @Binding public var ethWallet: AbstractKeystore?
    @State private var animateLoading = false
    @Environment(\.modelContext) private var mc

    var body: some View {
        VStack {
            EllipticalProgress(progress: $model.progress)
            .padding(.horizontal, 88)
            Spacer()
            switch model.phase {
            case .password:
                WalletCreatePasswordView(model: model, showPasswordEntry: $model.showPasswordEntry)
            case .seedRetrieve:
                WalletCreateSeedRetrieveView(seedPhrase: model.seedPhrase) { phase in
                    model.setPhase(phase, with: mc)
                }
            case .seedConfirmation:
                WalletCreateseedConfirmationView(model: model)
            case .creationSuccess:
                WalletCreateSuccessView(ethWallet: $ethWallet, model: model)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if model.creatingWalletInProgress {
                ZStack {
                    Color.black

                    Circle()
                    .fill(Color.primaryOrange)
                    .frame(width: 30, height: 30)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.primaryOrange, lineWidth: 100)
                                .scaleEffect(animateLoading ? 1 : 0)
                            Circle()
                                .stroke(Color.primaryOrange, lineWidth: 100)
                                .scaleEffect(animateLoading ? 1.5 : 0)
                            Circle()
                                .stroke(Color.primaryOrange, lineWidth: 100)
                                .scaleEffect(animateLoading ? 2 : 0)
                        }
                        .opacity(animateLoading ? 0.0 : 0.2)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: animateLoading)
                    )
                }
                .onAppear {
                    animateLoading = true
                }
            }
        }
    }
}
