//
//  WalletConnect.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/26/23.
//

import SwiftUI
import WalletConnectNetworking
struct WalletConnect: View {
    @StateObject var model = SelectChainViewController()
    @StateObject var coordinator = SignCoordinator()

    let wallet = "rainbow://"

    var body: some View {
        VStack {
            Link(destination: URL(string: wallet)!) {
                Text("Open Wallet")
                    .padding()
                    .background { Color(.systemFill) }
                    .foregroundColor(.white)
                    .cornerRadius(8)
//                    .onTapGesture {
//                        model.connectWithExampleWallet()
//                    }
            }
            Text("Connect")
                .padding()
                .background { Color(.systemBlue) }
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.vertical)
                .onTapGesture {
                    model.connect()
                }




//                activePairings
//                List(<#T##data: Range<Int>##Range<Int>#>, rowContent: <#T##(Int) -> View#>)


            Image("")//qrCodeView
            //        DispatchQueue.global().async { [unowned self] in
            //            let qrImage = QRCodeGenerator.generateQRCode(from: uri.absoluteString)
            //            DispatchQueue.main.async { [self] in
            //                qrCodeView.image = qrImage
            //                copyButton.isHidden = false
            //            }
            //        }

            if let uri = model.uri {
                VStack {
                    Text("Copy")
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                    Image(systemName: "doc.on.doc")
                }
                .padding()
                .background { Color(.systemBlue) }
                .foregroundColor(.white)
                .cornerRadius(8)
                .onTapGesture {
                    UIPasteboard.general.string = uri.absoluteString
                }


                Link(destination: URL(string: wallet + "wc?uri=\(uri.absoluteString)")!) {
                    Text("Connect Wallet")
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                        .background {
                            Color(.systemBlue)
                        }
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .background {
            Color(.systemBackground)
        }
        .onAppear{
            Networking.configure(projectId: "9ab2fa01d004ae5ee5b303327ec64508", socketFactory: SocketFactory())
            coordinator.start()
        }
    }
}

struct WalletConnect_Previews: PreviewProvider {
    static var previews: some View {
        WalletConnect()
    }
}
