//
//  UIViewController+Extensions.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

extension UIViewController {
    
    // MARK: - Public methods
    
    static func initFromStoryboard(named: String) -> Self {
        initHelper(storyboardName: named)
    }
    
    // MARK: - Private methods
    
    private static func initHelper<T>(storyboardName: String) -> T {
        let filename = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: filename)
        return viewController as! T
    }
    
}
