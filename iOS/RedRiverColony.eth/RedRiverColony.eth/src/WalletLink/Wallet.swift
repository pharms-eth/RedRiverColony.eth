//
//  MWPClient.swift
//  testWalletConnectCompBuild
//
//  Created by Daniel Bell on 4/13/23.
//

import Foundation
import SwiftUI

public struct Wallet: Codable {
    public let name: String
    public let iconUrl: URL
    public let url: URL
    public let mwpScheme: URL
    public let appStoreUrl: URL

    ///  return `true` if it can verify MWP supporting version of the wallet is installed on user's device.
    public var isInstalled: Bool { UIApplication.shared.canOpenURL(mwpScheme) }
}

extension Wallet {
    public static let coinbaseWallet = Wallet(
        name: "Coinbase Wallet",
        iconUrl: URL(string: "https://assets.coinbase.com/assets/2ee8edba4f470a10.png")!,
        url: URL(string: "https://wallet.coinbase.com/wsegue")!,
        mwpScheme: URL(string: "cbwallet://")!,
        appStoreUrl: URL(string: "https://apps.apple.com/app/id1278383455")!
    )
}

extension Wallet: Identifiable {
    public var id: String {
        name + appStoreUrl.absoluteString + mwpScheme.absoluteString
    }
}

public extension Wallet {
    enum Provider: Codable {
        case metamask
        case coinbase
    }

    struct Address: Codable {
        public let chain: String
        public let networkId: UInt
        public let address: String
        public let provider: Provider

        public init(chain: String, networkId: UInt, address: String, provider: Provider) {
            self.chain = chain
            self.networkId = networkId
            self.address = address
            self.provider = provider
        }
    }
}

extension Wallet.Address: Equatable {
    public static func == (lhs: Wallet.Address, rhs: Wallet.Address) -> Bool {
        lhs.address == rhs.address && lhs.networkId == rhs.networkId
    }
}
