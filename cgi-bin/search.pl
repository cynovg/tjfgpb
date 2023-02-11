#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use CGI;
use File::Slurp;
use Const::Fast;

const my $root => "/var/www/html/";

sub main {
	my $cgi = CGI->new;
	print $cgi->header(-charset => 'utf8');
	if ($cgi->request_method eq 'POST') {
		print "POST";
	} else {
		print read_file($root . "templates/search_form.html");
	}
}

main(@ARGV);