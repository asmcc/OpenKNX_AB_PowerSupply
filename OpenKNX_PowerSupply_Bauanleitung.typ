#let img-base = sys.inputs.at("img-dir", default: "Bilder")

#set text(font: ("Liberation Sans", "Segoe UI", "Arial"), size: 10pt, lang: "de")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.0cm, right: 2.0cm),
  header: context {
    if here().page() > 1 [
      #grid(
        columns: (1fr, 1fr),
        align(left)[#text(size: 8pt, fill: rgb("#666666"))[OpenKNX Busspannungsversorgung 1280 mA (6 TE)]],
        align(right)[#text(size: 8pt, fill: rgb("#666666"))[Bauanleitung & Dokumentation]]
      )
      #v(-4pt)
      #line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
    ]
  },
  footer: context [
    #line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
    #v(2pt)
    #grid(
      columns: (1fr, 1fr),
      align(left)[#text(size: 8pt, fill: rgb("#666666"))[AB-SmartHouse / OpenKNX / #link("https://github.com/asmcc")[asmcc]]],
      align(right)[#text(size: 8pt, fill: rgb("#666666"))[Seite #here().page() von #counter(page).final().at(0)]]
    )
  ]
)

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  v(14pt)
  text(fill: rgb("#1a446c"), weight: "bold", size: 1.4em)[#it]
  v(6pt)
}
#show heading.where(level: 2): it => {
  v(10pt)
  text(fill: rgb("#2a6496"), weight: "bold", size: 1.15em)[#it]
  v(4pt)
}

#let warning-box(title, body) = block(
  fill: rgb("#fff3cd"),
  stroke: 1pt + rgb("#ffeeba"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#856404"), size: 1.05em)[WARNUNG: #title] \
    #v(3pt)
    #text(fill: rgb("#533f03"))[#body]
  ]
)

#let note-box(title, body) = block(
  fill: rgb("#e8f4fd"),
  stroke: 1pt + rgb("#b8daff"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#004085"), size: 1.05em)[HINWEIS: #title] \
    #v(3pt)
    #text(fill: rgb("#002752"))[#body]
  ]
)

// Titelseite
#align(center)[
  #v(20pt)
  #text(size: 24pt, weight: "bold", fill: rgb("#1a446c"))[OpenKNX Busspannungsversorgung] \
  #v(4pt)
  #text(size: 16pt, weight: "medium", fill: rgb("#2a6496"))[1280 mA -- 6 TE -- Diagnose -- Redundant] \
  #v(10pt)
  #text(size: 12pt, style: "italic", fill: rgb("#555555"))[Technische Dokumentation und Schritt-für-Schritt Bauanleitung]
  #v(15pt)
]

