# Catering-Einkaufs- und Rezept-App

Eine webbasierte Anwendung zur Verwaltung von Zutaten, Rezeptkomponenten, Gerichten und Lieferantenangeboten für Catering-Unternehmen. Sie soll Rezeptmengen an unterschiedliche Personenzahlen anpassen, Zutatenbedarfe mehrerer Gerichte zusammenführen und Zutatenkosten sowie benötigte Liefergebinde berechnen.

**Projektstatus:** Schulprojekt in Entwicklung. Dieses README beschreibt den geplanten Funktionsumfang und den aktuellen konzeptionellen Datenbankentwurf; es bedeutet nicht, dass alle Funktionen bereits implementiert und getestet sind.

## 1. Über das Projekt

Catering-Rezepte müssen häufig für unterschiedliche Personenzahlen kalkuliert werden. Gleichzeitig verwenden Rezepte standardisierte Einheiten wie Gramm, Milliliter oder Stück, während Lieferanten Zutaten in Gebinden wie Säcken, Kartons oder Flaschen anbieten.

Werden mehrere Gerichte für eine Veranstaltung geplant, müssen gleiche Zutatenmengen zusammengezählt und die voraussichtlichen Kosten berechnet werden. Die Anwendung soll diese Informationen an einer zentralen Stelle verwalten und die Mengen- und Preiskalkulation nachvollziehbar unterstützen.

## 2. Geplante Funktionen

- Zutaten und standardisierte Rezept-Einheiten verwalten
- Wiederverwendbare Rezeptkomponenten erstellen
- Gerichte aus mehreren Komponenten zusammenstellen
- Rezeptmengen an die gewünschte Personenzahl anpassen
- Den Zutatenbedarf mehrerer Gerichte zusammenführen
- Lieferanten und ihre Zutatenangebote verwalten
- Preise pro Rezept-Einheit berechnen und Angebote vergleichen
- Zutaten- und Komponentenkosten kalkulieren
- Benötigte Zutatenmengen in ganze Liefergebinde umrechnen
- Allergene Zutaten zuordnen und Allergene für Komponenten und Gerichte aus deren Zutaten ableiten

Diese Liste beschreibt den geplanten Umfang und wird während der Entwicklung an den tatsächlichen Stand angepasst.

## 3. Datenbankmodell

Der aktuelle Entwurf umfasst zehn Tabellen. Die konkreten SQL-Datentypen und Constraints werden im Rahmen der Implementierung geprüft und festgelegt.

| Tabellenbereich | Tabellen | Aufgabe |
| --- | --- | --- |
| Einheiten und Zutaten | `einheiten`, `zutaten` | Rezept-Einheiten vereinheitlichen und Zutaten zentral verwalten |
| Lieferantenangebote | `lieferanten`, `lieferanten_zutaten` | Lieferanten sowie Gebinde, Gebindeinhalt und Preis eines Angebots speichern |
| Rezeptaufbau | `komponenten`, `komponenten_zutaten`, `gerichte`, `gericht_komponenten` | Wiederverwendbare Komponenten und daraus zusammengesetzte Gerichte abbilden |
| Allergene | `allergene`, `allergen_zutat` | Allergene verwalten und Zutaten zuordnen |

### Beziehungen im Überblick

- **Einheiten – Zutaten:** Eine Einheit kann mehreren Zutaten zugeordnet sein; jede Zutat besitzt eine festgelegte Rezept-Einheit.
- **Lieferanten – Zutaten:** Eine n:m-Beziehung wird über `lieferanten_zutaten` abgebildet. Ein Eintrag beschreibt ein konkretes Lieferantenangebot. Im aktuellen Schema ist pro Lieferant und Zutat höchstens ein Angebot vorgesehen.
- **Komponenten – Zutaten:** Eine n:m-Beziehung wird über `komponenten_zutaten` abgebildet.
- **Gerichte – Komponenten:** Eine n:m-Beziehung wird über `gericht_komponenten` abgebildet.
- **Allergene – Zutaten:** Eine n:m-Beziehung wird über `allergen_zutat` abgebildet.

Ein Datenbankdiagramm wird ergänzt, sobald eine passende, aktuelle Diagrammdatei vorliegt.

## 4. Wichtige Modellierungsentscheidungen

- **Rezept-Einheiten und Liefergebinde werden getrennt behandelt.** Eine Zutat hat eine standardisierte Rezept-Einheit. Der Gebindeinhalt eines Lieferantenangebots wird zusätzlich in genau dieser Einheit gespeichert. Ein 25-kg-Sack Mehl entspricht bei der Rezept-Einheit Gramm beispielsweise `25000`.
- **Zutaten werden zentral verwaltet.** Dieselbe Zutat kann in mehreren Komponenten sowie in Angeboten verschiedener Lieferanten verwendet werden.
- **Komponenten sind wiederverwendbar.** Gerichte können auf gemeinsame Rezeptbausteine zugreifen, statt Zutaten für jedes Gericht erneut zu definieren.
- **Lieferantenangebote werden getrennt gespeichert.** Gebindebezeichnung, verwendbarer Gebindeinhalt und Gebindepreis gehören zum jeweiligen Angebot.
- **Das Standardangebot muss nicht das günstigste sein.** Für die reguläre Kalkulation wird das als Standard markierte Angebot verwendet. Andere Angebote können verglichen und das Standardangebot kann über die Anwendung geändert werden.
- **Komponentenpreise werden berechnet.** Sie werden nicht dauerhaft in der Tabelle `komponenten` gespeichert, sondern aus Zutatenmengen und Zutatenpreisen ermittelt.
- **Allergene werden über Zutaten abgeleitet.** Allergene einer Komponente oder eines Gerichts ergeben sich aus den zugeordneten Allergenen seiner Zutaten. Fehlende Zuordnungen sind kein Nachweis für Allergenfreiheit.
- **Portionsmengen folgen einer einheitlichen Konvention.** `komponenten_zutaten.menge` gibt die Zutatenmenge für eine Komponentenportion an. `gericht_komponenten.menge` gibt an, wie viele Komponentenportionen für die in `gerichte.basisportionen` festgelegte Basisportionenzahl benötigt werden.

