# Mittwochtreff

Kurzes, statisches One‑page‑Site‑Projekt für die Gemeinschaftsveranstaltungen "Mittwochtreff".

Kurzbeschreibung

Dieses Repository enthält eine einfache statische Website (HTML, CSS, Vanilla JS) mit einer Veranstaltungs‑Kalenderansicht, einem Kontaktformular (mailto‑Fallback) und Bildern im Repo‑Root.

Schnellstart (lokal)

1. Repository klonen

   git clone https://github.com/swisswin/mittwochtreff.git
   cd mittwochtreff

2. Lokalen Testserver starten (empfohlen)

   # Python 3
   python -m http.server 8000

   Öffne dann http://localhost:8000/index.html im Browser.

Hinweis zu Assets / Bildern

- Die Dateien background.png und background-overlay.png sind im Repo‑Root. Bitte stelle sicher, dass du die Nutzungsrechte für diese Bilder besitzt. Falls nicht, ersetze sie durch lizenzfreie Bilder oder kontaktiere den Urheber.
- Zur Verbesserung der Ladezeiten empfiehlt es sich, responsive Bildvarianten (WebP/PNG) zu erzeugen und die CSS‑Referenz entsprechend anzupassen.

Vorschläge / To‑Do (kleine Verbesserungen)

- README erweitern mit Lizenz/Autor‑Angaben und Deploy‑Hinweisen (GitHub Pages/Netlify).
- Favicon und OpenGraph‑Bild (og:image) hinzufügen.
- Optional: Serverless‑Formular (Netlify Forms / Formspree) für das Kontaktformular.
- Accessibility‑Check (Kontraste, ARIA, Formular‑Fehlermeldungen).

Kontakt

Falls ich weiterhelfen soll (Optimierungen, Branch mit Fixes, Bildoptimierung), antworte hier mit den gewünschten Schritten oder erlaube mir, eine neue Branch anzulegen und Änderungen vorzuschlagen.
