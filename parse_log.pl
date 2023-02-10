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
	store_log(parse_log($logname));
}

sub store_log {
	my ($messages, $log) = @_;
	return;
}

sub parse_log {
	my ($filename) = @_;
	my (@log, @messages);
	open(my $fh, "<", $filename) or die "Cant open log: $!\n";
	while (<$fh>) {
		chomp;
		s/^(?<timestamp>\S+\s+\S+)\s+(?<int_id>\S+)\s+//;
		my $timestamp = $+{'timestamp'};
		my $int_id    = $+{'int_id'};
		if (/^(?<flag>(?:<=|=>|->|\*\*|==))\s+(?<address>\S+)\s+(?<message>.*)$/) {
			my $flag    = $+{'flag'};
			my $address = $+{'address'};
			my $message = $+{'message'};
			if ($flag eq "<=") {
				push @messages, {
					timestamp => $timestamp,
					int_id    => $int_id,
					str       => sprintf("%s %s %s %s", $int_id, $flag, $address, $message),
				};
			}
			else {
				push @log, {
					timestamp => $timestamp,
					int_id    => $int_id,
					address   => $address,
					str       => $message,
				};
			}
		}
		else {
			push @log, {
				timestamp => $timestamp,
				int_id    => $int_id,
				str       => $_,
			};
		}
	}
	return \@messages, \@log;
}

main(@ARGV);
