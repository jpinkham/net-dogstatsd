#!perl -T

use Test::Most tests => 1;

BEGIN
{
	use_ok( 'Net::Dogstatsd' );
}

diag( "Testing Net::Dogstatsd $Net::Dogstatsd::VERSION, Perl $], $^X" );
