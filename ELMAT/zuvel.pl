use XML::DOM;
use Digest::MD5;

# call it as 
# perl zuvel.pl `find ZUVEL -name *.zip` >a.ttl

my $parser=new XML::DOM::Parser;
my $authors;
my $out;
map { $out.=process($_); } @ARGV;
map { $out.=createPersonRecord($_); } (sort keys %$authors);
print TurtleEnvelope($out);

sub process {
  my $fn=shift;
  system("/bin/rm -rf /tmp/uhu; unzip $fn -d /tmp/uhu");
  my @l=split(/\//,$fn);
  shift @l; shift @l; 
  my $u=analyseManifest("/tmp/uhu/imsmanifest.xml");
  my $name=pop @l;
  $name=~s/.zip$//;
  my $src=join("/",@l);
  push(@$u,
       map("elmat:relatesTo <http://symbolicdata.org/ZUVEL/Gebiet/$_>",@l));
  push(@$u,"a elmat:Aufgabe");
  push(@$u,"elmat:hasSource <file://$fn>");
  my $out=join(";\n",@$u);
  return "<http://symbolicdata.org/ZUVEL/Aufgabe/$name> $out .\n\n";
}

sub analyseManifest {
  my $dom=$parser->parsefile(shift);
  my $u;
  map { push(@$u,"elmat:hasIdentifier \"$_\""); } @{getIdentifiers($dom)};
  push(@$u,"dct:title \"".getTitle($dom)."\"");
  # push(@$u,"dct:issued \"".getCreationTime($dom)."\"^^xsd:datetime");
  my $description=getDescription($dom); 
  push(@$u,"dct:description \"\"\"".$description."\"\"\"") if $description;
  map { 
    push(@$u,"dct:creator <http://symbolicdata.org/ZUVEL/Person/$_>"); 
  } @{getAuthors($dom)};
  map { push(@$u,"dct:subject \"$_\""); } @{getKeywords($dom)};
  return $u;
}

sub getIdentifiers {
  my $node=shift;
  my $u;
  map { 
    push(@$u,getValue($_,"imsmd:identifier")); 
  } $node->getElementsByTagName("imsmd:general");
  return $u;
}

sub getTitle {
  my $node=shift;
  map { 
    return getValue($_,"imsmd:langstring"); 
  } $node->getElementsByTagName("imsmd:title");
}

sub getDescription {
  my $node=shift;
  map { 
    return fix(getValue($_,"imsmd:langstring")); 
  } $node->getElementsByTagName("imsmd:description");
}

sub getCreationTime {
  my $node=shift;
  map { 
    return getValue($_,"dateTime"); 
  } $node->getElementsByTagName("imsmd:lifeCycle");
}

sub getAuthors {
  my $node=shift;
  my $u;
  map { 
    $author=getValue($_,"imsmd:vcard");
    $md5=Digest::MD5->md5_hex($author);
    $authors->{$md5}=$author;
    push(@$u,$md5); 
  } $node->getElementsByTagName("imsmd:entity");
  return $u;
}

sub getKeywords {
  my $node=shift;
  my $u;
  map { 
    push(@$u,getValue($_,"imsmd:langstring")); 
  } $node->getElementsByTagName("imsmd:keyword");
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
  print "$vcard\n";
  $vcard=~s#\r\n#\n#g;
  # print $vcard;
  my @l;
  push(@l,"foaf:name \"$1\"") if $vcard=~/FN:\s*(.*?)\s/;
  push(@l,"foaf:mbox \"$1\"") if $vcard=~/EMAIL:\s*(.*?)\s/;
  my $out=join(" ;\n",@l);

  return <<EOT;
<http://symbolicdata.org/ZUVEL/Person/$id> a foaf:Person;
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

<http://symbolicdata.org/ZUVEL/Aufgabenpool/> a owl:Ontology ;
   rdfs:label "ZUVEL Metadaten" ;
   dct:creator <http://symbolicdata.org/Data/Person/Graebe_HG> ; 
   dct:issued "2015-12-31"^^xsd:date ; 
   rdfs:comment "Aus Dump vom 27.10.2015 generiert" .

$out
EOT
}
