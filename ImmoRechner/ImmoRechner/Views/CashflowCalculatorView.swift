import SwiftUI

struct CashflowCalculatorView: View {
    @State private var coldRentMonthly: Double = 950
    @State private var financingRateMonthly: Double = 900
    @State private var nonRecoverableCostsMonthly: Double = 50
    @State private var maintenanceReserveMonthly: Double = 80

    private var cashflow: Double {
        Calculations.monthlyCashflow(
            coldRentMonthly: coldRentMonthly,
            financingRateMonthly: financingRateMonthly,
            nonRecoverableCostsMonthly: nonRecoverableCostsMonthly,
            maintenanceReserveMonthly: maintenanceReserveMonthly
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Monatliche Einnahmen") {
                    NumberInputRow(label: "Kaltmiete", value: $coldRentMonthly)
                }

                Section("Monatliche Ausgaben") {
                    NumberInputRow(label: "Finanzierungsrate", value: $financingRateMonthly)
                    NumberInputRow(label: "Nicht umlagefähige Kosten", value: $nonRecoverableCostsMonthly)
                    NumberInputRow(label: "Instandhaltungsrücklage", value: $maintenanceReserveMonthly)
                }

                Section("Ergebnis") {
                    ResultRow(
                        label: cashflow >= 0 ? "Monatlicher Überschuss" : "Monatliches Defizit",
                        value: AppFormatter.moneyPrecise(cashflow),
                        emphasized: true
                    )
                    .foregroundStyle(cashflow >= 0 ? .green : .red)
                }
            }
            .navigationTitle("Cashflow")
        }
    }
}

#Preview {
    CashflowCalculatorView()
}
