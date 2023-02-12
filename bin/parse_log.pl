#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use Const::Fast;

use FindBin qw( $Bin );
use lib "$Bin/../lib/";

use TJFGPB::Utils qw(get_dbh store_logs store_messages);
use TJFGPB::Process qw(fill_parts);

const my $logname    => "out";
const my $part_count => 10_000;

sub main {
	parse_log($logname);
}

sub store_recs {
	my ($parts) = @_;

	state $dbh = get_dbh();
	store_messages($dbh, $parts->{'message'});
	store_logs($dbh, $parts->{'log'});

}

sub parse_log {
	my ($filename) = @_;
	my $parts;
	open(my $fh, "<", $filename) or die "Cant open log: $!\n";
	my $lines_counter;
	while (<$fh>) {
		chomp;
		$lines_counter++;
		my ($type, $value) = fill_parts($_);
		next unless $type;
		push @{ $parts->{$type} }, $value;
		if ($lines_counter == $part_count) {
			store_recs($parts);
			$parts         = undef;
			$lines_counter = 0;
		}
	}
	return;
}

main(@ARGV);
