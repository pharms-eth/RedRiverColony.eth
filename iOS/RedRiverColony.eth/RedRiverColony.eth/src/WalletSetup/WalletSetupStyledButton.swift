//
//  WalletSetupStyledButton.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 9/29/23.
//

import SwiftUI

struct WalletSetupStyledButton: View {
    var title: String
    var background: Color

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
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
    }
}

