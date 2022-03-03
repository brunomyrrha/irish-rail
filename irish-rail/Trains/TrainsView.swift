//
//  TrainsView.swift
//  irish-rail
//
//  Created by Bruno Diniz on 03/03/2022.
//

import SwiftUI

struct TrainsView: View {
    
    @State private var didAppear = false
    
    let model: StationData
    private let noInfo = "Unavailable"
    
    var body: some View {
        ZStack {
            SecondarySystemBackground
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Title
                    .padding(.bottom, 16)
                Station
                Eta
                TimeSchedule
                DueTime
                    .padding(.vertical, 24)
                Spacer()
            }
            .padding(.top, 86)
            .onAppear { didAppear.toggle() }
        }
    }
    
    // MARK: - Viewbuilders
    
    @ViewBuilder private var Title: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Train Status")
                .font(.system(size: 38, weight: .bold))
                .padding(.leading, 16)
            Spacer()
            Code
        }
    }
    
    @ViewBuilder private var Code: some View {
        Text(model.code)
            .font(.system(size: 18, weight: .light))
            .padding(.horizontal, 24)
            .padding(.vertical, 4)
            .background(SystemGray)
            .foregroundColor(SystemGray6)
            .cornerRadius(12)
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder private var Station: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Destination")
                .foregroundColor(SystemGray)
                .padding(.leading)
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(model.destination)
                        .font(.system(size: 32, weight: .bold))
                }
                Spacer()
                StationSign
                    .padding(.horizontal, 8)
                
            }
            .padding()
            .background(CardBackground)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private var StationSign: some View {
        Text((model.locationType ?? "...").uppercased())
            .font(.system(size: 32, weight: .heavy))
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(SecondarySystemBackground)
            .background(SignBackgroundColor)
            .cornerRadius(8)
    }
    
    @ViewBuilder private var TimeSchedule: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Train")
                .foregroundColor(SystemGray)
                .padding(.leading)
            VStack {
                MakeTableItem(key: "Train Code", value: model.trainCode)
                MakeTableItem(key: "Departure", value: model.expDeparture ?? noInfo)
                MakeTableItem(key: "Time difference", value: model.late ?? noInfo)
            }
            .padding()
            .background(CardBackground)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private var Eta: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Status")
                .foregroundColor(SystemGray)
                .padding(.leading)
            VStack {
                MakeTableItem(key: "From", value: model.origin ?? noInfo)
                MakeTableItem(key: "Status", value: model.status ?? noInfo)
                MakeTableItem(key: "Direction", value: model.direction)
            }
            .padding()
            .background(CardBackground)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private var DueTime: some View {
            HStack {
                Spacer()
                Text(Due)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(SecondarySystemBackground)
                Spacer()
            }
            .padding(24)
            .background(DueBackgroundColor)
            .animation(.easeIn, value: didAppear)
    }
    
    @ViewBuilder private func MakeTableItem(key: String, value: String) -> some View {
        HStack {
            Text(key)
                .font(.callout)
            Spacer()
            Text(value)
                .font(.headline)
        }
    }
    
    @ViewBuilder private var CardBackground: some View {
        Rectangle()
            .foregroundColor(SystemBackground)
            .cornerRadius(4)
            .shadow(color: ShadowColor, radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Private methods
    
    private var SignBackgroundColor: Color {
        switch (model.locationType ?? "A").lowercased() {
        case "d": return .mint
        case "s": return .indigo
        case "m": return .orange
        default: return .accentColor
        }
    }
    
    private var DueBackgroundColor: Color {
        guard let due = Int(model.dueIn) else { return .accentColor }
        switch due {
        case 0 ... 10: return .red
        case 11 ... 30: return .orange
        default: return .green
        }
    }
    
    
    private var Due: String {
        guard let due = Int(model.dueIn) else { return noInfo }
        let dueMinutes = "Due in \(model.dueIn) minute"
        switch due {
        case 0: return "Arriving"
        case 1: return dueMinutes
        default: return dueMinutes.appending("s")
        }
    }
    
    private var ShadowColor: Color {
        Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.10)
    }
    
    private var SystemBackground: Color {
        Color(uiColor: UIColor.systemBackground)
    }
    
    private var SecondarySystemBackground: Color {
        Color(uiColor: UIColor.secondarySystemBackground)
    }
    
    private var SystemGray: Color {
        Color(uiColor: UIColor.systemGray)
    }
    
    private var SystemGray6: Color {
        Color(uiColor: UIColor.systemGray6)
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
