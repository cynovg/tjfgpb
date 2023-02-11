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

	return [ { id => "current_id", message => "address" }];
}

1;