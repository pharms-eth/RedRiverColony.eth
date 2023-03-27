//
//  SelectChainViewController.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/21/23.
//

import Foundation
import WalletConnectSign
import WalletConnectPairing
//import UIKit
import Combine
import UIKit

struct Chain {
    let name: String
    let id: String
}

class SelectChainViewController: ObservableObject {

    @Published var uri: WalletConnectURI? = nil
//    @Published var activePairings: [Pairing] = Pair.instance.getPairings()

    func connect() {
//        let chains = [ Chain(name: "Ethereum", id: "eip155:1") ]
        Task {
            let uri = try await Pair.instance.create()
            try await Sign.instance.connect(
                requiredNamespaces: ["eip155:1": ProposalNamespace(methods: ["eth_sendTransaction","personal_sign","eth_signTypedData"],events: [])],
                sessionProperties: ["caip154-mandatory": "true"],
                topic: uri.topic
            )
            DispatchQueue.main.async { [unowned self] in
                self.uri = uri
            }
        }
    }

//    func openWallet() {
//        UIApplication.shared.open(URL(string: "walletconnectwallet://")!)
//    }
//    func connectWithExampleWallet() {
//        guard let uri, let url = URL(string: "https://walletconnect.com/wc?uri=\(uri.absoluteString)") else { return }
//        DispatchQueue.main.async {
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
//    @objc func copyURI() {
//        UIPasteboard.general.string = uri.absoluteString
//    }
//









    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let pairingTopic = activePairings[indexPath.row].topic
    //        let requiredNamespaces: [String: ProposalNamespace] = [
    //            "eip155": ProposalNamespace(
    //                chains: [
    //                    Blockchain("eip155:1")!,
    //                    Blockchain("eip155:137")!
    //                ],
    //                methods: [
    //                    "eth_sendTransaction",
    //                    "personal_sign",
    //                    "eth_signTypedData"
    //                ], events: []
    //            ),
    //            "solana": ProposalNamespace(
    //                chains: [
    //                    Blockchain("solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ")!
    //                ],
    //                methods: [
    //                    "solana_signMessage",
    //                    "solana_signTransaction"
    //                ], events: []
    //            )
    //        ]
    //        let optionalNamespaces: [String: ProposalNamespace] = [
    //            "eip155:42161": ProposalNamespace(
    //                methods: [
    //                    "eth_sendTransaction",
    //                    "eth_signTransaction",
    //                    "get_balance",
    //                    "personal_sign"
    //                ],
    //                events: ["accountsChanged", "chainChanged"]
    //            )
    //        ]
    //        Task {
    //            _ = try await Sign.instance.connect(requiredNamespaces: requiredNamespaces, optionalNamespaces: optionalNamespaces, topic: pairingTopic)
    //            connectWithExampleWallet()
    //        }
    //    }
}

