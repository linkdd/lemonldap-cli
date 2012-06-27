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
     NOT_IMPLEMENTED    => "Not yet implemented",
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
     my ($self, $argv) = @_;

     $self->{argv} = \@{$argv};
     $self->{argc} = @{$argv};

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

     given (@{$self->{argv}}[0])
     {
          ## Variables

          when ("set")
          {
               # set takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $var = @{$self->{argv}}[1];
               my $val = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "set",
                    var  => $var,
                    val  => $val,
               };
          }

          when ("unset")
          {
               # unset takes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $var = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "unset",
                    var  => $var
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

               my $var = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "get",
                    var  => $var,
               };
          }

          ## Macros

          when ("set-macro")
          {
               # set-macro takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $m_name = @{$self->{argv}}[1];
               my $m_expr = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "set-macro",
                    name => $m_name,
                    expr => $m_expr
               };
          }

          when ("unset-macro")
          {
               # unset-macro takes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $m_name = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "unset-macro",
                    var  => $m_name
               };

          }

          when ("get-macro")
          {
               # get-macro tkaes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $m_name = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "get-macro",
                    name => $m_name
               };
          }

          ## Applications

          when ("apps-set-cat")
          {
               # apps-set-cat takes two parameter
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $catid   = @{$self->{argv}}[1];
               my $catname = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-cat",
                    id   => $catid,
                    name => $catname
               };
          }

          when ("apps-get-cat")
          {
               # apps-get-cat takes one parameter
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $catid = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "apps-get-cat",
                    id   => $catid
               };
          }

          when ("apps-add")
          {
               # apps-add takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid = @{$self->{argv}}[1];
               my $catid = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type  => "apps-add",
                    appid => $appid,
                    catid => $catid
               };
          }

          when ("apps-set-uri")
          {
               # apps-set-uri takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid  = @{$self->{argv}}[1];
               my $appuri = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-uri",
                    id   => $appid,
                    uri  => $appuri
               };
          }

          when ("apps-set-name")
          {
               # apps-set-name takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid   = @{$self->{argv}}[1];
               my $appname = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-name",
                    id   => $appid,
                    name => $appname
               };
          }

          when ("apps-set-desc")
          {
               # apps-set-desc takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid   = @{$self->{argv}}[1];
               my $appdesc = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-desc",
                    id   => $appid,
                    desc => $appdesc
               };
          }

          when ("apps-set-logo")
          {
               # apps-set-logo takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid   = @{$self->{argv}}[1];
               my $applogo = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-logo",
                    id   => $appid,
                    logo => $applogo
               };
          }

          when ("apps-set-display")
          {
               # apps-set-display takes two parameters
               if ($self->{argc} < 3)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid  = @{$self->{argv}}[1];
               my $appdpy = @{$self->{argv}}[2];

               # define action
               $self->{action} =
               {
                    type => "apps-set-display",
                    id   => $appid,
                    dpy  => $appdpy
               };
          }

          when ("apps-get")
          {
               # apps-get takes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "apps-get",
                    id   => $appid
               };
          }

          when ("apps-rm")
          {
               # apps-rm takes one parameter
               if ($self->{argc} < 2)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               my $appid = @{$self->{argv}}[1];

               # define action
               $self->{action} =
               {
                    type => "apps-rm",
                    id   => $appid
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
          ## Variables

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

          when ("unset")
          {
               my $var = $self->{action}->{var};

               delete $self->{conf}->{$var};

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

          ## Macros

          when ("set-macro")
          {
               my $m_name = $self->{action}->{name};
               my $m_expr = $self->{action}->{expr};

               $self->{conf}->{macros}->{$m_name} = $m_expr;

               # Save configuration
               my $cfgNb = $self->saveConf ();

               # If there is no config identifier, then an error occured
               if (!$cfgNb)
               {
                    $self->setError ("$_: ".$ERRORS->{TOO_FEW_ARGUMENTS});
                    return 0;
               }

               print "Configuration $cfgNb created!\n";
          }

          when ("unset-macro")
          {
               my $m_name = $self->{action}->{name};

               delete $self->{conf}->{macros}->{$m_name};

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

          when ("get-macro")
          {
               my $m_name = $self->{action}->{name};

               print "$m_name = '", $self->{conf}->{macros}->{$m_name}, "'\n";
          }

          ## Applications

          when ("apps-set-cat")
          {
               my $catid   = $self->{action}->{id};
               my $catname = $self->{action}->{name};

               if (defined ($self->{conf}->{applicationList}->{$catid}))
               {
                    $self->{conf}->{applicationList}->{$catid}->{catname} = $catname;
               }
               else
               {
                    $self->{conf}->{applicationList}->{$catid} =
                    {
                         type    => "category",
                         catname => $catname
                    };
               }

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

          when ("apps-get-cat")
          {
               my $catid = $self->{action}->{id};

               print "$catid: ", $self->{conf}->{applicationList}->{$catid}->{name}, "\n";
          }

          when ("apps-add")
          {
               my $appid = $self->{action}->{appid};
               my $catid = $self->{action}->{catid};

               if (not defined ($self->{conf}->{applicationList}->{$catid}))
               {
                    $self->setError ("$_: ".$ERRORS->{CONFIG_WRITE_ERROR}.": Category '$catid' doesn't exist");
                    return 0;
               }

               if (defined ($self->{conf}->{applicationList}->{$catid}->{$appid}))
               {
                    $self->setError ("$_: ".$ERRORS->{CONFIG_WRITE_ERROR}.": Application '$appid' exists");
                    return 0;
               }

               $self->{conf}->{applicationList}->{$catid}->{$appid} =
               {
                    type => "application",
                    options =>
                    {
                         logo        => "demo.png",
                         name        => $appid,
                         description => $appid,
                         display     => "auto",
                         uri         => "http://test1.example.com"
                    }
               };

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

          when ("apps-set-uri")
          {
               my $appid  = $self->{action}->{id};
               my $appuri = $self->{action}->{uri};

               my $found = 0;
               while (my ($catid, $applist) = each %{$self->{conf}->{applicationList}} and $found != 1)
               {
                    while (my ($_appid, $app) = each %{$applist} and $found != 1)
                    {
                         if ($appid eq $_appid)
                         {
                              $app->{options}->{uri} = $appuri;
                              $found = 1;
                         }
                    }
               }

               if ($found == 0)
               {
                    $self->setError ("$_: ".$ERRORS->{CONFIG_WRITE_ERROR}.": Application '$appid' not found");
                    return 0;
               }

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

          when ("apps-set-name")
          {
               my $appid   = $self->{action}->{id};
               my $appname = $self->{action}->{name};

               my $found = 0;
               while (my ($catid, $applist) = each %{$self->{conf}->{applicationList}} and $found != 1)
               {
                    while (my ($_appid, $app) = each %{$applist} and $found != 1)
                    {
                         if ($appid eq $_appid)
                         {
                              $app->{options}->{name} = $appname;
                              $found = 1;
                         }
                    }
               }

               if ($found == 0)
               {
                    $self->setError ("$_: ".$ERRORS->{CONFIG_WRITE_ERROR}.": Application '$appid' not found");
                    return 0;
               }

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

          default
          {
               $self->setError ("$_: ".$ERRORS->{NOT_IMPLEMENTED});
               return 0;
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
