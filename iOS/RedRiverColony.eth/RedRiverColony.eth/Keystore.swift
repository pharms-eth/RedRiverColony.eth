//
//  Keystore.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 9/8/23.
//

import Foundation
import SwiftData


@Model 
public class Address {
    @Attribute(.unique) var address: String?
    var path: String?
    var keystore: Keystore?

    public init() { }
}

@Model 
public class CipherParams {
    var iv: String?
    @Relationship(deleteRule: .cascade, inverse: \CryptoParams.cipherparams) var crypto: CryptoParams?

    public init() { }
}

@Model 
public class CryptoParams {
    var cipher: String?
    var ciphertext: String?
    var kdf: String?
    var mac: String?
    var version: String?
    @Relationship(deleteRule: .cascade) var cipherparams: CipherParams?
    @Relationship(deleteRule: .cascade, inverse: \KdfParams.crypto) var kdfparams: KdfParams?
    @Relationship(inverse: \Keystore.crypto) var keystore: Keystore?

    public init() { }
}

@Model 
public class KdfParams {
    var c: Int64? = 0
    var dklen: Int64? = 0
    var n: Int64? = 0
    var p: Int64? = 0
    var prf: String?
    var r: Int64? = 0
    var salt: String?
    @Relationship(deleteRule: .cascade) var crypto: CryptoParams?


    public init() { }

}

@Model 
public class Keystore: Identifiable {
    var access: String?
    @Attribute(.unique) public var id: String?
    var isHDWallet: Bool?
    var nickName: String?
    var rootPath: String?
//    var tint: Color?
    var version: Int16? = 0
    @Relationship(deleteRule: .cascade, inverse: \Address.keystore) var address: [Address]?
    @Relationship(deleteRule: .cascade) var crypto: CryptoParams?


    public init() { }
}
