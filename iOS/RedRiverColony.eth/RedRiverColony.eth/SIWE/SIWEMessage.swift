//
//  SIWEMessage.swift
//  
//
//  Created by Daniel Bell on 3/14/23.
//

import Foundation

public class SIWEMessage {
    /** RFC 4501 dns authority that is requesting the signing. */
    public var domain: String
    /** Ethereum address performing the signing conformant to capitalization
     * encoded checksum specified in EIP-55 where applicable. */
    public var address: String
    /** Human-readable ASCII assertion that the user will sign, and it must not
     * contain `\n`. */
    public var statement: String?
    /** RFC 3986 URI referring to the resource that is the subject of the signing
     *  (as in the __subject__ of a claim). */
    public var uri: URL?
    /** Current version of the message. */
    public var version: Int
    /** EIP-155 Chain ID to which the session is bound, and the network where
     * Contract Accounts must be resolved. */
    public var chainId: Int
    /** Randomized token used to prevent replay attacks, at least 8 alphanumeric
     * characters. */
    public var nonce: String?
    /** ISO 8601 datetime string of the current time. */
    public var issuedAt: String?
    /** ISO 8601 datetime string that, if present, indicates when the signed
     * authentication message is no longer valid. */
    public var expirationTime: String?
    /** ISO 8601 datetime string that, if present, indicates when the signed
     * authentication message will become valid. */
    public var notBefore: String?
    /** System-specific identifier that may be used to uniquely refer to the
     * sign-in request. */
    public var requestId: String?
    /** List of information or references to information the user wishes to have
     * resolved as part of authentication by the relying party. They are
     * expressed as RFC 3986 URIs separated by `\n- `. */
    public var resources: [String]?
    
    /**
     * Creates a parsed Sign-In with Ethereum Message (EIP-4361) object from a
     * string or an object. If a string is used an ABNF parser is called to
     * validate the parameter, otherwise the fields are attributed.
     * @param param {string | SiweMessage} Sign message as a string or an object.
     */
    //    init(paramStr: String) {
    //        let parsedMessage = ParsedMessage(paramStr)
    //        domain = parsedMessage.domain
    //        address = parsedMessage.address
    //        statement = parsedMessage.statement
    //        uri = parsedMessage.uri
    //        version = parsedMessage.version
    //        nonce = parsedMessage.nonce
    //        issuedAt = parsedMessage.issuedAt
    //        expirationTime = parsedMessage.expirationTime
    //        notBefore = parsedMessage.notBefore
    //        requestId = parsedMessage.requestId
    //        chainId = parsedMessage.chainId
    //        resources = parsedMessage.resources
    //        nonce = nonce.isEmpty ? generateNonce() : nonce
    //        validateMessage()
    //    }
    public init(paramObj: SIWEMessage) throws {
        
        domain = paramObj.domain
        address = paramObj.address
        statement = paramObj.statement
        uri = paramObj.uri
        version = paramObj.version
        nonce = paramObj.nonce
        issuedAt = paramObj.issuedAt
        expirationTime = paramObj.expirationTime
        notBefore = paramObj.notBefore
        requestId = paramObj.requestId
        chainId = paramObj.chainId
        resources = paramObj.resources
        nonce = (nonce?.isEmpty ?? true) ? Self.nonce() : nonce
        try validateMessage()
    }
    
    public init(domain: String, address: String, statement: String?, uri: URL, version: Int, chainId: Int, nonce: String? = nil) throws {
        self.domain = domain
        self.address = address
        self.statement = statement
        self.uri = uri
        self.version = version
        self.chainId = chainId
        self.nonce = nonce ?? Self.nonceRandom()
        self.issuedAt = Date().iso8601String
        try validateMessage()
    }
    
