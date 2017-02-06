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
# *manage_ruby*
# If true this module will install RVM and use it to install Ruby 2.2.6.
# This does not interfere with Puppet's ruby or the system ruby.
# Defaults to true
#
# *r10_cmd*
# The full path to r10k
# Defaults to `/usr/bin/r10k`
#
# *repo_control*
# The name of the control repo
# Defaults to `control-repo`
#
# *repo_hieradata*
# The name of the repository where the 'hieradata' is stored.
#
# *repo_puppetfile*
# The name of the repository where the 'Puppetfile' is stored.
#
# *slack_url*
# The url provided during the setup of a custom webhook in Slack
#
# *webhook_bind*
# On which address should the webhook bind
# Defaults to `0.0.0.0`
#
# *webhook_group*
# The group of this service/script
# Defaults to `8081`
#
# *webhook_home*
# This is the directory where all stuff of this webhook is installed
# Defaults to `/opt/webhook`
#
# *webhook_owner*
# The owner of this service/script
# Defaults to `root`
#
# *webhook_port*
# On which port should the webhook listen
# Defaults to `root`
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
  $slack_url       = $::puppetmaster_webhook::params::slack_url,
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

