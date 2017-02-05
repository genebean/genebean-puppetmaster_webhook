# Class: puppetmaster_webhook
# ===========================
#
# This will install and configure a webhook for triggering r10k
#
# === Requirements
#
# No requirements.
#
# === Parameters
#
# [*r10_cmd*]
# The full path to r10k
# Defaults to '/usr/bin/r10k'
#
# [*repo_control*]
# The name of the control repo
#
# [*repo_hieradata*]
# The name of the repository where the 'hieradata'
# is stored.
#
# [*repo_puppetfile*]
# The name of the repository where the 'Puppetfile'
# is stored.
#
# [*webhook_bind*]
# On which address should the webhook bind
#
# [*webhook_group*]
# The group of this service/script
#
# [*webhook_home*]
# This is the directory where all stuff of
# this webhook is installed
#
# [*webhook_owner*]
# The owner of this service/script
#
# [*webhook_port*]
# On which port should the webhook listen
#
# === Example
#
#  class { 'puppetmaster_webhook':
#    manage_ruby  => false,
#    webhook_port => '8888',
#    repo_control => 'control-repo',
#    require      => Package['ruby'],
#  }
#
# === Authors
#
# Author Name: Gene Liverman gene@technicalissues.us
#
class puppetmaster_webhook (
  $manage_ruby     = $::puppetmaster_webhook::params::manage_ruby,
  $r10k_cmd        = $::puppetmaster_webhook::params::r10k_cmd,
  $repo_control    = $::puppetmaster_webhook::params::repo_control,
  $repo_hieradata  = $::puppetmaster_webhook::params::repo_hieradata,
  $repo_puppetfile = $::puppetmaster_webhook::params::repo_puppetfile,
  $webhook_bind    = $::puppetmaster_webhook::params::webhook_bind,
  $webhook_group   = $::puppetmaster_webhook::params::webhook_group,
  $webhook_home    = $::puppetmaster_webhook::params::webhook_home,
  $webhook_owner   = $::puppetmaster_webhook::params::webhook_owner,
  $webhook_port    = $::puppetmaster_webhook::params::webhook_port,
) inherits puppetmaster_webhook::params {
  contain ::puppetmaster_webhook::install
  contain ::puppetmaster_webhook::config
  contain ::puppetmaster_webhook::service

  Class['::puppetmaster_webhook::install'] ->
  Class['::puppetmaster_webhook::config'] ->
  Class['::puppetmaster_webhook::service']
}

