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
        presentFavoritesView()
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
        fatalError(errorMessage)
    }
    
    func presentFavoritesView() {
        let vc = FavoritesViewController.initVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
