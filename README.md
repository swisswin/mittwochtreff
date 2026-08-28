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

- Die Dateien background.png und background-overlay.png sind im Repo‑Root. Bitte stelle sicher, dass du die Nutzungsrechte für diese Bilder besitzt. Falls nicht, ersetze sie durch lizenzfreie Bilder.
- Zur Verbesserung der Ladezeiten empfiehlt es sich, responsive Bildvarianten (WebP/PNG) zu erzeugen und die CSS‑Referenz entsprechend anzupassen.

Beispiel: Verwendung der generierten WebP‑Bilder in CSS

Die bereitgestellte `scripts/convert-images.sh` erzeugt responsive WebP‑Bilder (`bg-2000.webp`, `bg-1200.webp`, `bg-800.webp`) und optional eine kleine Platzhalterdatei `bg-lqip.webp`.

Ein einfaches CSS‑Beispiel für ein Hintergrundbild:

```css
.hero {
  background-image: url("dist/images/bg-800.webp");
  background-size: cover;
  background-position: center;
}

@media (min-width: 801px) {
  .hero { background-image: url("dist/images/bg-1200.webp"); }
}

@media (min-width: 1201px) {
  .hero { background-image: url("dist/images/bg-2000.webp"); }
}
```

Wenn du das kleine LQIP‑Bild als Platzhalter verwenden möchtest, kannst du es initial als Hintergrund setzen und bei vollständigem Laden des großen Bildes per JavaScript austauschen oder mit CSS‑Klassen arbeiten.

Alternativ, für inline‑Bilder (nicht Hintergrund), verwendest du das `<picture>`‑Element mit WebP und Fallbacks:

```html
<picture>
  <source type="image/webp" srcset="dist/images/bg-800.webp 800w, dist/images/bg-1200.webp 1200w, dist/images/bg-2000.webp 2000w">
  <img src="dist/images/bg-800.webp" alt="Hintergrundbild" style="width:100%;height:auto;">
</picture>
```

Vorschläge / To‑Do (kleine Verbesserungen)

- README erweitern mit Lizenz/Autor‑Angaben und Deploy‑Hinweisen (GitHub Pages/Netlify).
- Favicon und OpenGraph‑Bild (og:image) hinzufügen.
- Optional: Serverless‑Formular (Netlify Forms / Formspree) für das Kontaktformular.
- Accessibility‑Check (Kontraste, ARIA, Formular‑Fehlermeldungen).

Kontakt

Falls ich weiterhelfen soll (Optimierungen, Branch mit Fixes, Bildoptimierung), antworte hier mit den gewünschten Schritten oder erlaube mir, eine neue Branch anzulegen und Änderungen vorzuschlagen.
