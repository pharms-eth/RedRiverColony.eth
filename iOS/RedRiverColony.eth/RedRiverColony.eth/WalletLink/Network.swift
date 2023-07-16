//
//  Network.swift
//  testWalletConnectCompBuild
//
//  Created by Daniel Bell on 4/12/23.
//

import Foundation

enum Network: String, CaseIterable, Identifiable {
    case goerli = "0x5"
    case kovan = "0x2a"
    case ethereum = "0x1"
    case polygon = "0x89"

    var id: Self { self }

    var chainId: String {
        rawValue
    }

    var name: String {
        switch self {
            case .polygon: return "Polygon"
            case .ethereum: return "Ethereum"
            case .kovan: return "Kovan Testnet"
            case .goerli: return "Goerli Testnet"
        }
    }

    var rpcUrls: [String] {
        switch self {
        case .polygon: return ["https://polygon-rpc.com"]
        default: return []
        }
    }

    static func chain(for chainId: String) -> Network? {
        self.allCases.first(where: { $0.rawValue == chainId })
    }

    var networkID: UInt {
        switch self {
            case .goerli:
                return 5
            case .kovan:
                return 42
            case .ethereum:
                return 1
            case .polygon:
                return 89
        }
    }
}
