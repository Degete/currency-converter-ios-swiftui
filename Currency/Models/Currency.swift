//
//  Currency.swift
//  Currency
//
//  Created by David Garcia Tort on 3/10/21.
//

import Foundation

struct Currency: Codable, Hashable {
    var code: String
    var name: String
    
    static let defaultCurrency = Currency(code: "USD", name: "United States Dollar")
    static let defaultCurrenciesList = [
        Currency(code: "CNY", name: "Chinese Yuan"),
        Currency(code: "EUR", name: "Euro"),
        Currency(code: "JPY", name: "Japanese Yen"),
        Currency(code: "KRW", name: "South Korean Won"),
        Currency(code: "USD", name: "United States Dollar")
    ]
}
