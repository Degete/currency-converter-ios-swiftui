//
//  CurrencyTests.swift
//  CurrencyTests
//
//  Created by David Garcia Tort on 3/9/21.
//

import XCTest
@testable import Currency

class CurrencyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRateConvertion() throws {
        let viewModel = CurrencyViewModel()
        let currencies = Currency.defaultCurrenciesList
        let usd = currencies[4]
        let euro = currencies[1]
        let exchangeRate = 1.5
        let rates = [
            Rate(code: "\(usd.code)\(euro.code))", value: exchangeRate),
        ]
        viewModel.currencies = currencies
        viewModel.rates = rates
        
        // 1 USD -> 1.5 EUR
        XCTAssertEqual(viewModel.convert(from: usd, to: euro, amount: 1), 1.5)
        
        // 3 EUR -> 2 USD
        XCTAssertEqual(viewModel.convert(from: euro, to: usd, amount: 3), 2)
    }
    
    func testRateExpiration() throws {
        let viewModel = MockViewModel()
        
        // Last update 5min
        viewModel.lastUpdate = Date().addingTimeInterval(TimeInterval(-60*5))
        viewModel.checkRatesExpiration()
        XCTAssert(viewModel.dataWasFetched == false)
        
        // Last update 35min
        viewModel.lastUpdate = Date().addingTimeInterval(TimeInterval(-60*35))
        viewModel.checkRatesExpiration()
        XCTAssert(viewModel.dataWasFetched == true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockViewModel: CurrencyViewModel {
    var dataWasFetched = false
    override func fetchRates() {
        self.dataWasFetched = true
    }
}
