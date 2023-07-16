//
//  ENSProfileView.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 4/24/23.
//

import SwiftUI
import Web3Core
import web3swift
import BigInt

class ResourceLocator {
    var url: URL?
    var name: String?
    var image: URL?
    var description: String?
    var attributes: [[String: String]]?

    init(url: URL? = nil) {
        self.url = url
//        guard let urlValue = self.url else { return }
//        guard var components = URLComponents(url: urlValue, resolvingAgainstBaseURL: true) else { return }
//        print(components.scheme)
//        let pathComponents = components.path.components(separatedBy: "/")
//        // Check if we have enough path components to extract the desired information
//        if components.scheme == "eip155", pathComponents.count >= 3 {
//            let contractAddress = pathComponents[1].replacingOccurrences(of: "erc721:", with: "")
//            let tokenId = pathComponents[2]
//            await processEIP155(contractAddress: contractAddress, tokenId: tokenId)
//        } else {
//            fatalError("unimplemented scheme")
//        }
    }
    static func setup(url: String) async -> ResourceLocator? {
        //                if let url = URL(string: header) {
        //                    print(url.absoluteURL)
        if url.isEmpty {
            return ResourceLocator()
        }
        guard let urlValue = URL(string: url) else { return nil }
        guard let components = URLComponents(url: urlValue, resolvingAgainstBaseURL: true) else { return nil }
        let pathComponents = components.path.components(separatedBy: "/")
        // Check if we have enough path components to extract the desired information
        if components.scheme == "eip155", pathComponents.count >= 3 {
            let contractAddress = pathComponents[1].replacingOccurrences(of: "erc721:", with: "")
            let tokenId = pathComponents[2]
            return await processEIP155(contractAddress: contractAddress, tokenId: tokenId)
        } else if components.scheme == "https" {
            return ResourceLocator(url: urlValue)
        } else {
            fatalError("unimplemented scheme")
        }


    }
    //                    failed url: eip155:1/erc721:0xbcc664b1e6848caba2eb2f3de6e21f81b9276dd8/2998

    static func ipfsToHttpURL(ipfsURL: String, gateway: String = "https://ipfs.io") -> URL? {
        let ipfsPath = ipfsURL.replacingOccurrences(of: "ipfs://", with: "")
        return URL(string: "\(gateway)/ipfs/\(ipfsPath)")
    }

    static func processEIP155(contractAddress: String, tokenId: String) async -> ResourceLocator? {
        guard let ethAddr = EthereumAddress(from: contractAddress)  else {
            return nil
        }
        let token = BigUInt(Int(tokenId) ?? 0)

        guard let web3Instance = try? await Web3.InfuraMainnetWeb3(accessToken: "0b4ab916c77e4a478fdac71aca49bb78") else {
            return nil
        }
        let contract = ERC721(web3: web3Instance, provider: web3Instance.provider, address: ethAddr)

        guard let tokenURI = try? await contract.tokenURI(tokenId: token) else { return nil }

        if let urlValue = URL(string: tokenURI) {
            //  ipfs://QmaukL8zdkRZmaYzaYTRTRDgd2Hm4H5eKEi4LxCEGKktUy/4774/metadata.json
            guard let components = URLComponents(url: urlValue, resolvingAgainstBaseURL: true) else { return nil }
            let pathComponents = components.path.components(separatedBy: "/")
            print(pathComponents)
//                print(components.host)
//                ["", "4774", "metadata.json"]
//                Optional("QmaukL8zdkRZmaYzaYTRTRDgd2Hm4H5eKEi4LxCEGKktUy")

            if components.scheme == "ipfs" {
                let locater = ResourceLocator(url: urlValue)
                guard let httpURL = ipfsToHttpURL(ipfsURL: tokenURI) else {
                    return locater
                }

                do {
                    let (data, result) = try await URLSession.shared.data(from: httpURL)

                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        fatalError("invalid JSON")
                    }

                    print(json)
//                    ResourceLocator
                    locater.name = json["name"] as? String
                    locater.description = json["description"] as? String
                    locater.attributes = json["attributes"] as? [[String : String]]
                    if let imageIPFSLocation = json["image"] as? String {
                        locater.image = ipfsToHttpURL(ipfsURL: imageIPFSLocation)
                    }

                    return locater


//                            {
//                                "name": "PunkScape Relic",
//                                "description": "PunkScape Relics are remnants of a bygone era.\n\nScapes have moved fully onchain, and live on a new contract.\n\n→ collect at scapes.xyz",
//                                "image": "ipfs://QmPSBakJWKgpX7T9KcTks5R57c8t3ESFUCK3wGZ2Nw77Hp",
//                                "attributes": [
//                                    {
//                                        "trait_type": "Minted",
//                                        "value": "2021"
//                                    },
//                                    {
//                                        "trait_type": "Destroyed",
//                                        "value": "2022"
//                                    },
//                                    {
//                                        "trait_type": "Atmosphere",
//                                        "value": "Blue"
//                                    },
//                                    {
//                                        "trait_type": "Sky",
//                                        "value": "Dark Stripes"
//                                    },
//                                    {
//                                        "trait_type": "Celestial",
//                                        "value": "Happy Clouds"
//                                    },
//                                    {
//                                        "trait_type": "Fluid",
//                                        "value": "Ocean"
//                                    },
//                                    {
//                                        "trait_type": "Landscape",
//                                        "value": "Beach"
//                                    },
//                                    {
//                                        "trait_type": "Surface",
//                                        "value": "Meadow"
//                                    },
//                                    {
//                                        "trait_type": "Building",
//                                        "value": "Windmill"
//                                    },
//                                    {
//                                        "display_type": "date",
//                                        "trait_type": "date",
//                                        "value": 2295165797
//                                    }
//                                ]
//                            }
                } catch {
                    print(error)
                }

                return nil
            }
        }

