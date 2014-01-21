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
class sensu_server {

  package {'curl':
    ensure => latest,
  }

  class {'rabbitmq':
    delete_guest_user => true,
    default_user => '',
    default_pass => '',
    ssl               => true,
    ssl_cacert        => '/etc/rabbitmq/ssl/cacert.pem',
    ssl_cert          => '/etc/rabbitmq/ssl/cert.pem',
    ssl_key           => '/etc/rabbitmq/ssl/key.pem',
  }

  rabbitmq_user{'sensu':
    admin => true,
    password => 'sensu',
  }
  rabbitmq_vhost{'sensu':
    ensure => present,
  }

  rabbitmq_user_permissions { 'sensu@sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  class {'redis':}

  exec {'get-sensu-ca-scripts':
    command => '/usr/bin/wget -cv wget http://sensuapp.org/docs/0.12/tools/ssl_certs.tar -O - | tar -x',
    creates => '/tmp/ssl_certs',
    cwd     => '/tmp',
  }
  file {'/tmp/ssl_certs':
    ensure => present,
    require => Exec['get-sensu-ca-scripts'],
  }


  exec {'create-sensu-certs':
    command => '/tmp/ssl_certs/ssl_certs.sh generate',
    cwd     => '/tmp/ssl_certs',
    require => [Exec['get-sensu-ca-scripts'],File['/tmp/ssl_certs']],
    logoutput => true,
    unless    => '/usr/bin/file /tmp/ssl_certs/sensu_ca/cacert.pem',
  }

  file {['/etc/rabbitmq/ssl/cacert.pem','/etc/sensu/ssl/cacert.pem']:
    ensure => present,
    source => '/tmp/ssl_certs/sensu_ca/cacert.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {['/etc/rabbitmq/ssl/cert.pem','/etc/sensu/ssl/cert.pem']:
    ensure => present,
    source => '/tmp/ssl_certs/server/cert.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {['/etc/rabbitmq/ssl/key.pem','/etc/sensu/ssl/key.pem']:
    ensure => present,
    source => '/tmp/ssl_certs/server/key.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }





  class{'sensu':
    rabbitmq_password => 'sensu',
    rabbitmq_host => $fqdn,
    rabbitmq_ssl_cert_chain => '/etc/sensu/ssl/cert.pem',
    rabbitmq_ssl_private_key => '/etc/sensu/ssl/key.pem',
    server    => true,
    dashboard => true,
    api       => true,
    client    => false,
#    safe_mode => true,
  }
}
node /sandbox0[1-3].*/{
  notify {"welcome ${fqdn}":}
  class{'dell_openmanage':}
  class{'dell_openmanage::firmware::update':}
}
