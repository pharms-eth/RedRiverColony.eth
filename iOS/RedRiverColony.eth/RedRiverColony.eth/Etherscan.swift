//
//  Etherscan.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 9/17/23.
//

import Foundation

struct Etherscan {
    enum Network {
        case mainnet
        case goerli
        case sepolia
        var urlPrefix: String {
            var prefix = "api"

            switch self {
            case .mainnet:
                prefix += ""
            case .goerli:
                prefix += "-goerli"
            case .sepolia:
                prefix += "-sepolia"
            }

            return prefix + ".etherscan.io"
        }
    }

    var baseURL: String {
        chain.urlPrefix + "/api"
    }
    var chain: Network = .mainnet
    static let cache = Cache<String, EtherscanABIRequestResponse>()

    static let apiKeyToken = "XDW3ZRRM1AFT99AEPEWH11EIQIFKRW3NVJ"

    func abi(for address: String) async -> EtherscanABIRequestResponse? {

        if let cached = Etherscan.cache[address] {
            return cached
        }

        var queryItems: [URLQueryItem] = [ URLQueryItem(name: "chain", value: "eth") ]
        queryItems.append(URLQueryItem(name: "module", value: "contract"))
        queryItems.append(URLQueryItem(name: "action", value: "getabi"))
        queryItems.append(URLQueryItem(name: "address", value: "\(address)"))
        queryItems.append(URLQueryItem(name: "apikey", value: Self.apiKeyToken))

        var components = URLComponents()
        components.scheme = "https"
        components.host = chain.urlPrefix
        components.path = "/api"
        components.queryItems = queryItems

        var answer: EtherscanABIRequestResponse? = try? await getValueFrom(components.url)
        answer?.address = address
        Etherscan.cache[address] = answer
        return answer
    }

    func getValueFrom<T: Codable>(_ refUrl: URL? ) async throws -> T? {
        guard let url = refUrl else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let error {
                print(error)
                return nil
            }
        } catch let error {
            print(error)
            return nil
        }
    }
}

struct EtherscanABIRequestResponse: Codable {
    let status: String
    let result: String
    let message: Message
    var address: String?
    enum Message: String, Codable {
        case notOK = "NOTOK"
        case ok = "OK"
    }
}
