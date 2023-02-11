package TJFGPB::Process;
use utf8;
use v5.30;
use warnings;
use Exporter;
use List::Util qw(any);

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(fill_parts);

sub fill_parts {
	my ($line) = @_;

	my %part;
	my ($date, $time, $int_id, $flag, $address, @parts) = split(" ", $line);
	if (any { $flag eq $_ } ('<=', '=>', '->', '**', '==')) {
		my $message = join(" ", @parts);
		if ($flag eq "<=" && $message =~ /\sid=(?<id>\d+)/) { # skip lines wo id
			$part{'message'} = {
				created => "$date $time",
				int_id  => $int_id,
				id      => $+{'id'},
				str     => "$int_id $flag $address $message",
			};
		}
		else {
			$part{'log'} = {
				created => "$date $time",
				int_id  => $int_id,
				address => $address,
				str     => "$int_id $message",
			};
		}
	}
	else {
		$part{'log'} = {
			created => "$date $time",
			int_id  => $int_id,
			address => undef,
			str     => "$int_id " . join(" ", grep { $_ } $flag, $address, @parts),
		};
	}
	return %part;
}

1;
