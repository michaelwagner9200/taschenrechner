import SwiftUI

struct PropertyFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: PropertyStore

    @State private var property: Property
    private let isNew: Bool

    init(store: PropertyStore, property: Property? = nil) {
        self.store = store
        self.isNew = property == nil
        _property = State(initialValue: property ?? .blank())
    }

    private var isValid: Bool {
        !property.name.trimmingCharacters(in: .whitespaces).isEmpty && property.purchasePrice > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Objekt") {
                    TextField("Name (z. B. Musterstraße 12)", text: $property.name)
                }

                Section {
                    NumberInputRow(label: "Kaufpreis", value: $property.purchasePrice)
                    NumberInputRow(label: "Wohnfläche", value: $property.livingAreaSquareMeters, suffix: "m²")
                    Picker("Bundesland", selection: $property.germanState) {
                        ForEach(GermanState.allCases) { state in
                            Text(state.rawValue).tag(state)
                        }
                    }
                    NumberInputRow(label: "Notar & Grundbuch", value: $property.notaryAndRegistryFeePercent, suffix: "%")
                    NumberInputRow(label: "Maklerprovision", value: $property.brokerFeePercent, suffix: "%")
                } header: {
                    Text("Kaufdaten")
                } footer: {
                    if property.purchasePrice <= 0 {
                        ValidationBanner(message: "Bitte einen Kaufpreis größer als 0 € eingeben.")
                    }
                }

                Section("Finanzierung") {
                    NumberInputRow(label: "Eigenkapital", value: $property.equity)
                    NumberInputRow(label: "Zinssatz", value: $property.interestRatePercent, suffix: "%")
                    NumberInputRow(label: "Anfängliche Tilgung", value: $property.initialAmortizationRatePercent, suffix: "%")
                }

                Section("Miete & laufende Kosten") {
                    NumberInputRow(label: "Kaltmiete / Monat", value: $property.coldRentMonthly)
                    NumberInputRow(label: "Nicht umlagefähige Kosten / Monat", value: $property.nonRecoverableCostsMonthly)
                    NumberInputRow(label: "Instandhaltungsrücklage / Monat", value: $property.maintenanceReserveMonthly)
                }

                Section("Notizen") {
                    TextField("Optional", text: $property.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(isNew ? "Neues Objekt" : "Objekt bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        store.addOrUpdate(property)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    PropertyFormView(store: PropertyStore())
}
