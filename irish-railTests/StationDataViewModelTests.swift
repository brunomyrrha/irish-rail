//
//  StationDataViewModelTests.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 03/03/2022.
//

import XCTest
@testable import irish_rail

class StationDataViewModelTests: XCTestCase {

    private var viewModel: StationDataViewModel!
    private var api: StationDataAPIMock!
    private var storage: StorageManagerSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        api = StationDataAPIMock()
        storage = StorageManagerSpy()
        viewModel = StationDataViewModel(station: TestMocks.StationA, api: api, storageManager: storage)
    }
    
    override func tearDown() {
        viewModel = nil
        api = nil
        storage = nil
        
        super.tearDown()
    }
    
    // MARK: - Test cases
    
    func testFetchStationDataSuccess() async {
        XCTAssert(viewModel.stationData.isEmpty)
        await viewModel.fetchStationData()
        XCTAssertEqual(viewModel.stationData, [TestMocks.StationDataA])
    }
    
    func testFetchStationDataError() async {
        api.shouldFail = true
        XCTAssert(viewModel.stationData.isEmpty)
        await viewModel.fetchStationData()
        XCTAssert(viewModel.stationData.isEmpty)
    }
    
    func testFavoriteStationToggle() {
        XCTAssertFalse(viewModel.isFavorite)
        XCTAssertFalse(storage.didFavoriteStation)
        viewModel.favoriteStationToggle()
        XCTAssert(viewModel.isFavorite)
        XCTAssert(storage.didFavoriteStation)
        viewModel.favoriteStationToggle()
        XCTAssertFalse(viewModel.isFavorite)
        XCTAssertTrue(storage.didFavoriteStation)
    }
    
    func testGetTime() async {
        api.data.dueIn = "0"
        await viewModel.fetchStationData()
        XCTAssertEqual(viewModel.getTime(at: 0), "Due")
        api.data.dueIn = "2"
        await viewModel.fetchStationData()
        XCTAssertEqual(viewModel.getTime(at: 0), "Due in 2 minutes")
    }
    
}
