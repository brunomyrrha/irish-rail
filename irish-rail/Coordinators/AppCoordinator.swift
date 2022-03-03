//
//  AppCoordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

class AppCoordinator {
    
    private let stationNavigationController: UINavigationController
    private let favoriteNavigationController: UINavigationController
    private let tabBarController: UITabBarController
    private var childCoordinators: [Coordinator]
    
    // MARK: - Lifecycle
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        stationNavigationController = UINavigationController()
        favoriteNavigationController = UINavigationController()
        childCoordinators = []
        configureTabBarController()
    }
    
    // MARK: - Coordinator methods
    
    func start() {
        makeStationCoordinator()
        makeFavoriteCoordinator()
    }
    
    // MARK: - Private methods
    
    private func configureTabBarController() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        tabBarController.viewControllers = [stationNavigationController, favoriteNavigationController]
    }
    
    private func makeStationCoordinator() {
        let tabBarItem = UITabBarItem(title: "Stations", image: UIImage(systemName: "tram"), tag: 0)
        stationNavigationController.tabBarItem = tabBarItem
        let coordinator = StationsCoordinator(navigationController: stationNavigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func makeFavoriteCoordinator() {
        let tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bookmark"), tag: 1)
        favoriteNavigationController.tabBarItem = tabBarItem
        let coordinator = FavoritesCoordinator(navigationController: favoriteNavigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
