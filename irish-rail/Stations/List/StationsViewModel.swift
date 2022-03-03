//
//  StationsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation
import Combine

class StationsViewModel: ObservableObject {
    
    enum Route {
        case alert(AlertModel)
        case stationData(Station)
    }
    
    private enum StationViewModelError: Error {
        static var defaultErrorMessage: String { "Station data has an issue. Try again later." }
        static var infoNotFound: String { "Station info not found" }
    }
    
    @Published private(set) var stations = [Station]()
    private(set) var route = PassthroughSubject<Route, Never>()
    
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
            return StationViewModelError.infoNotFound
        }
        return stations[index].description.capitalized
    }
    
    func getStationCode(at index: Int) -> String {
        guard index < stations.count, let code = stations[index].code?.uppercased() else {
            routeAlert()
            return StationViewModelError.infoNotFound
        }
        return code
    }
    
    func didSelectStation(at index: Int) {
        route.send(.stationData(stations[index]))
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
        stations.removeAll()
        let message = error?.localizedDescription ?? StationViewModelError.defaultErrorMessage
        let alert = AlertModel(message: message)
        route.send(.alert(alert))
    }
    
}
