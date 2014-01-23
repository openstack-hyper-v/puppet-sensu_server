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
class sensu_server::install {

  package {'curl':
    ensure => latest,
  }
  file {'/etc/sensu/ssl/cacert.pem':
    ensure => present,
    source => '/tmp/ssl_certs/sensu_ca/cacert.pem',
    require => [
      File['/etc/sensu/ssl'],
      Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {'/etc/sensu/ssl/cert.pem':
    ensure => present,
    source => '/tmp/ssl_certs/server/cert.pem',
    require => [
      File['/etc/sensu/ssl'],
      Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {'/etc/sensu/ssl/key.pem':
    ensure => present,
    source => '/tmp/ssl_certs/server/key.pem',
    require => [
      File['/etc/sensu/ssl'],
      Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }

  class{'sensu':
    rabbitmq_password        => 'sensu',
    rabbitmq_host            => $ipaddress,
    rabbitmq_ssl_cert_chain  => '/etc/sensu/ssl/cert.pem',
    rabbitmq_ssl_private_key => '/etc/sensu/ssl/key.pem',
    server                   => true,
    dashboard                => true,
    api                      => true,
    subscriptions            => 'linux-diskspace',
#    client                   => false,
    safe_mode => true,
    require                  => File['/etc/rabbitmq/ssl/cacert.pem',
                                      '/etc/rabbitmq/ssl/cert.pem',
                                      '/etc/rabbitmq/ssl/key.pem'],
  }
  sensu::handler { 'default':
    command => 'mail -s \'sensu alert\' ppouliot@microsoft.com',
  }

  sensu::check { "linux-diskspace":
    command => '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/system/check-disk.rb',
    standalone => false,
    handlers => 'default',
  }
  sensu::check { "windows-check-diskspace":
    command => '/etc/sensu/plugins/windows/check-disk-windows.rb',
    standalone => false,
    handlers => 'default',
  }
  sensu::check { "windows-check-service":
    command => '/etc/sensu/plugins/windows/check-service-windows.rb',
    standalone => false,
    handlers => 'default',
  }
  sensu::check { "windows-check-process":
    command => '/etc/sensu/plugins/windows/check-process.rb',
    standalone => false,
    handlers => 'default',
  }
  sensu::check { "windows-check-cpu-load":
    command => '/etc/sensu/plugins/windows/cpu-load-windows.rb',
    standalone => false,
    handlers => 'default',
  }
  sensu::check { "windows-check-ram-usage":
    command => '/etc/sensu/plugins/windows/ram-usage-windows.rb',
    standalone => false,
    handlers => 'default',
  }

  sensu::handler{'irc':
    type => 'pipe',
    command => '/etc/sensu/handlers/notification/irc.rb',
    require => File['/etc/sensu/irc.json'],
  }

  file {'/etc/sensu/irc.json':
    ensure => file,
    owner  => 'sensu',
    group  => 'sensu',
    mode   => '0644',
    source => 'puppet:///modules/sensu_server/irc.json',
  }
  exec {'install-sensu-plugin-from-embedded-gem':
    command   => '/opt/sensu/embedded/bin/gem install sensu-plugin',
    unless    => '/opt/sensu/embedded/bin/gem list --local sensu-plugin|/bin/grep -q sensu-plugin',
    logoutput => true,
    require   => Class['sensu'],
  }
  exec {'install-carrier-pigeon-from-embedded-gem':
    command   => '/opt/sensu/embedded/bin/gem install carrier-pigeon',
    unless    => '/opt/sensu/embedded/bin/gem list --local carrier-pigeon|/bin/grep -q carrier-pigeon',
    logoutput => true,
    timeout   => 0,
    require   => Class['sensu'],
  }


}
