# == Class: sensu_server
#
# Full description of class sensu_server here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { sensu_server:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class sensu_server::community_plugins {

  vcsrepo{'/opt/sensu-community-plugins':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/sensu/sensu-community-plugins',
    owner   => 'sensu',
    group   => 'sensu',
  }
#  file {'/etc/sensu/extensions':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/extensions',
#  }
#  file {'/etc/sensu/handlers/debug':
#    ensure  => absent,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/handlers/debug',
#    require => File['/etc/sensu/handlers'],
#  }
#  file {'/etc/sensu/handlers/metrics':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/handlers/metrics',
#    require => File['/etc/sensu/handlers'],
#  }
#  file {'/etc/sensu/handlers/notificiation':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/handlers/notification',
#    require => File['/etc/sensu/handlers'],
#  }
#  file {'/etc/sensu/handlers/other':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/handlers/other',
#    require => File['/etc/sensu/handlers'],
#  }
#  file {'/etc/sensu/handlers/remediation':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/handlers/remediation',
#    require => File['/etc/sensu/handlers'],
#  }
# 
#  file {'/etc/sensu/mutators':
#    ensure  => present,
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0755', 
#    recurse => true,
#    source  => '/opt/sensu-community-plugins/mutators',
#    require => File['/etc/sensu/handlers'],
#  }

  exec {'copy-community-plugins-to-etc-sensu':
    command   => '/usr/bin/rsync -av /opt/sensu-community-plugins/plugins/ /etc/sensu/plugins/',
    logoutput => true,
    user      => 'sensu',
    group     => 'sensu',
    require => Vcsrepo['/opt/sensu-community-plugins'],
  }
}
