# == Class: sensu_server::irc_handler
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
class sensu_server::irc_handler {

  sensu::handler{'irc':
    type       => 'pipe',
    command    => '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/community/handlers/notification/irc.rb',
    require    => File['/etc/sensu/conf.d/irc.json'],
    severities => ['critical'],
  }

  file {'/etc/sensu/conf.d/irc.json':
    ensure  => file,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0644',
    source  => 'puppet:///modules/sensu_server/irc.json',
    require => Class['sensu_server::install'],
  }
  exec {'install-sensu-plugin-from-embedded-gem':
    command   => '/opt/sensu/embedded/bin/gem install sensu-plugin',
    unless    => '/opt/sensu/embedded/bin/gem list --local sensu-plugin|/bin/grep -q sensu-plugin',
    logoutput => true,
    require   => Class['sensu_server::install'],
  }
  exec {'install-carrier-pigeon-from-embedded-gem':
    command   => '/opt/sensu/embedded/bin/gem install carrier-pigeon',
    unless    => '/opt/sensu/embedded/bin/gem list --local carrier-pigeon|/bin/grep -q carrier-pigeon',
    logoutput => true,
    timeout   => 0,
    require   => Class['sensu_server::install'],
  }
}
