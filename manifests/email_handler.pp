# == Class: sensu_server::email_handler
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
class sensu_server::email_handler (
  $mail_from       = 'sensu@example.com',
  $mail_to         = 'monitor@example.com',
  $delivery_method = 'smtp',
  $smtp_address    = 'localhost',
  $smtp_port       = 25,
  $smtp_domain     = 'localhost.localdomain',
  $smtp_username   = undef,
  $smtp_password   = undef,
  $smtp_auth       = undef,
  $smtp_enable_tls = undef,
){

  sensu::handler{'mailer':
    type    => 'pipe',
    command => '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/community/handlers/notification/mailer.rb',
#    command => '/opt/sensu/embedded/bin/ruby /etc/sensu/handlers/notification/mailer.rb',
    require => File['/etc/sensu/conf.d/mailer-conf.json'],
  }

  file {'/etc/sensu/conf.d/mailer-conf.json':
    ensure  => file,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0644',
    content => template('sensu_server/mailer.json.erb'),
    require => Class['sensu_server::install'],
  }

  exec {'install-embedded-mail-gem':
    command   => '/opt/sensu/embedded/bin/gem install mail',
    unless    => '/opt/sensu/embedded/bin/gem list --local | /bin/grep -q mail',
    logoutput => true,
    require   => Class['sensu_server::install'],
  }

}
