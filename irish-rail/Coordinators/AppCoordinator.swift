//
//  AppCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator methods
    
    func start() {
        makeAppCoordinator()
    }
    
    func showDetails() {
        
    }
    
    // MARK: - Private methods
    
    private func makeAppCoordinator() {
        let coordinator = StationsCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    
}
