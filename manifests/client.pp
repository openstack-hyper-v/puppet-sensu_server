# == Class sensu_server::client
class sensu_server::client {
#file {'/etc/sensu/ssl/cacert.pem':
#    ensure  => present,
#    source  => 'puppet:///extra_files/sensu/cacert.pem',
#    require => File['/etc/sensu/ssl'],
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0644',
#  }
#  file {'/etc/sensu/ssl/cert.pem':
#    ensure  => present,
#    source  => 'puppet:///extra_files/sensu/cacert.pem',
#    require => File['/etc/sensu/ssl'],
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0644',
#  }
#  file {'/etc/sensu/ssl/key.pem':
#    ensure => present,
#    source  => 'puppet:///extra_files/sensu/cacert.pem',
#    require => File['/etc/sensu/ssl'],
#    owner   => 'sensu',
#    group   => 'sensu',
#    mode    => '0644',
#  }
class sensu_server::client {
  class{'sensu':
#    rabbitmq_password        => $sensu_client::rabbitmq_password,
#    rabbitmq_host            => "${sensu::rabbitmq_host}",
#    rabbitmq_ssl_cert_chain  => "${sensu::rabbitmq_ssl_cert_chain}",
#    rabbitmq_ssl_private_key => "${sensu::rabbitmq_ssl_private_key}",
    subscriptions            => $sensu::subscriptions,
#    dashboard                => $sensu::dashboard,
#    server                   => $sensu::server,
#    api                      => $sensu::api,
    rabbitmq_password        => 'sensu',
    rabbitmq_host            => '10.21.7.4',
    rabbitmq_ssl_cert_chain  => 'puppet:///extra_files/sensu/cert.pem',
    rabbitmq_ssl_private_key => 'puppet:///extra_files/sensu/key.pem',
#    subscriptions            => 'production',
    dashboard                => false,
    server                   => false,
    api                      => false,
#    safe_mode => true,
  }

}
