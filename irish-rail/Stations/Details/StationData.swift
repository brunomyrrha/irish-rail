//
//  StationData.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import Foundation

struct StationData: Equatable {
    
    private enum Keys {
        
        static let serverTime = "ServerTime"
        static let trainCode = "Traincode"
        static let stationFullName = "Stationfullname"
        static let stationCode = "Stationcode"
        static let queryTime = "Querytime"
        static let origin = "Origin"
        static let destination = "Destination"
        static let originTime = "Origintime"
        static let destinationTime = "Destinationtime"
        static let status = "Status"
        static let lastLocation = "Lastlocation"
        static let dueIn = "Duein"
        static let late = "Late"
        static let expArrival = "Exparrival"
        static let expDepart = "Expdepart"
        static let schArrival = "Scharrival"
        static let schDepart = "Schdepart"
        static let direction = "Direction"
        static let trainType = "Traintype"
        static let locationType = "Locationtype"
        
    }
    
    var serverTime: String?
    var trainCode: String?
    var fullName: String?
    var code: String?
    var queryTime: String?
    var trainDate: String?
    var origin: String?
    var destination: String?
    var originTime: String?
    var destinationTime: String?
    var status: String?
    var lastLocation: String?
    var dueIn: String?
    var late: String?
    var expArrival: String?
    var expDeparture: String?
    var schArrival: String?
    var schDeparture: String?
    var direction: String?
    var trainType: String?
    var locationType: Character?
    
    init?(from dictionary: [String: Any]) {
        print(dictionary)
    }
    
}
