//
//  ArtisticSpinner.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/19/23.
//

import SwiftUI

struct ArtisticSpinner: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.4)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            Circle()
                .trim(from: 0.4, to: 0.8)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: isAnimating ? -360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            Circle()
                .trim(from: 0.8, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

struct ArtisticSpinner_Previews: PreviewProvider {
    static var previews: some View {
        ArtisticSpinner()
    }
}
