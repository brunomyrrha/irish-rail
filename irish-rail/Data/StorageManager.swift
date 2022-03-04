//
//  Storage.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import Foundation

protocol StorageManager: AnyObject {
    
    func favoriteStation(_ station: Station)
    
    func unfavoriteStation(_ station: Station)
    
    func loadSavedStations() async -> [Station]
    
    func loadStations() async -> [Station]
    
    func saveStations(_ stations: [Station])
    
    func isStationSaved(_ station: Station) -> Bool
    
    func commitStorage()
    
    func loadStorage() async
    
}

class StorageManagerBase: StorageManager {

    private var favoriteStationsId = Set<Int>()
    private var loadedStations = Set<Station>()
    
    static let shared = StorageManagerBase()
    private init() { }
    
    // MARK: - Public methods
    
    func favoriteStation(_ station: Station) {
        favoriteStationsId.insert(station.id)
    }
    
    func unfavoriteStation(_ station: Station) {
        favoriteStationsId.remove(station.id)
    }
    
    func loadStations() -> [Station] {
        Array(loadedStations.sorted(by: { $0.description < $1.description }))
    }
    
    func saveStations(_ stations: [Station]) {
        loadedStations = Set(stations)
    }
    
    func isStationSaved(_ station: Station) -> Bool {
        loadedStations.contains(station) && favoriteStationsId.contains(station.id)
    }
    
    func loadSavedStations() async -> [Station] {
        Array(loadedStations.filter { favoriteStationsId.contains($0.id) }.sorted(by: { $0.code < $1.code} ))
    }
    
    func commitStorage() {
        print("Save")
    }
    
    func loadStorage() async {
        print("Load")
    }
    
    // MARK: - Private methods
    
    private func shouldPurgeLocalStorage() -> Bool {
        false
    }

}
