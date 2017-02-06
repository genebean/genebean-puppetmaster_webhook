# Does all the file configuration and setups up the needed gems
class puppetmaster_webhook::config (
  $manage_ruby     = $::puppetmaster_webhook::manage_ruby,
  $r10k_cmd        = $::puppetmaster_webhook::r10k_cmd,
  $repo_control    = $::puppetmaster_webhook::repo_control,
  $repo_hieradata  = $::puppetmaster_webhook::repo_hieradata,
  $repo_puppetfile = $::puppetmaster_webhook::repo_puppetfile,
  $slack_url       = $::puppetmaster_webhook::slack_url,
  $webhook_bind    = $::puppetmaster_webhook::webhook_bind,
  $webhook_group   = $::puppetmaster_webhook::webhook_group,
  $webhook_home    = $::puppetmaster_webhook::webhook_home,
  $webhook_owner   = $::puppetmaster_webhook::webhook_owner,
  $webhook_port    = $::puppetmaster_webhook::webhook_port,
) {
  $ruby_prefix = $::puppetmaster_webhook::params::ruby_prefix

  exec { 'create_webhook_homedir':
    command => "mkdir -p ${webhook_home}",
    path    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin',
    creates => $webhook_home,
  }

  exec { 'refresh_services':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
    notify      => Service['puppetmaster_webhook'],
  }

  exec { 'run_bundler':
    command     => "${ruby_prefix}bundle install --path vendor/bundle",
    cwd         => $webhook_home,
    refreshonly => true,
  }

  file { "${webhook_home}/config.ru":
    ensure  => present,
    owner   => $webhook_owner,
    group   => $webhook_group,
    mode    => '0755',
    source  => 'puppet:///modules/puppetmaster_webhook/config.ru',
    require => Exec['create_webhook_homedir'],
  }

  file { "${webhook_home}/webhook_config.json":
    ensure  => present,
    owner   => $webhook_owner,
    group   => $webhook_group,
    mode    => '0644',
    content => template('puppetmaster_webhook/webhook_config.json.erb'),
    require => Exec['create_webhook_homedir'],
    notify  => Service['puppetmaster_webhook'],
  }

  file { "${webhook_home}/Gemfile":
    ensure  => present,
    owner   => $webhook_owner,
    group   => $webhook_group,
    mode    => '0755',
    content => template('puppetmaster_webhook/Gemfile.erb'),
    notify  => Exec['run_bundler'],
    require => Exec['create_webhook_homedir'],
  }

  file { "${webhook_home}/log":
    ensure  => directory,
    owner   => $webhook_owner,
    group   => $webhook_group,
    mode    => '0755',
    require => Exec['create_webhook_homedir'],
  }

  file { "${webhook_home}/webhook.rb":
    ensure  => present,
    owner   => $webhook_owner,
    group   => $webhook_group,
    mode    => '0755',
    require => Exec['create_webhook_homedir'],
    source  => 'puppet:///modules/puppetmaster_webhook/webhook.rb',
    notify  => Service['puppetmaster_webhook'],
  }

  file { '/etc/systemd/system/puppetmaster_webhook.service':
    ensure  => present,
    mode    => '0775',
    content => template('puppetmaster_webhook/service.systemd.erb'),
    notify  => Exec['refresh_services'],
  }
}
