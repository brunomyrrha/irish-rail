//
//  StationsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation
import Combine

class StationsViewModel: ObservableObject {
    
    @Published var stations = [Station]()
    private let api: StationsAPI
    
    init(api: StationsAPI = StationsAPIBase.shared) {
        self.api = api
    }
    
    // MARK: - Public methods
    
    func fetchStations(id: Int) async {
        let result = await api.fetchStations(type: .init(rawValue: id) ?? .all)
        switch result {
        case .success(let values): stations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): print(error.localizedDescription)
        }
    }
    
    func fetchStations() async {
        let result = await api.fetchStations()
        switch result {
        case .success(let values): stations = values.sorted(by: { $0.description < $1.description })
        case .failure(let error): print(error.localizedDescription)
        }
    }
    
}
