package Lemonldap::NG::Cli;

# Required packages

use strict;
use Lemonldap::NG::Common::Conf;

use feature qw (switch);

# Constants

our $VERSION = "0.1";

our $ERRORS =
{
     TOO_FEW_ARGUMENTS  => "Too few arguments",
     UNKNOWN_ACTION     => "Unknown action",
     CONFIG_WRITE_ERROR => "Error while writting the configuration",
};

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

## @method int saveConf ()
# Save LemonLDAP::NG configuration
#
# @return Configuration identifier.
sub saveConf
{
     my ($self) = @_;
     my $ret = $self->{confAccess}->saveConf ($self->{conf});
     return $ret;
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
     $self->{argc} = @argv;

     if (!$self->parseCmd ())
     {
          print STDERR $self->getError (), "\n";
          return 1;
     }

     if (!$self->action ())
     {
          print STDERR $self->getError (), "\n";
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

     # check if there is at least on action specified
     if ($self->{argc} < 1)
     {
          $self->setError ($ERRORS->{TOO_FEW_ARGUMENTS});
          return 0;
     }

     given ($self->{argv}[0])
     {
          when ("set")
          {
               # set takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $var = $self->{argv}[1];
               my $val = $self->{argv}[2];

               # define action
               $self->{action} =
               {
                    type => "set",
                    var  => $var,
                    val  => $val,
               };
          }

          when ("get")
          {
               # get takes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $var = $self->{argv}[1];

               # define action
               $self->{action} =
               {
                    type => "get",
                    var  => $var,
               };
          }

          # no action found
          default
          {
               $self->setError ("$_: ".$ERRORS->{UNKNOWN_ACTION});
               return 0;
          }
     }

     return 1;
}

## @method bool action ()
# Execute action parsed by parseCmd() method
#
# @return true on success, false otherwise
sub action
{
     my ($self) = @_;

     given ($self->{action}->{type})
     {
          when ("set")
          {
               my $var = $self->{action}->{var};
               my $val = $self->{action}->{val};

               $self->{conf}->{$var} = $val;

               # Save configuration
               my $cfgNb = $self->saveConf ();

               # If there is no config identifier, then an error occured
               if (!$cfgNb)
               {
                    $self->setError ("$_: ".$ERRORS->{CONFIG_WRITE_ERROR});
                    return 0;
               }

               print "Configuration $cfgNb created!\n";
          }

          when ("get")
          {
               my $var = $self->{action}->{var};

               print "$var = '", $self->{conf}->{$var}, "'\n";
          }
     }

     return 1;
}

## @method void setError (string str)
# Set error message
#
# @param str Text of the error
sub setError
{
     my ($self, $msg) = @_;

     $self->{errormsg} = $msg;
}

## @method string getError ()
# Get error message
#
# @return Text of the error
sub getError
{
     my ($self) = @_;

     my $msg = $self->{errormsg};

     return $msg;
}

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
