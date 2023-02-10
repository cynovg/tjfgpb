#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use Const::Fast;

use FindBin qw( $Bin );
use lib "$Bin/lib/";

use TJFGPB::Utils qw(get_dbh);

const my $logname => "out";

sub main {
	my $dbh = get_dbh();

	open(my $fh, "<", $logname) or die "Cant open log: $!\n";
	while (<$fh>) {
		chomp;
		say
	}
}

main(@ARGV);