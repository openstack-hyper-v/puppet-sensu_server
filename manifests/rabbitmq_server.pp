# == Class: sensu_server::rabbitmq
#
# === Parameters
#
# === Variables
#
# === Authors
#
class sensu_server::rabbitmq_server {

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


  file {'/etc/rabbitmq/ssl/cacert.pem':
    ensure => present,
    source => '/tmp/ssl_certs/sensu_ca/cacert.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {'/etc/rabbitmq/ssl/cert.pem':
    ensure => present,
    source => '/tmp/ssl_certs/server/cert.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
  file {'/etc/rabbitmq/ssl/key.pem':
    ensure => present,
    source => '/tmp/ssl_certs/server/key.pem',
    require => [File['/etc/rabbitmq/ssl'],Exec['create-sensu-certs']],
    owner => 'sensu',
    group => 'sensu',
    mode  => '0644',
  }
}
