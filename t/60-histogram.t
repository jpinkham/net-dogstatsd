#!perl -T

use strict;
use warnings;

use Test::More tests => 5;
use Test::FailWarnings -allow_deps => 1;
use Test::Exception;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd, using default server/port settings.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);

throws_ok(
	sub {
		$dogstatsd->histogram();
	},
	qr/required argument/,
	'Histogram: dies on missing required argument-metric name',
);


throws_ok(
	sub {
		$dogstatsd->histogram( name => 'testmetric.inventory.onhand_minus_onhold' );
	},
	qr/required argument/,
	'Histogram: dies on missing required argument-metric value',
);


throws_ok(
	sub {
		$dogstatsd->histogram(
			name  => 'testmetric.inventory.onhand_minus_onhold',
			value => 'abc',
		);
	},
	qr/not a number/,
	'Histogram: dies on non-numeric value',
);


lives_ok(
	sub {
		$dogstatsd->histogram(
			name  => 'testmetric.inventory.onhand_minus_onhold',
			value => 250,
		);
	},
	'Histogram: specified metric name and value',
);