#block(
  fill: rgb("#f8f9fa"),
  stroke: 1pt + rgb("#e9ecef"),
  inset: 12pt,
  radius: 6pt,
  width: 100%,
  [
    #grid(
      columns: (1.2fr, 2fr),
      row-gutter: 6pt,
      [#strong[Entwickler / Projekt:]], [AB-Tools GmbH / #link("https://www.ab-smarthouse.com/produkt/openknx-busspannungsversorgung-1280-ma-6-te-diagnose-redundant/")[ab-smarthouse.com]],
      [#strong[GitHub / Bearbeiter:]], [#link("https://github.com/asmcc")[github.com/asmcc] (asmcc)],
      [#strong[OpenKNX-Modul:]], [OAM-BusPowerSupply (GPL-3.0)],
      [#strong[Hardware-Revisionen:]], [Base Board v1.8, Top Board v1.1, NanoBCU v1.1],
      [#strong[Netzteil-Module:]], [230 VAC Adapter v1.1, 22-60 VDC Converter v1.3],
      [#strong[Programmier-Tool:]], [Progger v1.8.1 (USB-C & SWD Debug)]
    )
  ]
)

#v(15pt)
#outline(indent: auto, depth: 2)

#pagebreak()

= Systemübersicht & Technische Daten

Die OpenKNX Busspannungsversorgung 1280 mA ist ein modulares Reiheneinbaugerät (REG) mit 6 Teilungseinheiten (TE) Baubreite für die Hutschiene (EN 60715). Sie vereint hohe Ausgangsleistung, echte Netzausfallsicherheit durch zwei autarke Netzteileinschübe und detaillierte KNX-Diagnosefunktionen.

== Elektrische Kenndaten

#table(
  columns: (1.5fr, 1.8fr, 2.5fr),
  fill: (x, y) => if y == 0 { rgb("#1a446c") } else if calc.even(y) { rgb("#f8f9fa") } else { none },
  stroke: 0.5pt + rgb("#dddddd"),
  align: (col, row) => if row == 0 { center } else { left },
  [#text(weight: "bold", fill: white)[Parameter]],
  [#text(weight: "bold", fill: white)[Spezifikation]],
  [#text(weight: "bold", fill: white)[Beschreibung / Besonderheit]],

  [Bussystem], [KNX TP-256 (Twisted Pair)], [9600 Baud, CSMA/CA],
  [Bus-Nennspannung], [30 V DC (28--31 V DC)], [Gedrosselte Ausgangsspannung],
  [Bus-Nennstrom], [1280 mA Dauerlast], [Auslegung für umfangreiche Liniensegmente],
  [Entkopplungsdrossel], [1,25--1,5 mH (0,5 $Omega$ DC)], [Ringkerndrossel zur HF-Signalentkopplung],
  [Hilfsspannung (AUX)], [30 V DC (ungedrosselt)], [Separate weiß/gelbe KNX-Klemme für Zusatzgeräte],
  [Netzteil-Dauerleistung], [Bis zu 72 W (30 V / 2,4 A)], [Sichere Pufferung von Busstart-Einschaltströmen],
  [Redundanz-Stufe], [Power-MOSFETs], [4 Power-MOSFETs (D4185) zur verlustarmen Entkopplung],
  [Modul 1 (Primär)], [230 V AC Schaltnetzteil], [Speisung ab regulärem Stromnetz],
  [Modul 2 (Redundanz)], [22--60 V DC Wandler], [Direktanbindung an 24 V / 48 V Akku, USV oder PV],
  [Controller-MCU], [Raspberry Pi RP2040], [Dual-Core Cortex-M0+ \@ 133 MHz, 16 MB SPI-Flash],
  [KNX-Transceiver], [ON Semi NCN5130], [Vollintegrierter KNX-Transceiver auf NanoBCU-Modul],
  [Gehäuse], [6 TE Hutschienengehäuse], [3D-Druck-Gehäuse (PLA/PETG) mit verschraubter Frontblende]
)

== Sicherheits- & Haftungshinweise

#warning-box("230-V-Netzspannung -- Lebensgefahr", [
  Arbeiten an 230-V-Wechselspannung bergen lebensgefährliche Risiken durch elektrischen Schlag und Lichtbogenbildung. Montage, Verdrahtung und Inbetriebnahme im Schaltschrank dürfen ausschließlich durch eine autorisierte Elektrofachkraft unter Beachtung der geltenden VDE-Vorschriften (DIN VDE 0100) erfolgen.
])

#v(8pt)

#note-box("Maker- & Open-Source-Hardware", [
  Dieses Gerät entstand im Rahmen des offenen OpenKNX-Community-Projekts für Entwickler und Maker. Es verfügt über keine industrielle Baumusterprüfung und keine KNX-Verbandszertifizierung. Zusammenbau und Betrieb erfolgen auf eigene Verantwortung.
])

#pagebreak()

= Schritt-für-Schritt-Bauanleitung

== Übersicht & Komponenten

Vor Beginn des Zusammenbaus ist der Bausatz auf Vollständigkeit zu prüfen:

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/01_Uebersicht/20260903_1711930.JPG", width: 100%),
    caption: [Gehäuseschalen, Frontblende und Leiterplatten]
  ),
  figure(
    image(img-base + "/01_Uebersicht/20260903_1733560.JPG", width: 100%),
    caption: [THT-Bestücksatz mit Drossel, Elkos und Klemmen]
  )
)

*Lieferumfang und Komponenten:*
- *Gehäuseteile:* 3D-Druck-Unter- und Oberschale (6 TE), Frontblende mit UV-Aufdruck, 4x M3 Senkkopfschrauben.
- *Leiterplatten:* Basisplatine (Base Board v1.8), Bedienerplatine (Top Board v1.1), 15-poliges FFC-Kabel.
- *THT-Komponenten:* 1x Ringkerndrossel (1,25--1,5 mH, `152K`), 2x Elkos 1000 µF / 50 V, 1x NanoBCU v1.1 Daughterboard, 1x 6-poliger Schraubklemmenblock grün (drei 2-polige Blöcke), 2x 1x5 Buchsenleisten, 4x Rundkontaktstifte, KNX-Klemmen (rot/schwarz & weiß/gelb).

