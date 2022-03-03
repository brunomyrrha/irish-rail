//
//  Storage.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import Foundation

protocol StorageManager: AnyObject {
    
    func saveStation(_ station: Station)
    
    func deleteStation(_ station: Station)
    
    func loadStations() -> [Station]
    
    func isStationSaved(_ station: Station) -> Bool
    
    func commitStorage()
    
    func loadStorage()
    
}

class StorageManagerBase: StorageManager {
    
    private var loadedStations = Set<Station>()
    
    static let shared = StorageManagerBase()
    private init() { }
    
    // MARK: - Public methods
    
    func saveStation(_ station: Station) {
        loadedStations.insert(station)
    }
    
    func deleteStation(_ station: Station) {
        loadedStations.remove(station)
    }
    
    func loadStations() -> [Station] {
        Array(loadedStations.sorted(by: { $0.description < $1.description }))
    }
    
    func isStationSaved(_ station: Station) -> Bool {
        loadedStations.contains(station)
    }
    
    func commitStorage() {
        
    }
    
    func loadStorage() {
        
    }
    
}
