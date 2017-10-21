# Class: puppetmaster_webhook
# ===========================
#
# This will install and configure a webhook for triggering r10k
#
# === Requirements
#
# r10k will need to be installed by some method other than this module. One
# good way to do so is to use the puppet/r10k module by Vox Pupuli. By default
# this module will assume you have installed r10k using the puppet_gem provider.
#
# === Parameters
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
# *slack_icon*
# The url to the icon you want to use for notifications in Slack
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
#    webhook_port => '8888',
#    repo_control => 'control-repo',
#    require      => Package['r10k'],
#  }
#
# === Authors
#
# Author Name: Gene Liverman gene@technicalissues.us
#
class puppetmaster_webhook (
  Stdlib::Absolutepath $puppet_agent_bin_dir,
  Stdlib::Absolutepath $r10k_cmd,
  String               $slack_icon,
  String               $webhook_bind,
  String               $webhook_group,
  Stdlib::Absolutepath $webhook_home,
  String               $webhook_owner,
  String               $webhook_port,
  Optional[String]     $slack_url,
  Optional[String]     $repo_control,
  Optional[String]     $repo_hieradata,
  Optional[String]     $repo_puppetfile,
) {
  $bundle_cmd = "${puppet_agent_bin_dir}/bundle"

  contain ::puppetmaster_webhook::install
  contain ::puppetmaster_webhook::config
  contain ::puppetmaster_webhook::service

  Class['::puppetmaster_webhook::install']
  -> Class['::puppetmaster_webhook::config']
  -> Class['::puppetmaster_webhook::service']
}
