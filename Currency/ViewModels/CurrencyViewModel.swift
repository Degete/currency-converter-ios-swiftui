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
    @Published var lastUpdate: Date? {
        didSet {
            saveLastUpdate()
        }
    }
    
    init() {
        currencies = (UserDefaults.standard.array(forKey: "currencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        rates = (UserDefaults.standard.object(forKey: "rates") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Rate.self, from: $0) }
        showCurrencies = (UserDefaults.standard.object(forKey: "showCurrencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date
        
        if currencies.isEmpty {
            fetchCurrencies()
        }
        
        if rates.isEmpty {
            fetchRates()
        }
        
        if showCurrencies.isEmpty {
            self.showCurrencies = Currency.defaultCurrenciesList
        }
    }
    
    func fetchCurrencies() {
        CurrencyLayer.shared.fetchCurrencies(completionHandler: { currencies in
            self.currencies = currencies
        }, errorHandler: { error in
            self.currencies = Currency.defaultCurrenciesList
            print("ERROR: \(error.localizedDescription)")
        })
    }
    
    func fetchRates() {
        CurrencyLayer.shared.fetchRates(completionHandler: { rates in
            self.rates = rates
            self.lastUpdate = Date()
        }, errorHandler: { error in
            print("ERROR: \(error.localizedDescription)")
        })
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
    
    private func saveLastUpdate() {
        UserDefaults.standard.setValue(lastUpdate, forKey: "lastUpdate")
    }
    
    func checkRatesExpiration() {
        let expirationMinutes = 30
        if let lastUpdate = lastUpdate {
            let minutes = Date().minutesFromNow(date: lastUpdate)
            if minutes > expirationMinutes {
                fetchRates()
            }
        }
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
