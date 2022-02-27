//
//  StationsViewModelTests.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 27/02/2022.
//

import XCTest
@testable import irish_rail

class StationsViewModelTests: XCTestCase {

    var viewModel: StationsViewModel!
    fileprivate var api: StationsAPISpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        api = StationsAPISpy()
        viewModel = StationsViewModel(api: api)
    }
    
    override func tearDown() {
        
        viewModel = nil
        api = nil
        super.tearDown()
    }
    
    // MARK: - Test cases
    
    func testFetchStationsSucceed() async {
        await viewModel.fetchStations()
        XCTAssertEqual(viewModel.stations, [api.mockedStation])
        await viewModel.fetchStations(id: 1)
        XCTAssertEqual(viewModel.stations, [api.mockedStation])
    }
    
    func testFetchStationsFail() async {
        api.shouldFail = true
        await viewModel.fetchStations()
        XCTAssertEqual(viewModel.stations, [])
        await viewModel.fetchStations(id: 1)
        XCTAssertEqual(viewModel.stations, [])
    }

}

private class StationsAPISpy: StationsAPI {
    
    enum SPYError: Error {
        case failed
    }
    
    var shouldFail = false
    var stations = [Station]()
    
    var mockedStation: Station {
        let data = ["StationId": "1", "StationDesc": "description"]
        let station = Station(from: data)
        return station!
    }
    
    init() {
        stations.append(mockedStation)
    }
    
    // MARK: - Public methods
    
    func fetchStations() async -> Result<[Station], Error> {
        shouldFail ? .failure(SPYError.failed) : .success(stations)
    }
    
    func fetchStations(type: StationType) async -> Result<[Station], Error> {
        shouldFail ? .failure(SPYError.failed) : .success(stations)
    }
    
}
