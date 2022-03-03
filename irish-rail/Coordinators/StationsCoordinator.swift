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
        presentStationsView()
    }
    
    func presentTrainsView(_ trains: StationData) {
        let vc = TrainsView.initVC(trains: trains)
        navigationController.present(vc, animated: true)
    }
    
    func presentStationsDataView(_ station: Station) {
        let vc = StationDataViewController.initVC(station: station)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentStationsView() {
        let vc = StationsViewController.initVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentFavoritesView() {
        fatalError(errorMessage)
    }
    
}
