//
//  DAppScreen.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/19/23.
//

import SwiftUI
import ExSoul_Eth
import web3swift
import Web3Core

struct DAppScreen: View {


    @State private var isWalletConnected = false


    enum SIWEState: Equatable {
        case none
        case managingInfo
        case preview
        case send
        case complete
    }

    @State private var siweState: SIWEState = .none
    @State private var newResource: String = ""
    @ObservedObject public var viewModel: DAppViewModel

    var fetchWalletInfo: () -> (EthereumAddress?, Int?)
    var sign: (SIWEMessage?) async throws -> ()

    var body: some View {
        ZStack {
            Color(hex: "#008080")
                .ignoresSafeArea()

            VStack {
                Text("dApp Screen")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                Spacer()

                VStack {
                    VStack {
                        if let address = viewModel.address, let chainID = viewModel.chainId {
                            VStack {
                                HStack {
                                    Text("Address")
                                    Spacer()
                                    Text(address)
                                }
                                HStack {
                                    Text("Chain ID:")
                                    Spacer()
                                    Text("\(chainID)")
                                }
                            }
                            .padding()
                        } else {
                            HStack {
                                Spacer()
                                Text("Please Reconnect Wallet")
                                Spacer()
                            }
                            .padding()
                        }
                        VStack {
                            HStack {
                                Text("Domain")
                                Spacer()
                                Text(viewModel.domain)
                            }
                            if let uri = viewModel.uri?.absoluteString {
                                HStack {
                                    Text("URI:")
                                    Spacer()
                                    Text("\(uri)")
                                }
                            }
                        }
                        .padding()
                    }
                    if siweState == .managingInfo {
                        Form {
                            Section(header: Text("General Information")) {
                                TextField("Statement", text: $viewModel.statement)
                                Stepper(value: $viewModel.version, in: 1...Int.max) {
                                    Text("Version: \(viewModel.version)")
                                }
                                HStack {
                                    Text("Nonce:")
                                        .padding(.trailing)
                                    Text(viewModel.nonce ?? "--")
                                    Spacer()
                                    Button(action: {
                                        viewModel.generateNonce()
                                    }) {
                                        Text("Generate Nonce")
                                    }
                                }
                            }

                            Section(header: Text("Timestamps")) {
                                DatePicker("Issued At", selection: $viewModel.issuedAt, displayedComponents: [.date, .hourAndMinute])
                                DatePicker("Expiration Time", selection: $viewModel.expirationTime, displayedComponents: [.date, .hourAndMinute])
                                DatePicker("Not Before", selection: $viewModel.notBefore, displayedComponents: [.date, .hourAndMinute])
                            }

                            Section(header: Text("Miscellaneous")) {
                                TextField("Request ID", text: $viewModel.requestId)
                                Section(header: Text("Resources")) {
                                    HStack {
                                        Text("Enter Resource URL:")
                                            .padding(.trailing)
                                        TextField("Resource URL", text: $newResource)
                                        Spacer()
                                        Button(action: {
                                            guard URL(string: newResource) != nil, !newResource.isEmpty else {
                                                return
                                            }
                                            viewModel.resources.append(newResource)
                                            newResource = ""
                                        }) {
                                            Text("Save")
                                        }
                                    }
                                    if !viewModel.resources.isEmpty {
                                        ForEach(viewModel.resources.indices, id: \.self) { index in
                                            TextField("String \(index)", text: Binding(
                                                get: { viewModel.resources[index] },
                                                set: { viewModel.resources[index] = $0 }
                                            ))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if siweState == .preview, let message = viewModel.siweMessage {
                        MessageView(message: message)
                    }
                    if siweState == .send {
                        Text("Check Wallet")
                    }
                    if siweState == .complete {
                        Text("Welcome") + Text(viewModel.address ?? "0x" )
                    }
                }
                Spacer()

                if isWalletConnected {
                    Button(action: {
                        switch siweState {
                            case .none:
                                siweState = .managingInfo
                            case .managingInfo:
                                do {
                                    try viewModel.createSIWEMessage()
                                } catch let error as SiweError {
                                    switch error.type {
                                        case .invalidDomain:
                                            print("error: ")
                                        case .invalidAddress:
                                            print("error: ")
                                        case .invalidURI:
                                            print("error: ")
                                        case .invalidResourceURI:
                                            print("error: ")
                                        case .invalidMessageVersion:
                                            print("error: ")
                                        case .invalidNonce:
                                            print("error: ")
                                        case .invalidTimeFormat:
                                            print("error: ")
                                        case .invalidChainID:
                                            print("error: ")
                                        case .invalidVersion:
                                            print("error: ")
                                    }
                                } catch {
                                    print("error: ")
                                }

                                siweState = .preview
                            case .preview:
                                //send sign message request
                                Task {
                                    do {
                                        try await sign(viewModel.siweMessage)
                                        //                                viewModel.verify(signature)
                                    } catch let error as SiweError {

                                    } catch {

                                    }
                                    siweState = .complete
                                }
                                siweState = .send
                            case .send:
                                siweState = .complete
                            case .complete:
                                siweState = .none
                        }
                    }, label: {
                        Group {
                            if siweState != .preview {
                                Text("Create Message")
                            } else {
                                Text("Send Message")
                            }
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#ffffff"))
                        .padding()
                        .background(Color(hex: "#FFA07A"))
                        .cornerRadius(10)
                        .padding(.bottom, 50)

                    })
                } else {
                    Button(action: {
                        let (address, chainID) = fetchWalletInfo()
                        guard let address, let chainID else { return }

                        viewModel.address = address.address
                        viewModel.chainId = chainID
                        withAnimation {
                            self.isWalletConnected.toggle()
                        }
                    }, label: {
                        Text("Connect Wallet")
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

//struct DAppScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        DAppScreen()
//    }
//}
