# Takes care of making sure RVM is installed and that Ruby 2.2.6 is available
class puppetmaster_webhook::install inherits puppetmaster_webhook {
  package { 'bundler':
    ensure   => present,
    provider => 'puppet_gem',
  }
}
