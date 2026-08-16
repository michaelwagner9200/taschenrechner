import SwiftUI

struct PropertiesListView: View {
    @ObservedObject var store: PropertyStore
    @State private var showingNewForm = false

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
                    List {
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
                        }
                    }
                }
            }
            .navigationTitle("Meine Objekte")
            .navigationDestination(for: Property.ID.self) { id in
                PropertyDetailView(store: store, propertyID: id)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewForm = true
                    } label: {
                        Label("Neues Objekt", systemImage: "plus")
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
