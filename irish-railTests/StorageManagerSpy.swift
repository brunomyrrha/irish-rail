//
//  StorageManagerSpy.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 03/03/2022.
//

import Foundation
@testable import irish_rail

class StorageManagerSpy: StorageManager {
    
    private(set) var didFavoriteStation = false
    private(set) var didUnfavoriteStation = false
    private(set) var didLoadSavedStations = false
    private(set) var didLoadStations = false
    private(set) var didSaveStation = false
    private(set) var didCalledIsStationSaved = false
    private(set) var didCommitStorage = false
    private(set) var didLoadStorage = false
    private var savedStation = false
    
    func favoriteStation(_ station: Station) {
        didFavoriteStation = true
        savedStation = true
    }
    
    func unfavoriteStation(_ station: Station) {
        didUnfavoriteStation = true
        savedStation = false
    }
    
    func loadSavedStations() async -> [Station] {
        didLoadSavedStations = true
        return [TestMocks.StationA, TestMocks.StationB]
    }
    
    func loadStations() async -> [Station] {
        didLoadStations = true
        return []
    }
    
    func cacheStations(_ stations: [Station]) {
        didSaveStation = true
    }
    
    func isStationSaved(_ station: Station) -> Bool {
        didCalledIsStationSaved = true
        return savedStation
    }
    
    func commitStorage() {
        didCommitStorage = true
    }
    
    func loadStorage() async {
        didLoadStorage = true
    }
    
}
