//
//  FavoritesViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    
    static func initVC() -> FavoritesViewController {
        let vc = FavoritesViewController.initFromStoryboard(named: "FavoritesView")
        vc.viewModel = FavoritesViewModel()
        return vc
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var viewModel: FavoritesViewModel!
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        observe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSavedStations()
    }
    
    // MARK: - Private methods
    
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loadSavedStations() {
        activityIndicator.startAnimating()
        Task.detached { [unowned self] in
            await self.viewModel.loadSavedStations()
        }
    }
    
    private func updateTableView() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
        informationLabel.isHidden = !viewModel.favoriteStations.isEmpty
    }
    
    
    // MARK: - Observe
    
    private func observe() {
        observeFavoriteStations()
        observeRoute()
    }

    func observeFavoriteStations() {
        viewModel.$favoriteStations
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in self.updateTableView() }
            .store(in: &cancellables)
    }
    
    func observeRoute() {
        viewModel.route
            .receive(on: RunLoop.main)
            .sink { [weak coordinator] route in
                switch route {
                case .alert(let alert): coordinator?.makeAlert(alert)
                case .station(let station): coordinator?.presentStationsDataView(station)
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteStations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell")!
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.getStationName(at: indexPath.row)
        content.secondaryText = viewModel.getStationCode(at: indexPath.row)
        cell.contentConfiguration = content
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectFavoriteStation(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate

extension FavoritesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(value: searchText)
    }
}
