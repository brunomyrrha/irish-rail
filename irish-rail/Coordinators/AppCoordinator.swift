//
//  AppCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    // MARK: - Coordinator methods
    
    func start() {
        makeAppCoordinator()
    }
    
    // MARK: - Private methods
    
    private func makeAppCoordinator() {
        let coordinator = StationsCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
