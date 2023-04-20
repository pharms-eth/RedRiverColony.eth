////
////  WalletScreen.swift
////  RedRiverColony.eth
////
////  Created by Daniel Bell on 4/2/23.
////
//
//import SwiftUI
//import ExSoul_Eth
//
//struct WalletScreen: View {
//    @ObservedObject var walletVM: WalletViewModel
//    @Binding var selectedMessage: SIWEMessage?
//    var sendSignature: (String?) -> ()
//
//    var body: some View {
//        VStack {
//            Text("Wallet")
//                .font(.title)
//                .padding()
//                .background {
//                    Color(hex: "#FFDAB9")
//                }
//            Spacer()
//            if let address = walletVM.expectedAddress?.address {
//                Text(address)
//                    .padding()
//                    .background {
//                        Color(hex: "#FFDAB9")
//                    }
//            }
//            Spacer()
//            Button("Create Account") {
//                walletVM.showLoading = true
//                walletVM.createAccount()
//            }
//            .padding()
//            .background {
//                Color(hex: "#FFDAB9")
//            }
//            Spacer()
//        }
//        .overlay {
//            if walletVM.showLoading {
//                VStack {
//                    Text("Loading...")
//                    ArtisticSpinner()
//                }
//            } else if let selectedMessage {
//                ZStack {
//                    Color.gray.opacity(0.5)
//                    VStack {
//                        ColordMessageView(message: selectedMessage)
//                        Button(action: {
//                            Task {
//                                let signature = try await walletVM.sign(message: selectedMessage)
//                                sendSignature(signature)
//                            }
//                        }, label: {
//                            Text("ACCEPT")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .foregroundColor(Color(hex: "#ffffff"))
//                            .padding()
//                            .background(Color(hex: "#FFA07A"))
//                            .cornerRadius(10)
//                            .padding(.bottom, 50)
//                        })
//                    }
//                }
//            }
//        }
//    }
//}
////struct WalletScreen_Previews: PreviewProvider {
////    static var previews: some View {
////        WalletScreen()
////    }
////}
