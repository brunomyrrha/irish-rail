//
//  StationPin.swift
//  irish-rail
//
//  Created by Bruno Diniz on 02/03/2022.
//

import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
