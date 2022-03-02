//
//  StationDetailsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import Foundation
import Combine
import CoreLocation

class StationDetailsViewModel: ObservableObject {
    
    @Published private(set) var code: String = .empty
    @Published private(set) var name: String = .empty
    @Published private(set) var stationData = [StationData]()
    @Published private(set) var location = CLLocation()
    
    private var fetchedStationData = [StationData]()
    private let api: StationDataAPI
    
    init(api: StationDataAPI = StationDataAPIBase.shared) {
        self.api = api
    }
    
    // MARK: - Public methods

    func setUp(with station: Station) {
        guard let code = station.code else { fatalError("ROUTE ERROR") }
        self.code = code
        name = "\(station.description) Station"
        tryUpdateLocation(latitude: station.latitude, longitude: station.longitude)
    }
    
    private func tryUpdateLocation(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude, let longitude = longitude else { return }
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func fetchStationData() async {
        let result = await api.fetchInfo(from: code)
        switch result {
        case .success(let values): updateStationData(with: values)
        case .failure(let error): print(error)
        }
    }
    
    func favoriteStation() {
        
    }
    
    func getTime(at idx: Int) -> String {
        guard let dueMinutes = Int(stationData[idx].dueIn) else { return "Can't detect due time" }
        let dueTextFormat = "Due in %i minutes"
        return dueMinutes > .zero ? String(format: dueTextFormat, dueMinutes) : "Due"
    }
    
    func getDirection(at idx: Int) -> String {
        stationData[idx].destination
    }
    
    // MARK: - Private methods
    
    private func updateStationData(with stationData: [StationData]) {
        DispatchQueue.main.async {
            self.stationData = stationData.sorted(by: { Int($0.dueIn) ?? .zero < Int($1.dueIn) ?? .zero })
        }
    }
    
}
