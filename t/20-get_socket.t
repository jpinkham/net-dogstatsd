#!perl -T

use strict;
use warnings;

use Test::More tests => 2;
use Test::FailWarnings -allow_deps => 1;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd, using default server/port settings.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);

my $ddog_socket = $dogstatsd->get_socket();

isa_ok(
	$ddog_socket, 'IO::Socket::INET',
	'Return value of Net::Dogstatsd->new()->get_socket()',
) || diag( explain( $dogstatsd ) );


