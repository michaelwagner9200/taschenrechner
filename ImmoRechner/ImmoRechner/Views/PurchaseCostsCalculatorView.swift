import SwiftUI

struct PurchaseCostsCalculatorView: View {
    @State private var purchasePrice: Double = 300_000
    @State private var state: GermanState = .nordrheinWestfalen
    @State private var transferTaxRate: Double = GermanState.nordrheinWestfalen.defaultTaxRatePercent
    @State private var notaryAndRegistryFeePercent: Double = 1.5
    @State private var brokerFeePercent: Double = 3.57

    private var breakdown: PurchaseCostsBreakdown {
        Calculations.purchaseCosts(
            purchasePrice: purchasePrice,
            state: state,
            transferTaxRatePercentOverride: transferTaxRate,
            notaryAndRegistryFeePercent: notaryAndRegistryFeePercent,
            brokerFeePercent: brokerFeePercent
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Kaufdaten") {
                    NumberInputRow(label: "Kaufpreis", value: $purchasePrice)
                    Picker("Bundesland", selection: $state) {
                        ForEach(GermanState.allCases) { state in
                            Text(state.rawValue).tag(state)
                        }
                    }
                    .onChange(of: state) { _, newValue in
                        transferTaxRate = newValue.defaultTaxRatePercent
                    }
                }

                Section {
                    NumberInputRow(label: "Grunderwerbsteuer", value: $transferTaxRate, suffix: "%")
                    NumberInputRow(label: "Notar & Grundbuch", value: $notaryAndRegistryFeePercent, suffix: "%")
                    NumberInputRow(label: "Maklerprovision", value: $brokerFeePercent, suffix: "%")
                } header: {
                    Text("Sätze (anpassbar)")
                } footer: {
                    Text("Richtwerte, Stand ca. 2024 – bitte die aktuellen Sätze für dein Bundesland und deinen Makler prüfen.")
                }

                Section("Ergebnis") {
                    ResultRow(label: "Grunderwerbsteuer", value: AppFormatter.money(breakdown.propertyTransferTax))
                    ResultRow(label: "Notar & Grundbuch", value: AppFormatter.money(breakdown.notaryAndRegistryFee))
                    ResultRow(label: "Maklerprovision", value: AppFormatter.money(breakdown.brokerFee))
                    ResultRow(label: "Kaufnebenkosten gesamt", value: AppFormatter.money(breakdown.total), emphasized: true)
                    ResultRow(label: "Gesamtinvestition", value: AppFormatter.money(purchasePrice + breakdown.total), emphasized: true)
                }
            }
            .navigationTitle("Kaufnebenkosten")
        }
    }
}

#Preview {
    PurchaseCostsCalculatorView()
}
