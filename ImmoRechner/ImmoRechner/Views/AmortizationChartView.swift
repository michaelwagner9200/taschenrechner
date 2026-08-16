import SwiftUI
import Charts

/// Verlauf der Restschuld über die Laufzeit als Flächen-/Linien-Chart.
struct AmortizationChartView: View {
    let schedule: [AmortizationYear]

    var body: some View {
        Chart(schedule) { year in
            AreaMark(
                x: .value("Jahr", year.year),
                y: .value("Restschuld", year.remainingDebt)
            )
            .foregroundStyle(
                .linearGradient(
                    colors: [.blue.opacity(0.35), .blue.opacity(0.02)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)

            LineMark(
                x: .value("Jahr", year.year),
                y: .value("Restschuld", year.remainingDebt)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.catmullRom)
        }
        .chartXAxisLabel("Jahr")
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let debt = value.as(Double.self) {
                        Text(AppFormatter.money(debt))
                    }
                }
            }
        }
        .frame(height: 180)
    }
}

#Preview {
    let schedule = Calculations.amortizationSchedule(
        loanAmount: 240_000,
        annualInterestRatePercent: 3.8,
        initialAmortizationRatePercent: 2.0
    )
    return AmortizationChartView(schedule: schedule)
        .padding()
}
