//
//  Environment.swift
//  Currency
//
//  Created by David Garcia Tort on 3/10/21.
//

import Foundation

enum Environment {
    
    enum Keys {
        case currencyLayerAccessKey
        
        var key: String {
            switch self {
            case .currencyLayerAccessKey: return "CurrencyLayerAccessKey"
            }
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static func value(for key: Keys) -> String {
        guard let value = infoDictionary[key.key] as? String else {
            fatalError("\(key.key) is not set in plist for this environment")
        }
        return value
    }
    
}
