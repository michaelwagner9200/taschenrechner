import SwiftUI

struct RentalYieldCalculatorView: View {
    @State private var purchasePrice: Double = 300_000
    @State private var purchaseCostsTotal: Double = 30_000
    @State private var coldRentMonthly: Double = 950
    @State private var nonRecoverableCostsMonthly: Double = 50
    @State private var maintenanceReserveMonthly: Double = 80

    private var totalInvestment: Double {
        purchasePrice + purchaseCostsTotal
    }

    private var grossYield: Double {
        Calculations.grossYieldPercent(
            annualColdRent: coldRentMonthly * 12,
            purchasePrice: purchasePrice
        )
    }

    private var netYield: Double {
        Calculations.netYieldPercent(
            annualColdRent: coldRentMonthly * 12,
            annualNonRecoverableCosts: nonRecoverableCostsMonthly * 12,
            annualMaintenanceReserve: maintenanceReserveMonthly * 12,
            totalInvestment: totalInvestment
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Kaufdaten") {
                    NumberInputRow(label: "Kaufpreis", value: $purchasePrice)
                    NumberInputRow(label: "Kaufnebenkosten", value: $purchaseCostsTotal)
                }

                Section("Miete & laufende Kosten") {
                    NumberInputRow(label: "Kaltmiete / Monat", value: $coldRentMonthly)
                    NumberInputRow(label: "Nicht umlagefähige Kosten / Monat", value: $nonRecoverableCostsMonthly)
                    NumberInputRow(label: "Instandhaltungsrücklage / Monat", value: $maintenanceReserveMonthly)
                }

                Section("Ergebnis") {
                    ResultRow(label: "Gesamtinvestition", value: AppFormatter.money(totalInvestment))
                    ResultRow(label: "Bruttomietrendite", value: AppFormatter.percentString(grossYield), emphasized: true)
                    ResultRow(label: "Nettomietrendite", value: AppFormatter.percentString(netYield), emphasized: true)
                }
            }
            .navigationTitle("Mietrendite")
        }
    }
}

#Preview {
    RentalYieldCalculatorView()
}
