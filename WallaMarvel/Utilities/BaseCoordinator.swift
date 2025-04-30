//
//  BaseCoordinator.swift
//  WallaMarvel
//
//  Created by orlando arzola on 30-04-25.
//

import UIKit

class BaseCoordinator: NSObject, UINavigationControllerDelegate {

    // MARK: - Public Properties

    var didFinish: ((BaseCoordinator) -> Void)?

    var navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    var childCoordinators: [BaseCoordinator] = []

    // MARK: - Init

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    // MARK: - Public Methods

    func start() {
        fatalError("Must be implemented by subclasses")
    }

    // MARK: - Navigation

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) { }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) { }

    // MARK: - Push and Popcoordinators

    func pushCoordinator(_ coordinator: BaseCoordinator) {
        // Install Handler
        coordinator.didFinish = { [weak self] coordinator in
            self?.popCoordinator(coordinator)
        }

        // Start Coordinator
        coordinator.start()

        // Append to Child Coordinators
        childCoordinators.append(coordinator)
    }

    func popCoordinator(_ coordinator: BaseCoordinator) {
        // Remove Coordinator From Child Coordinators
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
