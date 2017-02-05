class puppetmaster_webhook::service {
  service { 'puppetmaster_webhook':
    ensure     => running,
    hasstatus  => true,
    enable     => true,
    hasrestart => true,
  }
}
