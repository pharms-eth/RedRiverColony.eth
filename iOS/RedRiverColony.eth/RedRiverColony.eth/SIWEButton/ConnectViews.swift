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
    @State var domain: String?
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
                        //TODO: ENS, we have the authenticaed user
                        //TODO: ENS, create a unau version
                        switch success {
                            case false:
                                Rectangle().fill(Color.red).frame(width: 25, height: 25)
                                    .padding()
                                    .background { Color.orange }
                                    .padding()
                                    .background { Color.red }
                                    .onTapGesture {
                                        vm.messageSuccess = nil
                                    }
                            case true:
                                if let domain {
                                    ENSProfileView(domain: domain)
                                }
                                Rectangle().fill(Color.green).frame(width: 25, height: 25)
                                    .padding()
                                    .background { Color.ethereumPurple }
                                    .padding()
                                    .background { Color.ethereumLightBlue }
                                    .onAppear {
                                        Task {
                                            guard let address = vm.account else { return }
                                            print(address)
                                            domain = try? await ENSAdressiewModel().lookup(address: address.address)
                                        }
                                    }

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


import Web3Core
import web3swift

class ENSAdressiewModel: ObservableObject {

    func lookup(address: String) async throws -> String? {
        do {
            let web3 = try await Web3.InfuraMainnetWeb3(accessToken: "0b4ab916c77e4a478fdac71aca49bb78")
            let ens = ENS(web3: web3)


            //use ExSoul SIWE code to get code to validate address
            //let address = SIWE.validate(address:address)
            let node = address.stripHexPrefix().lowercased() + ".addr.reverse"
            guard let resolver = try await ens?.registry.getResolver(forDomain: node) else {//ens deployer
                return nil
            }

            let name = try await resolver.getCanonicalName(forNode: node)
            //                const check = await this.resolveName(name);
            //                if (check !== address) { return null; }
            //
            //                return name;
            print(name)

            return name
        } catch {
            print(error)
        }
        return nil
    }

}
