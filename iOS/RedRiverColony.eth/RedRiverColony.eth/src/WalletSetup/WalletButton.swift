//
//  WalletButton.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI
struct WalletButton: View {
    var title: String
    var background: Color = .primaryOrange
    var action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.system(size: 16.0, weight: .bold))
            Spacer()
        }
            .padding(16)
            .foregroundColor(.white)
            .background(background)
            .cornerRadius(168)
            .onTapGesture {
                action()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
    }
}
