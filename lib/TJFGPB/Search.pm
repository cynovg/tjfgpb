package TJFGPB::Search;
use utf8;
use v5.30;
use warnings;
use Exporter;
use Const::Fast;
use DBI;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(search);

sub search {
	my ($dbh, $type, $string) = @_;
	return _search_by_address($dbh, $string) if $type eq 'address';
}

sub _search_by_address {
	my ($dbh, $address) = @_;

	my $count = $dbh->selectrow_array(<<SQL_COUNT, {}, $address, $address);
SELECT
	count(*)
FROM
	(SELECT
		 `str`
	 FROM
		 `log`
	 WHERE
		`address` = ?
	 UNION
	 SELECT
		 `str`
	 FROM `message`
	 WHERE
		`str` LIKE ?
	)
AS
`a`
SQL_COUNT

	my $result = $dbh->selectall_arrayref(<<SQL, { Slice => {} }, $address, $address);
SELECT
	`str`
FROM
	(SELECT
		`created`, `int_id`, `str`
		FROM
			`log`
		WHERE
			`address` = ?
	 UNION
	 SELECT
		`created`, `int_id`, `str`
		FROM `message`
		WHERE `str` LIKE ?
	)
AS
	`a`
ORDER BY
	`int_id`,
	`created`
LIMIT 100
SQL


	return $count, [map { $_->{'str'} } @$result];
}

1;