        return nil
    }

//eip155:1/erc721:0x51ae5e2533854495f6c587865af64119db8f59b4/4774
//Optional("eip155")
//Optional("eip155")
}

class ENSViewModel: ObservableObject {
    @Published var web3: Web3?
    @Published var ens: ENS?

    @Published var owner: EthereumAddress?
    @Published var address: EthereumAddress?

    @Published var isNameSupports: Bool?
//    @Published var isABIsupports: Bool = false
    @Published var isTextSupports: Bool = false





    @Published var avatar: ResourceLocator?
    @Published var description: String?
    //a canonical display name for the ENS name; this MUST match the ENS name when its case is folded, and clients should ignore this value if it does not (e.g. "ricmoo.eth" could set this to "RicMoo.eth")
    @Published var display: String?
//    @Published var email: String?
    //A list of comma-separated keywords, ordered by most significant first; clients that interpresent this field may choose a threshold beyond which to ignore
    @Published var keywords: String?
    @Published var notice: String?
    //A generic location (e.g. "Toronto, Canada")
    @Published var location: String?
    //A physical mailing address
//    @Published var mail: String?
    //A phone number as an E.164 string
//    @Published var phone: String?
    //a website URL
    @Published var url: String?
    //a GitHub username
    @Published var github: String?
    //a LinkedIn username
//    @Published var linkedin: String?
    //a Twitter username
    @Published var twitter: String?
    //a discord username
//    @Published var discord: String?
    //a instagram username
    @Published var instagram: String?
    @Published var pronouns: String?

    @Published var cover: ResourceLocator?
    @Published var header: ResourceLocator?

    init(web3: Web3? = nil) {
        self.web3 = web3
        if let web3Instance = self.web3 {
            ens = ENS(web3: web3Instance)
        } else {
            Task {
                let web3Instance = try await Web3.InfuraMainnetWeb3(accessToken: "0b4ab916c77e4a478fdac71aca49bb78")
                DispatchQueue.main.async {
                    self.web3 = web3Instance
                    self.ens = ENS(web3: web3Instance)
                }
            }
        }
    }
//https://app.ens.domains/sio.eth
//https://app.ens.domains/brantly.eth
    //header

