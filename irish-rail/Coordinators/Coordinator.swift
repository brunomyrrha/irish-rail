//
//  Coordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    func start()
    
    func makeAlert(_ alert: AlertModel)
    
    func presentTrainsView(_ trains: StationData)
        
    func presentStationsDataView(_ station: Station)
    
    func presentStationsView()
    
    func presentFavoritesView()
    
}

extension Coordinator {
    
    var errorMessage: String { "AppCoordinator can't present ViewControllers" }
    
    func makeAlert(_ alert: AlertModel) {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
}
