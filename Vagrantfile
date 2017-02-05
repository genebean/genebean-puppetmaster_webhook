# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'genebean/centos-7-puppet-agent'
  config.vm.synced_folder '.', '/vagrant'

  config.vm.provision 'shell', inline: 'yum -y install rsync'
  config.vm.provision 'shell', inline: 'puppet module install maestrodev-rvm --version 1.13.1'
  config.vm.provision 'shell', inline: 'puppet resource file /etc/puppetlabs/code/environments/production/modules/puppetmaster_webhook ensure=link target="/vagrant"'
  config.vm.provision 'shell', inline: 'puppet apply -e "include ::puppetmaster_webhook"'
  config.vm.provision 'shell', inline: "su - vagrant -c 'rvm use ruby-2.2.6; export PUP_MOD=puppetmaster_webhook; rsync -rv --delete /vagrant/ /home/vagrant/$PUP_MOD --exclude bundle; cd /home/vagrant/$PUP_MOD; bundle install --jobs=3 --retry=3 --path=${BUNDLE_PATH:-vendor/bundle}; bundle exec rake spec_prep'"

  config.vm.network "forwarded_port", guest: 8081, host: 8081
end

