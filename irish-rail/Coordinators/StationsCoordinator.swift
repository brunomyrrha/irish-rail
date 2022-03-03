//
//  StationsCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import UIKit
import SwiftUI

class StationsCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let viewController = StationsViewController.initFromStoryboard(named: "StationsView")
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func makeStationData(_ station: Station) {
        let viewController = StationDataViewController.initFromStoryboard(named: "StationDataView")
        viewController.coordinator = self
        viewController.inject(model: station)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func makeTrain(_ data: StationData) {
        let view = TrainsView(model: data)
        let hostingViewController = UIHostingController(rootView: view)
        navigationController.present(hostingViewController, animated: true, completion: nil)
    }
    
}
