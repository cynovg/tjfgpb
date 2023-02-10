#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/lib/";

use TJFGPB::Utils qw(get_dbh);

sub main {
	my $dbh = get_dbh();
	use DDP; die np $dbh;
}

main(@ARGV);