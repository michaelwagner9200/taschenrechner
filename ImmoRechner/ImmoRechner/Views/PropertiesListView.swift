import SwiftUI

struct PropertiesListView: View {
    @ObservedObject var store: PropertyStore
    @State private var showingNewForm = false
    @State private var selectedIDs = Set<Property.ID>()
    @State private var comparisonSelection: [Property.ID]?

    private var sortedProperties: [Property] {
        store.properties.sorted(by: { $0.createdAt > $1.createdAt })
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.properties.isEmpty {
                    ContentUnavailableView(
                        "Noch keine Objekte",
                        systemImage: "house",
                        description: Text("Lege dein erstes Immobilienobjekt an, um alle Kennzahlen auf einen Blick zu sehen.")
                    )
                } else {
                    List(selection: $selectedIDs) {
                        ForEach(sortedProperties) { property in
                            NavigationLink(value: property.id) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(property.name)
                                        .font(.headline)
                                    HStack(spacing: 12) {
                                        Text(AppFormatter.money(property.purchasePrice))
                                        Text(AppFormatter.percentString(property.metrics.netYieldPercent) + " netto")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { offsets in
                            let idsToDelete = offsets.map { sortedProperties[$0].id }
                            store.properties.removeAll { idsToDelete.contains($0.id) }
                            selectedIDs.subtract(idsToDelete)
                        }
                    }
                }
            }
            .navigationTitle("Meine Objekte")
            .navigationDestination(for: Property.ID.self) { id in
                PropertyDetailView(store: store, propertyID: id)
            }
            .navigationDestination(item: $comparisonSelection) { ids in
                PropertyComparisonView(store: store, propertyIDs: ids)
            }
            .toolbar {
                if store.properties.count >= 2 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewForm = true
                    } label: {
                        Label("Neues Objekt", systemImage: "plus")
                    }
                }
                if selectedIDs.count >= 2 {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            comparisonSelection = Array(selectedIDs)
                        } label: {
                            Label("Vergleichen (\(selectedIDs.count))", systemImage: "square.split.2x1")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingNewForm) {
                PropertyFormView(store: store)
            }
        }
    }
}

#Preview {
    PropertiesListView(store: PropertyStore())
}
