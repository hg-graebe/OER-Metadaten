# Projekt zu einem RDF-basierten Konzept von OER-Metadaten 

## Hintergrund

Es gibt heute eine ganze Reihe von Plattformen, die Lehr-Materialien anbieten.
Ein besonderer Fokus wird in letzter Zeit auf OER - Open Educational Resources
- gelegt, da immer deutlicher wird, dass die freizügige Zugänglichkeit
entsprechender Wissensressourcen eine wesentliche kulturelle Voraussetzung ist,
um die Möglichkeiten des digitalen Zeitalters für eine umfassende Entwicklung
optimal zu nutzen.

Es gibt eine Reihe von Initiativen, zu diesem Ökosystem öffentlich verfügbarer
Texte ein Katalogsystem aufzubauen, wobei sich die Ansätze unterscheiden.
Zentrale Plattformen wie [edutags.de](http://www.edutags.de) legen den Fokus
auf zentrale Lösungen, die durch regelmäßiges Crawlen des Netzes sowie durch
Nutzercontent erweitert werden.  Vor- und Nachteile einer solchen zentralen
Lösung sind im Text "Zentrale und dezentrale Informationsplattformen" genauer
ausgeführt.  Problematisch ist hier oft die Datenqualität, da Informationen im
Netz oft eine geringe Halbwertzeit haben und der unidirektionale Verweis vom
Katalog auf die Quellen derartige Änderungen an den Quellen selbst nicht
"mitschneidet".

Neben solchen zentralen Lösungen gibt es Ansätze, die entsprechenden
Metainformationen (Katalog-Informationen) von den Betreibern selbst in einem zu
vereinbarenden Format als dezentrale Informationsressource bereitstellen zu
lassen und so einen dezentral verteilten öffentlichen Datenbestand als "globale
Datenbank" aufzubauen, auf deren Basis spezialisierte Weblösungen verschiedener
Ausrichtung auf ähnliche Weise umgesetzt werden können wie dies heute auf der
Basis lokaler Datenbanken und dynamischer Webseite bereits üblich ist. 

Hierfür gibt es heute bereits eine Reihe von konzeptionellen Vorbereitungen und
Lösungen, die lokale Informationsanbieter beachten sollten, wenn sie eigene
Metadaten in einen solchen Prozess einbringen wollen.  

- http://www.openarchives.org/OAI/openarchivesprotocol.html
- https://www.deutsche-digitale-bibliothek.de/content/ueber-uns
- Protocol for Metadata Harvesting

In den meisten Fällen ist es allerdings schwierig, für derart umfassende
Vernetzungsstrategien in kurzen Zeiträumen die erforderlichen Ressourcen
aufzubringen. 

Mit diesem Projekt soll deshalb studiert werden, wie leichtgewichtige Lösungen
auf der Basis von [Linked Open Data Prinzipien (LOD)](http://lod-cloud.net/)
und RDF für erste Schritte der Transformation bestehender Metadatensysteme in
Richtung eines dezentral verteilten öffentlichen Datenbestand als "globale
Datenbank" aufbereitet werden können. 

## Beispiele

In den Beispielen werden jeweils öffentlich interessante Daten in einer
Plattform itentifiziert und diese im RDF-Format in einem speziellen Bereich der
Plattform nach LOD-Prinzipien verfügbar gemacht.  Diese Daten werden zugelich
verwendet, um Informationsdarstellungen auf der eigenen Plattform 

### Webseiten der Fachgruppe Computeralgebra

- Webseite: http://www.fachgruppe-computeralgebra.de/
- Basis: Wordpress. 
- RDF-Daten: http://www.fachgruppe-computeralgebra.de/rdf/
- Code: https://github.com/symbolicdata/maintenance - casn-plugin

Diese Informationen werden an verschiedenen Stellen der Plattform eingebunden.
Eine Übersicht dieser Einbindungen ist auf einer [speziellen
Seite](http://www.fachgruppe-computeralgebra.de/symbolicdata/) der Plattform
zusammengetragen. Die Realisierung dieser Einbindung erfolgt über ein speziell
für diese Zwecke entwickeltes WP-Plugin, in dem WP-Shortcodes für die einzelnen
Darstellungsaufgaben definiert werden.

### Webseiten des KoSemNet-Projekts

- Webseite: http://lsgm.de/KoSemNet/
- Basis: Einfache PHP-Lösung auf der Basis von Bootstrap
- RDF-Daten: http://lsgm.de/KoSemNet/rdf/

Diese Informationen werden verwendet, um die [Liste der verfügbaren
Aufsätze](http://lsgm.de/KoSemNet/ArticleList.php) zu erzeugen.  Um einen neuen
Aufsatz einzuarbeiten, sind die entsprechenden  Metainformationen nur in die
Datei `Article.rdf` einzufügen. 

### ELMAT-Projekt - zu ergänzen

### ZUVEL-Projekt - zu ergänzen
