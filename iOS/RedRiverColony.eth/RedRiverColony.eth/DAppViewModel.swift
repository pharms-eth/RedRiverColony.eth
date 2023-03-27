//
//  DAppViewModel.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/19/23.
//

import SwiftUI
import ExSoul_Eth
class DAppViewModel: ObservableObject {
    /** RFC 4501 dns authority that is requesting the signing. */
    @Published var domain: String = "dviances.com"
    /** Ethereum address performing the signing conformant to capitalization
     * encoded checksum specified in EIP-55 where applicable. */
    @Published public var address: String?
    /** Human-readable ASCII assertion that the user will sign, and it must not
     * contain `\n`. */
    @Published var statement: String
    /** RFC 3986 URI referring to the resource that is the subject of the signing
     *  (as in the __subject__ of a claim). */
    @Published var uri: URL?
    /** Current version of the message. */
    @Published var version: Int = 1
    /** EIP-155 Chain ID to which the session is bound, and the network where
     * Contract Accounts must be resolved. */
    @Published var chainId: Int? = nil
    /** Randomized token used to prevent replay attacks, at least 8 alphanumeric
     * characters. */
    @Published public var nonce: String? = nil
    /** ISO 8601 datetime string of the current time. */
    @Published var issuedAt: Date = Date()
    /** ISO 8601 datetime string that, if present, indicates when the signed
     * authentication message is no longer valid. */
    @Published var expirationTime: Date = Date()
    /** ISO 8601 datetime string that, if present, indicates when the signed
     * authentication message will become valid. */
    @Published var notBefore: Date = Date()
    /** System-specific identifier that may be used to uniquely refer to the
     * sign-in request. */
    @Published var requestId: String
    /** List of information or references to information the user wishes to have
     * resolved as part of authentication by the relying party. They are
     * expressed as RFC 3986 URIs separated by `\n- `. */
    @Published var resources: [String] = []

    @Published var siweMessage: SIWEMessage? = nil

    @Published var signature: String?

    init(requestId: String) {
        self.statement = "This is a test statement."
        self.uri = URL(string: origin)
        self.requestId = requestId
    }

    func generateNonce() {
        nonce = SIWEMessage.nonce()
    }

    let origin = "https://dviances.com/login"

    func createSIWEMessage() throws {

        guard let address else { throw SiweError(type: .invalidAddress, message: address) }
        guard let uri else { throw SiweError(type: .invalidURI, message: uri?.absoluteString) }
        guard let chainId else { throw SiweError(type: .invalidChainID, message: "\(chainId ?? .min)") }

        let message = try SIWEMessage(domain: domain, address: address, statement: statement, uri: uri, version: version, chainId: chainId)

        message.nonce = nonce
        message.requestId = requestId

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        message.issuedAt = dateFormatter.string(from: issuedAt)
        message.expirationTime = dateFormatter.string(from: expirationTime)
        message.notBefore = dateFormatter.string(from: notBefore)
        message.resources = resources.compactMap{ URL(string: $0)?.absoluteString }

        guard !(try message.toMessage()).isEmpty else {
            siweMessage = nil
            return
        }
        siweMessage = message
    }

}
