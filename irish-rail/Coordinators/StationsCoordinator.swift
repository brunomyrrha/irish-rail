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
    
    func makeAlert(_ alert: AlertModel) {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func makeStationDetails(_ station: Station) {
        print("Did tap", station.description)
    }
    
}
