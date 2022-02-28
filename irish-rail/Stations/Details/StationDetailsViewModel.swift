//
//  StationDetailsViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import Foundation
import Combine

class StationDetailsViewModel: ObservableObject {
    
    @Published private(set) var title: String = .empty
    private var fetchedStationData = [StationData]()
    
    private let api: StationDataAPI
    
    init(api: StationDataAPI = StationDataAPIBase.shared) {
        self.api = api
    }
    
    // MARK: - Public methods

    func fetchStationData(with code: String) async {
        title = code
        let result = await api.fetchInfo(from: code)
        switch result {
        case .success(let values): print(values)
        case .failure(let error): print(error)
        }
    }
    
    func favoriteStation() {
        
    }
}
