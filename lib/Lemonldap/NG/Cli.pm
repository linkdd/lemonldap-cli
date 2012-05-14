package Lemonldap::NG::Cli;

our $VERSION = "0.1";

use Lemonldap::NG::Common::Conf;
use Config::IniFiles;

## @cmethod Lemonldap::NG::Cli new (hashRef args)
# Create a new Lemonldap::NG::Cli object
#
# @param $args Arguments to pass to the constructor
# @return New Lemonldap::NG::Cli object
sub new
{
     my ($class, $args) = @_;

     my $this = { "confpath": $args->{confpath} };

     if (!defined ($this->{confpath}))
     {
          $this->{confpath} = "/etc/lemonldap-ng/lemonldap-ng.ini";
     }

     $this->{ini} = Config::IniFiles->new (-file => $this->{confpath});

     bless ($this, $class);
     return $this;
}

## @method Lemonldap::NG::Common::Conf loadConf ()
# Read LemonLDAP::NG configuration in order to know where the manager store the
# runtime configuration (File, LDAP database, other DBI databases ?), and then
# use those informations to load that configuration.
#
# If confpath isn't defined, then the default value is assigned to it :
# /etc/lemonldap-ng/lemonldap-ng.ini
sub loadConf
{
     my ($self) = @_;

     my $conf =
     {
          "type" => $self->{ini}->val ("configuration", "type"),

          # $conf->{type} = "File"
          "dirName" => $self->{ini}->val ("configuration", "dirName"),

          # $conf->{type} = "RDBI" / "CDBI"
          "dbiChain"    => $self->{ini}->val ("configuration", "dbiChain"),
          "dbiUser"     => $self->{ini}->val ("configuration", "dbiUser"),
          "dbiPassword" => $self->{ini}->val ("configuration", "dbiPassword"),
          "dbiTable"    => "lmConfig",

          # $conf->{type} = "SOAP"
          "proxy"        => $self->{ini}->val ("configuration", "proxy");
          # The value of proxyOptions is a perl expression
          "proxyOptions" => eval $self->{ini}->val ("configuration", "proxyOptions"),

          # $conf->{type} = "LDAP"
          "ldapServer"       => $self->{ini}->val ("configuration", "ldapServer"),
          "ldapConfBranch"   => $self->{ini}->val ("configuration", "ldapConfBase"),
          "ldapBindDN"       => $self->{ini}->val ("configuration", "ldapBindDN"),
          "ldapBindPassword" => $self->{ini}->val ("configuration", "ldapBindPassword"),

          # Local cache configuration
          "localStorage"        => $self->{ini}->val ("configuration", "localStorage"),
          # The value of localStorageOptions is a perl expression
          "localStorageOptions" => eval $self->{ini}->val ("configuration", "localStorageoptions")
     };

     my $self->{confAccess} = new Lemomldap::NG::Common::Conf ($conf) or die "Unable to build Lemonldap::NG::Common::Conf";
}

## @method void parseCmd (array argv)
# Initialize the shell
#
# @param @argv List of arguments of the command line
# @return 
sub parseCmd
{
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
