#!perl -T

use Test::More tests => 1;

BEGIN
{
	use_ok( 'Net::Dogstatsd' );
}

diag( "Testing Net::Dogstatsd $Net::Dogstatsd::VERSION, Perl $], $^X" );
