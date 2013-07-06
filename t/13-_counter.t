#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Test::FailWarnings -allow_deps => 1;
use Test::Exception;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd - no parameters.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);

throws_ok(
	sub {
		$dogstatsd->_counter( action => 'foo' );
	},
	qr/invalid action/,
	'_counter: Dies on invalid action'
);


throws_ok(
	sub {
		$dogstatsd->_counter( action => 'foo' );
	},
	qr/invalid action/,
	'_counter: Dies on invalid action'
);


throws_ok(
	sub {
		$dogstatsd->_counter( action => 'foo' );
	},
	qr/invalid action/,
	'_counter: Dies on invalid action'
);


