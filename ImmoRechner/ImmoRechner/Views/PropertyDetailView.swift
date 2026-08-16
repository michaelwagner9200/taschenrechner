import SwiftUI

struct PropertyDetailView: View {
    @ObservedObject var store: PropertyStore
    let propertyID: Property.ID
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditForm = false
    @State private var showingDeleteConfirmation = false

    private var property: Property? {
        store.properties.first { $0.id == propertyID }
    }

    var body: some View {
        Group {
            if let property {
                let metrics = property.metrics
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ResultCard(title: "Kaufnebenkosten") {
                            ResultRow(label: "Grunderwerbsteuer", value: AppFormatter.money(metrics.purchaseCosts.propertyTransferTax))
                            ResultRow(label: "Notar & Grundbuch", value: AppFormatter.money(metrics.purchaseCosts.notaryAndRegistryFee))
                            ResultRow(label: "Maklerprovision", value: AppFormatter.money(metrics.purchaseCosts.brokerFee))
                            Divider()
                            ResultRow(label: "Gesamtinvestition", value: AppFormatter.money(metrics.totalInvestment), emphasized: true)
                        }

                        ResultCard(title: "Finanzierung") {
                            ResultRow(label: "Darlehenssumme", value: AppFormatter.money(metrics.loanAmount))
                            ResultRow(label: "Monatliche Rate", value: AppFormatter.moneyPrecise(metrics.monthlyFinancingRate), emphasized: true)
                            if let year10 = metrics.amortizationSchedule.first(where: { $0.year == 10 }) {
                                ResultRow(label: "Restschuld nach 10 Jahren", value: AppFormatter.money(year10.remainingDebt))
                            }
                        }

                        ResultCard(title: "Mietrendite") {
                            ResultRow(label: "Bruttomietrendite", value: AppFormatter.percentString(metrics.grossYieldPercent), emphasized: true)
                            ResultRow(label: "Nettomietrendite", value: AppFormatter.percentString(metrics.netYieldPercent), emphasized: true)
                        }

                        ResultCard(title: "Cashflow") {
                            ResultRow(
                                label: metrics.monthlyCashflow >= 0 ? "Monatlicher Überschuss" : "Monatliches Defizit",
                                value: AppFormatter.moneyPrecise(metrics.monthlyCashflow),
                                emphasized: true
                            )
                            .foregroundStyle(metrics.monthlyCashflow >= 0 ? .green : .red)
                        }

                        if !property.notes.isEmpty {
                            ResultCard(title: "Notizen") {
                                Text(property.notes)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .navigationTitle(property.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Bearbeiten") { showingEditForm = true }
                    }
                    ToolbarItem(placement: .secondaryAction) {
                        Button("Objekt löschen", systemImage: "trash", role: .destructive) {
                            showingDeleteConfirmation = true
                        }
                    }
                }
                .sheet(isPresented: $showingEditForm) {
                    PropertyFormView(store: store, property: property)
                }
                .confirmationDialog(
                    "Objekt wirklich löschen?",
                    isPresented: $showingDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Löschen", role: .destructive) {
                        store.delete(property)
                        dismiss()
                    }
                    Button("Abbrechen", role: .cancel) {}
                }
            } else {
                ContentUnavailableView("Objekt nicht gefunden", systemImage: "house")
            }
        }
    }
}

#Preview {
    let store = PropertyStore()
    let sample = Property.blank()
    store.addOrUpdate(sample)
    return NavigationStack {
        PropertyDetailView(store: store, propertyID: sample.id)
    }
}
