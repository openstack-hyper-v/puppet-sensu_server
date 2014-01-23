# == Class: sensu_server::ssl
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
#
class sensu_server::ssl {


  exec {'get-sensu-ca-scripts':
    command => '/usr/bin/wget -cv wget http://sensuapp.org/docs/0.12/tools/ssl_certs.tar -O - | tar -x',
    creates => '/tmp/ssl_certs',
    cwd     => '/tmp',
    notify => Exec['create-sensu-certs'],
  }

  file {'/tmp/ssl_certs':
    ensure => present,
    require => Exec['get-sensu-ca-scripts'],
  }


  exec {'create-sensu-certs':
    command     => '/tmp/ssl_certs/ssl_certs.sh generate',
    cwd         => '/tmp/ssl_certs',
    creates     => ['/tmp/ssl_certs/sensu_ca/cacert.pem',
                    '/tmp/ssl_certs/server/cert.pem',
                    '/tmp/ssl_certs/server/key.pem'],
    require     => [Exec['get-sensu-ca-scripts'],File['/tmp/ssl_certs']],
    logoutput   => true,
    unless      => '/usr/bin/file /tmp/ssl_certs/sensu_ca/cacert.pem',
    refreshonly => true,
  }
}
