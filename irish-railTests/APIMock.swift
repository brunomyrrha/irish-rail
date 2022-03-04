//
//  StationsAPIMock.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 03/03/2022.
//

import Foundation
@testable import irish_rail

class StationsAPIMock: StationsAPI {
    
    enum SPYError: Error {
        case failed
    }
    
    var shouldFail = false
    var stations = [Station]()
    
    // MARK: - Public methods
    
    func fetchStations() async -> Result<[Station], Error> {
        stations.append(contentsOf: [TestMocks.StationA, TestMocks.StationB])
        return shouldFail ? .failure(SPYError.failed) : .success(stations)
    }
    
    func fetchStations(type: StationType) async -> Result<[Station], Error> {
        guard !shouldFail else {
            return .failure(SPYError.failed)
        }
        stations = [type == .all ? TestMocks.StationA : TestMocks.StationB]
        return .success(stations)
    }
        
}

class StationDataAPIMock: StationDataAPI {
    
    enum SPYError: Error {
        case failed
    }
    
    var shouldFail = false
    var data = TestMocks.StationDataA
    
    func fetchInfo(from code: String) async -> Result<[StationData], Error> {
        shouldFail ? .failure(SPYError.failed) : .success([data])
    }
    
}
