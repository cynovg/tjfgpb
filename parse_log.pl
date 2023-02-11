#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use Const::Fast;

use FindBin qw( $Bin );
use lib "$Bin/lib/";

use TJFGPB::Utils qw(get_dbh);
use TJFGPB::Process qw(fill_parts);

const my $logname => "out";

sub main {
	my ($messages_count, $logs_count) = store_recs(parse_log($logname));
	printf("MESSAGES ADDED [%s]\n", $messages_count);
	printf("LOGS ADDED [%s]\n", $logs_count);
}

sub store_recs {
	my ($parts) = @_;

	my $dbh = get_dbh();
	my $messages_count = store_messages($dbh, $parts->{'message'});
	my $logs_count = store_logs($dbh, $parts->{'log'});

	return $messages_count, $logs_count;
}

sub store_logs {
	my ($dbh, $logs) = @_;
	my ($logs_count);
	while (my @part = splice(@$logs, 0, 500)) {
		my $values = join(", ", map {
			sprintf("( %s )",
				join(",",
					$dbh->quote($_->{'timestamp'}),
					$dbh->quote($_->{'id'}),
					$dbh->quote($_->{'str'}),
					$dbh->quote($_->{'address'}),
				)
			)
		} @part);
		$logs_count += $dbh->do("INSERT INTO `log` (`created`, `int_id`, `str`, `address`) VALUES " . $values);
	}
	return $logs_count;
}

sub store_messages {
	my ($dbh, $messages) = @_;

	my ($messages_count);
	while (my @part = splice(@$messages, 0, 500)) {
		my $values = join(", ", map {
			sprintf("( %s )",
				join(",",
					$dbh->quote($_->{'timestamp'}),
					$dbh->quote($_->{'id'}),
					$dbh->quote($_->{'int_id'}),
					$dbh->quote($_->{'str'})
				)
			)
		} @part);
		$messages_count += $dbh->do("INSERT INTO `message` (`created`, `id`, `int_id`, `str`) VALUES " . $values);
	}
	return $messages_count;
}

sub parse_log {
	my ($filename) = @_;
	my $parts;
	open(my $fh, "<", $filename) or die "Cant open log: $!\n";
	while (<$fh>) {
		chomp;
		my ($type, $value) = fill_parts($_);
		push @{$parts->{$type}}, $value;
	}
	return $parts;
}



main(@ARGV);
