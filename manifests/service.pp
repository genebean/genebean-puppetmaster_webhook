# Configures a service for the webhook receiver
class puppetmaster_webhook::service inherits puppetmaster_webhook {
  service { 'puppetmaster_webhook':
    ensure     => 'running',
    hasstatus  => true,
    enable     => true,
    hasrestart => true,
  }
}
