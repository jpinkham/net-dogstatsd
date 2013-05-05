#!/usr/local/bin/perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;
use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd, using default server/port settings.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);

# Additional sample rate-specific tests

throws_ok(
	sub {
		$dogstatsd->increment(
			name        => 'testmetric.request_count',
			sample_rate => '',
		);
	},
	qr/Invalid sample rate/,
	'Increment: dies with empty sample_rate',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name        => 'testmetric.request_count',
			sample_rate => 2,
		);
	},
	qr/Invalid sample rate/,
	'Increment: dies with sample rate > 1',
);


dies_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			sample_rate => -1,
		);
	},
	'Increment: dies with negative sample rate',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			sample_rate => 0,
		);
	},
	qr/Invalid sample rate/,
	'Increment: dies with sample rate of zero',
);


lives_ok(
	sub {
		$dogstatsd->increment(
			name        => 'testmetric.request_count',
			sample_rate => 0.5,
		);
	},
	'Increment: valid sample rate',
) || diag ($dogstatsd );