#pagebreak()

== Vorbereitung AC/DC-Netzteil 230 V AC

Das 230-V-AC-Schaltnetzteil (30 V / 72 W) wird über die Adapterplatine `Bus Power Supply, 230 VAC Adapter v1.1` montiert.

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1719751.JPG", width: 100%),
    caption: [AC/DC-Modul, Adapterplatine und 4 Lötstifte]
  ),
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1721468.JPG", width: 100%),
    caption: [Unterseite des AC/DC-Schaltnetzteils]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1910108.JPG", width: 100%),
    caption: [Lötstifte in Adapterplatine eingesetzt]
  ),
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1910141.JPG", width: 100%),
    caption: [Lötstifte auf Rückseite verlötet]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1925200.JPG", width: 100%),
    caption: [Zusammenfügen Primärseite: 2--3 mm Platinenabstand]
  ),
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1925337.JPG", width: 100%),
    caption: [Zusammenfügen Sekundärseite: SMD-Bauteile anliegend]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1926353.JPG", width: 100%),
    caption: [Fertig verlötete Sekundärseite]
  ),
  figure(
    image(img-base + "/02_ACDC_230VAC/20260903_1926588.JPG", width: 100%),
    caption: [Fertig verlötete Primärseite]
  )
)

*Arbeitsanweisung:*
1. Vier Lötstifte von der Unterseite in die Adapterplatine stecken und verlöten.
2. Es gibt hier keinen separaten Abstandshalter! Das Netzteil aufsetzen und die beiden Platinen möglichst nah aneinander zusammendrücken, sodass die SMD-Bauteile des AC/DC-Netzteils direkt an der Hilfsplatine anliegen und der verbleibende Abstand zwischen den beiden Platinen 2--3 mm beträgt (siehe Abbildungen).
3. Die Lötstifte primärseitig (N, L) sowie sekundärseitig (+, -) von beiden Seiten vollflächig verlöten.

#pagebreak()

== Vorbereitung DC/DC-Wandler 22--60 V DC

Das DC/DC-Modul `22-60 VDC Converter v1.3` dient als redundante Speisung aus 24 V oder 48 V DC. Da dieses Modul neu im Sortiment ist, erfordert es vor dem Einlöten eine sorgfältige mechanische Vorbereitung.

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/03_DCDC_60VDC/20260903_1723791.JPG", width: 100%),
    caption: [Oberseite des DC/DC-Wandlermoduls vor Bearbeitung]
  ),
  figure(
    image(img-base + "/03_DCDC_60VDC/20260903_1723906.JPG", width: 100%),
    caption: [Rückseite mit vorstehenden Drahtenden vor Bearbeitung]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/03_DCDC_60VDC/20260903_2150095.JPG", width: 100%),
    caption: [Bündiges Kürzen der Trafo- und Bauteilbeinchen]
  ),
  figure(
    image(img-base + "/03_DCDC_60VDC/20260903_2150215.JPG", width: 100%),
    caption: [Seitenansicht: Profilprüfung der bündigen Drahtenden (< 1 mm)]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/03_DCDC_60VDC/20261102_1002236.JPG", width: 100%),
    caption: [Moduloberseite mit bestückter grüner LED (PWR)]
  ),
  figure(
    image(img-base + "/03_DCDC_60VDC/20261102_1002241.JPG", width: 100%),
    caption: [Seitenansicht der bestückten 3-mm-LED]
  )
)

#figure(
  image(img-base + "/03_DCDC_60VDC/20261102_1001353.JPG", width: 70%),
  caption: [Vollständig und plan nachgelötete Unterseite mit verlöteter LED]
)

*Arbeitsanweisung:*
1. Sämtliche auf der Rückseite überstehenden Anschlussdrähte von Übertrager, Elkos und Entstörkondensator mit einem Präzisions-Seitenschneider bündig abtrennen.
2. In der Profilansicht kontrollieren, dass die Aufbauhöhe unter 1 mm bleibt.
3. Alle Bauteile ordentlich und ohne Überreste vom Lötzinn verlöten. Eine absolut plane Unterseite verhindert zuverlässig Kurzschlüsse bei der späteren vertikalen Montage auf der Basisplatine.
4. *Grüne Grundlast-LED einlöten:* Die grüne 3-mm-Bedrahtungs-LED auf der Oberseite am Bestückungsplatz `PWR` einsetzen (Polarität: langes Beinchen = Anode / `+`, kurzes Beinchen = Kathode / `–`). Auf der Unterseite verlöten und überstehende Anschlüsse bündig abtrennen.

