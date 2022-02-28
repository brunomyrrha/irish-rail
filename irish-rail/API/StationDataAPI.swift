//
//  StationDataAPI.swift
//  irish-rail
//
//  Created by Bruno Diniz on 28/02/2022.
//

import Foundation

protocol StationDataAPI {
    
    func fetchInfo(from code: String) async -> Result<[StationData], Error>
    
}

class StationDataAPIBase: BaseAPI<StationData>, StationDataAPI {
    
    private enum Constants {
        
        static let getStationDataByCodePath = "/realtime/realtime.asmx/getStationDataByCodeXML"
        static let stationCodeKey = "StationCode"
        static let objectKey = "objStationData"
        
    }
    
    // MARK: - Shared instance
    
    static let shared = StationDataAPIBase()
    
    private override init() {
        super.init()
    }
    
    // MARK: - StationDataAPI
    
    func fetchInfo(from code: String) async -> Result<[StationData], Error> {
        let queryItem = URLQueryItem(name: Constants.stationCodeKey, value: code)
        let url = makeURL(path: Constants.getStationDataByCodePath, queryItems: [queryItem])
        return await makeRequest(url: url)
    }
    
    // MARK: - BaseAPI methods
    
    override func didFinishParsing(result: [String : Any]) {
        guard let stationData = StationData(from: result) else { return }
        parsedObjects.append(stationData)
    }
    
    override func isEndingObjectKey(name: String) -> Bool {
        name == Constants.objectKey
    }
    
}