    func process(domain: String = "brantly.eth") async {
        do {

            let owner = try await ens?.registry.getOwner(node: domain)
            let address = try await ens?.getAddress(forNode: domain)
            DispatchQueue.main.async {
                self.owner = owner
                self.address = address
            }



            guard let resolver = try await ens?.registry.getResolver(forDomain: domain) else {
                return
            }

            let isNameSupports = try await resolver.supportsInterface(interfaceID: .name)
//            let isABIsupports = try await resolver.supportsInterface(interfaceID: .ABI)
            let isTextSupports = try await resolver.supportsInterface(interfaceID: .text)

            DispatchQueue.main.async {
                self.isNameSupports = isNameSupports
//                self.isABIsupports = isABIsupports
                self.isTextSupports = isTextSupports
            }

//            if isABIsupports {
//                let res = try await resolver.getContractABI(forNode: domain, contentType: .zlibCompressedJSON)
//                print(res.0.description)
//                print(res.1)
//            } else {
//
//            }


            if isTextSupports {
                let avatar = try await resolver.getTextData(forNode: domain, key: "avatar")
                let cover = try await resolver.getTextData(forNode: domain, key: "cover")
                let header = try await resolver.getTextData(forNode: domain, key: "header")
                let description = try await resolver.getTextData(forNode: domain, key: "description")
                let display = try await resolver.getTextData(forNode: domain, key: "display")
                let keywords = try await resolver.getTextData(forNode: domain, key: "keywords")
                let notice = try await resolver.getTextData(forNode: domain, key: "notice")
                let location = try await resolver.getTextData(forNode: domain, key: "location")
                let url = try await resolver.getTextData(forNode: domain, key: "url")
                let github = try await resolver.getTextData(forNode: domain, key: "com.github")
                let twitter = try await resolver.getTextData(forNode: domain, key: "com.twitter")
//                let discord = try await resolver.getTextData(forNode: domain, key: "com.discord")
//                let linkedin = try await resolver.getTextData(forNode: domain, key: "com.linkedin")
//                let email = try await resolver.getTextData(forNode: domain, key: "email")
//                let mail = try await resolver.getTextData(forNode: domain, key: "mail")
//                let phone = try await resolver.getTextData(forNode: domain, key: "phone")


                guard let avatarResourceLocator = await ResourceLocator.setup(url: avatar) else {
//                    failed url: eip155:1/erc721:0xbcc664b1e6848caba2eb2f3de6e21f81b9276dd8/2998
                    fatalError("failed url: " + avatar)
                }

//                guard !cover.isEmpty, let coverResourceLocator = await ResourceLocator.setup(url: cover) else {
//                    fatalError("failed url: " + cover)
//                }

//                guard let headerResourceLocator = await ResourceLocator.setup(url: header) else {
//                    fatalError("failed url: " + header)
//                }

                DispatchQueue.main.async {
                    self.avatar = avatarResourceLocator
                    self.description = description
                    self.display = display
//                    self.email = email
                    self.keywords = keywords
                    self.notice = notice
                    self.location = location
//                    self.mail = mail
//                    self.phone = phone
                    self.url = url
                    self.github = github
//                    self.linkedin = linkedin
                    self.twitter = twitter
//                    self.discord = discord
//                    self.cover = coverResourceLocator
//                    self.header = headerResourceLocator
                }

                //UI examples
                //      Discord

//                self.avatar = avatarResourceLocator
//                    self.description = description
//                    self.keywords = keywords
//                    self.display = display
//                    self.notice = notice
//                    self.discord = discord
//                self.header = headerResourceLocator




                //      Instagram
                //      Twitter

                //      Dviances
                //      Figma community
                //
                //optimize calls
                //add discord, instagram, pronouns, content with rainbow wallet then get the data here
                //add cover with rainbow wallet then get the data here

                //eth.RedRiverColony.XYZ for serivces
            }
        } catch {
            print(error)
        }
    }
}

struct ENSProfileView: View {
    @StateObject var viewModel = ENSViewModel()
    let domain: String
    var body: some View {
        VStack {
            VStack {
                if let owner = viewModel.owner {
                    Text(owner.address)
                } else {
                    Text("no owner")
                }

                if let address = viewModel.address {
                    Text(address.address)
                } else {
                    Text("no address")
                }

                if viewModel.isNameSupports ?? false {
                    Text("isNameSupports")
                }
            }

            VStack {
                if viewModel.isTextSupports {
                    Text("isTextSupports")
                }  else {
                    Text("no isTextSupports")
                }
                VStack {

                    if let text = viewModel.avatar?.url {
                        AsyncImage(url: text) { img in
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange)
                                .frame(width: 25, height: 25)
                        }

                        Text("avatar: " + text.absoluteString)
                    }
                    if let text = viewModel.description {
                        Text("description: " + text)
                    }
                    if let text = viewModel.display {
                        Text(text)
                    }
                    if let text = viewModel.keywords {
                        Text(text)
                    }
                    if let text = viewModel.notice {
                        Text(text)
                    }
                    if let text = viewModel.location {
                        Text(text)
                    }
                }
                VStack {
                    if let text = viewModel.url {
                        Text(text)
                    }
                    if let text = viewModel.github {
                        Text(text)
                    }
                    if let text = viewModel.twitter {
                        Text(text)
                    }
                }

                VStack {
                    if let text = viewModel.instagram {
                        Text("instagram" + text)
                    }
                    if let text = viewModel.pronouns {
                        Text("pronouns" + text)
                    }
                    if let text = viewModel.cover {
                        Text("cover: " + (text.url?.absoluteString ?? "--"))
                        Text("cover name: " + (text.name ?? "--"))
                        Text("cover description: " + (text.description ?? "--"))
                        Text("attributes \(text.attributes?.count ?? 0)")
                        if let textImage = text.image {
                            AsyncImage(url: textImage) { img in
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange)
                                    .frame(width: 25, height: 25)
                            }
                        }


                    }

                    if let text = viewModel.header {
                        Text("header: " + (text.url?.absoluteString ?? "--"))
                        Text("header name: " + (text.name ?? "--"))
                        Text("header description: " + (text.description ?? "--"))
                        Text("attributes \(text.attributes?.count ?? 0)")
                        if let textImage = text.image {
                            AsyncImage(url: textImage) { img in
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange)
                                    .frame(width: 25, height: 25)
                            }
                        }


                    }
                }
            }
            .background {
                if viewModel.isTextSupports {
                    Color.green
                }  else {
                    Color.red
                }
            }

        }
        .onAppear {
            Task {
                await viewModel.process(domain: domain)
            }
        }
    }
}

struct ENSProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ENSProfileView(domain: "EXAMPLE.ETH")
    }
}













