////
////  ContentView.swift
////  RedRiverColony.eth
////
////  Created by Daniel Bell on 3/18/23.
////
//
//import SwiftUI
//import ExSoul_Eth
////import Web3Core
////import web3swift
//
//struct SIWEDemoView: View {
//
//    @StateObject var walletVM = WalletViewModel()
//    @StateObject private var viewModel = DAppViewModel(requestId: "1")
//    @State private var selectedMessage: SIWEMessage? = nil
//    
//    var body: some View {
//        VStack {
//            HStack(spacing: 0) {
//                RoundedRectangle(cornerRadius: 10)
//                    .foregroundColor(Color(hex: "#4B0082"))
//                    .frame(maxWidth: .infinity)
//                    .overlay {
//                        WalletScreen(walletVM: walletVM, selectedMessage: $selectedMessage) { signature in
//                            viewModel.signature = signature
//                        }
//                    }
//                    .shadow(radius: 10)
//                RoundedRectangle(cornerRadius: 10)
//                    .foregroundColor(Color(hex: "#008080"))
//                    .frame(maxWidth: .infinity)
//                    .overlay {
//                        DAppScreen(viewModel: viewModel) {
//                            return (walletVM.expectedAddress, walletVM.chainId)
//                        } sign: { message in
//                            selectedMessage = message
//                        }
//                    }
//                    .shadow(radius: 10)
//
//            }
//        }
//        .padding()
//    }
//}
//
//extension SIWEMessage: Identifiable {
//
//}
//
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        SIWEDemoView()
////    }
////}
////
////
////
