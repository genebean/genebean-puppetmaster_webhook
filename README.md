[![Puppet Forge][pf-img]][pf-link]
[![GitHub tag][gh-tag-img]][gh-link]

# puppetmaster_webhook

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with puppetmaster_webhook](#setup)
    * [What puppetmaster_webhook affects](#what-puppetmaster_webhook-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppetmaster_webhook](#beginning-with-puppetmaster_webhook)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures a Sinatra based webhook receiver designed to
trigger r10k

## Setup

### What puppetmaster_webhook affects **OPTIONAL**

By default this module will install RVM system-wide and uses it to install Ruby 2.2.6.

### Beginning with puppetmaster_webhook

By simply including this module you will end up with a webhook receiver listening
on all interfaces on port 8081. It assumes that you are using a control repo named
`control-repo`.

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

*r10_cmd*  
The full path to r10k  
Defaults to `/usr/bin/r10k`

*repo_control*  
The name of the control repo  
Defaults to `control-repo`

*repo_hieradata*  
The name of the repository where the 'hieradata' is stored.

*repo_puppetfile*  
The name of the repository where the 'Puppetfile' is stored.

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

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Pull requests are welcome. Testing is done against CentOS 7 using Puppet 4.
A Vagrantfile is included to aide in testing and development.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.


[gh-tag-img]: https://img.shields.io/github/tag/genebean/genebean-puppetmaster_webhook.svg
[gh-link]: https://github.com/genebean/genebean-puppetmaster_webhook
[pf-img]: https://img.shields.io/puppetforge/v/genebean/puppetmaster_webhook.svg
[pf-link]: https://forge.puppetlabs.com/genebean/puppetmaster_webhook
[travis-ci]: https://travis-ci.org/genebean/genebean-puppetmaster_webhook
[travis-img-master]: https://img.shields.io/travis/genebean/genebean-puppetmaster_webhook/master.svg
