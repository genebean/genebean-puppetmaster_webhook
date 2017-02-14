[![Build Status][travis-img-master]][travis-ci]
[![Puppet Forge][pf-img]][pf-link]
[![GitHub tag][gh-tag-img]][gh-link]

# puppetmaster_webhook

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
    * [What puppetmaster_webhook affects](#what-puppetmaster_webhook-affects)
    * [Beginning with puppetmaster_webhook](#beginning-with-puppetmaster_webhook)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures a Sinatra based webhook receiver designed to
trigger r10k. If you choose, you can also have messages from this receiver sent to
a Slack channel.

## Setup

### What puppetmaster_webhook affects

By default this module will install RVM system-wide and uses it to install Ruby 2.2.6.

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

*manage_ruby*  
If true this module will install RVM and use it to install Ruby 2.2.6.
This does not interfere with Puppet's ruby or the system ruby.  
Defaults to true

*r10_cmd*  
The full path to r10k  
Defaults to `/usr/local/rvm/wrappers/ruby-2.2.6/bundle exec r10k` if `manage_ruby` is true  
Defaults to `/usr/bin/r10k` if `manage_ruby` is false

*repo_control*  
The name of the control repo  
Defaults to `control-repo`

*repo_hieradata*  
The name of the repository where the 'hieradata' is stored.

*repo_puppetfile*  
The name of the repository where the 'Puppetfile' is stored.

*slack_url*
The url provided during the setup of a custom webhook in Slack

*webhook_bind*  
On which address should the webhook bind  
Defaults to `0.0.0.0`

*webhook_group*  
The group of this service/script  
Defaults to `8081`

*webhook_home*  
This is the directory where all stuff of this webhook is installed  
Defaults to `/opt/webhook`

*webhook_owner*  
The owner of this service/script  
Defaults to `root`

*webhook_port*  
On which port should the webhook listen  
Defaults to `root`


## Limitations

This module has been tested on CentOS 7 and should work fine on anything in
the Red Hat family that uses `systemd`. In theory it should work on other
distributions that also use `systemd` but testing has not been done.


## Development

Pull requests are welcome. Testing is done against CentOS 7 using Puppet 4.
A Vagrantfile is included to aide in testing and development.


[gh-tag-img]: https://img.shields.io/github/tag/genebean/genebean-puppetmaster_webhook.svg
[gh-link]: https://github.com/genebean/genebean-puppetmaster_webhook
[pf-img]: https://img.shields.io/puppetforge/v/genebean/puppetmaster_webhook.svg
[pf-link]: https://forge.puppetlabs.com/genebean/puppetmaster_webhook
[travis-ci]: https://travis-ci.org/genebean/genebean-puppetmaster_webhook
[travis-img-master]: https://img.shields.io/travis/genebean/genebean-puppetmaster_webhook/master.svg
