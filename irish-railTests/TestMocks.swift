//
//  TestMocks.swift
//  irish-railTests
//
//  Created by Bruno Diniz on 03/03/2022.
//

import Foundation
@testable import irish_rail

enum TestMocks {
    
    static var StationA: Station {
        let data = ["StationId": "1",
                    "StationDesc": "name a",
                    "StationCode": "1"]
        let station = Station(from: data)
        return station!
    }
    
    static var StationB: Station {
        let data = ["StationId": "2",
                    "StationDesc": "name b",
                    "StationCode": "2"]
        let station = Station(from: data)
        return station!
    }
    
    static var StationDataA: StationData {
        let data = ["Stationfullname": "Name",
                    "Stationcode": "ARGH"
,                    "Traincode": "Code",
                    "Duein": "1",
                    "Destination": "Destination",
                    "Direction": "Direction"]
        let stationData = StationData(from: data)
        return stationData!
    }
    
}
