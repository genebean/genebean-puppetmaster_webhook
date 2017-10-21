[![Build Status][travis-img-master]][travis-ci]
[![Puppet Forge][pf-img]][pf-link]
[![GitHub tag][gh-tag-img]][gh-link]

# puppetmaster_webhook

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
    * [What puppetmaster_webhook affects](#what-puppetmaster_webhook-affects)
    * [No more RVM](#no-more-rvm)
    * [Beginning with puppetmaster_webhook](#beginning-with-puppetmaster_webhook)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Troubleshooting](#troubleshooting)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures a Sinatra based webhook receiver designed to
trigger r10k. If you choose, you can also have messages from this receiver sent to
a Slack channel.

## Setup

### What puppetmaster_webhook affects

This module installs the bundler gem in the Pupppet agent's ruby environment. It
then uses the Puppet agent's ruby and this version of bundler to install and run
the webhook receiver.

### No more RVM

Versions of this module before 1.0.0 used RVM to manage ruby. This has been done
away with in favor of using the one shipped with the Puppet agent. See the
troubleshooting section below for upgrade tips.

### Beginning with puppetmaster_webhook

By simply including this module you will end up with a webhook receiver listening
on all interfaces on port 8081. It assumes that you are using a control repo named
`control-repo`.

## Usage

```puppet
# Use the defaults:
incldue ::puppetmaster_webhook
```

```puppet
class { '::puppetmaster_webhook':
  webhook_port => '8888',
  repo_control => 'control-repo',
  slack_url    => 'https://hooks.slack.com/services/YOUR-URL/GOES-HERE',
}
```

## Reference

*puppet_agent_bin_dir*  
This is the absolute path to Puppet's bin directory  
Defaults to `/opt/puppetlabs/puppet/bin`

*r10_cmd*  
The absolute path to r10k. The assumption is that you have installed it with the
`puppet_gem` provider like is done by the
[puppet/r10k](https://forge.puppet.com/puppet/r10k) module.  
Defaults to `/opt/puppetlabs/puppet/bin/r10k`

*repo_control*  
The name of the control repo  
Defaults to `control-repo`

*repo_hieradata*  
The name of the repository where the 'hieradata' is stored.

*repo_puppetfile*  
The name of the repository where the 'Puppetfile' is stored.

*slack_icon*
The url to the icon you want to use for notifications in Slack  
Defaults to the GitHub url of an icon in this modules.

*slack_url*
The url provided during the setup of a custom webhook in Slack

*webhook_bind*  
On which address should the webhook bind  
Defaults to `0.0.0.0`

*webhook_group*  
The group of this service/script  
Defaults to `root`

*webhook_home*  
This is the directory where all parts of this webhook are installed  
Defaults to `/opt/webhook`

*webhook_owner*  
The owner of this service/script  
Defaults to `root`

*webhook_port*  
On which port should the webhook listen  
Defaults to `8081`


## Troubleshooting

If you find that you are getting errors after having used this module for a
while the most likely issue is a change in something related to Ruby. To have
the module clean things up for you I recommend running the following commands
as root:

```bash
cd /opt/webhook
rm -rf /opt/webhook/vendor
/opt/puppetlabs/puppet/bin/bundle install --path /opt/webhook/vendor/bundle
```

This will reinstall all gems by the webhook. If while doing the above you get an
error about the command not being found then run Puppet and it will reinstall
bundler for you using the `puppet_gem` provider.

If you run into other error then please file a ticket on this module's GitHub
page.


## Limitations

This module has been tested on CentOS 7 and should work fine on anything in
the Red Hat family that uses `systemd`. In theory it should work on other
distributions that also use `systemd` but testing has not been done.


## Development

Pull requests are welcome. Testing is done against CentOS 7 using Puppet 5.
A Vagrantfile is included to aide in testing and development.


[gh-tag-img]: https://img.shields.io/github/tag/genebean/genebean-puppetmaster_webhook.svg
[gh-link]: https://github.com/genebean/genebean-puppetmaster_webhook
[pf-img]: https://img.shields.io/puppetforge/v/genebean/puppetmaster_webhook.svg
[pf-link]: https://forge.puppetlabs.com/genebean/puppetmaster_webhook
[travis-ci]: https://travis-ci.org/genebean/genebean-puppetmaster_webhook
[travis-img-master]: https://img.shields.io/travis/genebean/genebean-puppetmaster_webhook/master.svg
