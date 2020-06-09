<?php
/**
 * User: Hans-Gert Gräbe
 * Date: 2015-07-26
 */

include_once("layout.php");
include_once("php/elmat.php");

$content='      
<div class="container">
<h1 align="center">ZUVEL Metadaten</h1>  

<div class="row"><div class="col-sm-12">

<p><a href="http://forschungsinfo.tu-dresden.de/detail/forschungsprojekt/15016">Hintergrund des Projekts</a>.

</div></div>'.getZUVEL().'</div>';

echo showPage($content);

?>