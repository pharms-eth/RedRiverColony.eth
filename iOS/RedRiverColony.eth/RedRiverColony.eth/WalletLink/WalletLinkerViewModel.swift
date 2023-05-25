//
//  ConnectWalletCoinbaseViewModel.swift
//  testWalletConnectCompBuild
//
//  Created by Daniel Bell on 4/12/23.
//

import SwiftUI
import Combine
import metamask_ios_sdk
import CoinbaseWalletSDK

public extension Dapp {
    static var instance: Dapp?
    static func configure(_ dAPP: Dapp) {
        instance = dAPP
    }
}

class WalletLinkerViewModel: ObservableObject {

    @Published var account:  Wallet.Address?
    let wallet = Wallet.coinbaseWallet

    private var cancellables: Set<AnyCancellable> = []
    private var dapp: Dapp {
        guard let instance = Dapp.instance else {
            fatalError("Missing configuration: call `Dapp.configure` before accessing the `shared` instance.")
        }
        return instance
    }
    private var ethereum = MetaMaskSDK.shared.ethereum

    func connect() {
        ethereum.connect(dapp)?.sink(receiveCompletion: { completion in
//            switch completion {
//            case let .failure(error):
////                self.errorMessage = error.localizedDescription
//            default: break
//            }
        }, receiveValue: { result in
            guard let address = result as? String else { return }
            let chain = Network.chain(for: self.ethereum.chainId)
            self.account =  Wallet.Address(chain: chain?.name ?? "UNKNOWN", networkId: chain?.networkID ?? .max, address: address, provider: .metamask)
            //result is the address
        })
        .store(in: &cancellables)
    }

    func initiateHandshake() {
        CoinbaseWalletSDK.shared.initiateHandshake() { result, account in
            switch result {
                case .success(let response):
                    for returnValue in response.content {
                        switch returnValue {
                        case .success(let value):
                                guard self.account == nil else {
                                    return
                                }
                            guard let decoded = value.decode() as? [String: Any] else {
                                return
                            }
                            guard let chain = decoded["chain"] as? String else {
                                return
                            }
                            guard let networkId = decoded["networkId"] as? Int else {
                                return
                            }
                            guard let address = decoded["address"] as? String else {
                                return
                            }
                                self.account =  Wallet.Address(chain: chain, networkId: UInt(networkId), address: address, provider: .coinbase)
                        case .failure(let error):
        //                    self.log("error \(error.code): \(error.message)")
                                print(error)
                        }
                    }
                guard let account = account else { return }
                guard self.account == nil else { return }
                    self.account =  Wallet.Address(chain: account.chain, networkId: account.networkId, address: account.address, provider: .coinbase)
            case .failure(let error):
                    let abc = type(of: error)
                    print(error.localizedDescription)

                    print(abc)
    //                self.log("\(error)")
                    print(error)
            }
        }
    }
}