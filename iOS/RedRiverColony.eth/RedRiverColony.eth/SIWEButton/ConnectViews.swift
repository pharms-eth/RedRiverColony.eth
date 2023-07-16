//
//  CoinbaseConnect.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 4/2/23.
//

import SwiftUI

struct WalletLinkedView: View {
    @Binding var account: Wallet.Address?
    @StateObject private var vm = WalletLinkedViewModel()

    var body: some View {
        VStack {
            HStack {
                Button("resetConnection", action: vm.resetConnection)
            }
            VStack {
                if account != nil {
                    Button("SIWE") {
                        try? vm.createSIWEMessage()
                    }
                    if let success = vm.messageSuccess {
                        switch success {
                            case false:
                                Rectangle().fill(Color.red).frame(width: 25, height: 25)
                                    .padding()
                                    .background { Color.orange }
                                    .padding()
                                    .background { Color.red }
                            case true:
                                Rectangle().fill(Color.green).frame(width: 25, height: 25)
                                    .padding()
                                    .background { Color.ethereumPurple }
                                    .padding()
                                    .background { Color.ethereumLightBlue }
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.account = self.account
        }
    }
}
