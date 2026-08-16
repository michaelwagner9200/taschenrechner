import SwiftUI

struct ContentView: View {
    @StateObject private var store = PropertyStore()

    var body: some View {
        TabView {
            FinancingCalculatorView()
                .tabItem { Label("Finanzierung", systemImage: "eurosign.circle") }

            RentalYieldCalculatorView()
                .tabItem { Label("Mietrendite", systemImage: "percent") }

            PurchaseCostsCalculatorView()
                .tabItem { Label("Nebenkosten", systemImage: "doc.text") }

            CashflowCalculatorView()
                .tabItem { Label("Cashflow", systemImage: "arrow.left.arrow.right") }

            PropertiesListView(store: store)
                .tabItem { Label("Objekte", systemImage: "house") }
        }
    }
}

#Preview {
    ContentView()
}
