import SwiftUI

/// Eingabezeile mit Label links und einem Zahlenfeld rechts (€ oder %).
struct NumberInputRow: View {
    let label: String
    @Binding var value: Double
    var suffix: String = "€"

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 110)
            Text(suffix)
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
        }
    }
}

/// Eine Ergebniszeile, optional hervorgehoben (z. B. Gesamtsumme).
struct ResultRow: View {
    let label: String
    let value: String
    var emphasized: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(emphasized ? .primary : .secondary)
                .fontWeight(emphasized ? .semibold : .regular)
            Spacer()
            Text(value)
                .fontWeight(emphasized ? .bold : .medium)
                .monospacedDigit()
        }
    }
}

/// Abgerundete Karte, die einen Ergebnisblock gruppiert.
struct ResultCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 2)
            content
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
