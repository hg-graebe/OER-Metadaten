use XML::DOM;
use Digest::MD5;

my $parser=new XML::DOM::Parser;
my $authors;
my $out;
open(FH,"a.txt") or die;
while(<FH>) {
  chomp;
  $out.=process($_);
}
close FH;

map { $out.=createPersonRecord($_); } (sort keys %$authors);
# print $out;
print TurtleEnvelope($out);

sub process {
  my @l=split(/\//,shift);
  shift @l; shift @l; 
  my $src=join("/",@l);
  my $dir=$src; $dir=~s/.zip$//;
  my $u=analyseManifest($dir);
  my $name=pop @l;
  $name=~s/.zip$//;
  push(@$u,
       map("elmat:relatesTo <http://symbolicdata.org/ELMAT/Gebiet/$_>",@l));
  push(@$u,"a elmat:Aufgabe");
  push(@$u,"elmat:hasSource <$src>");
  my $out=join(";\n",@$u);
  return "<http://symbolicdata.org/ELMAT/Aufgabe/$name> $out .\n\n";
}

sub analyseManifest {
  my $dir=shift;
  my $dom=$parser->parsefile("Aufgabenpool_Mathematik/$dir/imsmanifest.xml");
  my $u;
  map { push(@$u,"elmat:hasIdentifier \"$_\""); } @{getIdentifiers($dom)};
  push(@$u,"dct:title \"".getTitle($dom)."\"");
  push(@$u,"dct:issued \"".getCreationTime($dom)."\"^^xsd:datetime");
  my $description=getDescription($dom); 
  push(@$u,"dct:description \"\"\"".$description."\"\"\"") if $description;
  map { 
    push(@$u,"dct:creator <http://symbolicdata.org/ELMAT/Person/$_>"); 
  } @{getAuthors($dom)};
  map { push(@$u,"dct:subject \"$_\""); } @{getKeywords($dom)};
  return $u;
}

sub getIdentifiers {
  my $node=shift;
  my $u;
  map { 
    push(@$u,getValue($_,"entry")); 
  } $node->getElementsByTagName("identifier");
  return $u;
}

sub getTitle {
  my $node=shift;
  map { 
    return getValue($_,"string"); 
  } $node->getElementsByTagName("title");
}

sub getDescription {
  my $node=shift;
  map { 
    return fix(getValue($_,"string")); 
  } $node->getElementsByTagName("description");
}

sub getCreationTime {
  my $node=shift;
  map { 
    return getValue($_,"dateTime"); 
  } $node->getElementsByTagName("lifeCycle");
}

sub getAuthors {
  my $node=shift;
  my $u;
  map { 
    $author=getValue($_,"entity");
    $md5=Digest::MD5->md5_hex($author);
    $authors->{$md5}=$author;
    push(@$u,$md5); 
  } $node->getElementsByTagName("lifeCycle");
  return $u;
}

sub getKeywords {
  my $node=shift;
  my $u;
  map { 
    push(@$u,getValue($_,"string")); 
  } $node->getElementsByTagName("keyword");
  return $u;
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
  s|\\|&bs;|gs;
  s#\r\n#\n#g;
  return $_;
}

sub createPersonRecord {
  my $id=shift;
  my $vcard=$authors->{$id};
  $vcard=~s#\r\n#\n#g;
  # print $vcard;
  my @l;
  push(@l,"foaf:name \"$1\"") if $vcard=~/FN:(.*?)\n/;
  push(@l,"foaf:mbox \"$1\"") if $vcard=~/EMAIL:(.*?)\n/;
  my $out=join(" ;\n",@l);

  return <<EOT;
<http://symbolicdata.org/ELMAT/Person/$id> a foaf:Person;
  $out .

EOT




EOT

}



sub TurtleEnvelope {
  my $out=shift;

  return <<EOT
\@prefix owl: <http://www.w3.org/2002/07/owl#> .
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
\@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
\@prefix foaf: <http://xmlns.com/foaf/0.1/> .
\@prefix dct: <http://purl.org/dc/terms/> .
\@prefix elmat: <http://symbolicdata.org/ELMAT/Model#> .

<http://symbolicdata.org/ELMAT/Aufgabenpool_Mathematik/> a owl:Ontology ;
   rdfs:label "ELMAT Metadaten" ;
   dct:creator <http://symbolicdata.org/Data/Person/Graebe_HG> ; 
   dct:issued "2015-09-22"^^xsd:date ; 
   rdfs:comment "Aus Dump vom 15.02.2015 generiert" .

$out
EOT
}
