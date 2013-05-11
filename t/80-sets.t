#!perl

use strict;
use warnings;

use Test::More tests => 4;
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
		$dogstatsd->sets();
	},
	qr/required argument/,
	'Sets: dies on missing required argument-metric name',
);

throws_ok(
	sub {
		$dogstatsd->sets( name => 'testmetric.inventory.onhand_minus_onhold' );
	},
	qr/required argument/,
	'Sets: dies on missing required argument-metric value',
);


lives_ok(
	sub {
		$dogstatsd->sets(
			name => 'testmetric.site.unique_visitors',
			value => '508123',
		);
	},
	'Sets: specified metric name and value',
) || diag ( $dogstatsd );
