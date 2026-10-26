const dialogBg = document.getElementById('dialog-bg');
const listDialog = document.getElementById("list-dialog");

function openDialog() {
    dialogBg.classList.remove('d-none');
    listDialog.classList.remove('d-none');
}

function closeDialog() {
    dialogBg.classList.add('d-none');
    listDialog.classList.add('d-none');
}




// init.js  Initialisierung: notwendige Grundlagen bereitstellen, HTML-Templates laden und grundlegende Backend-Kommunikation vorbereiten.
// script.js    Hauptsteuerung der Website: Seiteninitialisierung, Navigation und allgemeiner Ablauf zwischen den Bereichen.
// render.js	Frontend-Rendering: HTML-Elemente und Oberflächen dynamisch erzeugen, beispielsweise Speisenkarten, Formulare und Auswahlfelder.
// api.js	Kommunikation mit PHP: Daten abrufen, Formulare übermitteln und Antworten entgegennehmen.
// data-render.js	Backend-basiertes Rendering: die vom Backend gelieferten Daten für die Darstellung aufbereiten und die entsprechenden Oberflächen aktualisieren.
// Eventuell Dateien für Buchen, rezepte, Berechnungen
