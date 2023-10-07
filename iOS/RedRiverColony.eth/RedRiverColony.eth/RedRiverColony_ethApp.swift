//
//  RedRiverColony_ethApp.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 4/15/23.
//

import SwiftUI
import CoinbaseWalletSDK
import metamask_ios_sdk

@main
struct RedRiverColony_ethApp: App {
    var body: some Scene {
        WindowGroup {
            Group {
                RedRiverColonyParentView()
            }
            .onAppear{
                guard let callbackURL = URL(string: "https://redrivercolony.xyz") else {
                    fatalError("Coinbase Callback URL not properly configured")
                }
                guard let iconURL = URL(string: "https://darkroom.co/assets/images/help/appicons/DR6-Chrome.png") else {
                    fatalError("Coinbase Callback URL not properly configured")
                }
                let name = "Red River Colony"
                CoinbaseWalletSDK.configure(callback: callbackURL, appId: "Red River Colony", name: name, iconUrl: iconURL)

                let currentDapp = Dapp(name: name, url: "https://youtube.com")
                Dapp.configure(currentDapp)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleSpotlight)
            .onOpenURL(perform: handleLink)
        }
        .modelContainer(for: [Keystore.self, KdfParams.self, CryptoParams.self, CipherParams.self, Address.self])
    }

    func handleSpotlight(_ userActivity: NSUserActivity) {
        print("Continue activity \(userActivity)")
//        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
//            <#statements#>
//        }
        guard let url = userActivity.webpageURL else {
                return
        }
//        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        print("User wants to open URL: \(url)")
        // TODO same handling as done in onOpenURL()
        handleLink(url)
    }

    func handleLink(_ link: URL) {
        if (try? CoinbaseWalletSDK.shared.handleResponse(link)) == true {
            return
        }
    }
}


