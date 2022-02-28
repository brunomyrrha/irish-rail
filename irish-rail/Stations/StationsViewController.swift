//
//  StationsViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit
import Combine

class StationsViewController: UIViewController {
    
    @IBOutlet private weak var stationTypeSegmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = StationsViewModel()
    private var storage = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    weak var coordinator: StationsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .tintColor
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        observe()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchStations()
    }
    
    // MARK: - IBActions
        
    @IBAction func didChangeStationType(_ sender: UISegmentedControl) {
        fetchStations(id: sender.selectedSegmentIndex)
    }
    
    // MARK: - Private methods
    
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
        }
    }
    
    private func endLoadAnimation() {
        DispatchQueue.main.async {
            self.stationTypeSegmentControl.isEnabled = true
            UIView.animate(withDuration: 0.25) {
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func refreshControlAction() {
        defer { refreshControl.endRefreshing() }
        let index = stationTypeSegmentControl.selectedSegmentIndex
        fetchStations(id: index)
    }
    
    // MARK: - Observe
    
    private func observe() {
        observeStations()
        observeRoute()
    }
    
    private func observeStations() {
        startLoadAnimation()
        viewModel.$stations
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.endLoadAnimation() }
            .store(in: &storage)
    }
    
    private func observeRoute() {
        viewModel.route
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .initial: break
                case .alert(let alert): self?.coordinator?.makeAlert(alert)
                case .stationDetails(station: let station): self?.coordinator?.makeStationDetails(station)
                }
        }
            .store(in: &storage)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stations.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell")!
        cell.textLabel?.text = viewModel.getStationName(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectStation(at: indexPath.row)
    }
    
}
