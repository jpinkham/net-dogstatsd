#!perl -T

use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd - no parameters.
my $dogstatsd = Net::Dogstatsd->new();

isa_ok(
	$dogstatsd, 'Net::Dogstatsd',
	'Return value of Net::Dogstatsd->new()',
) || diag( explain( $dogstatsd ) );


# Set verbosity with invalid value
lives_ok(
	sub
	{
		$dogstatsd->verbose(3);
	},
	'Does not set verbosity to anything but 0/1',
);

# Set verbosity with valid value
$dogstatsd->verbose(1);

# Get verbosity
my $verbosity = $dogstatsd->verbose();

is(
	$verbosity,
	1,
	"Verbosity set to true."
);
