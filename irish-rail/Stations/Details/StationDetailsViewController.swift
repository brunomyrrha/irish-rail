//
//  StationDetailsViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import UIKit
import MapKit

class StationDetailsViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    
    private let viewModel = StationDetailsViewModel()
    weak var coordinator: StationsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
    }
    
    // MARK: - Public methods
    
    func setUp(with model: Station) {
        guard let code = model.code else {
            fatalError("Implement safety check for code")
        }
        Task.detached { [unowned viewModel] in
            await viewModel.fetchStationData(with: code)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapFavorite(_ sender: Any) {
        viewModel.favoriteStation()
    }
    
}
