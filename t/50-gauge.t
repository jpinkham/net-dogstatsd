#!perl -T

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd, using default server/port settings.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);

throws_ok(
	sub {
		$dogstatsd->gauge();
	},
	qr/required argument/,
	'Gauge: dies on missing required argument-metric name',
);


throws_ok(
	sub {
		$dogstatsd->gauge( name => 'testmetric.inventory.onhand_minus_onhold' );
	},
	qr/required argument/,
	'Gauge: dies on missing required argument - metric value',
);


throws_ok(
	sub {
		$dogstatsd->gauge(
			name  => 'testmetric.inventory.onhand_minus_onhold',
			value => 'abc',
		);
	},
	qr/not a number/,
	'Gauge: non-numeric value',
);


lives_ok(
	sub {
		$dogstatsd->gauge(
			name => 'testmetric.inventory.onhand_minus_onhold',
			value => 250,
		);
	},
	'Gauge: specified valid metric name and value',
) || diag ($dogstatsd );
