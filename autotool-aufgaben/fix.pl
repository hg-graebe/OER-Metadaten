use strict;
my $newserver='<server_conn name="Autotool Server HTWK Leipzig" version="0.2.0"/>';
my $fn=shift;
open(FH,"$fn") or die;
undef $/;
$_=<FH>;
s|<server_conn(.*)/>|$newserver|g;

print $_;
