use utf8;      # so literals and identifiers can be in UTF-8
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use XML::DOM;
use HTML::Entities;
use File::Basename;
use strict;

my $parser=new XML::DOM::Parser;

createMetaData("W13.AutomatenUndSprachen");

#for my $a (@ARGV) { copyFile($a); }

sub createMetaData {
  my $prefix=shift;
  my $out="";
  for my $a (@ARGV) {
    my $dom=$parser->parsefile($a) or die;
    map { $out.=createEntry($prefix,$_,basename($a)); }
      $dom->getElementsByTagName("autotoolnode");
  }
  print TurtleEnvelope($out);
}

## end main 

sub copyFile {
  my $fn=shift;
  my $dom=$parser->parsefile($fn) or die;
  my $sig=getValue($dom,"signature");
#  print("system(cp '$fn' tmp/$sig.xml)\n");
  system("cp '$fn' tmp/$sig.xml");
}

sub createEntry {
  my ($prefix,$node,$fn)=@_;
  #print $node->toString();
  my $sig=getValue($node,"signature");
  my @l;
  map {
    push(@l,"at:hasType <http://symbolicdata.org/autotool/Type/".$_->getAttribute("type_name").">");
    # push(@l,"at:scoring \"".$_->getAttribute("type_scoring")."\"");
  } $node->getElementsByTagName("tasktype");
  push(@l,"at:conf_text \"\"\"".decode_entities(getValue($node,"conf_text"))."\"\"\"");
#  push(@l,"at:doc_text \"\"\"".decode_entities(getValue($node,"doc_text"))."\"\"\"");
  push(@l,"at:remark \"\"\"".decode_entities(getValue($node,"description")."\"\"\""));
  my $out=join(";\n\t",@l);
  return <<EOT;
<http://symbolicdata.org/autotool/Configuration/$prefix/$sig> a at:Config;
 at:Aufgabenstellung "tba" ;
 at:Aufgabentext "tba" ;
 at:contributedBy atp:Loebe_Frank ;
 at:hasXMLFile "$prefix/$fn" ;
 at:relatedCourse <http://symbolicdata.org/autotool/Course/$prefix> ;
 rdfs:label "$prefix/$sig" ;
$out .
EOT
}

sub getValue {
  my ($node,$tag)=@_;
  map {
    my $s=$_->toString();
    $s=~s/<[^>]*>\s*//gs;
    $s=~s/\s*<\/[^>]*>//gs;
    return $s;
  } $node->getElementsByTagName($tag,1);
}

sub TurtleEnvelope {
  my $out=shift;

  return <<EOT
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix at: <http://symbolicdata.org/autotool/Model/> .
\@prefix atp: <http://symbolicdata.org/autotool/Person/> .
\@prefix owl: <http://www.w3.org/2002/07/owl#> .
\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
\@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

$out
EOT
}
