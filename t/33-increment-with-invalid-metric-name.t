#!/usr/local/bin/perl

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
		$dogstatsd->increment(
			name => '1testmetric.request_count',
		);
	},
	qr/Invalid metric name/,
	'Increment: dies with invalid metric name  - starting with number',
);


lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count:',
		);
	},
	'Increment: warns on translated metric name - colon',
) || diag ($dogstatsd );

lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count|',
		);
	},
	'Increment: warns on translated metric name - pipe',
) || diag ($dogstatsd );

lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count@',
		);
	},
	'Increment: warns on translated metric name - at sign',
) || diag ($dogstatsd );

