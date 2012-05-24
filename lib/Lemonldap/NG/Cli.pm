package Lemonldap::NG::Cli;

our $VERSION = "0.1";

use Lemonldap::NG::Common::Conf;

## @cmethod Lemonldap::NG::Cli new ()
# Create a new Lemonldap::NG::Cli object
#
# @return New Lemonldap::NG::Cli object
sub new
{
     my ($class) = @_;

     my $this =
     {
          "confAccess" =>  Lemonldap::NG::Common::Conf->new ()
     };

     $this->{conf} = $this->{confAccess}->getConf ();

     bless ($this, $class);
     return $this;
}

## @method int run (array argv)
# Run the application
#
# @param @argv List of arguments of the command line
# @return Exit code
sub run
{
     my ($self, @argv) = @_;

     $self->{argv} = \@argv;

     if (!$self->parseCmd ())
     {
          return 1;
     }

     return 0;
}

## @method bool parseCmd ()
# Parse command line
#
# @return true on success, false otherwise
sub parseCmd
{
     my ($self) = @_;

     return 1;
}

use strict;
1;
__END__

=head1 NAME

=encoding utf8

Lemonldap::NG::Cli - Command Line Interface to edit LemonLDAP::NG configuration.

=head1 DESCRIPTION

Lemonldap::NG::Cli allow user to edit the configuration of Lemonldap::NG via the
command line.

=head1 SEE ALSO

L<Lemonldap::NG>, L<Lemonldap::NG::Common::Conf>

=head1 AUTHOR

David Delassus E<lt>david.jose.delassus@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012, by David Delassus

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
