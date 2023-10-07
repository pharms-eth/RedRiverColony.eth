//
//  Color.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/19/23.
//

import SwiftUI
public extension Color {
    static let ethereumLightBlue = Color(red: 78 / 255, green: 161 / 255, blue: 242 / 255)
    static let ethereumPurple = Color(red: 127 / 255, green: 96 / 255, blue: 219 / 255)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    static let background = Color("Background")
    static let primaryOrange = Color("PrimaryOrange")

    static let textBackground = Color("TextBackground")
    static let textForeground = Color("TextForeground")

    static let labelForeground = Color("LabelForeground")

    static let cardBorder = Color("CardBorder")

    static let secondaryOrange = Color("SecondaryOrange")
}
