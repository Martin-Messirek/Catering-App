-- Catering-Einkaufs- und Rezept-App
-- Datenbankschema für MySQL / MariaDB
-- Lagerverwaltung und automatische Einkaufslisten sind noch nicht enthalten.

CREATE DATABASE IF NOT EXISTS catering_app
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE catering_app;


-- 1. Einheiten
-- Standardisierte Rezept-Einheiten mit zugehöriger Dimension.
-- Beispiele: g (Masse), ml (Volumen), Stück (Anzahl).

CREATE TABLE einheiten (
    einheit_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    dimension VARCHAR(30) NOT NULL
);


-- 2. Zutaten
-- Jede Zutat wird zentral gespeichert und kann in mehreren
-- Komponenten und bei mehreren Lieferanten verwendet werden.
-- rezept_einheit_id legt die Einheit für alle Rezeptmengen dieser Zutat fest.

CREATE TABLE zutaten (
    zutat_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    bezeichnung VARCHAR(150) NOT NULL UNIQUE,
    rezept_einheit_id INT UNSIGNED NOT NULL,

    CONSTRAINT fk_zutaten_einheit
        FOREIGN KEY (rezept_einheit_id)
        REFERENCES einheiten (einheit_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 3. Lieferanten

CREATE TABLE lieferanten (
    lieferant_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);



-- 4. Lieferanten-Zutaten
-- Ein Lieferantenangebot beschreibt ein konkretes Gebinde
-- mit Gebindebezeichnung, verwendbarem Inhalt und Preis.
-- Der Inhalt wird in der Rezept-Einheit der Zutat erfasst.
-- Pro Lieferant und Zutat ist vorläufig ein aktuelles Angebot erlaubt.
-- ist_standard kennzeichnet das bevorzugte Angebot einer Zutat.
-- Die Anwendung verwaltet die Standardauswahl.

CREATE TABLE lieferanten_zutaten (
    lieferant_zutat_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lieferant_id INT UNSIGNED NOT NULL,
    zutat_id INT UNSIGNED NOT NULL,
    gebinde_bezeichnung VARCHAR(50) NOT NULL,
    gebinde_in_rezept_einheiten DECIMAL(12,3) NOT NULL,
    gebindepreis DECIMAL(12,2) NOT NULL,
    umrechnung_geprueft_am DATETIME NULL,
    ist_standard BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT uq_lieferant_zutat
        UNIQUE (lieferant_id, zutat_id),

    CONSTRAINT chk_lz_gebindeinhalt
        CHECK (gebinde_in_rezept_einheiten > 0),

    CONSTRAINT chk_lz_gebindepreis
        CHECK (gebindepreis >= 0),

    CONSTRAINT fk_lz_lieferant
        FOREIGN KEY (lieferant_id)
        REFERENCES lieferanten (lieferant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_lz_zutat
        FOREIGN KEY (zutat_id)
        REFERENCES zutaten (zutat_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);



-- 5. Komponenten
-- Wiederverwendbare Bestandteile eines Gerichts,
-- beispielsweise Schnitzel oder Pommes.
-- Der Komponentenpreis wird berechnet und nicht gespeichert.

CREATE TABLE komponenten (
    komponente_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    komponentenname VARCHAR(150) NOT NULL
);


-- 6. Komponenten-Zutaten
-- Die Menge wird in der Rezept-Einheit der jeweiligen Zutat angegeben.
-- Der zusammengesetzte Primärschlüssel verhindert doppelte Zutaten
-- innerhalb derselben Komponente.

CREATE TABLE komponenten_zutaten (
    komponente_id INT UNSIGNED NOT NULL,
    zutat_id INT UNSIGNED NOT NULL,
    menge DECIMAL(12,3) NOT NULL,

    PRIMARY KEY (komponente_id, zutat_id),

    CONSTRAINT chk_kz_menge
        CHECK (menge > 0),

    CONSTRAINT fk_kz_komponente
        FOREIGN KEY (komponente_id)
        REFERENCES komponenten (komponente_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_kz_zutat
        FOREIGN KEY (zutat_id)
        REFERENCES zutaten (zutat_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 7. Gerichte
-- basisportionen gibt an, für wie viele Personen
-- die hinterlegten Rezeptmengen ursprünglich gelten.

CREATE TABLE gerichte (
    gericht_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    gerichtname VARCHAR(150) NOT NULL,
    beschreibung TEXT NULL,
    kategorie VARCHAR(50) NULL,
    basisportionen INT UNSIGNED NOT NULL,

    CONSTRAINT chk_gerichte_basisportionen
        CHECK (basisportionen > 0)
);


-- 8. Gericht-Komponenten
-- Ordnet einem Gericht seine wiederverwendbaren Komponenten zu.
-- menge gibt die benötigte Anzahl an Komponenten bzw. Portionen
-- für die basisportionen des jeweiligen Gerichts an.

CREATE TABLE gericht_komponenten (
    gericht_id INT UNSIGNED NOT NULL,
    komponente_id INT UNSIGNED NOT NULL,
    menge DECIMAL(12,3) NOT NULL,

    PRIMARY KEY (gericht_id, komponente_id),

    CONSTRAINT chk_gk_menge
        CHECK (menge > 0),

    CONSTRAINT fk_gk_gericht
        FOREIGN KEY (gericht_id)
        REFERENCES gerichte (gericht_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_gk_komponente
        FOREIGN KEY (komponente_id)
        REFERENCES komponenten (komponente_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 9. Allergene

CREATE TABLE allergene (
    allergen_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    allergenname VARCHAR(100) NOT NULL UNIQUE
);


-- 10. Allergen-Zutat
-- n:m-Verknüpfung zwischen Zutaten und Allergenen.
-- Die Allergene einer Komponente werden über ihre Zutaten ermittelt.
-- Fehlende Zuordnungen sind kein Nachweis für Allergenfreiheit.

CREATE TABLE allergen_zutat (
    zutat_id INT UNSIGNED NOT NULL,
    allergen_id INT UNSIGNED NOT NULL,

    PRIMARY KEY (zutat_id, allergen_id),

    CONSTRAINT fk_az_zutat
        FOREIGN KEY (zutat_id)
        REFERENCES zutaten (zutat_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_az_allergen
        FOREIGN KEY (allergen_id)
        REFERENCES allergene (allergen_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
