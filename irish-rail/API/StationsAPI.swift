//
//  StationsAPI.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation

class StationsAPI: BaseAPI<Station> {
    
    private enum Constants {
    
        static let scheme = "http"
        static let host = "api.irishrail.ie"
        static let allStationsPath = "/realtime/realtime.asmx/getAllStationsXML"
        static let allStationsWithTypeURL = "/realtime/realtime.asmx/getAllStationsXML_WithStationType"
        static let objectKey = "objStation"
        
    }
    
    enum URLStationType: Int {
        case all
        case mainline
        case suburban
        case dart
        
        var key: String { "StationType" }
        var value: String {
            switch self {
            case .dart: return "D"
            case .suburban: return "S"
            case .mainline: return "M"
            default: return "A"
            }
        }
        
    }
    
    // MARK: - Shared
    
    static let shared = StationsAPI()
    private override init() {
        super.init()
    }
    
    // MARK: - Public methods
    
    func fetchStations(completion: @escaping (Result<[Station], Error>) -> Void) {
        let url = makeURL(path: Constants.allStationsPath)
        super.makeRequest(url: url, completion: completion)
    }
    
    func fetchStations(type: URLStationType, completion: @escaping(Result<[Station], Error>) -> Void) {
        let queryItem = URLQueryItem(name: type.key, value: type.value)
        let url = makeURL(path: Constants.allStationsWithTypeURL, queryItems: [queryItem])
        super.makeRequest(url: url, completion: completion)
    }
    
    // MARK: - BaseAPI methods
    
    override func didFinishParsing(result: [String : Any]) {
        guard let station = Station(from: result) else { return }
        parsedObjects.append(station)
    }
    
    override func isEndingObjectKey(name: String) -> Bool {
        name == Constants.objectKey
    }
    
    // MARK: - Private methods
    
    private func makeURL(path: String, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
    
}
