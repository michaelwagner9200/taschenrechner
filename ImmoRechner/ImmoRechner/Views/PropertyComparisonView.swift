import SwiftUI

/// Eine Zeile in der Vergleichstabelle: ein Label links, ein Wert je Objekt.
private struct ComparisonGridRow: View {
    let label: String
    let values: [String]
    var colors: [Color]? = nil

    var body: some View {
        GridRow {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 170, alignment: .leading)
            ForEach(values.indices, id: \.self) { index in
                Text(values[index])
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .foregroundStyle(colors?[index] ?? .primary)
                    .frame(width: 140, alignment: .leading)
            }
        }
    }
}

/// Seite-an-Seite-Vergleich mehrerer gespeicherter Objekte.
struct PropertyComparisonView: View {
    @ObservedObject var store: PropertyStore
    let propertyIDs: [Property.ID]

    private var properties: [Property] {
        propertyIDs.compactMap { id in store.properties.first { $0.id == id } }
    }

    var body: some View {
        Group {
            if properties.count < 2 {
                ContentUnavailableView(
                    "Nicht genug Objekte",
                    systemImage: "square.split.2x1",
                    description: Text("Wähle mindestens zwei Objekte aus, um sie zu vergleichen.")
                )
            } else {
                ScrollView([.horizontal, .vertical]) {
                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 14) {
                        GridRow {
                            Text("")
                                .frame(width: 170)
                            ForEach(properties) { property in
                                Text(property.name)
                                    .font(.headline)
                                    .frame(width: 140, alignment: .leading)
                            }
                        }

                        GridRow {
                            Divider().gridCellColumns(properties.count + 1)
                        }

                        ComparisonGridRow(
                            label: "Kaufpreis",
                            values: properties.map { AppFormatter.money($0.purchasePrice) }
                        )
                        ComparisonGridRow(
                            label: "Wohnfläche",
                            values: properties.map { "\(Int($0.livingAreaSquareMeters)) m²" }
                        )
                        ComparisonGridRow(
                            label: "Kaufpreis / m²",
                            values: properties.map { AppFormatter.money($0.metrics.pricePerSquareMeter) }
                        )
                        ComparisonGridRow(
                            label: "Gesamtinvestition",
                            values: properties.map { AppFormatter.money($0.metrics.totalInvestment) }
                        )

                        GridRow {
                            Divider().gridCellColumns(properties.count + 1)
                        }

                        ComparisonGridRow(
                            label: "Monatliche Rate",
                            values: properties.map { AppFormatter.moneyPrecise($0.metrics.monthlyFinancingRate) }
                        )
                        ComparisonGridRow(
                            label: "Bruttomietrendite",
                            values: properties.map { AppFormatter.percentString($0.metrics.grossYieldPercent) }
                        )
                        ComparisonGridRow(
                            label: "Nettomietrendite",
                            values: properties.map { AppFormatter.percentString($0.metrics.netYieldPercent) }
                        )
                        ComparisonGridRow(
                            label: "Cashflow / Monat",
                            values: properties.map { AppFormatter.moneyPrecise($0.metrics.monthlyCashflow) },
                            colors: properties.map { $0.metrics.monthlyCashflow >= 0 ? .green : .red }
                        )
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Vergleich")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let store = PropertyStore()
    var a = Property.blank()
    a.name = "Musterstraße 12"
    var b = Property.blank()
    b.name = "Beispielweg 4"
    b.purchasePrice = 260_000
    b.coldRentMonthly = 890
    store.addOrUpdate(a)
    store.addOrUpdate(b)
    return NavigationStack {
        PropertyComparisonView(store: store, propertyIDs: [a.id, b.id])
    }
}
