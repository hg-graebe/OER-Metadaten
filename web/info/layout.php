<?php
/**
 * User: Hans-Gert Gräbe
 * Date: 2016-06-26
 */

function pageHeader() {
  return '
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content="OER Metadata Standalone Info Page"/>
    <meta name="author" content="SymbolicData Project"/>
    <link rel="icon" href="img/favicon.ico"/>

    <title>OER Metadata Standalone Info Page</title>
    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet"/>
    
  </head>
<!-- end header -->
  <body>

';
}

function pageNavbar() {
  return '

    <!-- Fixed navbar -->
    <nav class="navbar navbar-default" role="navigation">
      <div class="container">
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="index.php">Index</a></li> 
            <li><a href="ksn.php">KoSemNet Artikelübersicht</a></li> 
            <li><a href="zuvel.php">ZUVEL Metadaten</a></li> 
          </ul>
        </div><!-- navbar end -->
      </div><!-- container end -->
    </nav>';
}

function generalContent() {
  return '
<div class="container">
  <h1 align="center">The OER Metadata Demonstration Site</h1>

<p> We demonstrate the power of distributed RDF-based OER Metadata for a search
and filter infrastructure on OER content descriptions.</p> </div>

<div class="footer"> <div class="container"> <p class="text-muted">&copy; <a
href="http://bis.informatik.uni-leipzig.de/HansGertGraebe">OER Metadata
Project</a> 2016 </p> </div> 
</div>
';
}

function pageFooter() {
  return '

    <!-- jQuery (necessary for Bootstrap JavaScript plugins) -->
    <script src="js/jquery.js"></script>
    <!-- Bootstrap core JavaScript -->
    <script src="js/bootstrap.min.js"></script>
    
  </body>
</html>';
}

function showPage($content) {
  return pageHeader().generalContent().pageNavbar().($content).pageFooter();
}
