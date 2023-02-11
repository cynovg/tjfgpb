package TJFGPB::Process;
use utf8;
use v5.30;
use warnings;
use Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(fill_parts);

sub fill_parts {
	my ($line) = @_;

	my %part;
	$line =~ s/^(?<timestamp>\S+\s+\S+)\s+(?<int_id>\S+)\s+//;
	my $timestamp = $+{'timestamp'};
	my $int_id    = $+{'int_id'};
	if ($line =~ /^(?<flag>(?:<=|=>|->|\*\*|==))\s+(?<address>\S+)\s+(?<message>.*)$/) {
		my $flag    = $+{'flag'};
		my $address = $+{'address'};
		my $message = $+{'message'};
		if ($flag eq "<=" && $message =~ /\sid=(?<id>\S+)/) { # skip lines wo id
			$part{'message'} = {
				timestamp => $timestamp,
				int_id    => $int_id,
				id        => $+{'id'},
				str       => "$int_id $flag $address $message",
			};
		}
		else {
			$part{'log'} = {
				timestamp => $timestamp,
				int_id    => $int_id,
				address   => $address,
				str       => $message,
			};
		}
	}
	else {
		$part{'log'} = {
			timestamp => $timestamp,
			int_id    => $int_id,
			address   => undef,
			str       => $line,
		};
	}
	return %part;
}

1;
