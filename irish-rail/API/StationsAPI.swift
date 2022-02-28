//
//  StationsAPI.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation

protocol StationsAPI {
    
    func fetchStations() async -> Result<[Station], Error>
    
    func fetchStations(type: StationType) async -> Result<[Station], Error>
    
}

class StationsAPIBase: BaseAPI<Station>, StationsAPI {
    
    private enum Constants {
    
        static let allStationsPath = "/realtime/realtime.asmx/getAllStationsXML"
        static let allStationsWithTypeURL = "/realtime/realtime.asmx/getAllStationsXML_WithStationType"
        static let objectKey = "objStation"
        
    }
    
    // MARK: - Shared instance
    
    static let shared = StationsAPIBase()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public methods
    
    func fetchStations() async -> Result<[Station], Error> {
        let url = makeURL(path: Constants.allStationsPath)
        return await makeRequest(url: url)
    }
    
    func fetchStations(type: StationType) async -> Result<[Station], Error> {
        let queryItem = URLQueryItem(name: type.key, value: type.value)
        let url = makeURL(path: Constants.allStationsWithTypeURL, queryItems: [queryItem])
        return await makeRequest(url: url)
    }
    
    // MARK: - BaseAPI methods
    
    override func didFinishParsing(result: [String : Any]) {
        guard let station = Station(from: result) else { return }
        parsedObjects.append(station)
    }
    
    override func isEndingObjectKey(name: String) -> Bool {
        name == Constants.objectKey
    }
    
}
