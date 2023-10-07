//
//  WalletCreateseedConfirmationView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI

class WalletCreateSeedConfirmationViewModel: ObservableObject {
    @Published public var seedPhraseConfirmation: [String] = []
    @Published public var seedPhraseEntered: [String] = []
    @Published public var seedIndex: Int = -1
}

struct WalletCreateseedConfirmationView: View {
    let gridItems = [GridItem(.adaptive(minimum: 131.0))]
    @ObservedObject var model: WalletCreateViewModel
    @StateObject var confirmationModel = WalletCreateSeedConfirmationViewModel()
    @Environment(\.modelContext) private var mc

    var body: some View {
        VStack {
            VStack(spacing: 8.0) {
                Text("Password")
                    .font(.system(size: 16.0, weight: .bold))
                    .foregroundColor(.primaryOrange)
                Text("This password will only unlock your Pocket wallet on this service")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondaryOrange)
            }
            .padding(.vertical, 40)
            LazyVGrid(columns: gridItems, spacing: 16.0) {
                ForEach((confirmationModel.seedPhraseEntered), id: \.self) {index in
                    HStack {
                        Text("\((model.seedPhrase.firstIndex(of: index) ?? 0) + 1): " + index)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.textForeground)
                    }
                    .padding()
                    .background(Color.textBackground)
                    .cornerRadius(8.0)
                }
            }
            Spacer()

            if confirmationModel.seedPhraseConfirmation.isEmpty {
                Spacer()
                WalletButton(title: "Set Password") {
                    guard confirmationModel.seedPhraseConfirmation.isEmpty else {
                        return
                    }
                    model.setPhase(.creationSuccess, with: mc)
                }
                .padding(.bottom, 42)
            } else {

            LazyVGrid(columns: gridItems, spacing: 16.0) {
                ForEach((confirmationModel.seedPhraseConfirmation), id: \.self) {index in
                    HStack {
                        Text(index)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.textForeground)
                    }
                    .padding()
                    .background(Color.textBackground)
                    .cornerRadius(8.0)
                    .onTapGesture {

                        guard let itemIndex = model.seedPhrase.firstIndex(of: index), itemIndex == confirmationModel.seedIndex + 1 else {
                            return
                        }
                        confirmationModel.seedIndex = itemIndex
                        confirmationModel.seedPhraseConfirmation.removeAll { $0 == index }
                        confirmationModel.seedPhraseEntered.append(index)
                    }
                }
            }
            Spacer()
            }
        }
        .background(Color.background)
        .onAppear {
            confirmationModel.seedPhraseConfirmation = model.seedPhrase// .shuffled().shuffled()
        }
    }
}
