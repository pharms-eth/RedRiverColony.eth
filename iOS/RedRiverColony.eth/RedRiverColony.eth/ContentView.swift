//
//  ContentView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/18/23.
//

import SwiftUI
import ExSoul_Eth
import Web3Core
import web3swift


struct ContentView: View {

    @StateObject var walletVM = WalletViewModel()
    @StateObject private var viewModel = DAppViewModel(requestId: "1")
    @State private var selectedMessage: SIWEMessage? = nil

    //create account on wallet
    //connect dApp to wallet
    //create SIWE Message
    //create message button changes form into a static data display to verify
    //wallet needs to accept sign requests
    //sign message on wallet
    //wallet needs UI to sign SIWE




    //        //=================================================================
    //        //=================================================================
    //wallet needs updated UI to sign SIWE

    //verify Signature on dApp
    //        //=================================================================
    //        //=================================================================
    //
    //        //=================================================================
    //
    //        let response = try await verify(message: siweMessage, against: signature)

    //    func verify(message: SIWEMessage, against signature: String) async throws -> Bool {
    //
    //        guard let web3 = web3 else {
    //            return false
    //        }
    //        guard let sig = Data.fromHex(signature) else { return false }
    //        guard let data = try message.toMessage().data(using: .utf8) else { return false }
    //        let signer = web3.personal.recoverAddress(message: data, signature: sig)
    //
    //        return message.address == signer?.address
    //        }

    //
    //        //=================================================================
    //=================================================================
    //=================================================================





    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "#4B0082"))
                    .frame(maxWidth: .infinity)
                    .overlay {
                        VStack {
                            Text("Wallet")
                                .font(.title)
                                .padding()
                                .background {
                                    Color(hex: "#FFDAB9")
                                }
                            Spacer()
                            if let address = walletVM.expectedAddress?.address {
                                Text(address)
                                    .padding()
                                    .background {
                                        Color(hex: "#FFDAB9")
                                    }
                            }
                            Spacer()
                            Button("Create Account") {
                                walletVM.showLoading = true
                                walletVM.createAccount()
                            }
                            .padding()
                            .background {
                                Color(hex: "#FFDAB9")
                            }
                            Spacer()
                        }
                        .overlay {
                            if walletVM.showLoading {
                                VStack {
                                    Text("Loading...")
                                    ArtisticSpinner()
                                }
                            } else if let selectedMessage {
                                ZStack {
                                    Color.gray.opacity(0.5)
                                    VStack {
                                        ColordMessageView(message: selectedMessage)
                                        Button(action: {
                                            Task {
                                                let signature = try await walletVM.sign(message: selectedMessage)
                                                viewModel.signature = signature
                                            }
                                        }, label: {
                                            Text("ACCEPT")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#ffffff"))
                                            .padding()
                                            .background(Color(hex: "#FFA07A"))
                                            .cornerRadius(10)
                                            .padding(.bottom, 50)
                                        })
                                    }
                                }
                            }
                        }
                    }
                    .shadow(radius: 10)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: "#008080"))
                    .frame(maxWidth: .infinity)
                    .overlay {
                        DAppScreen(viewModel: viewModel) {
                            return (walletVM.expectedAddress, walletVM.chainId)
                        } sign: { message in
                            selectedMessage = message
                        }
                    }
                    .shadow(radius: 10)

            }
        }
        .padding()
    }
}

extension SIWEMessage: Identifiable {

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







//Community communications app:
//
//Primary color: #008080 (teal)
//This color is often associated with communication, community, and technology. It's a modern, youthful color that's also calming and easy on the eyes. It can also represent stability and trustworthiness.
//Secondary color: #FFA07A (light salmon)
//This color is a warm and friendly color that can add some energy and excitement to your app. It's often associated with friendliness, playfulness, and youthfulness.
//Financial wallet aimed at teens:
//
//Primary color: #4B0082 (indigo)
//This color is often associated with wisdom, intuition, and spirituality. It's a deep, mysterious color that can also convey a sense of responsibility and trustworthiness.
//Secondary color: #FFDAB9 (peach puff)
//This color is a soft and calming color that can evoke a sense of comfort and safety. It's often associated with sweetness, innocence, and playfulness, which can be appealing to a younger demographic.
