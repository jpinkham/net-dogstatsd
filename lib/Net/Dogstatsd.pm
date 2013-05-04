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


=head2 verbose()

Get or set the 'verbose' property.

	my $verbose = $dogstatsd->verbose();
	$dogstatsd->verbose( 1 );

=cut

sub verbose
{
	my ( $self, $value ) = @_;
	
	if ( defined $value && $value =~ /^[01]$/ )
	{
		$self->{'verbose'} = $value;
	}
	else
	{
		return $self->{'verbose'};
	}
	
	return;
}


=head2 get_socket()

Create a new socket, if one does not already exist.

	my $socket = $dogstatsd->get_socket();

=cut

sub get_socket
{
	my ( $self ) = @_;
	my $verbose = $self->verbose();
	
	if ( !defined $self->{'socket'} )
	{
		try
		{
			$self->{'socket'} = IO::Socket::INET->new(
				PeerAddr => $self->{'host'},
				PeerPort => $self->{'port'},
				Proto    => 'udp'
				) 
			|| die "Could not open UDP connection to" . $self->{'host'} . ":" . $self->{'port'};
			
		}
		catch
		{
			croak( "Could not open connection to metrics server. Error: >$_<" );
		};
	}
	
	return $self->{'socket'};
}



=head1 RUNNING TESTS

By default, only basic tests that do not require a connection to Datadog's
platform are run in t/.

To run the developer tests, you will need to do the following:

=over 4

=item * Sign up to become a Datadog customer ( if you are not already), at
L<https://app.datadoghq.com/signup>. Free trial accounts are available.

=item * Install and configure Datadog agent software (requires python 2.6)
L<https://app.datadoghq.com/account/settings#agent>

=back


=head1 AUTHOR

Jennifer Pinkham, C<< <jpinkham at cpan.org> >>.


=head1 BUGS

Please report any bugs or feature requests to the GitHub Issue Tracker at L<https://github.com/jpinkham/net-dogstatsd/issues>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Net::Dogstatsd


You can also look for information at:

=over 4

=item * Bugs: GitHub Issue Tracker

L<https://github.com/jpinkham/net-dogstatsd/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Dogstatsd>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Dogstatsd>

=item * MetaCPAN

L<https://metacpan.org/release/Net-Dogstatsd>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to ThinkGeek (<http://www.thinkgeek.com/>) and its corporate overlords at
Geeknet (<http://www.geek.net/>), for footing the bill while I write code for them!

=head1 COPYRIGHT & LICENSE

Copyright 2013 Jennifer Pinkham.

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
