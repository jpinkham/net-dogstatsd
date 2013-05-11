#!perl -T

use strict;
use warnings;

use Test::More tests => 7;
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
		$dogstatsd->timer();
	},
	qr/required argument/,
	'Timer: dies on missing required argument-metric name',
);

throws_ok(
	sub {
		$dogstatsd->timer( name => 'testmetric.timing.sample_sql' );
	},
	qr/required argument/,
	'Timer: dies on missing required argument-metric value',
);

throws_ok(
	sub {
		$dogstatsd->timer(
			name  => 'testmetric.timing.sample_sql',
			value => 400
		);
	},
	qr/required argument/,
	'Timer: dies on missing required argument-unit of time',
);


throws_ok(
	sub {
		$dogstatsd->timer(
			name  => 'testmetric.timing.sample_sql',
			value => 250,
			unit  => 'parsecs',
		);
	},
	qr/invalid value/,
	'Timer: dies on invalid unit',
);

throws_ok(
	sub {
		$dogstatsd->timer(
			name  => 'testmetric.timing.sample_sql',
			value => 'abc',
			unit  => 'sec',
		);
	},
	qr/not a number/,
	'Timer: dies on non-numeric value',
);

lives_ok(
	sub {
		$dogstatsd->timer(
			name  => 'testmetric.timing.sample_sql',
			value => 250,
			unit  => 'sec',
		);
	},
	'Timer: specified metric, value, unit',
);