#note-box("Schutzfunktion der grünen LED (Grundlast)", [
  Die grüne LED dient als erforderliche Grundlast für den DC/DC-Schaltwandler: Im lastfreien Leerlauf begrenzt sie die Ausgangsspannung zuverlässig auf maximal *31,5 V DC*. Ohne diese LED-Grundlast kann die Leerlaufspannung des Wandlers auf bis zu *40 V DC* ansteigen und angeschlossene Baugruppen gefährden.
])

#pagebreak()

== Steckerleisten & Schraubanschlüsse

Nun werden die Klemmen und Steckverbinder auf der Basisplatine bestückt.

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/04_Steckerleisten_Schraubanschluesse/20260903_1825922.JPG", width: 100%),
    caption: [Eingesetzte 6-polige Schraubklemme]
  ),
  figure(
    image(img-base + "/04_Steckerleisten_Schraubanschluesse/20260903_1825656.JPG", width: 100%),
    caption: [Unterseite mit durchgelöteten Klemmenpins]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/04_Steckerleisten_Schraubanschluesse/20260903_1822850.JPG", width: 100%),
    caption: [Unterseite mit Progger- und NanoBCU-Lötstellen]
  ),
  figure(
    image(img-base + "/04_Steckerleisten_Schraubanschluesse/20260903_1822932.JPG", width: 100%),
    caption: [Oberseite mit 1x7 NanoBCU-Stiftleiste und 2x5 Progger-Buchse]
  )
)

*Arbeitsanweisung:*
1. *6-polige Klemmenleiste:* Die drei 2-poligen Klemmenblöcke über die seitlichen Führungen fest ineinander einstecken und somit mechanisch einen stabilen 6-poligen Block bilden. Mit den Schrauben nach oben und Kabeleinführungen nach außen einlöten. Belegung von links nach rechts: `PE/GND` | `N2/GND` | `L2/DC2` | `PE/GND` | `N1/GND` | `L1/DC1`.
2. *Progger-Buchse:* Zwei 1x5 Buchsenleisten nebeneinander zu einer 2x5 Pfostenbuchse für den Programmieradapter einlöten.
3. *NanoBCU-Leiste:* 1x7 Stiftleiste (Raster 2,54 mm) senkrecht im Bereich `NanoBCU` einlöten.

#pagebreak()

== KNX-Modul (NanoBCU)

Das Daughterboard `NanoBCU v1.1` enthält den ON Semi NCN5130 KNX-Transceiver.

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/05_KNX_Modul/20260903_1826565.JPG", width: 100%),
    caption: [NanoBCU mit roter Markierung um Isolierfolie des Elkos]
  ),
  figure(
    image(img-base + "/05_KNX_Modul/20260903_1828417.JPG", width: 100%),
    caption: [Seitenansicht der Huckepack-Montage]
  )
)

#figure(
  image(img-base + "/05_KNX_Modul/20260903_1830514.JPG", width: 45%),
  caption: [Verlötete NanoBCU mit NCN5130 Transceiver und 16 MHz Quarz]
)

*Arbeitsanweisung:*
1. *Isolationsschutz auf Elko:* Der Elektrolytkondensator auf der NanoBCU muss sorgfältig mit Isolierfolie (Kaptonband) beklebt werden (in der Abbildung mit rotem Kreis hervorgehoben), um Kurzschlüsse mit darüberliegenden Bauteilen zuverlässig auszuschließen.
2. Die NanoBCU v1.1 auf die 1x7 Stiftleiste stecken.
3. Es werden die oberen 5 Pins kontaktiert: `KNX`, `GND`, `SAV`, `RX`, `TX`. Die unteren Pins `3V3` / `NC` bleiben unbelegt.
4. Modul waagerecht ausrichten und verlöten.

#pagebreak()

== KNX- & Hilfsspannungsanschlüsse (AUX)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/06_KNX_Anschluesse/20260903_1832088.JPG", width: 100%),
    caption: [Unterseite: Verlötete 4 Buskontaktstifte]
  ),
  figure(
    image(img-base + "/06_KNX_Anschluesse/20260903_1833266.JPG", width: 100%),
    caption: [Aufgesteckte KNX- und AUX-Busklemmen]
  )
)

*Arbeitsanweisung:*
1. Die 4 Rundstifte rechtwinklig in die Bohrungen für `KNX` und `AUX` einlöten.
2. Standardklemmen aufstecken: Rot/Schwarz für KNX-Bus, Weiß/Gelb für 30 V AUX.

