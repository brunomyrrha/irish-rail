//
//  StationsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation
import Combine

class StationsViewModel: ObservableObject {
    
    enum StationRoute {
        case initial
        case alert(alert: AlertModel)
        case stationDetails(station: Station)
    }
    
    private enum StationViewModelError: Error {
        static var defaultErrorMessage: String { "Something is wrong. Try again later." }
        static var nameNotFound: String { "Station name not found" }
    }
    
    @Published private(set) var stations = [Station]()
    @Published private(set) var route = PassthroughSubject<StationRoute, Never>()
    
    private var fetchedStations = [Station]()
    private let api: StationsAPI
    
    init(api: StationsAPI = StationsAPIBase.shared) {
        self.api = api
    }
    
    // MARK: - Public methods
    
    func fetchStations(id: Int) async {
        let result = await api.fetchStations(type: .init(rawValue: id) ?? .all)
        switch result {
        case .success(let values): fetchedStations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): routeAlert(error: error)
        }
        stations = fetchedStations
    }
    
    func fetchStations() async {
        let result = await api.fetchStations()
        switch result {
        case .success(let values): fetchedStations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): routeAlert(error: error)
        }
        stations = fetchedStations
    }
    
    func getStationName(at index: Int) -> String {
        guard index < stations.count else {
            routeAlert()
            return StationViewModelError.nameNotFound
        }
        return stations[index].description.capitalized
    }
    
    func didSelectStation(at index: Int) {
        route.send(.stationDetails(station: stations[index]))
    }
    
    func search(value text: String?) {
        guard let text = text, !text.isEmpty else {
            clearSearch()
            return
        }
        stations = fetchedStations.filter { station in
            station.description.lowercased().contains(text.lowercased())
        }
    }
    
    func clearSearch() {
        stations = fetchedStations
    }
    
    // MARK: - Private methods
    
    private func routeAlert(error: Error? = nil) {
        let message = error?.localizedDescription ?? StationViewModelError.defaultErrorMessage
        let alert = AlertModel(message: message)
        route.send(.alert(alert: alert))
    }
    
}