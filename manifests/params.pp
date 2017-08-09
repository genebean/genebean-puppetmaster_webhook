# class: puppetmaster_webhook::params
#
# this class manages puppetmaster_webhook's parameters
class puppetmaster_webhook::params {
  $manage_ruby     = true

  if $manage_ruby {
    $ruby_prefix = '/usr/local/rvm/wrappers/ruby-2.2.6/'
    $r10k_cmd    = "${ruby_prefix}bundle exec r10k"
  } else {
    $ruby_prefix = undef
    $r10k_cmd    = '/usr/bin/r10k'
  }

  $repo_control    = 'control-repo'
  $repo_hieradata  = undef
  $repo_puppetfile = undef
  # lint:ignore:140chars
  $slack_icon      = 'https://raw.githubusercontent.com/genebean/genebean-puppetmaster_webhook/master/files/P-Icon-Amber-White-lg.jpg'
  # lint:endignore
  $slack_url       = undef
  $webhook_bind    = '0.0.0.0'
  $webhook_group   = 'root'
  $webhook_home    = '/opt/webhook'
  $webhook_owner   = 'root'
  $webhook_port    = '8081'
}
