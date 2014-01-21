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
    rabbitmq_host            => $fqdn,
    rabbitmq_ssl_cert_chain  => '/etc/sensu/ssl/cert.pem',
    rabbitmq_ssl_private_key => '/etc/sensu/ssl/key.pem',
    server                   => true,
    dashboard                => true,
    api                      => true,
    client                   => false,
#    safe_mode => true,
    require                  => [
      Class['sensu_server::community_plugins'],
      Service['rabbitmq-server','redis-server'],
      Exec['create-sensu-certs']],
  }
}
