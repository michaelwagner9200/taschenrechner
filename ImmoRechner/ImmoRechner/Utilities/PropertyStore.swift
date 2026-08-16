import Foundation
import Combine

/// Hält alle gespeicherten Objekte im Speicher und persistiert sie
/// lokal als JSON-Datei im Documents-Verzeichnis (kein Server nötig).
final class PropertyStore: ObservableObject {
    @Published var properties: [Property] = [] {
        didSet { save() }
    }

    private let fileURL: URL

    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            self.fileURL = documents.appendingPathComponent("properties.json")
        }
        load()
    }

    func addOrUpdate(_ property: Property) {
        if let index = properties.firstIndex(where: { $0.id == property.id }) {
            properties[index] = property
        } else {
            properties.append(property)
        }
    }

    func delete(_ property: Property) {
        properties.removeAll { $0.id == property.id }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let decoded = try? decoder.decode([Property].self, from: data) {
            properties = decoded
        }
    }

    private func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(properties) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
