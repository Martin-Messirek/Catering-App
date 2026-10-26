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
















/* Seiteneffekte */

const duration = getComputedStyle(document.documentElement)
    .getPropertyValue("--page-transition-duration")
    .trim();

const durationMs = parseFloat(duration) *
    (duration.endsWith("ms") ? 1 : 1000);



document.addEventListener("click", function (event) {
    const link = event.target.closest("a[href]");

    if (!link) return;

    // Normales Anklicken voraussetzen
    if (
        event.defaultPrevented ||
        event.button !== 0 ||
        event.ctrlKey ||
        event.shiftKey ||
        event.altKey ||
        event.metaKey ||
        link.hasAttribute("download") ||
        (link.target && link.target !== "_self") ||
        window.matchMedia("(prefers-reduced-motion: reduce)").matches
    ) {
        return;
    }

    const targetUrl = new URL(link.href, window.location.href);

    // Nur interne Seiten wechseln
    if (targetUrl.origin !== window.location.origin) return;

    // Sprünge innerhalb derselben HTML-Seite normal ausführen
    if (
        targetUrl.pathname === window.location.pathname &&
        targetUrl.search === window.location.search
    ) {
        return;
    }

    event.preventDefault();

    document.body.classList.add("page-leaving");

    // Erst nach dem Ausblenden navigieren

    window.setTimeout(function () {
        window.location.href = targetUrl.href;
}, durationMs);
});

// Beim Wiederherstellen aus dem Browser-Cache
// einen eventuell verbliebenen Ausblendzustand entfernen.
window.addEventListener("pageshow", function (event) {
    if (event.persisted) {
        document.body.classList.remove("page-leaving");
    }
});