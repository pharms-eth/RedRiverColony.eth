//
//  ContractRetriever.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/6/23.
//

import Foundation
import Web3Core
import web3swift
import BigInt


struct ContractRetriever {

    var abi: String {
        """
        [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"AccessControlBadConfirmation","type":"error"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"bytes32","name":"neededRole","type":"bytes32"}],"name":"AccessControlUnauthorizedAccount","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"OwnableInvalidOwner","type":"error"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"OwnableUnauthorizedAccount","type":"error"},{"inputs":[{"internalType":"string","name":"parameter","type":"string"}],"name":"RRCServer_InvalidAddressParameter","type":"error"},{"inputs":[{"internalType":"string","name":"param","type":"string"},{"internalType":"string","name":"value","type":"string"}],"name":"RRCServer_InvalidStringParameter","type":"error"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"perp","type":"address"},{"internalType":"string","name":"accessPoint","type":"string"}],"name":"RRCServer_ServerNoPermission","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"channelId","type":"uint256"}],"name":"ChannelAddedToServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"channelId","type":"uint256"}],"name":"ChannelDeletedFromServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"MetadataUpdate","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"previousAdminRole","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"newAdminRole","type":"bytes32"}],"name":"RoleAdminChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":false,"internalType":"string","name":"newName","type":"string"}],"name":"ServerNameChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":false,"internalType":"address","name":"newName","type":"address"}],"name":"ServerNameResolverChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"channelId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserAddedToChannel","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserAddedToServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserBannedOnServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"channelId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserDeletedFromChannel","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserDeletedFromServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserMutedOnServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserUnbannedOnServer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"serverId","type":"uint256"},{"indexed":true,"internalType":"address","name":"userAddress","type":"address"}],"name":"UserUnmutedOnServer","type":"event"},{"inputs":[],"name":"DEFAULT_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"channelId","type":"uint256"},{"internalType":"address","name":"userAddress","type":"address"}],"name":"addUserToChannel","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"userAddress","type":"address"}],"name":"addUserToServer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"_user","type":"address"}],"name":"banUser","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"address","name":"","type":"address"}],"name":"bannedUsers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"channelCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"channels","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"owner","type":"address"},{"internalType":"string","name":"name","type":"string"},{"internalType":"bool","name":"isActive","type":"bool"},{"internalType":"bool","name":"isPublic","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"string","name":"channelName","type":"string"},{"internalType":"bool","name":"isPublic","type":"bool"}],"name":"createChannel","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"serverName","type":"string"},{"internalType":"address","name":"nameResolver","type":"address"},{"internalType":"bool","name":"isPublic","type":"bool"}],"name":"createServer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"id","type":"uint256"}],"name":"deleteChannel","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"id","type":"uint256"}],"name":"deleteServer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"channelId","type":"uint256"},{"internalType":"address","name":"userAddress","type":"address"}],"name":"deleteUserFromChannel","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"userAddress","type":"address"}],"name":"deleteUserFromServer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleAdmin","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"_user","type":"address"}],"name":"muteUser","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"address","name":"","type":"address"}],"name":"mutedUsers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"callerConfirmation","type":"address"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_from","type":"address"},{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_from","type":"address"},{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"_tokenId","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"serverCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"servers","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"address","name":"owner","type":"address"},{"internalType":"string","name":"name","type":"string"},{"internalType":"address","name":"nameResolver","type":"address"},{"internalType":"bool","name":"isActive","type":"bool"},{"internalType":"bool","name":"isPublic","type":"bool"},{"internalType":"uint256","name":"generalChannelId","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"admin","type":"address"},{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"bool","name":"grant","type":"bool"}],"name":"setAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"newBaseURI","type":"string"}],"name":"setBaseURI","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"admin","type":"address"},{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"bool","name":"grant","type":"bool"}],"name":"setChannelAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"admin","type":"address"},{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"bool","name":"grant","type":"bool"}],"name":"setServerAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"string","name":"newName","type":"string"}],"name":"setServerName","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"nameResolver","type":"address"}],"name":"setServerNameResolver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_index","type":"uint256"}],"name":"tokenByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"uint256","name":"_index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"_user","type":"address"}],"name":"unbanUser","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"serverId","type":"uint256"},{"internalType":"address","name":"_user","type":"address"}],"name":"unmuteUser","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"userToChannel","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"users","outputs":[{"internalType":"address","name":"wallet","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"recipient","type":"address"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}]
        """
    }
    let address = "0x55482205dFC6aDe2805B7B312E3E2CC34c05E159"
    var endpointURL = URL(string: "https://sepolia.infura.io/v3/0b4ab916c77e4a478fdac71aca49bb78")
    var network: Networks { .Custom(networkID: BigUInt(11155111)) }

