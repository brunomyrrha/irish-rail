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
        static let trainDate = "Traindate"
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
    
    var fullName: String
    var code: String
    var trainCode: String
    var dueIn: String
    var destination: String
    var serverTime: String?
    var queryTime: String?
    var trainDate: String?
    var origin: String?
    var originTime: String?
    var destinationTime: String?
    var status: String?
    var lastLocation: String?
    var late: String?
    var expArrival: String?
    var expDeparture: String?
    var schArrival: String?
    var schDeparture: String?
    var direction: String?
    var trainType: String?
    var locationType: Character?
    
    init?(from dictionary: [String: Any]) {
        guard let fullName = dictionary[Keys.stationFullName] as? String,
              let code = dictionary[Keys.stationCode] as? String,
              let trainCode = dictionary[Keys.trainCode] as? String,
              let dueIn = dictionary[Keys.dueIn] as? String,
              let destination = dictionary[Keys.destination] as? String else { return nil }
        self.fullName = fullName
        self.code = code
        self.trainCode = trainCode
        self.dueIn = dueIn
        self.destination = destination
        serverTime = dictionary[Keys.serverTime] as? String
        queryTime = dictionary[Keys.queryTime] as? String
        trainDate = dictionary[Keys.trainDate] as? String
        origin = dictionary[Keys.origin] as? String
        originTime = dictionary[Keys.originTime] as? String
        status = dictionary[Keys.status] as? String
        lastLocation = dictionary[Keys.lastLocation] as? String
        late = dictionary[Keys.late] as? String
        expArrival = dictionary[Keys.expArrival] as? String
        expDeparture = dictionary[Keys.expDepart] as? String
        schArrival = dictionary[Keys.schArrival] as? String
        schDeparture = dictionary[Keys.schDepart] as? String
        direction = dictionary[Keys.direction] as? String
        trainType = dictionary[Keys.trainType] as? String
        locationType = dictionary[Keys.locationType] as? Character
    }
    
}
