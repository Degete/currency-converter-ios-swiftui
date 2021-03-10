//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by David Garcia Tort on 3/10/21.
//

import Foundation

class CurrencyViewModel: ObservableObject {
    static let shared = CurrencyViewModel()
    
    @Published var currencies: [Currency] {
        didSet {
            saveCurrencies()
        }
    }
    @Published var rates: [Rate] {
        didSet {
            saveRates()
        }
    }
    @Published var showCurrencies: [Currency] {
        didSet {
            saveCurrencyList()
        }
    }
    
    init() {
        currencies = (UserDefaults.standard.array(forKey: "currencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        rates = (UserDefaults.standard.object(forKey: "rates") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Rate.self, from: $0) }
        showCurrencies = (UserDefaults.standard.object(forKey: "showCurrencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        
        if currencies.isEmpty {
            CurrencyLayer.shared.fetchCurrencies(completionHandler: { currencies in
                self.currencies = currencies
            }, errorHandler: { error in
                self.currencies = Currency.defaultCurrenciesList
                print("ERROR: \(error.localizedDescription)")
            })
            
        }
        
        if rates.isEmpty {
            CurrencyLayer.shared.fetchRates(completionHandler: { rates in
                self.rates = rates
            }, errorHandler: { error in
                print("ERROR: \(error.localizedDescription)")
            })
        }
        
        if showCurrencies.isEmpty {
            self.showCurrencies = Currency.defaultCurrenciesList
        }
    }
    
    private func saveCurrencies() {
        let data = currencies.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "currencies")
    }
    
    private func saveRates() {
        let data = rates.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "rates")
    }
    
    private func saveCurrencyList() {
        let data = showCurrencies.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.setValue(data, forKey: "showCurrencies")
    }
    
    private func filterRateByCurrency(from: Currency, to: Currency) -> Double {
        // USD is based for all convertions
        let baseCurrency = "USD"
        var value: Double = 1
        rates.forEach { rate in
            let convertionCurrency = rate.code.components(withLength: 3)
            //let fromCurrency = convertionCurrency[0]
            let toCurrency = convertionCurrency[1]
            if from.code != baseCurrency, from.code == toCurrency {
                value /= rate.value
            }
            if toCurrency == to.code {
                value *= rate.value
            }
        }
        return value
    }
    
    func convert(from: Currency, to: Currency, amount: Double) -> Double {
        amount * filterRateByCurrency(from: from, to: to)
    }
    
    func add(currency: Currency) {
        showCurrencies.append(currency)
    }
    
    func removeCurrency(at index: IndexSet) {
        index.forEach { showCurrencies.remove(at: $0) }
    }
}

extension String {
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}
