#!/usr/bin/env perl

use Config::IniFiles;
use strict;
use warnings;

my $outfile = shift;

my $cfg = Config::IniFiles->new ( -file => "config" );

open (INBIN, "<lemonldap-ng-cli.in");
my @contents = <INBIN>;
close (INBIN);

open (OUTBIN, ">$outfile");

foreach (@contents)
{
     my $line = $_;

     if ($line =~ /__CONFPATH__/)
     {
          my $confpath = $cfg->val ('build', 'confpath');

          $line =~ s/__CONFPATH__/$confpath/g;
     }

     print OUTBIN $line;
}
