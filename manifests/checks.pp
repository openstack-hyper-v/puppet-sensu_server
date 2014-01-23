# == Class: sensu_server::checks
#
# Full description of class sensu_server::checks here.
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
class sensu_server::checks {

  sensu::check { "linux-diskspace":
    command => '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/system/check-disk.rb',
    standalone => false,
    subscribers => 'production',
    handlers => ['default','irc'],
  }
  sensu::check { "jenkins-job-status":
    command => '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/jenkins/check-jenkins-job-status.rb',
    standalone => false,
    subscribers => 'production',
    handlers => ['default','irc'],
  }
  sensu::check { "windows-check-diskspace":
    command => '/etc/sensu/plugins/windows/check-disk-windows.rb',
    standalone => false,
    subscribers => 'hyper-v',
    handlers => ['default','irc'],
  }
  sensu::check { "windows-check-service":
    command => '/etc/sensu/plugins/windows/check-service-windows.rb',
    standalone => false,
    subscribers => 'hyper-v',
    handlers => ['default','irc'],
  }
  sensu::check { "windows-check-process":
    command => '/etc/sensu/plugins/windows/check-process.rb',
    standalone => false,
    subscribers => 'hyper-v',
    handlers => ['default','irc'],
  }
  sensu::check { "windows-check-cpu-load":
    command => '/etc/sensu/plugins/windows/cpu-load-windows.rb',
    standalone => false,
    subscribers => 'hyper-v',
    handlers => ['default','irc'],
  }
  sensu::check { "windows-check-ram-usage":
    command => '/etc/sensu/plugins/windows/ram-usage-windows.rb',
    standalone => false,
    subscribers => 'hyper-v',
    handlers => ['default','irc'],
  }
}
