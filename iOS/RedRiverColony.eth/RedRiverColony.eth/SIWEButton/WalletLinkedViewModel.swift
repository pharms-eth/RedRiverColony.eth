//
//  SignView.swift
//  metamask-ios-sdk_Example
//

import SwiftUI
import Combine
import web3swift
import metamask_ios_sdk
import CoinbaseWalletSDK
import ExSoul_Eth

class WalletLinkedViewModel: ObservableObject {
    @Published var account: Wallet.Address?
    func web3() async -> Web3? {
        guard let url = URL(string: "http://127.0.0.1:8545") else {
            return nil
        }

        return try? await Web3.new(url)
    }

    private var cancellables: Set<AnyCancellable> = []
    @Published var messageSuccess: Bool?

    func createSIWEMessage() throws {
        guard let address = self.account?.address, let chainId = account?.networkId else { //"0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
            return
        }

        let object = try SIWEMessage(
            domain: "RedRiverColony.xyz",
            address: address,
            statement: "I hereby confirm that I accept the RedRiverColony.xyz Terms of Service, which can be found at https://redrivercolony.xyz/tos, and agree to sign in using Ethereum according to EIP-4361 protocol. By signing this assertion, I acknowledge and accept all conditions, responsibilities, and obligations stated in the Terms of Service and EIP-4361.",
            uri: URL(string: "https://RedRiverColony.xyz/login")!,
            version: 1,
            chainId: Int(chainId))

        object.nonce = SIWEMessage.nonceRandom() ?? SIWEMessage.nonce()

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        object.issuedAt = dateFormatter.string(from: Date())


        guard !(try object.toMessage()).isEmpty else {
            return
        }
        switch account?.provider {
            case .metamask:
                try metaMaskCreateSIWEMessage(object)
            case .coinbase:
                try coinbaseCreateSIWEMessage(object, address: address)
            case .none:
                return
        }
    }

    func coinbaseCreateSIWEMessage(_ object: SIWEMessage, address: String) throws {

        CoinbaseWalletSDK.shared.makeRequest(Request(actions: [
                Action(jsonRpc: .personal_sign(address: address, message: try object.toMessage()))
            ]))
        { result in
            guard case .success(let response) = result else {
                return
            }
            guard let returnValue = response.content.first else { return }
            switch returnValue {
            case .success(let value):
                guard let decoded = value.decode() as? String else {
                    return
                }
                print(decoded)
                    Task {
                        do {
                            self.messageSuccess = try await self.verify(message: object, against: decoded)
                        } catch {
                            print(error)
                        }
                    }
            case .failure(let error):
                    print("error \(error.code): \(error.message)")
            }
        }
    }

    func metaMaskCreateSIWEMessage(_ object: SIWEMessage) throws {

        let signRequest = EthereumRequest(method: .personalSign, params: [MetaMaskSDK.shared.ethereum.selectedAddress, try object.toMessage()])


        MetaMaskSDK.shared.ethereum.request(signRequest)?.sink(receiveCompletion: { completion in
//            switch completion {
//                case let .failure(error):
//                    self.errorMessage = error.localizedDescription
//                    self.showError = true
//                default: break
//            }
        }, receiveValue: { value in
//            self.result = value as? String ?? ""
//            print(value)
//            print("=========")

            Task {
                do {
                    self.messageSuccess = try await self.verify(message: object, against: value as? String ?? "")
                } catch {
                    print(error)
                }
            }
        })
        .store(in: &cancellables)


    }




    func verify(message: SIWEMessage, against signature: String) async throws -> Bool {
        guard let sig = Data.fromHex(signature) else { return false }
        guard let data = try message.toMessage().data(using: .utf8) else { return false }
        let signer = await web3()?.personal.recoverAddress(message: data, signature: sig)
        return message.address.lowercased() == signer?.address.lowercased()

    }

    func resetConnection() {
        self.account = nil
        switch account?.provider {
            case .coinbase:
                let result = CoinbaseWalletSDK.shared.resetSession()
            default:
                print("nothing implemented yet")
        }


    }
}
