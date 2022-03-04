//
//  FavoritesViewModelTests.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 04/03/2022.
//

import XCTest
@testable import irish_rail

class FavoritesViewModelTests: XCTestCase {

    private var viewModel: FavoritesViewModel!
    private var storage: StorageManagerSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        storage = StorageManagerSpy()
        viewModel = FavoritesViewModel(storageManager: storage)
    }
    
    override func tearDown() {
        viewModel = nil
        storage = nil
        
        super.tearDown()
    }
    
    // MARK: - Test cases

    func testLoadSavedStations() async {
        XCTAssert(viewModel.favoriteStations.isEmpty)
        XCTAssertFalse(storage.didLoadSavedStations)
        await viewModel.loadSavedStations()
        XCTAssertTrue(storage.didLoadSavedStations)
        XCTAssertEqual(viewModel.favoriteStations, [TestMocks.StationA, TestMocks.StationB])
    }
    
    func testSearch() async {
        await viewModel.loadSavedStations()
        XCTAssertEqual(viewModel.favoriteStations, [TestMocks.StationA, TestMocks.StationB])
        viewModel.search(value: "name a")
        XCTAssertEqual(viewModel.favoriteStations, [TestMocks.StationA])
    }
    
    func testGetStationName() async {
        await viewModel.loadSavedStations()
        XCTAssertEqual(viewModel.getStationName(at: 0), "name a")
    }
    
    func testGetStationCode() async {
        await viewModel.loadSavedStations()
        XCTAssertEqual(viewModel.getStationCode(at: 0), "1")
    }

}
