//
//  BaseAPI.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import Foundation

class BaseAPI<T>: NSObject, XMLParserDelegate {
    
    private enum APIFailure: Error {
        case data, code
    }
    
    var parsedObjects = [T]()
    private var keyBuffer: String = .empty
    private var valueBuffer: String = .empty
    private var tempData = [String: Any]()
    private let scheme = "http"
    private let host = "api.irishrail.ie"
    
    override init() { }
    
    // MARK: - Public methods
    
    func makeRequest(url: URL) async -> Result<[T], Error> {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                throw APIFailure.code
            }
            try self.startParser(from: data)
            let parsedObjects = self.parsedObjects
            self.parsedObjects.removeAll()
            return .success(parsedObjects)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func didFinishParsing(result: [String : Any]) {
        fatalError("Call from BaseAPI not allowed")
    }
    
    func isEndingObjectKey(name: String) -> Bool {
        fatalError("Call from BaseAPI not allowed")
    }
        
    func makeURL(path: String, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
    
    // MARK: - XMLParserDelegate

        func parser(_ parser: XMLParser,
                    didStartElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?,
                    attributes attributeDict: [String : String] = [:]) {
            keyBuffer = elementName
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            valueBuffer = string
        }
        
        func parser(_ parser: XMLParser,
                    didEndElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?) {
            endParsingElement()
            if isEndingObjectKey(name: elementName) {
                didFinishParsing(result: tempData)
                tempData.removeAll()
            }
        }
        
    
    // MARK: - Private methods
    
    private func startParser(from data: Data?) throws {
        guard let data = data else { throw APIFailure.data }
        let parser = XMLParser(data: data)
        parser.delegate = self
        if !parser.parse() {
            throw APIFailure.data
        }
    }
    
    private func endParsingElement() {
        tempData[keyBuffer] = valueBuffer
        keyBuffer = .empty
        valueBuffer = .empty
    }
    
}
