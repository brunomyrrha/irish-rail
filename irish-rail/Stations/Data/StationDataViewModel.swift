//
//  StationDataViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import Foundation
import Combine
import CoreLocation

class StationDataViewModel: ObservableObject {
    
    enum StationDataRoute {
        case alert(AlertModel)
        case trainData(StationData)
    }
    
    private enum StationDataViewModelError: Error {
        static var defaultErrorMessage: String { "Can't parse this station data." }
    }
    
    @Published private(set) var code: String = .empty
    @Published private(set) var name: String = .empty
    @Published private(set) var stationData = [StationData]()
    @Published private(set) var location = CLLocation()
    @Published private(set) var isFavorite = false
    private(set) var route = PassthroughSubject<StationDataRoute, Never>()
    
    let title: String
    private let api: StationDataAPI
    private let storageManager: StorageManager
    private var station: Station?
    
    init(station: Station, api: StationDataAPI = StationDataAPIBase.shared, storageManager: StorageManager = StorageManagerBase.shared) {
        self.api = api
        self.storageManager = storageManager
        self.station = station
        title = station.description
        code = station.code
        setUp(with: station)
    }
    
    // MARK: - Public methods
    
    func fetchStationData() async {
        let result = await api.fetchInfo(from: code)
        switch result {
        case .success(let values): updateStationData(with: values)
        case .failure(let error): routeAlert(error: error)
        }
    }
    
    func favoriteStationToggle() {
        guard let station = station else {
            routeAlert()
            return
        }
        isFavorite ? storageManager.unfavoriteStation(station) : storageManager.favoriteStation(station)
        isFavorite.toggle()
    }
    
    func getTime(at idx: Int) -> String {
        guard let dueMinutes = Int(stationData[idx].dueIn) else { return "Can't detect due time" }
        let dueTextFormat = "Due in %i minutes"
        return dueMinutes > 1 ? String(format: dueTextFormat, dueMinutes) : "Due"
    }
    
    func getDirection(at idx: Int) -> String {
        stationData[idx].destination
    }
    
    func didSelectTimeSchedule(at idx: Int) {
        route.send(.trainData(stationData[idx]))
    }
    
    // MARK: - Private methods
    
    private func tryUpdateLocation(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude, let longitude = longitude else { return }
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func setUp(with station: Station) {
        isFavorite = storageManager.isStationSaved(station)
        name = "\(station.description) Station"
        tryUpdateLocation(latitude: station.latitude, longitude: station.longitude)
    }
    
    private func updateStationData(with stationData: [StationData]) {
        self.stationData = stationData.sorted(by: { Int($0.dueIn) ?? .zero < Int($1.dueIn) ?? .zero })
    }
    
    private func routeAlert(error: Error? = nil) {
        let message = error?.localizedDescription ?? StationDataViewModelError.defaultErrorMessage
        let alert = AlertModel(message: message)
        route.send(.alert(alert))
    }
    
}
