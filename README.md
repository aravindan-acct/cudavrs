# vrs

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with vrs](#setup)
    * [What vrs affects](#what-vrs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vrs](#beginning-with-vrs)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module can be used to configure applications scans using the Barracuda Vulnerability Remediation Service. The service is normally used with a Barracuda Web Application Firewall but can be potentially used as an independent service. The domain / web application to be scanned should be DNS resolvable over the internet and the scan should be authorised by the domain administrator. More details can be found on [here](https://campus.barracuda.com/) in the "Barracuda Vulnerability Remediation Service" section.

## Setup
Create a file in /etc/puppetlabs/puppet/ path called credentials.json. The file is a json file in the following format:

```
{
"username":"waf admin username, ex. 'admin'",
"password":"password for waf login",
"host":"ip add of waf",
"port":"management port of the waf"
}
```
### What vrs affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For
example, folks can probably figure out that your mysql_instance module affects
their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you might want to include an additional "Upgrading" section
here.

### Beginning with vrs

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
