import SwiftUI

struct FinancingCalculatorView: View {
    @State private var purchasePrice: Double = 300_000
    @State private var equity: Double = 60_000
    @State private var interestRate: Double = 3.8
    @State private var amortizationRate: Double = 2.0

    private var loanAmount: Double {
        max(0, purchasePrice - equity)
    }

    private var monthlyRate: Double {
        Calculations.monthlyFinancingRate(
            loanAmount: loanAmount,
            annualInterestRatePercent: interestRate,
            initialAmortizationRatePercent: amortizationRate
        )
    }

    private var schedule: [AmortizationYear] {
        Calculations.amortizationSchedule(
            loanAmount: loanAmount,
            annualInterestRatePercent: interestRate,
            initialAmortizationRatePercent: amortizationRate
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Eingaben") {
                    NumberInputRow(label: "Kaufpreis", value: $purchasePrice)
                    NumberInputRow(label: "Eigenkapital", value: $equity)
                    NumberInputRow(label: "Zinssatz", value: $interestRate, suffix: "%")
                    NumberInputRow(label: "Anfängliche Tilgung", value: $amortizationRate, suffix: "%")
                }

                Section {
                    ResultRow(label: "Darlehenssumme", value: AppFormatter.money(loanAmount))
                    ResultRow(label: "Monatliche Rate", value: AppFormatter.moneyPrecise(monthlyRate), emphasized: true)
                    if let firstYear = schedule.first {
                        ResultRow(label: "davon Zinsen (Jahr 1)", value: AppFormatter.money(firstYear.interestPaid / 12))
                        ResultRow(label: "davon Tilgung (Jahr 1)", value: AppFormatter.money(firstYear.principalPaid / 12))
                    }
                } header: {
                    Text("Ergebnis")
                }

                if !schedule.isEmpty {
                    Section("Tilgungsplan (Restschuld je Jahr)") {
                        ForEach(schedule.prefix(15)) { year in
                            HStack {
                                Text("Jahr \(year.year)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(AppFormatter.money(year.remainingDebt))
                                    .monospacedDigit()
                            }
                        }
                        if schedule.count > 15 {
                            Text("Volltilgung nach \(schedule.count) Jahren")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Finanzierung")
        }
    }
}

#Preview {
    FinancingCalculatorView()
}