#pagebreak()

== KNX-Entkopplungsdrossel

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/07_Drosselspule/20260903_1834034.JPG", width: 100%),
    caption: [Lötverbindung der massiven Drosseldrähte]
  ),
  figure(
    image(img-base + "/07_Drosselspule/20260903_1834059.JPG", width: 100%),
    caption: [Bündig abgetrennte und sauber verlötete Anschlüsse]
  )
)

#figure(
  image(img-base + "/07_Drosselspule/20260903_1837531.JPG", width: 65%),
  caption: [Eingesetzte Drosselspule und verriegeltes FFC-Kabel]
)

*Arbeitsanweisung:*
1. Die Ringkerndrossel (1,25--1,5 mH / 0,5 $Omega$) bündig aufsetzen und die dicken Kupferlackdrähte auf der Unterseite verlöten.
2. Überstehende Drahtenden bündig mit dem Seitenschneider abtrennen und sauber nachlöten.
3. Das 15-polige FFC-Flachbandkabel in die ZIF-Buchse der Basisplatine stecken und sicher verriegeln.

#pagebreak()

== Elektrolytkondensatoren

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/08_Elektrolitkondensatoren/20260903_1839001.JPG", width: 100%),
    caption: [FFC-Kabelführung: unter den Elkos und oberhalb der NanoBCU]
  ),
  figure(
    image(img-base + "/08_Elektrolitkondensatoren/20260903_1841026.JPG", width: 100%),
    caption: [Niedrige Aufbauhöhe: Elkos flach über der NanoBCU]
  )
)

#figure(
  image(img-base + "/08_Elektrolitkondensatoren/20260903_1842226.JPG", width: 65%),
  caption: [Draufsicht auf die fertig montierten 1000 µF / 50 V Kondensatoren]
)

*Arbeitsanweisung:*
1. Anschlussbeine der beiden 1000 µF / 50 V Elkos um 90° abwinkeln (Polarität strikt beachten: Minusstreifen zum PCB-Aufdruck).
2. Das weiße FFC-Kabel sauber unter den liegenden Elkos und oberhalb der NanoBCU einfädeln.
3. Die Elkos waagerecht direkt oberhalb des NanoBCU-Moduls einlöten.

#pagebreak()

== Montage der Netzteilmodule (AC/DC & DC/DC)

Nun werden die vorbereiteten Leistungswandler vertikal in die Basisplatine eingelötet.

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260903_1929427.JPG", width: 100%),
    caption: [Kapton-Isolierband unter dem Netzteilstellplatz (s. Pfeil)]
  ),
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260903_1931675.JPG", width: 100%),
    caption: [Isolierschutz gegen Kühlkörper-Kurzschluss (s. Pfeil)]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260903_1931162.JPG", width: 100%),
    caption: [Hinteres AC/DC-Modul vertikal eingesetzt]
  ),
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260903_1932172.JPG", width: 100%),
    caption: [Unterseite: Verlötete Anschlüsse des hinteren Moduls]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260904_1806264.JPG", width: 100%),
    caption: [Beide Module vertikal verlötet]
  ),
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260904_1805177.JPG", width: 100%),
    caption: [Unterseite: Vollflächig durchgelötete Schlitze beider Module]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260904_1805049.JPG", width: 100%),
    caption: [Gesamtansicht des Leistungsblocks von oben]
  ),
  figure(
    image(img-base + "/09_Montage_ACDC_DCDC/20260904_1806189.JPG", width: 100%),
    caption: [Seitenansicht: Gesamtaufbauhöhe der Leistungsbaugruppe]
  )
)

*Arbeitsanweisung:*
1. *Isolationsband aufbringen:* Auf der Basisplatine unterhalb des Sekundär-Kühlkörpers einen Streifen hitzefestes Kapton-Klebeband anbringen (in den Abbildungen mit Pfeilen gekennzeichnet), um Massekontakte zu den Leiterbahnen und den 4 Power-MOSFETs (`D4185`) auszuschließen.
2. *AC/DC-Modul einsetzen & verlöten (Hintere Reihe):* Das Modul in die hinteren Montageschlitze stecken. Die Lötflächen auf der Oberseite sowie die breiten Anschlussflächen auf der Platinenunterseite mit ausreichend Hitze (350–380 °C) und Zinn vollflächig verlöten.
3. *DC/DC-Modul einsetzen & verlöten (Vordere Reihe):* Das DC/DC-Wandlermodul in die vorderen Schlitze stecken und ebenfalls von Ober- und Unterseite massiv verlöten.
4. *Prüfung der Lötstellen:* Auf der Platinenunterseite sichtprüfen, dass sämtliche Schlitze vollständig und hohlraumfrei mit Lötzinn gefüllt sind.

