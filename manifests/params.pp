# class: puppetmaster_webhook::params
#
# this class manages puppetmaster_webhook's parameters
class puppetmaster_webhook::params {
  $manage_ruby     = true
  $r10k_cmd        = '/usr/bin/r10k'
  $repo_control    = undef
  $repo_hieradata  = undef
  $repo_puppetfile = undef
  $slack_url       = undef
  $webhook_bind    = '0.0.0.0'
  $webhook_group   = 'root'
  $webhook_home    = '/opt/webhook'
  $webhook_owner   = 'root'
  $webhook_port    = '8081'
}
