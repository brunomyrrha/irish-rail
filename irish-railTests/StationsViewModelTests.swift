//
//  StationsViewModelTests.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 27/02/2022.
//

import XCTest
@testable import irish_rail

class StationsViewModelTests: XCTestCase {

    private var viewModel: StationsViewModel!
    private var api: StationsAPIMock!
    private var storage: StorageManagerSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        api = StationsAPIMock()
        storage = StorageManagerSpy()
        viewModel = StationsViewModel(api: api, storageManager: storage)
    }
    
    override func tearDown() {
        viewModel = nil
        api = nil
        storage = nil
        
        super.tearDown()
    }
    
    // MARK: - Test cases
    
    func testFetchStationsSucceed() async {
        XCTAssertFalse(storage.didLoadStations)
        XCTAssert(viewModel.stations.isEmpty)
        await viewModel.fetchStations()
        XCTAssert(storage.didLoadStations)
        XCTAssertEqual(viewModel.stations, [TestMocks.StationA, TestMocks.StationB])
        await viewModel.fetchStations(id: 0)
        XCTAssertEqual(viewModel.stations, [TestMocks.StationA])
        await viewModel.fetchStations(id: 1)
        XCTAssertEqual(viewModel.stations, [TestMocks.StationB])
    }
    
    func testFetchStationsFail() async {
        api.shouldFail = true
        await viewModel.fetchStations()
        XCTAssert(viewModel.stations.isEmpty)
        await viewModel.fetchStations(id: 1)
        XCTAssert(viewModel.stations.isEmpty)
    }

    func testGetStationName() async {
        await viewModel.fetchStations()
        XCTAssertEqual(viewModel.getStationName(at: 0), "Name A")
        XCTAssertEqual(viewModel.getStationName(at: 1), "Name B")
    }
    
    func testGetStationCode() async {
        await viewModel.fetchStations()
        XCTAssertEqual(viewModel.getStationCode(at: 0), "1")
        XCTAssertEqual(viewModel.getStationCode(at: 1), "2")
    }
    
    func testSearch() async {
        XCTAssert(viewModel.stations.isEmpty)
        await viewModel.fetchStations()
        XCTAssertFalse(viewModel.stations.isEmpty)
        viewModel.search(value: "Name A")
        XCTAssertEqual(viewModel.stations, [TestMocks.StationA])
    }
    
}
