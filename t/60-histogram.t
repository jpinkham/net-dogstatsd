#!perl -T

use strict;
use warnings;

use Test::More tests => 21;
use Test::FailWarnings -allow_deps => 1;
use Test::Exception;
use Test::Warn;

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


throws_ok(
	sub {
		$dogstatsd->histogram(
			name => '1testmetric.request_count',
			value => 250,
		);
	},
	qr/Invalid metric name/,
	'Histogram: dies with invalid metric name  - starting with number',
);


warning_like(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count:',
			value => 250,
		);
	},
	qr/converted metric/,
	'Histogram: warns on translated metric name - colon',
) || diag ($dogstatsd );


warning_like(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count|',
			value => 250,
		);
	},
	qr/converted metric/,
	'Histogram: warns on translated metric name - pipe',
) || diag ($dogstatsd );


warning_like(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count@',
			value => 250,
		);
	},
	qr/converted metric/,
	'Histogram: warns on translated metric name - at sign',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->histogram(
			name  => 'testmetric.inventory.onhand_minus_onhold',
			value => 250,
		);
	},
	'Histogram: specified metric name and value',
);


# Additional tag-specific tests

throws_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => {},
		);
	},
	qr/list is invalid/,
	'Histogram: dies unless tag list is a hashref',
);


throws_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [ '1tag:something:value' ],
		);
	},
	qr/Invalid tag/,
	'Histogram: dies when tag list contains invalid item - tag starting with number',
);


throws_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [ 'tagabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz:value' ],
		);
	},
	qr/Invalid tag/,
	'Histogram: dies when tag list contains invalid item - tag > 200 characters',
);


# This is a non-standard check, DataDog will allow it, but it will result in
# confusion and unusual behavior in UI/graphing
throws_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [ 'tag:something:value' ],
		);
	},
	qr/Invalid tag/,
	'Histogram: dies when tag list contains invalid item - two colons',
);


lives_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [],
		);
	},
	'Histogram: specified name, value and empty tag list',
) || diag ($dogstatsd );


warning_like(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [ 'tag+name&here:value' ],
		);
	},
	qr/converted tag/,
	'Histogram: tag list with invalid item - WARN on disallowed characters',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			tags => [ 'testingtag', 'testtag:testvalue' ]
		);
	},
	'Histogram: specified valid name, value and tag list',
) || diag ($dogstatsd );


# Additional sample rate-specific tests

throws_ok(
	sub {
		$dogstatsd->histogram(
			name        => 'testmetric.request_count',
			value => 250,
			sample_rate => '',
		);
	},
	qr/Invalid sample rate/,
	'Histogram: dies with empty sample_rate',
);


throws_ok(
	sub {
		$dogstatsd->histogram(
			name        => 'testmetric.request_count',
			value => 250,
			sample_rate => 2,
		);
	},
	qr/Invalid sample rate/,
	'Histogram: dies with sample rate > 1',
);


dies_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			sample_rate => -1,
		);
	},
	'Histogram: dies with negative sample rate',
);


throws_ok(
	sub {
		$dogstatsd->histogram(
			name => 'testmetric.request_count',
			value => 250,
			sample_rate => 0,
		);
	},
	qr/Invalid sample rate/,
	'Histogram: dies with sample rate of zero',
);


lives_ok(
	sub {
		$dogstatsd->histogram(
			name        => 'testmetric.request_count',
			value => 250,
			sample_rate => 0.5,
		);
	},
	'Histogram: valid sample rate',
) || diag ($dogstatsd );
