package Lemonldap::NG::Cli;

our $VERSION = "0.1";

use Lemonldap::NG::Common::Conf;
use Config::IniFiles;

## @method Lemonldap::NG::Common::Conf loadConf (string confpath)
# Read LemonLDAP::NG configuration in order to know where the manager store the
# runtime configuration (File, LDAP database, other DBI databases ?), and then
# use those informations to load that configuration.
#
# If confpath isn't defined, then the default value is assigned to it :
# /etc/lemonldap-ng/lemonldap-ng.ini
#
# @param $confpath Optional, path to the LemonLDAP::NG configuration.
# @return New Lemonldap::NG::Common::Conf object
sub loadConf
{
     my ($self, $confpath) = @_;

     if (!defined ($confpath))
     {
          $confpath = "/etc/lemonldap-ng/lemonldap-ng.ini";
     }

     my $ini = Config::IniFiles->new (-file => $confpath);

     my $conf =
     {
          "type" => $ini->val ("configuration", "type"),

          # $conf->{type} = "File"
          "dirName" => $ini->val ("configuration", "dirName"),

          # $conf->{type} = "RDBI" / "CDBI"
          "dbiChain"    => $ini->val ("configuration", "dbiChain"),
          "dbiUser"     => $ini->val ("configuration", "dbiUser"),
          "dbiPassword" => $ini->val ("configuration", "dbiPassword"),
          "dbiTable"    => "lmConfig",

          # $conf->{type} = "SOAP"
          "proxy"        => $ini->val ("configuration", "proxy");
          # The value of proxyOptions is a perl expression
          "proxyOptions" => eval $ini->val ("configuration", "proxyOptions"),

          # $conf->{type} = "LDAP"
          "ldapServer"       => $ini->val ("configuration", "ldapServer"),
          "ldapConfBranch"   => $ini->val ("configuration", "ldapConfBase"),
          "ldapBindDN"       => $ini->val ("configuration", "ldapBindDN"),
          "ldapBindPassword" => $ini->val ("configuration", "ldapBindPassword"),

          # Local cache configuration
          "localStorage"        => $ini->val ("configuration", "localStorage"),
          # The value of localStorageOptions is a perl expression
          "localStorageOptions" => eval $ini->val ("configuration", "localStorageoptions")
     };

     my $confAccess = new Lemomldap::NG::Common::Conf ($conf) or die "Unable to build Lemonldap::NG::Common::Conf";
     return $confAccess;
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