    func get(function: String, abi overrideABI: String? = nil) async {
        print(overrideABI)
        guard let endpointURL = endpointURL else { return }
        guard let web3 = try? await Web3.new(endpointURL, network: network) else { return }
        guard let contract = web3.contract(overrideABI ?? abi, at: EthereumAddress(address)) else {
            return
        }

        let readTX = contract.createReadOperation("name")
        readTX?.transaction.from = EthereumAddress("0xe22b8979739D724343bd002F9f432F5990879901")
        let result = try? await readTX?.callContractMethod()
        let res = result?["0"]
        print(res)
        //how to get all servers a user is on


        //createServer
        //setServerAdmin
        //addUserToServer
        //createChannel
        //setChannelAdmin
        //addUserToChannel
    }

    func get() async -> String? {

        var ethScan = Etherscan()
        ethScan.chain = .sepolia

        guard let abiResponse = await ethScan.abi(for: address) else { return nil }

        guard abiResponse.status == "1" || abiResponse.message == .ok else { return nil }

        let abi = abiResponse.result

        await get(function: "name", abi: abi)


        //let methods: [String: [ABI.Element.Function]] = contract.contract.methods
        return abi
        //==================================================================
        //==================================================================
        //        let parameters: [Any] = [Data.randomBytes(length: 32), Data.randomBytes(length: 32)]
        //        let functionSignature = getFuncSignature("setData(bytes32,bytes)")
        //        let transaction = contract.createWriteOperation(functionSignature, parameters: parameters)
        //==================================================================
        //        let parameters: [Any] = [
        //            [Data.randomBytes(length: 32), Data.randomBytes(length: 32)],
        //            [Data.randomBytes(length: 32), Data.randomBytes(length: 32)]
        //        ]
        //        let functionNameWithParameters = "setData(bytes32[],bytes[])"
        //        let transaction = contract.createWriteOperation(functionNameWithParameters, parameters: parameters)
        //==================================================================
        //        let writeTX = contract!.createWriteOperation("fallback")!
        //        writeTX.transaction.from = from
        //        writeTX.transaction.value = value!
        //        let policies = Policies(gasLimitPolicy: .manual(78423))
        //        let result = try await writeTX.writeToChain(password: "", policies: policies, sendRaw: false)
        //        let txHash = Data.fromHex(result.hash.stripHexPrefix())!
        //
        //        Thread.sleep(forTimeInterval: 1.0)
        //
        //        let receipt = try await web3.eth.transactionReceipt(txHash)
        //
        //        XCTAssert(receipt.status == .ok)
        //
        //        switch receipt.status {
        //        case .notYetProcessed:
        //            return
        //        default:
        //            break
        //        }
        //
        //        let details = try await web3.eth.transactionDetails(txHash)
        //
        //        // FIXME: Re-enable this test.
        ////            XCTAssertEqual(details.transaction.gasLimit, BigUInt(78423))
        //==================================================================
        //        let parameters: [Any] = []
        //        let sendTx = contract.createWriteOperation("fallback", parameters: parameters)!
        //
        //        let valueToSend = try XCTUnwrap(Utilities.parseToBigUInt("1.0", units: .ether))
        //        sendTx.transaction.value = valueToSend
        //        sendTx.transaction.from = allAddresses[0]
        //
        //        let balanceBeforeTo = try await web3.eth.getBalance(for: sendToAddress)
        //        let balanceBeforeFrom = try await web3.eth.getBalance(for: allAddresses[0])
        //
        //        let result = try await sendTx.writeToChain(password: "web3swift", sendRaw: false)
        //        let txHash = Data.fromHex(result.hash.stripHexPrefix())!
        //
        //        Thread.sleep(forTimeInterval: 1.0)
        //
        //        let receipt = try await web3.eth.transactionReceipt(txHash)
        //
        //        switch receipt.status {
        //        case .notYetProcessed:
        //            return
        //        default:
        //            break
        //        }
        //
        //        let details = try await web3.eth.transactionDetails(txHash)
        //
        //        let balanceAfterTo = try await web3.eth.getBalance(for: sendToAddress)
        //        let balanceAfterFrom = try await web3.eth.getBalance(for: allAddresses[0])
        //
        //        XCTAssertEqual(balanceAfterTo - balanceBeforeTo, valueToSend)
        //        let txnGasPrice = details.transaction.meta?.gasPrice ?? 0
        //        XCTAssertEqual(balanceBeforeFrom - (balanceAfterFrom + receipt.gasUsed * txnGasPrice), valueToSend)
        //==================================================================
        //        let writeTX = contract!.createWriteOperation("fallback")!
        //        writeTX.transaction.from = allAddresses[0]
        //        writeTX.transaction.value = 1
        //
        //        let policies = Policies(gasLimitPolicy: .automatic)
        //        let result = try await writeTX.writeToChain(password: "", policies: policies, sendRaw: false)
        //
        //        let txHash = Data.fromHex(result.hash.stripHexPrefix())!
        //
        //        let transactionReceipt = try await TransactionPollingTask(transactionHash: txHash, web3Instance: web3).wait()
        //==================================================================
        //==================================================================
        //==================================================================







        //guard let keystore = importWalletWith(privateKey: privateKey) else {
        //    return
        //}

        ////TODO: cleanup code by removing force unwraps
        //let keystoreManager = KeystoreManager([keystore])
        //web3.addKeystoreManager(keystoreManager)
        //guard let contract = web3.contract(abiString) else {
        //    return
        //}

    }
}
