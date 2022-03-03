//
//  StationDataViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import UIKit
import MapKit
import Combine

class StationDataViewController: UIViewController {

    static func initVC(station: Station) -> StationDataViewController {
        let vc = StationDataViewController.initFromStoryboard(named: "StationDataView")
        vc.viewModel = StationDataViewModel(station: station)
        return vc
    }
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favoriteButton: UIBarButtonItem!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: StationDataViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var centerLocation = CLLocationCoordinate2D()
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUp()
        observe()
        fetchStationData()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapFavorite(_ sender: Any) {
        viewModel.favoriteStationToggle()
    }
    
    @IBAction func didTapStationName(_ sender: Any) {
        mapView.setCenter(centerLocation, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchStationData() {
        Task.detached { [unowned self] in
            await startLoadAnimation()
            await viewModel.fetchStationData()
        }
    }
    
    private func startLoadAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
            self.informationLabel.isHidden = true
            self.activityIndicator.startAnimating()
        }
    }
    
    private func endLoadAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = self.viewModel.stationData.isEmpty
            self.informationLabel.isHidden = !self.viewModel.stationData.isEmpty
            self.tableView.alpha = 1
        }
    }
    
    private func updateMap(location: CLLocation) {
        centerLocation = location.coordinate
        let region = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let stationPin = StationAnnotation(title: viewModel.name, coordinate: centerLocation)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: false)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.addAnnotation(stationPin)
        mapView.setCenter(centerLocation, animated: false)
    }
    
    // MARK: - Observe
    
    private func observe() {
        observeCode()
        observeName()
        observeStationData()
        observeLocation()
        observeIsFavorite()
        observeRoute()
    }
    
    private func observeCode() {
        viewModel.$code
            .receive(on: RunLoop.main)
            .sink { [unowned self] in self.title = $0 }
            .store(in: &cancellables)
    }
    
    private func observeName() {
        viewModel.$name
            .receive(on: RunLoop.main)
            .sink { [unowned self] in self.nameLabel.text = $0 }
            .store(in: &cancellables)
    }
    
    private func observeStationData() {
        viewModel.$stationData
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in self.endLoadAnimation() }
            .store(in: &cancellables)
    }
    
    private func observeLocation() {
        viewModel.$location
            .receive(on: RunLoop.main)
            .sink { [unowned self] in self.updateMap(location: $0) }
            .store(in: &cancellables)
    }
    
    private func observeIsFavorite() {
        viewModel.$isFavorite
            .receive(on: RunLoop.main)
            .sink { [unowned self] isFavorite in
                let imageName = isFavorite ? "bookmark.fill" : "bookmark"
                self.favoriteButton.image = UIImage(systemName: imageName)
            }
            .store(in: &cancellables)
    }
    
    private func observeRoute() {
        viewModel.route
            .receive(on: RunLoop.main)
            .sink { [unowned self] in
                switch $0 {
                case .alert(let alert): self.coordinator?.makeAlert(alert)
                case .trainData(let train): self.coordinator?.presentTrainsView(train)
                }
            }
            .store(in: &cancellables)
    }
    
}

extension StationDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationDataCell")!
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.getDirection(at: indexPath.row)
        content.secondaryText = viewModel.getTime(at: indexPath.row)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectTimeSchedule(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
