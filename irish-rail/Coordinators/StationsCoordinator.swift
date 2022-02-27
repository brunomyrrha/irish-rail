//
//  StationsCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import UIKit

class StationsCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let viewController = StationsViewController.initFromStoryboard(named: "Stations")
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func stationDetails(station: Station) {
        
    }
    
}
