# explore the autolat part in a OpenOlat course dump:
# 1) read the runstructure.xml and extract the BBautOLATCourseNode's
# 2) extract $ident and load the corresponding autotool file
#    export/autolatExport_$ident.xml
# 3) extract all desired information from both sources.
# No idea about the autotool files in the coursefolder dir.

use utf8;      # so literals and identifiers can be in UTF-8
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use XML::DOM;
use HTML::Entities;
use File::Basename;
use strict;

my $basedir="tmp/S15InfBerechenbarkeit";
my $prefix="http://symbolicdata.org/autotool/Configuration/S15.Berechenbarkeit";

my $parser=new XML::DOM::Parser;
#my $out=exploreRunstructure();
my $out=exploreConfigDir();
print TurtleEnvelope(fix($out));
#print $out;


# end main

sub exploreRunstructure {
  my $dom=$parser->parsefile("$basedir/runstructure.xml") or die;
  my $out;
  map { $out.=exploreBBNode($_); }
    $dom->getElementsByTagName("de.htwk.autolat.BBautOLAT.BBautOLATCourseNode");
  return $out;
}

sub exploreConfigDir { 
  opendir(D, "$basedir") || die "Can't open directory: $!\n";
  my @files=grep /\.xml/, readdir D;
  closedir(D);
  my $out;
  map { $out.=exploreConfigFile($_); } (sort @files);
  return $out;
}

sub exploreBBNode {
  my $node=shift;
  my $ident=getValue($node,"ident");
  my $fn="$basedir/export/autolatExport_$ident.xml"; 
  my $d=$parser->parsefile($fn) or die "No such file $fn\n";
  # print $d->toString();
  my $l=exploreXMLFile($d);
  push(@$l,"at:nodeIdent \"$ident\"");
  my $shortTitle=getValue($node,"shortTitle");
  push(@$l,"rdfs:label \"$shortTitle\"") if $shortTitle; 
  my $longTitle=getValue($node,"longTitle");
  push(@$l,"at:longTitle \"$longTitle\"") if $longTitle; 
  my $learningObjectives=decode_entities(getValue($node,"learningObjectives"));
  push(@$l,"at:learningObjectives \"\"\"$learningObjectives\"\"\"") 
    if $learningObjectives; 
  $out=join(";\n  ",reverse @$l);
  return <<EOT;
<$prefix/$ident> a at:Config;
  $out .

EOT
}

sub exploreConfigFile {
  my $fn=shift;
  my $id=$fn; $id=~s/\.xml//;
  my $dom=$parser->parsefile("$basedir/$fn") or die;
  my $sig=getValue($dom,"signature");
  my $l;
  map {
    push(@$l,"at:hasType <http://symbolicdata.org/autotool/Type/".$_->getAttribute("type_name").">");
    # push(@l,"at:scoring \"".$_->getAttribute("type_scoring")."\"");
  } $dom->getElementsByTagName("tasktype");
#  push(@$l,"at:conf_text \"\"\"".decode_entities(getValue($dom,"conf_text"))."\"\"\"");
#  push(@$l,"at:doc_text \"\"\"".decode_entities(getValue($dom,"doc_text"))."\"\"\"");
  my $remark=decode_entities(getValue($dom,"description"));
  push(@$l,"at:remark \"\"\"".$remark."\"\"\"") if $remark;
  push(@$l,"at:signature \"$sig\"");
  $out=join(";\n  ",reverse @$l);
  return <<EOT;
<$prefix/$id> a at:Config;
  $out .

EOT
}


sub exploreXMLFile {
  my $node=shift;
  #print $node->toString();
  my $sig=getValue($node,"signature");
  my $l;
  map {
    push(@$l,"at:hasType <http://symbolicdata.org/autotool/Type/".$_->getAttribute("type_name").">");
    # push(@l,"at:scoring \"".$_->getAttribute("type_scoring")."\"");
  } $node->getElementsByTagName("tasktype");
#  push(@$l,"at:conf_text \"\"\"".decode_entities(getValue($node,"conf_text"))."\"\"\"");
#  push(@$l,"at:doc_text \"\"\"".decode_entities(getValue($node,"doc_text"))."\"\"\"");
  my $remark=decode_entities(getValue($node,"description"));
  push(@$l,"at:remark \"\"\"".$remark."\"\"\"") if $remark;
  push(@$l,"at:signature \"$sig\"");
  return $l;
}

sub copyFile {
  my $fn=shift;
  my $dom=$parser->parsefile($fn) or die;
  my $sig=getValue($dom,"signature");
#  print("system(cp '$fn' tmp/$sig.xml)\n");
  system("cp '$fn' tmp/$sig.xml");
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

sub fix {
  local $_=shift;
  s/&Auml;/Ä/gs;
  s/&Ouml;/Ö/gs;
  s/&Uuml;/Ü/gs;
  s/&auml;//gs;
  s/&ouml;/ö/gs;
  s/&uuml;/ü/gs;
  s/&szlig;/ß/gs;
  s/&gt;/>/gs;
  s// /gs;
  return $_;
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
\@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

$out
EOT
}
