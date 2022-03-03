//
//  TrainsView.swift
//  irish-rail
//
//  Created by Bruno Diniz on 03/03/2022.
//

import SwiftUI

struct TrainsView: View {
    
    var model: StationData
    
    var body: some View {
        VStack {
            Text(model.code)
            Text(model.fullName)
            Text(model.trainCode)
            Text(model.destination)
            Text(model.expDeparture ?? "NOT FOUND")
            Text(model.expArrival ?? "NOT FOUND")
            Text(model.status ?? "NOT FOUND")
            Text(model.locationType ?? "NOT FOUND")
            Text(model.dueIn)
            
        }
    }
}

struct TrainsView_Previews: PreviewProvider {

    static let stationDictionary = ["Traincode": "P407 ",
                                    "Destination": "Grand Canal Dock",
                                    "Expdepart": "10:37",
                                    "Schdepart": "10:37",
                                    "Traintype": "Train",
                                    "Destinationtime": "11:20",
                                    "Duein": "56",
                                    "Scharrival": "10:36",
                                    "Stationcode": "ADMTN",
                                    "Lastlocation": "\n    ",
                                    "Traindate": "03 Mar 2022",
                                    "Direction": "Northbound",
                                    "Status": "No Information",
                                    "Querytime": "09:41:18",
                                    "Late": "0",
                                    "Origintime": "10:32",
                                    "Origin": "Hazelhatch",
                                    "Stationfullname": "Adamstown",
                                    "Locationtype": "S",
                                    "Exparrival": "10:36",
                                    "Servertime": "2022-03-03T09:41:18.767"]

    static var previews: some View {
        TrainsView(model:  StationData(from: stationDictionary)!)
    }
}
