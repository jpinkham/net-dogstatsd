#!perl -T

use strict;
use warnings;

use Test::More tests => 8;
use Test::Exception;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd, using default server/port settings.
my $dogstatsd = Net::Dogstatsd->new();

ok(
	defined( $dogstatsd ),
	'Net::Dogstatsd instance defined',
);


# Additional tag-specific tests

throws_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => {},
		);
	},
	qr/list is invalid/,
	'Increment: dies unless tag list is a hashref',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [ '1tag:something:value' ],
		);
	},
	qr/Invalid tag/,
	'Increment: dies when tag list contains invalid item - tag starting with number',
);


throws_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [ 'tagabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz:value' ],
		);
	},
	qr/Invalid tag/,
	'Increment: dies when tag list contains invalid item - tag > 200 characters',
);


# This is a non-standard check, DataDog will allow it, but it will result in
# confusion and unusual behavior in UI/graphing
throws_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [ 'tag:something:value' ],
		);
	},
	qr/Invalid tag/,
	'Increment: dies when tag list contains invalid item - two colons',
);


lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [],
		);
	},
	'Increment: empty tag list',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [ 'tag+name&here:value' ],
		);
	},
	'Increment: tag list with invalid item - WARN on disallowed characters',
) || diag ($dogstatsd );


lives_ok(
	sub {
		$dogstatsd->increment(
			name => 'testmetric.request_count',
			tags => [ 'testingtag', 'testtag:testvalue' ]
		);
	},
	'Increment: valid tag list',
) || diag ($dogstatsd );

