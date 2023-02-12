#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use CGI;
use Const::Fast;
use HTML::Template;

use FindBin qw( $Bin );
use lib "$Bin/../lib/";

use TJFGPB::Utils qw(get_dbh);
use TJFGPB::Search qw(search);

const my $template_name => "/var/www/html/templates/search_form.tmpl";

sub main {
	my $cgi = CGI->new;
	print $cgi->header(-charset => 'utf8');
	my $template = HTML::Template->new(filename => $template_name);
	if ($cgi->request_method eq 'POST' && (my $address = scalar $cgi->param("address"))) {
		my $dbh = get_dbh();
		$address = 'error' if $address !~ /^[\w\d\@.-:]+\Z/;
		my ($count, $result) = search($dbh, address => $address);
		$template->param(RESULT => 1);
		$template->param(COUNT  => $count);
		$template->param(SEARCH => $address);
		if ($count) {
			$template->param(ROWS => [map { ROW => $_ }, @$result]);
			$template->param(MORE => $count) if $count > 100;
		}
	}
	print $template->output();
	return;
}

main(@ARGV);
