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
    
    func loadFavoriteStations() -> [Station]
    
    func loadCachedStations() -> [Station]
    
    func cacheStations(_ stations: [Station])
    
    func isStationSaved(_ station: Station) -> Bool
    
    func commitStorage()
    
    func loadStorage()
    
}

class StorageManagerBase: StorageManager {
    
    private enum Keys {
        static let favoriteStationsId = "FavoriteStationsId"
        static let stationsCache = "StationsCache"
        static let lastCacheTime = "LastCacheTime"
    }
    
    private var favoriteStationsId = Set<Int>()
    private var cachedStations = Set<Station>()
    
    static let shared = StorageManagerBase()
    private init() { }
    
    // MARK: - Public methods
    
    func favoriteStation(_ station: Station) {
        favoriteStationsId.insert(station.id)
    }
    
    func unfavoriteStation(_ station: Station) {
        favoriteStationsId.remove(station.id)
    }
    
    func loadCachedStations() -> [Station] {
        Array(cachedStations.sorted(by: { $0.description < $1.description }))
    }
    
    func cacheStations(_ stations: [Station]) {
        cachedStations = Set(stations)
    }
    
    func isStationSaved(_ station: Station) -> Bool {
        cachedStations.contains(station) && favoriteStationsId.contains(station.id)
    }
    
    func loadFavoriteStations() -> [Station] {
        Array(cachedStations.filter { favoriteStationsId.contains($0.id) }.sorted(by: { $0.code < $1.code} ))
    }
    
    func commitStorage() {
        storeInUserDefaults()
    }
    
    func loadStorage() {
        if shouldPurgeLocalCache() {
            purgeLocalCache()
        }
        loadFromUserDefaults()
    }
    
    // MARK: - Private methods
    
    private func shouldPurgeLocalCache() -> Bool {
        if let data = UserDefaults.standard.data(forKey: Keys.lastCacheTime) {
            do {
                let lastTime = try JSONDecoder().decode(TimeInterval.self, from: data)
                let now = Date().timeIntervalSince1970
                let week: Double = 86400 * 7
                if now - lastTime > week {
                    return true
                }
            } catch (let error) {
                handleError(error: error)
            }
        }
        do {
            let time = try JSONEncoder().encode(Date().timeIntervalSince1970)
            UserDefaults.standard.set(time, forKey: Keys.lastCacheTime)
        } catch (let error) {
            handleError(error: error)
        }
        return false
    }
    
    private func purgeLocalCache() {
        UserDefaults.standard.removeObject(forKey: Keys.stationsCache)
    }
    
    private func storeInUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let stationsCache = try encoder.encode(cachedStations)
            let favorites = try encoder.encode(favoriteStationsId)
            UserDefaults.standard.set(stationsCache, forKey: Keys.stationsCache)
            UserDefaults.standard.set(favorites, forKey: Keys.favoriteStationsId)
        } catch (let error) {
            handleError(error: error)
        }
    }
    
    private func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        if let cacheData = UserDefaults.standard.data(forKey: Keys.stationsCache) {
            do {
                let decodedData = try decoder.decode(Set<Station>.self, from: cacheData)
                cachedStations = decodedData
            } catch (let error) {
                handleError(error: error)
            }
        }
        if let favoritesData = UserDefaults.standard.data(forKey: Keys.favoriteStationsId) {
            do {
                let decodedData = try decoder.decode(Set<Int>.self, from: favoritesData)
                favoriteStationsId = decodedData
            } catch (let error) {
                handleError(error: error)
            }
        }
    }
    
    private func handleError(error: Error?) {
        
    }
    
}
