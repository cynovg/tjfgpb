package TJFGPB::Utils;
use utf8;
use v5.30;
use warnings;
use Exporter;
use Const::Fast;
use DBI;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(get_dbh);

const my $database => 'content';
const my $host     => '127.0.0.1';
const my $user     => 'tjfgpb';
const my $passwd   => 'qwerty';

sub get_dbh {
    my $dbh = DBI->connect( "DBI:mysql:database=$database;host=$host",
        $user, $passwd, { PrintError => 0, RaiseError => 1 } );

    $dbh->{'mysql_enable_utf8mb4'} = 1;

    return $dbh;
}

1;
