#!perl -T

use strict;
use warnings;

use Test::More tests => 2;

use Net::Dogstatsd;


# Create an object to communicate with Dogstatsd - no parameters.
my $dogstatsd = Net::Dogstatsd->new();

isa_ok(
	$dogstatsd, 'Net::Dogstatsd',
	'Return value of Net::Dogstatsd->new()',
) || diag( explain( $dogstatsd ) );


# Set verbosity
$dogstatsd->verbose(1);

# Get verbosity
my $verbosity = $dogstatsd->verbose();

is(
	$verbosity,
	1,
	"Verbosity set to true."
);
