//
//  ConnectWalletButton.swift
//  testWalletConnectCompBuild
//
//  Created by Daniel Bell on 4/13/23.
//

import SwiftUI

public struct ConnectWalletButton: View {
    @State private var showingSheet = false
    @Binding public var account:  Wallet.Address?

    public init(account: Binding< Wallet.Address?>) {
        _account = account
    }

    public var body: some View {
        HStack {
            Image("eth-diamond-purple")
            Text("Connect Wallet")
        }
            .foregroundColor(.white)
            .padding()
            .background(Color.ethereumPurple)
            .cornerRadius(10)
            .onTapGesture {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                ConnectWalletSheetView(account: $account)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
    }
}

struct ConnectWalletButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectWalletButton(account: .constant(nil))
    }
}
