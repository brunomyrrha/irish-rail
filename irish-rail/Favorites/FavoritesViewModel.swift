//
//  FavoritesViewModel.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    
    enum FavoritesRoute {
        case alert(AlertModel)
        case station(Station)
    }
    
    private enum FavoritesViewModelError: Error {
        static var defaultErrorMessage: String { "There's an issue with favorites" }
        static var infoNotFound: String { "Station info not found" }
    }
    
    @Published private(set) var favoriteStations = [Station]()
    private(set) var route = PassthroughSubject<FavoritesRoute, Never>()
    
    private var storedStations = [Station]()
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager = StorageManagerBase.shared) {
        self.storageManager = storageManager
    }
    
    // MARK: - Public methods
    
    func loadSavedStations() async {
        await favoriteStations = storageManager.loadSavedStations()
    }
    
    func search(value text: String?) {
        guard let text = text, !text.isEmpty else {
            clearSearch()
            return
        }
        favoriteStations = storedStations.filter {
            $0.description.lowercased().contains(text.lowercased())
        }
    }
    
    func getStationName(at idx: Int) -> String {
        guard favoriteStations.count > idx else {
            routeAlert()
            return FavoritesViewModelError.infoNotFound
        }
        return favoriteStations[idx].description
    }
    
    func getStationCode(at idx: Int) -> String {
        guard favoriteStations.count > idx else {
            routeAlert()
            return FavoritesViewModelError.infoNotFound
        }
        return favoriteStations[idx].code.uppercased()
    }
    
    func didSelectFavoriteStation(at index: Int) {
        route.send(.station(favoriteStations[index]))
    }
    
    // MARK: - Private methods
    
    private func clearSearch() {
        favoriteStations = storedStations
    }
    
    private func routeAlert(error: Error? = nil) {
        let message = error?.localizedDescription ?? FavoritesViewModelError.defaultErrorMessage
        let alert = AlertModel(message: message)
        route.send(.alert(alert))
    }
    
}