    public static func nonce() -> String {
        let length = 8
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    public static func nonceRandom() -> String? {
        var bytes = [UInt8](repeating: 0, count: 256)
        let result = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        
        guard result == errSecSuccess else {
            print("Problem generating random bytes")
            return nil
        }
        
        let rawString = Data(bytes).base64EncodedString()
        let pattern = "[^A-Za-z0-9]+"
        let newString = rawString.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
        return newString
    }
    
    public static func nonceSecure() -> String {
        let nonce = randomStringForEntropy(length: 96)
        if nonce.isEmpty || nonce.count < 8 {
            fatalError("Error during nonce creation.")
        }
        return nonce
    }
    
    static func randomStringForEntropy(length: Int) -> String {
        let byteCount = length / 4 * 3 // adjust for base64 encoding
        var randomData = Data(count: byteCount)
        let _ = randomData.withUnsafeMutableBytes { (mutableBytes: UnsafeMutableRawBufferPointer) in
            guard let mutableRawPointer = mutableBytes.baseAddress else {
                return
            }
            let result = SecRandomCopyBytes(kSecRandomDefault, byteCount, mutableRawPointer)
            if result != errSecSuccess {
                return
            }
        }
        let randomString = randomData.base64EncodedString()
        return String(randomString.prefix(length))
    }
    
    let ISO8601 = #"^(?<date>[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))[Tt]([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9]|60)(\.[0-9]+)?(([Zz])|([+|-]([01][0-9]|2[0-3]):[0-5][0-9]))$"#
    func isValidISO8601Date(_ inputDate: String) -> Bool {
        /* Split groups and make sure inputDate is in ISO8601 format */
        guard let inputMatch = inputDate.range(of: ISO8601, options: .regularExpression)?.lowerBound else {
            /* if inputMatch is nil the date is not ISO-8601 */
            return false
        }
        
        /* Extract the matched substring from the input date */
        let inputMatchString = String(inputDate[inputMatch...])
        
        /* Creates a date object with input date to parse for invalid days e.g. Feb, 30 -> Mar, 01 */
        let inputDateParsed = DateFormatter.iso8601.date(from: inputMatchString) ?? Date()
        
        /* Get groups from new parsed date to compare with the original input */
        
        guard let parsedInputMatch = ISO8601DateFormatter().string(from: inputDateParsed).range(of: ISO8601, options: .regularExpression)?.lowerBound else {
            return false
        }
        
        /* Compare remaining fields */
        return inputMatch == parsedInputMatch
    }
    
    func isEIP55Address(_ address: String) -> Bool {
        guard address.count == 42 else { // Ethereum addresses should have length 42
            return false
        }
        
        let lowerAddress = address.lowercased().replacingOccurrences(of: "0x", with: "")
        let hash: String = lowerAddress.keccak256()
        var result = "0x"
        
        for (i, character) in lowerAddress.enumerated() {
            let index = hash.index(hash.startIndex, offsetBy: i)
            let hashChar = hash[index]
            if let intValue = Int(String(hashChar), radix: 16), intValue >= 8 {
                result.append(character.uppercased())
            } else {
                result.append(character)
            }
        }
        
        return address.lowercased() == result.lowercased()
    }
    
    func isValidLDAPAuthority(_ authority: String) -> Bool {
        // Regular expression pattern for validating an LDAP URL
        let pattern = #"^([a-zA-Z0-9]+@)?([a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]+)*|\[[0-9a-fA-F:]+\])(?::(\d*))?$"#
        
        // Create a regular expression object from the pattern
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        // Test the input string against the regular expression
        let range = NSRange(location: 0, length: authority.utf16.count)
        let matches = regex.numberOfMatches(in: authority, options: [], range: range)
        
        // If the number of matches is greater than zero, the string is a valid LDAP authority
        return matches > 0
    }
    
    func isValidUrl(_ str: String) -> Bool {
        let regex = #"^(https?|ftp|ipfs):\/\/[^\s/$.?#].[^\s]*$"# // Use a raw string literal to avoid escaping backslashes
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: str)
    }
    
    func isValidNonce(_ str: String?) throws -> Bool {
        guard let str else {
            throw SiweError(type: .invalidNonce, message: "Nonce is nil")
        }
        /** Check if the nonce is alphanumeric and bigger then 8 characters */
        guard let nonce = str.range(of: #"[a-zA-Z0-9]{8,}"#, options: .regularExpression) else {
            throw SiweError(type: .invalidNonce, message: "Nonce is empty or not alphanumeric")
        }
        
        if str.count < 8 || nonce != str.startIndex..<str.endIndex {
            throw SiweError(type: .invalidNonce, message: "Length < 8 or Nonce is not alphanumeric")
        }
        return true
    }
    
