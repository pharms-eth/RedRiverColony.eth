//
//  ViewModifier.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI

struct ImportCardify: ViewModifier {
    var minBorder: Bool = false
    func body(content: Content) -> some View {
        HStack(alignment: .center) {
            content
        }
        .padding(.horizontal, minBorder ? 10 : 16)
        .padding(.vertical, minBorder ? 6 : 12)
        .cornerRadius(16)
        .background(Color.black.cornerRadius(16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 24/255, green: 30/255, blue: 37/255), lineWidth: 2)
        )
    }
}

extension View {
    func importCard() -> some View {
        modifier(ImportCardify())
    }
    func importCardMinBorder() -> some View {
        modifier(ImportCardify(minBorder: true))
    }
}
