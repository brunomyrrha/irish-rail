//
//  StationsViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

class StationsViewModel {
    
    var stations = [Station]()
    
    func fetchStations(id: Int, completion: @escaping () -> Void) {
        StationsAPI.shared.fetchStations(type: .init(rawValue: id) ?? .all) { result in
            switch result {
            case .success(let stations): self.stations = stations
            case .failure(let error): print("Error:", error)
            }
            completion()
        }
    }
    
    func fetchStations(completion: @escaping () -> Void) {
        StationsAPI.shared.fetchStations(type: .mainline) { result in
            switch result {
            case .success(let stations): self.stations = stations
            case .failure(let error): print("Error:", error)
            }
            completion()
        }
    }
    
}

class StationsViewController: UIViewController {
    
    @IBOutlet private weak var stationTypeSegmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = StationsViewModel()
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.fetchStations { [weak self] in
            self?.updateTableView()
        }
    }

    // MARK: - IBActions
    
    @IBAction func didChangeStationType(_ sender: UISegmentedControl) {
        viewModel.fetchStations(id: sender.selectedSegmentIndex) { [weak self] in
            self?.updateTableView()
        }
        
    }
    
    // MARK: - Private methods
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension StationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stations.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell")!
        cell.textLabel?.text = viewModel.stations[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