    func validateMessage() throws {
        guard !domain.isEmpty, isValidLDAPAuthority(domain) else {
            throw SiweError(type: .invalidDomain, message: domain)
        }
        guard isEIP55Address(self.address) else {
            throw SiweError(type: .invalidAddress, message: self.address)
        }
        guard version == 1 else {
            throw SiweError(type: .invalidVersion, message: "\(version)")
        }
        guard try isValidNonce(self.nonce) else {
            throw SiweError(type: .invalidNonce, message: "Nonce is invalid")
        }
        guard let uri, isValidUrl(uri.absoluteString) else {
            throw SiweError(type: .invalidURI, message: uri?.absoluteString ?? "")
        }
        try resources?.forEach {
            if URL(string: $0) == nil || !isValidUrl($0) {
                throw SiweError(type: .invalidResourceURI, message: $0)
            }
        }
        guard let issuedAt = self.issuedAt, isValidISO8601Date(issuedAt) else {
            throw SiweError(type: .invalidTimeFormat, message: "Issued At")
        }
        if let expirationTime = self.expirationTime {
            guard isValidISO8601Date(expirationTime) else {
                throw SiweError(type: .invalidTimeFormat, message: "Expiration Time")
            }
        }
        if let notBefore = self.notBefore {
            guard isValidISO8601Date(notBefore) else {
                throw SiweError(type: .invalidTimeFormat, message: "Not Before")
            }
        }
    }
    
    public func toMessage() throws -> String {
        // Validates all fields of the object
        
        if self.nonce == nil {
            self.nonce = Self.nonce()
        }
        
        try validateMessage()
        
        let header = "\(self.domain) wants you to sign in with your Ethereum account:"
        let uriField = "URI: \(uri?.absoluteString ?? "" )"
        var prefix = [header, self.address].joined(separator: "\n")
        let versionField = "Version: \(self.version)"
        
        let chainField = "Chain ID: \(self.chainId)"
        let nonceField = "Nonce: \(self.nonce ?? "")"
        
        var suffixArray = [uriField, versionField, chainField, nonceField]
        
        if self.issuedAt == nil {
            self.issuedAt = Date().iso8601String
        }
        
        suffixArray.append("Issued At: \(self.issuedAt!)")
        
        if let expirationTime = self.expirationTime {
            let expiryField = "Expiration Time: \(expirationTime)"
            suffixArray.append(expiryField)
        }
        
        if let notBefore = self.notBefore {
            suffixArray.append("Not Before: \(notBefore)")
        }
        
        if let requestId = self.requestId {
            suffixArray.append("Request ID: \(requestId)")
        }
        
        if let resources = self.resources {
            let resourcesList = resources.map { "- \($0)" }.joined(separator: "\n")
            suffixArray.append("Resources:\n\(resourcesList)")
        }
        
        let suffix = suffixArray.joined(separator: "\n")
        
        prefix = [prefix, self.statement ?? ""].joined(separator: "\n\n")
        if self.statement != nil {
            prefix += "\n"
        }
        
        return [prefix, suffix].joined(separator: "\n")
    }
}

public struct SiweError: Error {
    public enum SiweErrorType {
        case invalidDomain
        case invalidAddress
        case invalidURI
        case invalidResourceURI
        case invalidMessageVersion
        case invalidNonce
        case invalidTimeFormat
        case invalidChainID
        case invalidVersion
    }
    
    public let type: SiweErrorType
    let message: String?
    let context: String?
    
    public init(type: SiweError.SiweErrorType, message: String?, debugInfo context: String? = nil) {
        self.type = type
        self.message = message
        self.context = context
    }
}

// A helper extension to calculate the Keccak-256 hash of a string
extension String {
    func keccak256() -> String {
        let data = self.data(using: .utf8)!
        let hash = data.sha3(.keccak256)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
