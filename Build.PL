#!/usr/bin/perl -w

use Module::Build;
use strict;

my $build = Module::Build->new (
          module_name       => 'Lemonldap::NG::Cli',
          license           => 'perl',
          dist_author       => 'David Delassus <david.jose.delassus@gmail.com>',
          dist_version_from => 'lib/Lemonldap/NG/Cli.pm',

          requires => {
               'Config::IniFiles'            => 0,
               'Lemonldap::NG::Common::Conf' => '1.0',
          },
          conf_files => {
               'lemonldap-cli.ini' => 'conf/lemonldap-cli.ini',
          },
);

$build->install_path (conf => $build->prefix () . '/etc/lemonldap-ng/');
$build->add_build_element ("conf");
$build->create_build_script ();
