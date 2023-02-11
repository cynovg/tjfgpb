#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use CGI;
use File::Slurp;
use Const::Fast;
use HTML::Table;

use FindBin qw( $Bin );
use lib "$Bin/../lib/";

use TJFGPB::Utils qw(get_dbh);
use TJFGPB::Search qw(search);

const my $root => "/var/www/html/";

sub main {
	my $cgi = CGI->new;
	print $cgi->header(-charset => 'utf8');
	if ($cgi->request_method eq 'POST' && (my $address = scalar $cgi->param("address"))) {
		my $dbh = get_dbh();
		my ($count, $result) = search($dbh, address => $address);
		my $html = read_file($root . "templates/search_form.html");
		if ($count) {
			my $table = HTML::Table->new(
				-cols => 2,
				-head => [ qw/id message/ ],
			);
			for (@$result) {
				$table->addRow($_->{'id'}, $_->{'message'});
			}
			$html =~ s/<!-- RESULT -->/$table/;
			$html .= "<br /><div>\n<p>total $count</p>\n</div>\n" if $count > 100;
		} else {
			my $not_found = "<div>\n<p>Address <i><b>$address</b></i> not found</p>\n</div>\n";
			$html =~ s/<!-- RESULT -->/$not_found/;
		}
		print $html;
	} else {
		print read_file($root . "templates/search_form.html");
	}
}

main(@ARGV);