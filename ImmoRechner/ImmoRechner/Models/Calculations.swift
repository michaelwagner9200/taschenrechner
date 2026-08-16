import Foundation

/// Ein Jahr im Tilgungsplan eines Annuitätendarlehens.
struct AmortizationYear: Identifiable, Hashable {
    var id: Int { year }
    let year: Int
    let interestPaid: Double
    let principalPaid: Double
    let remainingDebt: Double
}

/// Aufschlüsselung der Kaufnebenkosten.
struct PurchaseCostsBreakdown: Hashable {
    let propertyTransferTax: Double
    let notaryAndRegistryFee: Double
    let brokerFee: Double

    var total: Double { propertyTransferTax + notaryAndRegistryFee + brokerFee }
}

/// Alle berechneten Kennzahlen zu einem Objekt, gebündelt für die Anzeige.
struct PropertyMetrics {
    let purchaseCosts: PurchaseCostsBreakdown
    let totalInvestment: Double
    let loanAmount: Double
    let monthlyFinancingRate: Double
    let amortizationSchedule: [AmortizationYear]
    let grossYieldPercent: Double
    let netYieldPercent: Double
    let monthlyCashflow: Double
}

/// Reine, zustandslose Berechnungsfunktionen für alle Rechner der App.
/// Werden sowohl von den eigenständigen Rechnern als auch vom
/// Objekt-Dashboard (PropertyDetailView) verwendet.
enum Calculations {

    // MARK: - Kaufnebenkosten

    static func purchaseCosts(
        purchasePrice: Double,
        state: GermanState,
        transferTaxRatePercentOverride: Double? = nil,
        notaryAndRegistryFeePercent: Double,
        brokerFeePercent: Double
    ) -> PurchaseCostsBreakdown {
        let taxRate = transferTaxRatePercentOverride ?? state.defaultTaxRatePercent
        return PurchaseCostsBreakdown(
            propertyTransferTax: purchasePrice * taxRate / 100,
            notaryAndRegistryFee: purchasePrice * notaryAndRegistryFeePercent / 100,
            brokerFee: purchasePrice * brokerFeePercent / 100
        )
    }

    // MARK: - Finanzierung (Annuitätendarlehen)

    /// Monatliche Rate eines Annuitätendarlehens aus Zins- und anfänglichem Tilgungssatz.
    static func monthlyFinancingRate(
        loanAmount: Double,
        annualInterestRatePercent: Double,
        initialAmortizationRatePercent: Double
    ) -> Double {
        guard loanAmount > 0 else { return 0 }
        let annualRate = loanAmount * (annualInterestRatePercent + initialAmortizationRatePercent) / 100
        return annualRate / 12
    }

    /// Jährlicher Tilgungsplan mit konstanter Annuität, bis das Darlehen getilgt ist
    /// (maximal `maxYears`, als Sicherheitsgrenze z. B. bei sehr niedriger Tilgung).
    static func amortizationSchedule(
        loanAmount: Double,
        annualInterestRatePercent: Double,
        initialAmortizationRatePercent: Double,
        maxYears: Int = 40
    ) -> [AmortizationYear] {
        guard loanAmount > 0 else { return [] }
        let annualPayment = loanAmount * (annualInterestRatePercent + initialAmortizationRatePercent) / 100
        guard annualPayment > 0 else { return [] }

        var schedule: [AmortizationYear] = []
        var remaining = loanAmount

        for year in 1...maxYears {
            guard remaining > 0.01 else { break }
            let interest = remaining * annualInterestRatePercent / 100
            var principal = annualPayment - interest
            if principal > remaining { principal = remaining }
            remaining -= principal
            schedule.append(AmortizationYear(
                year: year,
                interestPaid: interest,
                principalPaid: principal,
                remainingDebt: max(0, remaining)
            ))
        }
        return schedule
    }

    // MARK: - Mietrendite

    static func grossYieldPercent(annualColdRent: Double, purchasePrice: Double) -> Double {
        guard purchasePrice > 0 else { return 0 }
        return annualColdRent / purchasePrice * 100
    }

    static func netYieldPercent(
        annualColdRent: Double,
        annualNonRecoverableCosts: Double,
        annualMaintenanceReserve: Double,
        totalInvestment: Double
    ) -> Double {
        guard totalInvestment > 0 else { return 0 }
        let netIncome = annualColdRent - annualNonRecoverableCosts - annualMaintenanceReserve
        return netIncome / totalInvestment * 100
    }

    // MARK: - Cashflow

    static func monthlyCashflow(
        coldRentMonthly: Double,
        financingRateMonthly: Double,
        nonRecoverableCostsMonthly: Double,
        maintenanceReserveMonthly: Double
    ) -> Double {
        coldRentMonthly - financingRateMonthly - nonRecoverableCostsMonthly - maintenanceReserveMonthly
    }

    // MARK: - Gebündelte Kennzahlen für ein gespeichertes Objekt

    static func metrics(for property: Property) -> PropertyMetrics {
        let costs = purchaseCosts(
            purchasePrice: property.purchasePrice,
            state: property.germanState,
            notaryAndRegistryFeePercent: property.notaryAndRegistryFeePercent,
            brokerFeePercent: property.brokerFeePercent
        )
        let totalInvestment = property.purchasePrice + costs.total
        let loanAmount = max(0, totalInvestment - property.equity)

        let rate = monthlyFinancingRate(
            loanAmount: loanAmount,
            annualInterestRatePercent: property.interestRatePercent,
            initialAmortizationRatePercent: property.initialAmortizationRatePercent
        )

        let schedule = amortizationSchedule(
            loanAmount: loanAmount,
            annualInterestRatePercent: property.interestRatePercent,
            initialAmortizationRatePercent: property.initialAmortizationRatePercent
        )

        let grossYield = grossYieldPercent(
            annualColdRent: property.coldRentMonthly * 12,
            purchasePrice: property.purchasePrice
        )

        let netYield = netYieldPercent(
            annualColdRent: property.coldRentMonthly * 12,
            annualNonRecoverableCosts: property.nonRecoverableCostsMonthly * 12,
            annualMaintenanceReserve: property.maintenanceReserveMonthly * 12,
            totalInvestment: totalInvestment
        )

        let cashflow = monthlyCashflow(
            coldRentMonthly: property.coldRentMonthly,
            financingRateMonthly: rate,
            nonRecoverableCostsMonthly: property.nonRecoverableCostsMonthly,
            maintenanceReserveMonthly: property.maintenanceReserveMonthly
        )

        return PropertyMetrics(
            purchaseCosts: costs,
            totalInvestment: totalInvestment,
            loanAmount: loanAmount,
            monthlyFinancingRate: rate,
            amortizationSchedule: schedule,
            grossYieldPercent: grossYield,
            netYieldPercent: netYield,
            monthlyCashflow: cashflow
        )
    }
}
