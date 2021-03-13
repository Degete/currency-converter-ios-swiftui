//
//  ContentView.swift
//  Currency
//
//  Created by David Garcia Tort on 3/9/21.
//

import SwiftUI

struct CurrencyDashboardView: View {
    @ObservedObject var viewModel = CurrencyViewModel.shared
    @State var currentCurrency: Currency = Currency.defaultCurrency
    @State var amount: String = "1"
    @State var showCurrenciesSheet: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Form {
                            Section() {
                                Picker(selection: $currentCurrency, label: Text(currentCurrency.code)) {
                                    ForEach(viewModel.currencies.sorted { $0.name < $1.name }, id: \.code) { currency in
                                        Text(currency.name)
                                            .tag(currency)
                                    }
                                }
                                TextField("Amount", text: $amount)
                                    .font(.title)
                                    .modifier(TextFieldClearButton(text: $amount))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(height: rowHeight)
                                    .onChange(of: amount) { value in
                                        viewModel.checkRatesExpiration()
                                    }
                            }
                            Section() {
                                HStack {
                                    Text("Last update:")
                                    Spacer()
                                    Text(lastUpdate())
                                }
                                .font(.subheadline)
                            }
                            Section() {
                                ForEach(viewModel.showCurrencies, id: \.code) { currency in
                                    HStack(alignment: .center, spacing: nil) {
                                        VStack {
                                            Text(currency.code)
                                        }
                                        Spacer()
                                        Text(rateConvertion(to: currency))
                                            .font(.title)
                                    }
                                    .frame(height: rowHeight)
                                }
                                .onDelete(perform: viewModel.removeCurrency)
                                Button(action: { showCurrenciesSheet.toggle() }) {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "plus")
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                .navigationTitle("Currency")
                .navigationBarItems(
                    trailing: Button(action: {
                        showCurrenciesSheet.toggle()
                    }, label: {
                        Text(Image(systemName: "plus"))
                    })
                )
            }
            .sheet(
                isPresented: $showCurrenciesSheet,
                content: {
                    NavigationView {
                        List {
                            ForEach(viewModel.currencies.sorted { $0.name < $1.name }.filter { !viewModel.showCurrencies.contains($0) }, id: \.code) { currency in
                                Button(action: {
                                    viewModel.add(currency: currency)
                                    showCurrenciesSheet.toggle()
                                }) {
                                    Text(currency.name)
                                }
                            }
                        }
                        .navigationTitle("Currencies")
                    }
                })
        }
    }
    
    // MARK: - Drawing variables
    private var rowHeight: CGFloat = 50
    
    private func lastUpdate() -> String {
        if let lastUpdate = viewModel.lastUpdate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: lastUpdate)
        }
        return ""
    }
    
    private func rateConvertion(to currency: Currency) -> String {
        if let amount = Double(amount) {
            return String(format: "%.2f", viewModel.convert(from: currentCurrency, to: currency, amount: amount))
        }
        return "-"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyDashboardView()
    }
}
