<?php
/**
 * User: Hans-Gert Gräbe
 * Date: 2016-05-27
 */

include_once("layout.php");
require_once("lib/EasyRdf.php");

function getZUVEL() {
  EasyRdf_Namespace::set('foaf', 'http://xmlns.com/foaf/0.1/');
  EasyRdf_Namespace::set('dcterms', 'http://purl.org/dc/terms/');
  EasyRdf_Namespace::set('elmat', 'http://symbolicdata.org/ELMAT/Model#');
  $query = '
construct { ?a ?b ?c . }
from <http://symbolicdata.org/ZUVEL/Aufgabenpool/>
Where { ?a ?b ?c . } ';

  $sparql = new EasyRdf_Sparql_Client('http://pcai003.informatik.uni-leipzig.de:8893/sparql');
  $result=$sparql->query($query); // a CONSTRUCT query returns an EasyRdf_Graph
  //echo $result->dump("turtle");
  $a=array();
  foreach ($result->allOfType("elmat:Aufgabe") as $v) {
    $id=$v->getUri();
    $content=displayEntry($v);
    $a[]=array("sort" => "$id", "content" => $content);
  }
  array_multisort($a);
  $out=''; foreach($a as $v) { $out.=$v["content"]; }
  return $out;
}

function fix($s) {
  $s=str_replace("http://kosemnet.de/Data/Article/", "", $s);
  $s=str_replace("http://kosemnet.de/Data/Tag/", "", $s);
  return $s;
}

function displayEntry($v) { 
  $title=$v->get("dcterms:title");
  $subject=$v->join("dcterms:subject");
  $created=date_format(date_create($v->get('dcterms:created')),"d.m.Y");
  $abstract=$v->get("dcterms:description");
  $out='
<div class="row"><div  class="col-sm-12">
<h3>'.$title.'</h3></div></div>
<div class="row"><div  class="col-sm-12">
<p><dl>
<dd> <b>Autor(en)</b>: '.$author.'</dd>
<dd> <b>Inhalt</b>: '.$abstract.'</dd>
<dd> <b>Schlüsselworte</b>: '.$subject.'</dd>
<dd> <b>Created</b>: '.$created.'</dd>
</dl></div></div>';
  return $out;
}

?>
