//
//  FavoritesCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let viewController = FavoritesViewController.initFromStoryboard(named: "FavoritesView")
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
