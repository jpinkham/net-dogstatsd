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

# test required argument
throws_ok(
	sub {
		$dogstatsd->increment();
	},
	qr/required argument/,
	'Increment: dies on missing required argument-metric name',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name  => 'testmetric.request_count',
			value => 'abc',
		);
	},
	qr/positive integer/,
	'Increment: dies on non-numeric value',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name  => 'testmetric.request_count',
			value => -1,
		);
	},
	qr/positive integer/,
	'Increment: dies on negative value',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name  => 'testmetric.request_count',
			value => 0.5,
		);
	},
	qr/positive integer/,
	'Increment: dies on float value',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->increment( name => 'testmetric.request_count' );
	},
	'Increment: specified metric name only',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->increment(
			name  => 'testmetric.request_count',
			value => 4,
		);
	},
	'Increment: specified metric name and value',
) || diag ($dogstatsd );

