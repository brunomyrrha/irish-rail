//
//  TrainsView.swift
//  irish-rail
//
//  Created by Bruno Diniz on 03/03/2022.
//

import SwiftUI

struct TrainsView: View {
    
    static func initVC(trains: StationData) -> UIHostingController<TrainsView> {
        let view = TrainsView(model: trains)
        let hostingViewController = UIHostingController(rootView: view)
        return hostingViewController
    }
    
    @State private var didAppear = false
    
    let model: StationData
    private let noInfo = "Unavailable"
    
    var body: some View {
        ZStack {
            SecondarySystemBackgroundColor
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Title
                    .padding(.bottom)
                Station
                Train
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
                .font(.largeTitle)
                .bold()
                .padding(.leading)
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
            .padding(.horizontal)
    }
    
    @ViewBuilder private var Station: some View {
        VStack(alignment: .leading, spacing: 4) {
            MakeCardTitle("Destination")
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(model.destination)
                        .font(.title)
                }
                Spacer()
                StationSign
                    .padding(.horizontal, 8)
                
            }
            .padding()
            .background(CardBackground)
        }
    }
    
    @ViewBuilder private var StationSign: some View {
        Text((model.locationType ?? "...").uppercased())
            .font(.system(size: 32, weight: .heavy))
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(SystemBackgroundColor)
            .background(SignBackgroundColor)
            .cornerRadius(8)
    }
    
    @ViewBuilder private var TimeSchedule: some View {
        VStack(alignment: .leading, spacing: 4) {
            MakeCardTitle("Train")
            VStack {
                MakeTableItem(key: "Train Code", value: model.trainCode)
                MakeTableItem(key: "Departure", value: model.expDeparture ?? noInfo)
                MakeTableItem(key: "Split difference", value: model.late ?? noInfo)
            }
            .padding()
            .background(CardBackground)
        }
    }
    
    @ViewBuilder private var Train: some View {
        VStack(alignment: .leading, spacing: 4) {
            MakeCardTitle("Status")
            VStack {
                MakeTableItem(key: "From", value: model.origin ?? noInfo)
                MakeTableItem(key: "Status", value: model.status ?? noInfo)
                MakeTableItem(key: "Direction", value: model.direction)
            }
            .padding()
            .background(CardBackground)
        }
    }
    
    @ViewBuilder private var DueTime: some View {
        HStack {
            Spacer()
            Text(Due)
                .font(.title3)
                .bold()
                .foregroundColor(SystemBackgroundColor)
            Spacer()
        }
        .padding()
        .background(DueBackgroundColor)
        .animation(.easeIn, value: didAppear)
    }
    
    @ViewBuilder private func MakeCardTitle(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .foregroundColor(SystemGray)
            .padding(.leading)
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
            .foregroundColor(SystemBackgroundColor)
            .cornerRadius(4)
    }
    
    // MARK: - Private methods
    
    private var SignBackgroundColor: Color {
        switch (model.locationType ?? "A").lowercased() {
        case "d": return .mint
        case "s": return .indigo
        case "o": return .orange
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
    
    private var SystemBackgroundColor: Color {
        Color(uiColor: UIColor.systemBackground)
    }
    
    private var SecondarySystemBackgroundColor: Color {
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
