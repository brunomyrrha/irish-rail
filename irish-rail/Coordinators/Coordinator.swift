//
//  Coordinator.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    func start()
    
}
