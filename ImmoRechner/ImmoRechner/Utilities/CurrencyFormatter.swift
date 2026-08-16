import Foundation

enum AppFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static let currencyPrecise: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    static let percent: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de_DE")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    static func money(_ value: Double) -> String {
        currency.string(from: NSNumber(value: value)) ?? "–"
    }

    static func moneyPrecise(_ value: Double) -> String {
        currencyPrecise.string(from: NSNumber(value: value)) ?? "–"
    }

    static func percentString(_ value: Double) -> String {
        (percent.string(from: NSNumber(value: value)) ?? "–") + " %"
    }
}
