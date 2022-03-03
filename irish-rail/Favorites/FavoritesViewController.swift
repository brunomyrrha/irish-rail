//
//  FavoritesViewController.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    weak var coordinator: FavoritesCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
