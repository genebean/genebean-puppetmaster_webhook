# Takes care of making sure RVM is installed and that Ruby 2.2.6 is available
class puppetmaster_webhook::install (
  $manage_ruby = $::puppetmaster_webhook::manage_ruby,
) {
  if $manage_ruby {
    include ::rvm

    rvm_system_ruby {'ruby-2.2.6':
      ensure => present
    }

    rvm_gem {'bundler':
      ruby_version => 'ruby-2.2.6',
      require      => Rvm_system_ruby['ruby-2.2.6']
    }
  }
}
