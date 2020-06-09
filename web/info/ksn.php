<?php
/**
 * User: Hans-Gert Gräbe
 * Date: 2015-07-26
 */

include_once("layout.php");
include_once("php/kosemnet.php");

$content='      
<div class="container">
<h1 align="center">KoSemNet Artikelübersicht</h1>  

<h2 align="center">Kurzübersicht über verfügbare Texte im 
<a href="http://lsgm.uni-leipzig.de/KoSemNet">KoSemNet-Archiv</a></h2>

<div class="row"><div class="col-sm-12">

<p>Die folgenden Aufsätze und mathematischen Miniaturen sind Teil der 
<a href="http://lsgm.uni-leipzig.de/KoSemNet">KoSemNet Datenbasis</a>.

<p> "geeignet für" bedeutet, dass der Text geeigent ist für die Arbeit mit
Schülern der Befähigungsstufe (klasse)-(grad).  "Grad" orientiert sich an der
Schwierigkeit von Aufgaben der Mathematikolympiade (MO) der angegebenen
Klassenstufe und reicht von 1 (MO 1. Stufe) bis 5 (IMO).
   </div></div>'.getArticles().'</div>';

echo showPage($content);

?>