#!perl -T

use strict;
use warnings;

use Test::More tests => 2;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd - no parameters.
my $dogstatsd = Net::Dogstatsd->new();

isa_ok(
	$dogstatsd, 'Net::Dogstatsd',
	'Return value of Net::Dogstatsd->new()',
) || diag( explain( $dogstatsd ) );


my $ddog_socket = $dogstatsd->get_socket();

isa_ok(
	$ddog_socket, 'IO::Socket::INET',
	'Return value of Net::Dogstatsd->new()->get_socket()',
) || diag( explain( $dogstatsd ) );


