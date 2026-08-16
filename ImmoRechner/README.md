# Immo Rechner

Eine iPhone-App (SwiftUI) mit Rechnern rund um Immobilien-Investments:

- **Finanzierung** – monatliche Rate, Zins-/Tilgungsanteil, Tilgungsplan
- **Mietrendite** – Brutto- und Nettomietrendite
- **Kaufnebenkosten** – Grunderwerbsteuer je Bundesland, Notar, Grundbuch, Makler
- **Cashflow** – monatlicher Überschuss oder Defizit
- **Objekte** – Immobilien lokal speichern; alle vier Kennzahlen werden automatisch
  aus den gespeicherten Daten berechnet und als Dashboard angezeigt

Alles läuft komplett lokal auf dem Gerät (kein Server, kein Account nötig).
Gespeicherte Objekte landen als JSON-Datei im App-Sandbox-Verzeichnis.

## Voraussetzungen

- Ein Mac mit **Xcode 15 oder neuer**
- iOS-Deployment-Ziel: iOS 17.0

Der App-Code wurde in dieser Session geschrieben und getestet an der Logik
(reine Swift-Berechnungen), aber **nicht** in Xcode kompiliert oder im
Simulator ausgeführt, da diese Umgebung kein macOS bereitstellt. Beim ersten
Öffnen in Xcode kann es sein, dass kleine Anpassungen nötig sind
(z. B. Team/Signing für ein echtes Gerät).

## Projekt öffnen

1. Repository auf den Mac klonen bzw. den Ordner `ImmoRechner/` dorthin kopieren.
2. `ImmoRechner.xcodeproj` doppelklicken – öffnet in Xcode.
3. Links oben das Team unter **Signing & Capabilities** auf deinen eigenen
   Apple-Account setzen (Zeile `DEVELOPMENT_TEAM` ist aktuell leer).
4. Optional: `PRODUCT_BUNDLE_IDENTIFIER` (`com.example.ImmoRechner`) auf eine
   eigene, eindeutige Bundle-ID ändern.
5. Simulator oder eigenes iPhone als Ziel wählen, ▶️ **Run** drücken.

## Projektstruktur

```
ImmoRechner/
├── ImmoRechner.xcodeproj/
└── ImmoRechner/
    ├── ImmoRechnerApp.swift        # App-Einstieg
    ├── ContentView.swift           # TabView mit 5 Tabs
    ├── Models/
    │   ├── Property.swift          # Gespeichertes Objekt (Codable)
    │   ├── Calculations.swift      # Alle Rechenformeln (pure functions)
    │   └── GermanState.swift       # Bundesländer + Grunderwerbsteuersätze
    ├── Views/
    │   ├── FinancingCalculatorView.swift
    │   ├── RentalYieldCalculatorView.swift
    │   ├── PurchaseCostsCalculatorView.swift
    │   ├── CashflowCalculatorView.swift
    │   ├── PropertiesListView.swift
    │   ├── PropertyFormView.swift
    │   ├── PropertyDetailView.swift
    │   └── Components.swift        # Wiederverwendbare UI-Bausteine
    ├── Utilities/
    │   ├── PropertyStore.swift     # Lokale JSON-Persistenz
    │   └── CurrencyFormatter.swift
    └── Assets.xcassets/
```

## Hinweis zu Steuersätzen

Die hinterlegten Grunderwerbsteuersätze je Bundesland sowie Notar-/Makler-
Prozentsätze sind Richtwerte (Stand ca. 2024) und in der App überall
editierbar. Bitte vor einer echten Kaufentscheidung die aktuellen Sätze
prüfen – die App ersetzt keine Steuer- oder Rechtsberatung.
