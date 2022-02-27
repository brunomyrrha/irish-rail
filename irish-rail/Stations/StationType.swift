//
//  StationType.swift
//  irish-rail
//
//  Created by Bruno Diniz on 27/02/2022.
//

import Foundation

enum StationType: Int {
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
