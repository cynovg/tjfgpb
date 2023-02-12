#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;
use Test::More;

use FindBin qw( $Bin );
use lib "$Bin/../../../lib/";

use_ok("TJFGPB::Process", "fill_parts");

for (map { chomp; $_; } <DATA>) {
	subtest "check log simple", sub {
		my $simple = shift;
		my ($type, $result) = fill_parts($simple);
		ok($type, 'Type fetched');
		ok(ref $result eq 'HASH', 'Recod parsed');
	}, $_;
}

is(fill_parts(""), undef, "Empty record skipped");

done_testing();


__DATA__
2012-02-13 14:59:48 1RwtdM-0000Ac-5x <= tpxmuwr@somehost.ru H=mail.somehost.com [84.154.134.45] P=esmtp S=2924 id=120213145213.DOMOI_STAT_CHNG_RU_DOMAIN_UPDATED.167925@whois.somehost.ru
2012-02-13 14:59:48 1RwtdM-0000Ac-9w => tpxmuwr@somehost.ru H=mail.somehost.com [84.154.134.45] P=esmtp S=1471 id=120213145156.FAXCHADMNIC.132031@whois.somehost.ru
2012-02-13 14:59:48 1RwtdC-0000Ac-Dr == qwryowky@bbpg.ru R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set
2012-02-13 14:59:48 SMTP connection from mail.somehost.com [84.154.134.45] closed by QUIT
