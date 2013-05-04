package Net::Dogstatsd;

use strict;
use warnings;

use Carp qw( croak carp );
use Data::Dumper;
use Data::Validate::Type;
use IO::Socket::INET;
use Try::Tiny;


=head1 NAME

Net::Dogstatsd - Perl client to Datadog's dogstatsd metrics collector.


=head1 VERSION

Version 0.9.0

=cut

our $VERSION = '0.9.0';


=head1 SYNOPSIS

This module allows you to interact with dogstatsd, a local daemon installed by
Datadog agent package. dogstatsd sends custom metrics to the Datadog service.

	use Net::Dogstatsd;

	# Create object.
	my $dogstatsd = Net::Dogstatsd->new();

=cut

=head1 MAIN

=cut

# Used to build the UDP datagram
my $METRIC_TYPES =
{
	'counter'   => 'c',
	'gauge'     => 'g',
	'histogram' => 'h',
	'timer'     => 'ms',
	'sets'      => 's',
};

=head1 METHODS

=head2 new()

Create a new Net::Dogstatsd object that will be used to interact with dogstatsd.

	use Net::Dogstatsd;

	my $dogstatsd = Net::Dogstatsd->new(
		host    => 'localhost',  #optional. Default = 127.0.0.1
		port    => '8125',       #optional. Default = 8125
		verbose => 1,            #optional. Default = 0
	);

=cut

sub new
{
	my ( $class, %args ) = @_;
	
	# Defaults
	my $host = $args{'host'} // '127.0.0.1';
	my $port = $args{'port'} // '8125';
	my $verbose = $args{'verbose'} // 0;
	
	my $self = {
		host             => $host,
		port             => $port,
		verbose          => $verbose,
	};
	
	bless( $self, $class );
	
	return $self;
}




=head1 RUNNING TESTS

By default, only basic tests that do not require a connection to Adobe
Dogstatsd's platform are run in t/.

To run the developer tests, you will need to do the following:

=over 4

=item *

Request access to Adobe web services from your Adobe Online Marketing Suite administrator.

=item *

In Dogstatsd's interface, you will need to log in as an admin, then go
to the "Admin" tab, "Admin Console > Company > Web Services". There you can find
your "shared secret" for your username.

=item *

Your report suite IDs can be found in Dogstatsd's interface. Visit
"Admin > Admin Console > Report Suites".

=back

You can now create a file named DogstatsdConfig.pm in your own directory, with
the following content:

	package DogstatsdConfig;

	sub new
	{
		return
		{
			username                => 'username',
			shared_secret           => 'shared_secret',
			verbose                 => 0, # Enable this for debugging output
		};
	}

	1;

You will then be able to run all the tests included in this distribution, after
adding the path to DogstatsdConfig.pm to your library paths.


=head1 AUTHOR

Jennifer Pinkham, C<< <jpinkham at cpan.org> >>.


=head1 BUGS

Please report any bugs or feature requests to C<bug-Net-Dogstatsd at rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Dogstatsd>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Net::Dogstatsd


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Dogstatsd>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Dogstatsd>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Dogstatsd>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Dogstatsd/>

=back


=head1 ACKNOWLEDGEMENTS

Special thanks for technical help from fellow ThinkGeek CPAN author Guillaume Aubert L<http://search.cpan.org/~aubertg/>


=head1 COPYRIGHT & LICENSE

Copyright 2012 Jennifer Pinkham.

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
