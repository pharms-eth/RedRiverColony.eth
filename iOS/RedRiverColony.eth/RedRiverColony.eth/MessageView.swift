//
//  MessageView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/19/23.
//

import SwiftUI
import ExSoul_Eth

struct MessageView: View {
    var message: SIWEMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack {
                Text("Domain: \(message.domain)")
                Text("Address: \(message.address)")
                if let statement = message.statement {
                    Text("Statement: \(statement)")
                }
                if let uri = message.uri {
                    Text("URI: \(uri.absoluteString)")
                }
                Text("Version: \(message.version)")
                Text("Chain ID: \(message.chainId)")
                if let nonce = message.nonce {
                    Text("Nonce: \(nonce)")
                }
            }
            VStack {
                if let issuedAt = message.issuedAt {
                    Text("Issued At: \(issuedAt)")
                }
                if let expirationTime = message.expirationTime {
                    Text("Expiration Time: \(expirationTime)")
                }
                if let notBefore = message.notBefore {
                    Text("Not Before: \(notBefore)")
                }
                if let requestId = message.requestId {
                    Text("Request ID: \(requestId)")
                }
                if let resources = message.resources {
                    Text("Resources:")
                    ForEach(resources, id: \.self) { resource in
                        Text("- \(resource)")
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SleekMessageView: View {
    var message: SIWEMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Domain")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.domain)
                        .font(.title2)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Address")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.address)
                        .font(.title2)
                }
            }
            if let statement = message.statement {
                VStack(alignment: .leading) {
                    Text("Statement")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(statement)
                        .font(.title2)
                }
            }
            if let uri = message.uri {
                VStack(alignment: .leading) {
                    Text("URI")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(uri.absoluteString)
                        .font(.title2)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Version")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(message.version)")
                        .font(.title2)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Chain ID")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(message.chainId)")
                        .font(.title2)
                }
            }
            if let nonce = message.nonce {
                VStack(alignment: .leading) {
                    Text("Nonce")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(nonce)
                        .font(.title2)
                }
            }
            if let issuedAt = message.issuedAt {
                VStack(alignment: .leading) {
                    Text("Issued At")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(issuedAt)
                        .font(.title2)
                }
            }
            if let expirationTime = message.expirationTime {
                VStack(alignment: .leading) {
                    Text("Expiration Time")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(expirationTime)
                        .font(.title2)
                }
            }
            if let notBefore = message.notBefore {
                VStack(alignment: .leading) {
                    Text("Not Before")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(notBefore)
                        .font(.title2)
                }
            }
            if let requestId = message.requestId {
                VStack(alignment: .leading) {
                    Text("Request ID")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(requestId)
                        .font(.title2)
                }
            }
            if let resources = message.resources {
                VStack(alignment: .leading) {
                    Text("Resources")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ForEach(resources, id: \.self) { resource in
                        Text("- \(resource)")
                            .font(.title2)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ColordMessageView: View {
    var message: SIWEMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    Label("Domain", systemImage: "globe")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(message.domain)
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Label("Address", systemImage: "location")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(message.address)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                if let statement = message.statement {
                    Label("Statement", systemImage: "doc.text")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(statement)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let uri = message.uri {
                    Label("URI", systemImage: "link")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(uri.absoluteString)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                VStack {
                    Label("Version", systemImage: "number")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(message.version)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Label("Chain ID", systemImage: "link")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(message.chainId)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    if let nonce = message.nonce {
                        Label("Nonce", systemImage: "number.circle")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(nonce)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                if let issuedAt = message.issuedAt {
                    Label("Issued At", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(issuedAt)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let expirationTime = message.expirationTime {
                    Label("Expiration Time", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(expirationTime)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let notBefore = message.notBefore {
                    Label("Not Before", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(notBefore)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let requestId = message.requestId {
                    Label("Request ID", systemImage: "number.circle")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(requestId)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if let resources = message.resources {
                    Label("Resources", systemImage: "rectangle.stack")
                        .font(.headline)
                        .foregroundColor(.white)
                    ForEach(resources, id: \.self) { resource in
                        Text("- \(resource)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(Color(.darkGray))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .cornerRadius(10)
        .padding()
    }
}



//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView()
//    }
//}
