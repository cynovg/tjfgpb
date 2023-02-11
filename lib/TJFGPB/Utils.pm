package TJFGPB::Utils;
use utf8;
use v5.30;
use warnings;
use Exporter;
use Const::Fast;
use DBI;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(get_dbh store_logs store_messages);

const my $database => 'content';
const my $host     => '127.0.0.1';
const my $user     => 'tjfgpb';
const my $passwd   => 'qwerty';

sub get_dbh {
	my $dbh = DBI->connect(
		"DBI:mysql:database=$database;host=$host",
		$user, $passwd, { PrintError => 0, RaiseError => 1 }
	);

	$dbh->{'mysql_enable_utf8mb4'} = 1;

	return $dbh;
}

sub store_logs {
	my ($dbh, $logs) = @_;
	my ($logs_count);
	while (my @part = splice(@$logs, 0, 500)) {
		my $values = join(", ",
			map {
				sprintf("( %s )",
					join(",",
						$dbh->quote($_->{'created'}),
						$dbh->quote($_->{'id'}),
						$dbh->quote($_->{'str'}),
						$dbh->quote($_->{'address'}),
					)
				)
			} @part
		);
		$logs_count += $dbh->do("INSERT INTO `log` (`created`, `int_id`, `str`, `address`) VALUES " . $values);
	}
	return $logs_count;
}

sub store_messages {
	my ($dbh, $messages) = @_;

	my ($messages_count);
	while (my @part = splice(@$messages, 0, 500)) {
		my $values = join(", ",
			map {
				sprintf("( %s )",
					join(",",
						$dbh->quote($_->{'created'}),
						$dbh->quote($_->{'id'}),
						$dbh->quote($_->{'int_id'}),
						$dbh->quote($_->{'str'}),
					)
				)
			} @part
		);
		$messages_count += $dbh->do("INSERT INTO `message` (`created`, `id`, `int_id`, `str`) VALUES " . $values);
	}
	return $messages_count;
}

1;
