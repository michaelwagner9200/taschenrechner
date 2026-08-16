import Foundation

/// Bundesland mit dem aktuell üblichen Grunderwerbsteuersatz.
/// Hinweis: Steuersätze können sich ändern. Die Werte sind Richtwerte
/// (Stand ca. 2024) und in der App überschreibbar.
enum GermanState: String, CaseIterable, Identifiable, Codable, Hashable {
    case badenWuerttemberg = "Baden-Württemberg"
    case bayern = "Bayern"
    case berlin = "Berlin"
    case brandenburg = "Brandenburg"
    case bremen = "Bremen"
    case hamburg = "Hamburg"
    case hessen = "Hessen"
    case mecklenburgVorpommern = "Mecklenburg-Vorpommern"
    case niedersachsen = "Niedersachsen"
    case nordrheinWestfalen = "Nordrhein-Westfalen"
    case rheinlandPfalz = "Rheinland-Pfalz"
    case saarland = "Saarland"
    case sachsen = "Sachsen"
    case sachsenAnhalt = "Sachsen-Anhalt"
    case schleswigHolstein = "Schleswig-Holstein"
    case thueringen = "Thüringen"

    var id: String { rawValue }

    /// Grunderwerbsteuersatz in Prozent (Richtwert, bitte im Einzelfall prüfen).
    var defaultTaxRatePercent: Double {
        switch self {
        case .badenWuerttemberg: return 5.0
        case .bayern: return 3.5
        case .berlin: return 6.0
        case .brandenburg: return 6.5
        case .bremen: return 5.0
        case .hamburg: return 5.5
        case .hessen: return 6.0
        case .mecklenburgVorpommern: return 6.0
        case .niedersachsen: return 5.0
        case .nordrheinWestfalen: return 6.5
        case .rheinlandPfalz: return 5.0
        case .saarland: return 6.5
        case .sachsen: return 5.5
        case .sachsenAnhalt: return 5.0
        case .schleswigHolstein: return 6.5
        case .thueringen: return 5.0
        }
    }
}
