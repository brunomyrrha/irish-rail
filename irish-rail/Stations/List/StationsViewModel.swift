//
//  StationsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation
import Combine
import CoreData

class StationsViewModel: ObservableObject {
    
    enum StationsViewRoute {
        case alert(AlertModel)
        case station(Station)
    }
    
    private enum StationViewModelError: Error {
        static var defaultErrorMessage: String { "Station data has an issue. Try again later." }
        static var infoNotFound: String { "Station info not found" }
    }
    
    @Published private(set) var stations = [Station]()
    private(set) var route = PassthroughSubject<StationsViewRoute, Never>()
    
    private var fetchedStations = [Station]()
    private let api: StationsAPI
    private let storageManager: StorageManager
    
    init(api: StationsAPI = StationsAPIBase.shared, storageManager: StorageManager = StorageManagerBase.shared) {
        self.api = api
        self.storageManager = storageManager
    }
    
    // MARK: - Public methods
    
    func fetchStations() async {
        await stations = storageManager.loadStations()
        guard stations.isEmpty else { return }
        let result = await api.fetchStations()
        switch result {
        case .success(let values): fetchedStations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): routeAlert(error: error)
        }
        stations = fetchedStations
        storageManager.saveStations(stations)
    }
    
    func fetchStations(id: Int) async {
        let result = await api.fetchStations(type: .init(rawValue: id) ?? .all)
        switch result {
        case .success(let values): fetchedStations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): routeAlert(error: error)
        }
        stations = fetchedStations
    }
    
    func getStationName(at index: Int) -> String {
        guard index < stations.count else {
            routeAlert()
            return StationViewModelError.infoNotFound
        }
        return stations[index].description.capitalized
    }
    
    func getStationCode(at index: Int) -> String {
        guard index < stations.count  else {
            routeAlert()
            return StationViewModelError.infoNotFound
        }
        return stations[index].code.uppercased()
    }
    
    func didSelectStation(at index: Int) {
        route.send(.station(stations[index]))
    }
    
    func search(value text: String?) {
        guard let text = text, !text.isEmpty else {
            clearSearch()
            return
        }
        stations = fetchedStations.filter {
            $0.description.lowercased().contains(text.lowercased())
        }
    }
    
    func clearSearch() {
        stations = fetchedStations
    }
    
    // MARK: - Private methods
    
    private func routeAlert(error: Error? = nil) {
        stations.removeAll()
        let message = error?.localizedDescription ?? StationViewModelError.defaultErrorMessage
        let alert = AlertModel(message: message)
        route.send(.alert(alert))
    }
    
}
