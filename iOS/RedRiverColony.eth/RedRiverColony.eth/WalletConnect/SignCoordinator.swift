//
//  SignCoordinator.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 3/21/23.
//
import UIKit
import Combine
import WalletConnectSign
//import WalletConnectRelay
import WalletConnectPairing

final class SignCoordinator: ObservableObject {
    enum SignState {
    case delete
        case response
        case settleAccount
        case account
        case selectChain
    }

    private var publishers = Set<AnyCancellable>()

    @Published var state: SignState = .selectChain

    func start() {
        let metadata = AppMetadata(
            name: "Swift Dapp",
            description: "WalletConnect DApp sample",
            url: "wallet.connect",
            icons: ["https://avatars.githubusercontent.com/u/37784886"])

        Pair.configure(metadata: metadata)
        try? Sign.instance.cleanup()

        /// Publisher that sends deleted session topic
        Sign.instance.sessionDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                print("Quantum7")
                showSelectChainScreen()
            }.store(in: &publishers)

        /// Publisher that sends response for session request
        Sign.instance.sessionResponsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] response in
//                let controller = UINavigationController(rootViewController: ResponseViewController(response: response))
                print("Quantum6")
//                navigationController.present(controller, animated: true, completion: nil)
            }.store(in: &publishers)

        /// Publisher that sends session when one is settled
        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                print("Quantum5")
                let vc = showAccountsScreen(session)
//                vc.proposePushSubscription()
            }.store(in: &publishers)

        Sign.instance.sessionProposalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                print("Quantum1")
//                vc.proposePushSubscription()
            }.store(in: &publishers)

        /// Publisher that sends session request
        Sign.instance.sessionRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                print("Quantum2")
//                vc.proposePushSubscription()
            }.store(in: &publishers)

        /// Publisher that sends session proposal that has been rejected
        Sign.instance.sessionRejectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                print("Quantum3")
//                vc.proposePushSubscription()
            }.store(in: &publishers)

        /// Publisher that sends session event
        Sign.instance.sessionEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                print("Quantum4")
//                vc.proposePushSubscription()
            }.store(in: &publishers)



//        /// Publisher that sends web socket connection status
//        public var socketConnectionStatusPublisher: AnyPublisher<SocketConnectionStatus, Never>
//
//
//        /// Publisher that sends session topic and namespaces on session update
//        ///
//        /// Event will be emited controller and non-controller client when both communicating peers have successfully updated methods requested by the controller client.
//        public var sessionUpdatePublisher: AnyPublisher<(sessionTopic: String, namespaces: [String: SessionNamespace]), Never>
//
//        /// Publisher that sends session topic when session is extended
//        ///
//        /// Event will be emited on controller and non-controller clients.
//        public var sessionExtendPublisher: AnyPublisher<(sessionTopic: String, date: Date), Never>
//
//        /// Publisher that sends session topic when session ping received
//        ///
//        /// Event will be emited on controller and non-controller clients.
//        public var pingResponsePublisher: AnyPublisher<String, Never>
//
//        /// Publisher that sends sessions on every sessions update
//        ///
//        /// Event will be emited on controller and non-controller clients.
//        public var sessionsPublisher: AnyPublisher<[Session], Never>














        if let session = Sign.instance.getSessions().first {
            _ = showAccountsScreen(session)
        } else {
            showSelectChainScreen()
        }
    }

    private func showSelectChainScreen() {
        state = .selectChain
//        let controller = SelectChainViewController()
//        navigationController.viewControllers = [controller]
    }

    private func showAccountsScreen(_ session: Session) -> UIViewController {//AccountsViewController {
//        let controller = AccountsViewController(session: session)
//        controller.onDisconnect = { [unowned self]  in
//            showSelectChainScreen()
//        }
//        navigationController.presentedViewController?.dismiss(animated: false)
//        navigationController.viewControllers = [controller]
//        return controller
        return UIViewController()
    }
}
