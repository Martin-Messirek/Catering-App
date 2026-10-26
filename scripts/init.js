// init.js  Initialisierung: notwendige Grundlagen bereitstellen, HTML-Templates laden und grundlegende Backend-Kommunikation vorbereiten.




// Header und Footer rendern

async function includeHTML() {
    let includeElements = document.querySelectorAll('[w3-include-html]');

    for (let i = 0; i < includeElements.length; i++) {
        const element = includeElements[i];
        const file = element.getAttribute("w3-include-html");

        try {
            const resp = await fetch(file);

            if (resp.ok) {
                element.innerHTML = await resp.text();
            } else {
                element.innerHTML = 'Page not found';
            }
        } catch (error) {
            element.innerHTML = 'Error loading file';
        }
    }
}