## 5. Berechnungslogik

Die Datenbank speichert die Ausgangsdaten. Das Backend verwendet sie, um Zutatenpreise, Rezeptmengen und voraussichtliche Gebindemengen zu berechnen.

### Preis pro Rezept-Einheit

Der Preis pro Rezept-Einheit wird aus dem Gebindepreis und dem Gebindeinhalt berechnet:

```text
Preis pro Rezept-Einheit = Gebindepreis / Gebindeinhalt in Rezept-Einheiten
```

Beispiel: Ein Gebinde enthält 25.000 g Mehl und kostet 32,50 €. Der Preis beträgt `32,50 € / 25.000 g = 0,0013 €/g`.

Angebote sind nur sinnvoll vergleichbar, wenn sie auf dieselbe Rezept-Einheit oder zuverlässig umrechenbare Einheiten bezogen sind.

### Komponentenpreis

Der Preis einer Komponentenportion ergibt sich aus den Kosten ihrer Zutaten:

```text
Komponentenpreis = Summe (Zutatenmenge × Preis pro Rezept-Einheit)
```

Die verwendeten Mengen beziehen sich auf eine Komponentenportion. Das Backend ermittelt für jede Zutat den Preis anhand des Standardangebots und addiert die Einzelkosten.

### Rezept skalieren

Die Rezeptmengen werden mit einem Skalierungsfaktor angepasst:

```text
Skalierungsfaktor = gewünschte Personenanzahl / Basisportionen
```

Beispiel: Ein Gericht ist für 10 Personen ausgelegt und soll für 150 Personen zubereitet werden. Der Skalierungsfaktor beträgt `150 / 10 = 15`.

### Zutatenbedarf mehrerer Gerichte zusammenführen

Das Backend berechnet den Zutatenbedarf für jedes ausgewählte Gericht und addiert die Mengen gleicher Zutaten. Die Zusammenführung setzt identische oder zuverlässig ineinander umrechenbare Rezept-Einheiten voraus.

Beispiel: Benötigen drei Gerichte 2 kg, 1,5 kg und 0,5 kg Reis, beträgt der Gesamtbedarf 4 kg.

### Benötigte Gebinde

Die benötigte Gebindeanzahl wird auf die nächste ganze Zahl aufgerundet:

```text
Benötigte Gebinde = aufrunden (Gesamtbedarf / Gebindeinhalt)
```

Beispiel: Bei einem Mehlbedarf von 30 kg und Säcken zu je 25 kg werden `30 / 25 = 1,2`, also **2 Säcke**, benötigt.

## 6. Geplanter technischer Aufbau

Der vorgesehene Grundaufbau ist:

```text
Benutzeroberfläche
        ↓
JavaScript-Backend
        ↓
Relationale Datenbank (MySQL / MariaDB)
```

Das Backend soll die Berechnungen durchführen; die Datenbank speichert die zugrunde liegenden Stammdaten und Zuordnungen. Konkrete Frameworks, API-Endpunkte, Hostingdetails und Verzeichnisstrukturen werden ergänzt, sobald sie feststehen.

## 7. Entwicklungsstand und nächste Schritte

Der Datenbankentwurf und die grundlegende Berechnungslogik sind konzeptionell beschrieben. Die Umsetzung und Überprüfung der einzelnen Bestandteile erfolgt schrittweise.

Vorgesehene nächste Schritte:

1. Datenmodell und Beziehungen finalisieren
2. Datenbankschema erstellen und testen
3. Beispieldaten anlegen
4. Backend mit der Datenbank verbinden
5. Rezeptskalierung und Zutatenberechnung implementieren
6. Kostenberechnung und Gebindeumrechnung mit Beispielen testen
7. Benutzeroberfläche ergänzen
8. Allergeninformationen integrieren und überprüfen

Ein Schritt wird erst dann als abgeschlossen gekennzeichnet, wenn er tatsächlich umgesetzt und geprüft wurde.

## 8. Abgrenzung und mögliche Erweiterungen

### Nicht Bestandteil der ersten Version

- Vollständige Lagerverwaltung
- Automatischer Abzug von Lagerbeständen
- Automatische Erstellung von Einkaufslisten
- Automatische Bestellungen
- Umfassendes Warenwirtschaftssystem

### Denkbare spätere Erweiterungen

- Einkaufslistenexport
- Berücksichtigung von Lagerbeständen
- Kalkulation weiterer Veranstaltungskosten
- Erfassung von Zubereitungszeiten
- Allergenfilter
- Verbesserte Darstellung für Smartphones und Tablets

Die gespeicherten Gebindegrößen und Gebindepreise schaffen bereits eine Grundlage für spätere Einkaufsfunktionen. Sie bedeuten jedoch nicht, dass eine Lagerverwaltung oder automatische Einkaufsliste schon umgesetzt ist.
