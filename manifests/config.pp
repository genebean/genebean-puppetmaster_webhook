# Does all the file configuration and setups up the needed gems
class puppetmaster_webhook::config inherits puppetmaster_webhook {
  exec {
    default:
      path => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin',
    ;
    'create_webhook_homedir':
      command => "mkdir -p ${puppetmaster_webhook::webhook_home}",
      creates => $puppetmaster_webhook::webhook_home,
    ;
    'refresh_services':
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      notify      => Service['puppetmaster_webhook'],
    ;
    'run_bundler':
      command     => "${puppetmaster_webhook::bundle_cmd} install --path vendor/bundle",
      cwd         => $puppetmaster_webhook::webhook_home,
      refreshonly => true,
    ;
  }

  file {
    default:
      ensure => 'file',
      owner  => $puppetmaster_webhook::webhook_owner,
      group  => $puppetmaster_webhook::webhook_group,
      mode   => '0755',
    ;
    "${puppetmaster_webhook::webhook_home}/config.ru":
      source  => 'puppet:///modules/puppetmaster_webhook/config.ru',
      require => Exec['create_webhook_homedir'],
    ;
    "${puppetmaster_webhook::webhook_home}/webhook_config.json":
      mode    => '0644',
      content => epp('puppetmaster_webhook/webhook_config.json.epp'),
      require => Exec['create_webhook_homedir'],
      notify  => Service['puppetmaster_webhook'],
    ;
    "${puppetmaster_webhook::webhook_home}/Gemfile":
      source  => 'puppet:///modules/puppetmaster_webhook/Gemfile',
      notify  => Exec['run_bundler'],
      require => Exec['create_webhook_homedir'],
    ;
    "${puppetmaster_webhook::webhook_home}/log":
      ensure  => 'directory',
      require => Exec['create_webhook_homedir'],
    ;
    "${puppetmaster_webhook::webhook_home}/webhook.rb":
      require => Exec['create_webhook_homedir'],
      source  => 'puppet:///modules/puppetmaster_webhook/webhook.rb',
      notify  => Service['puppetmaster_webhook'],
    ;
    '/etc/systemd/system/puppetmaster_webhook.service':
      content => epp('puppetmaster_webhook/service.systemd.epp'),
      notify  => Exec['refresh_services'],
  }
}
