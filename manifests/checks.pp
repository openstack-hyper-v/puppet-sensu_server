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
class sensu_server::checks (
  $check_defaults = hiera('sensu_server::checks::check_defaults',{})
  $sensu_checks   = hiera('sensu_server::checks::sensu_checks',{})
){

#  Still need to handle this better for splitting linux and windows check definitions in hiera.
  #linux checks
  create_resources("sensu::check", $sensu_checks['linux'], $check_defaults['linux'])
  #windows checks
  create_resources("sensu::check", $sensu_checks['windows'], $check_defaults['windows'])

}
