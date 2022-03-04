//
//  AppDelegate.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task.detached {
            await StorageManagerBase.shared.loadStorage()
        }
        return true
    }

}

