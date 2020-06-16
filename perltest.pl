#!/usr/bin/perl
#
 


use POSIX;
use LWP::Simple;
use JSON;
use Data::Dumper;
use utf8;

use DBI;
require "/usr/wt/trd-reload.ph";
 

$dbh->disconnect;

print "\nNo errors if this is printed\n\n";


