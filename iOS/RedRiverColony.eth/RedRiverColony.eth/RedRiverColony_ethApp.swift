//
//  RedRiverColony_ethApp.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/18/23.
//

import SwiftUI
import CoinbaseWalletSDK

@main
struct RedRiverColony_ethApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            WalletConnect()
            Text("COINBASE WALLET")
//                .onAppear{
//                    CoinbaseWalletSDK.configure(callback: URL(string: "https://myappxyz.com/mycallback")!)
//                }
//            Universal Links
//            configured with a Universal Link to your application
//            This callback URL will be used by the Coinbase Wallet application to navigate back to your application.
        }
//        func application(_ app: UIApplication, open url: URL ...) -> Bool {
//            if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
//                return true
//            }
//            // handle other types of deep links
//            return false
//        }
    }
}