#pagebreak()

== Bediener-Einheit & Progger

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/10_Bediener-Einheit_und_Progger/20260904_1807152.JPG", width: 100%),
    caption: [Bedienerplatine (Top Board v1.1) aufgesetzt]
  ),
  figure(
    image(img-base + "/10_Bediener-Einheit_und_Progger/20260904_1833169.JPG", width: 100%),
    caption: [Aufgesteckter Progger v1.8.1 zur Programmierung]
  )
)

*Arbeitsanweisung:*
1. FFC-Kabel durch den Längsschlitz der Top-Platine führen und in den ZIF-Verbinder verriegeln.
2. Top-Platine waagerecht auf die Kanten der beiden vertikalen Netzteilplatinen aufsetzen und fixieren.
3. Zum Flashen der Firmware den modularen `Progger v1.8.1` auf die 2x5 Buchsenleiste aufstecken und via USB-C mit dem PC verbinden.

*LED-Matrix der Frontblende:*
- `BUS`: Busspannungsstatus (Grün = OK, Rot = Fehler/Kurzschluss).
- `TMP`: Übertemperaturwarnung.
- `TRC`: Telegramm-Trace (Bustraffic-Blinken).
- `DEV`: Controller-Heartbeat / Systemzustand.
- `PW1` / `PW2`: Status der beiden autarken Netzteile.
- `INF`: Parametrierbare Diagnose-/Infoanzeige aus der ETS.
- `MAX`: Überlastwarnung ($I > 1280$ mA).
- `PRG` / `RST`: Programmiermodus-LED und Bus-Reset-Anzeige.

#pagebreak()

== Zusammenbau des Gehäuses

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/11_Zusammenbau_Gehaeuse/20260904_1924034.JPG", width: 100%),
    caption: [Frontalansicht des montierten 6-TE-Gehäuses]
  ),
  figure(
    image(img-base + "/11_Zusammenbau_Gehaeuse/20260904_1925394.JPG", width: 100%),
    caption: [Oberseite mit Klemmenbeschriftung und Lüftungsschlitzen]
  )
)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  figure(
    image(img-base + "/11_Zusammenbau_Gehaeuse/20260904_1924238.JPG", width: 100%),
    caption: [Frontblende mit Tastern und LED-Fenstern]
  ),
  figure(
    image(img-base + "/11_Zusammenbau_Gehaeuse/20260904_1925314.JPG", width: 100%),
    caption: [Unterseite mit Aussparung für KNX/AUX-Busklemmen]
  )
)

*Arbeitsanweisung:*
1. Platinenblock in die untere Gehäuseschale einsetzen und Oberschale aufschieben.
2. Frontblende einlegen und mit den 4 Senkkopfschrauben fixieren.
3. Klemmen eindeutig und dauerhaft beschriften (`PE`, `N 230V`, `L`, `PE`, `- 20-60V DC`, `+`).

#pagebreak()

= Inbetriebnahme & ETS-Parametrierung

1. *Prüfplatz-Inbetriebnahme:*
   - Das Gerät vor dem Einbau in die Hausverteilung am Laborarbeitsplatz mit Strombegrenzung in Betrieb nehmen.
   - Spannungen an den Klemmen prüfen: KNX-Bus nom. 29,5 bis 30,5 V DC; AUX-Ausgang nom. 29,5 bis 30,5 V DC.
2. *Firmware aufspielen:*
   - Firmware mit der *OpenKNX Toolbox* für das Modul `OAM-BusPowerSupply` erstellen.
   - Über den USB-C-Progger v1.8.1 im Boot-Modus (Taste `Boot` gedrückt halten beim Verbinden) flashen.
3. *ETS-Integration:*
   - Die Produktdatenbankdatei (`.knxprod`) in die ETS einbinden.
   - Taste `PRG` drücken (rote LED leuchtet) und physikalische Adresse programmieren.
   - Kommunikationsobjekte für Busspannung, Busstrom, Buslast, Einzelnetzteilströme, Alarmgrenzen und Bus-Reset mit Gruppenadressen verknüpfen.
