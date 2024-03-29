//
//  StationsViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit
import Combine

class StationsViewController: UIViewController {
    
    static func initVC() -> StationsViewController {
        let vc = StationsViewController.initFromStoryboard(named: "StationsView")
        vc.viewModel = StationsViewModel()
        return vc
    }
    
    @IBOutlet private weak var stationTypeSegmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: StationsViewModel!
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        observe()
        fetchStations()
    }
    
    // MARK: - IBActions
    
    @IBAction func didChangeStationType(_ sender: UISegmentedControl) {
        fetchStations(id: sender.selectedSegmentIndex)
    }
    
    // MARK: - Private methods
    
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .tintColor
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    private func fetchStations(id: Int? = nil) {
        Task.detached { [unowned self] in
            await self.startLoadAnimation()
            if let id = id {
                await self.viewModel.fetchStations(id: id)
            } else {
                await self.viewModel.fetchStations()
            }
        }
    }
    
    private func startLoadAnimation() {
        stationTypeSegmentControl.isEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
            self.activityIndicator.startAnimating()
        }
    }
    
    private func endLoadAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.tableView.alpha = 1
            self.stationTypeSegmentControl.isEnabled = true
        }
    }
    
    @objc private func refreshControlAction() {
        defer { refreshControl.endRefreshing() }
        let index = stationTypeSegmentControl.selectedSegmentIndex
        fetchStations(id: index)
        searchBar.text?.removeAll()
    }
    
    // MARK: - Observe
    
    private func observe() {
        observeStations()
        observeRoute()
    }
    
    private func observeStations() {
        viewModel.$stations
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in self.endLoadAnimation() }
            .store(in: &cancellables)
    }
    
    private func observeRoute() {
        viewModel.route
            .receive(on: RunLoop.main)
            .sink { [weak coordinator] in
                switch $0 {
                case .alert(let alert): coordinator?.makeAlert(alert)
                case .station(let station): coordinator?.presentStationsDataView(station)
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell")!
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.getStationName(at: indexPath.row)
        content.secondaryText = viewModel.getStationCode(at: indexPath.row)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectStation(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchBarDelegate

extension StationsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(value: searchText)
    }
    
}
