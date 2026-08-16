import Foundation

/// Ein gespeichertes Immobilienobjekt mit allen Eingaben, die für
/// Finanzierung, Mietrendite, Kaufnebenkosten und Cashflow gebraucht werden.
struct Property: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()

    // Kaufdaten
    var purchasePrice: Double
    var livingAreaSquareMeters: Double
    var germanState: GermanState
    var brokerFeePercent: Double
    var notaryAndRegistryFeePercent: Double

    // Finanzierung
    var equity: Double
    var interestRatePercent: Double
    var initialAmortizationRatePercent: Double

    // Miete & laufende Kosten
    var coldRentMonthly: Double
    var nonRecoverableCostsMonthly: Double
    var maintenanceReserveMonthly: Double

    var notes: String

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        purchasePrice: Double,
        livingAreaSquareMeters: Double,
        germanState: GermanState,
        brokerFeePercent: Double,
        notaryAndRegistryFeePercent: Double,
        equity: Double,
        interestRatePercent: Double,
        initialAmortizationRatePercent: Double,
        coldRentMonthly: Double,
        nonRecoverableCostsMonthly: Double,
        maintenanceReserveMonthly: Double,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.purchasePrice = purchasePrice
        self.livingAreaSquareMeters = livingAreaSquareMeters
        self.germanState = germanState
        self.brokerFeePercent = brokerFeePercent
        self.notaryAndRegistryFeePercent = notaryAndRegistryFeePercent
        self.equity = equity
        self.interestRatePercent = interestRatePercent
        self.initialAmortizationRatePercent = initialAmortizationRatePercent
        self.coldRentMonthly = coldRentMonthly
        self.nonRecoverableCostsMonthly = nonRecoverableCostsMonthly
        self.maintenanceReserveMonthly = maintenanceReserveMonthly
        self.notes = notes
    }

    static func blank() -> Property {
        Property(
            name: "",
            purchasePrice: 300_000,
            livingAreaSquareMeters: 75,
            germanState: .nordrheinWestfalen,
            brokerFeePercent: 3.57,
            notaryAndRegistryFeePercent: 1.5,
            equity: 60_000,
            interestRatePercent: 3.8,
            initialAmortizationRatePercent: 2.0,
            coldRentMonthly: 950,
            nonRecoverableCostsMonthly: 50,
            maintenanceReserveMonthly: 80
        )
    }

    /// Bequemer Zugriff auf alle abgeleiteten Kennzahlen dieses Objekts.
    var metrics: PropertyMetrics {
        Calculations.metrics(for: self)
    }
}
