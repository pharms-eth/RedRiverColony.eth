//
//  WalletConnectManager.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/20/23.
//

import Foundation
import WalletConnectPairing

//struct WalletConnectManager {
//    func pair() async throws {
//        let metadata = AppMetadata(name: "RedRiverColony.Eth", description: "A Platform for communities", url: "RedRiverColony.th", icons: [])
//
//        Pair.configure(metadata: metadata)
//
//        let uri = try await Pair.instance.create()
//    }
//
//
//    func startNetwork() {
//        Networking.configure(projectId: "5a9544b53b5de3c43770e79c79bb7d6f", socketFactory: SocketFactory())
//    }
//}

struct SocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        return WebSocketConnector(url: url)
    }
}


import Foundation

public class WebSocketConnector: WebSocketConnecting {
    public var isConnected: Bool {
        return task?.state == .running
    }

    public var onConnect: (() -> Void)?
    public var onDisconnect: ((Error?) -> Void)?
    public var onText: ((String) -> Void)?

    public var request: URLRequest {
        didSet {
            guard let url = request.url else {
                fatalError("Invalid WebSocket URL")
            }
            task = URLSession.shared.webSocketTask(with: url)
        }
    }

    private var task: URLSessionWebSocketTask?

    public init(request: URLRequest) {
        self.request = request
    }

    public init(url: URL) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        self.request = request
    }


    public func connect() {
        task?.resume()
        receive()
        onConnect?()
    }

    public func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
    }

    public func write(string: String, completion: (() -> Void)?) {
        let message = URLSessionWebSocketTask.Message.string(string)
        task?.send(message, completionHandler: { error in
            if let error = error {
                self.onDisconnect?(error)
            } else {
                completion?()
            }
        })
    }

    private func receive() {
        task?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.onText?(text)
                case .data:
                    self.onDisconnect?(nil)
                @unknown default:
                    fatalError("Unknown WebSocket message type")
                }
                self.receive()
            case .failure(let error):
                self.onDisconnect?(error)
            }
        })
    }
}

