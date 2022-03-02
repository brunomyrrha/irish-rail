//
//  Station.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import Foundation

struct Station: Equatable {
    
    private enum Keys {
        
        static let id = "StationId"
        static let code = "StationCode"
        static let alias = "StationAlias"
        static let description = "StationDesc"
        static let latitude = "StationLatitude"
        static let longitude = "StationLongitude"
        
    }
    
    var id: Int
    var description: String
    var code: String?
    var alias: String?
    var latitude: Double?
    var longitude: Double?
    
    init?(from dictionary: [String: Any]) {
        guard let idString = dictionary[Keys.id] as? String,
              let id = Int(idString),
              let description = dictionary[Keys.description] as? String else { return nil }
        self.id = id
        self.description = description
        code = dictionary[Keys.code] as? String
        alias = dictionary[Keys.alias] as? String
        if let latitudeString = dictionary[Keys.latitude] as? String {
            latitude = Double(latitudeString)
        }
        if let longitudeString = dictionary[Keys.longitude] as? String {
            longitude = Double(longitudeString)
        }
    }
    
    
}

