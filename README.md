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

Barracuda VRS makes configuration changes on the WAF automatically mitigate vulnerabilities identified during the scan.

Typically, the VRS will do the following changes:
* The existing security policy is turned to active or a new security policy is created and turned to active.
* Scanner IP addresses are whitelisted through the WAF's Trusted Hosts configuration.

The above mentioned configuration changes are done if the options are configured in the manifests.

### Setup Requirements **OPTIONAL**

i. VRS Credentials: Its important to maintain the credentials in a file called bcc_credentials in /etc/puppetlabs/puppet/ path. The file format should be in the following format:

```
{
"username":"vrs account name",
"password":"vrs account password"
}
```
ii. WAF Credentials: The provider checks the WAF serial number through a REST API call for which we have to maintain the credentials in a file called credentials.json in /etc/puppetlabs/puppet/ path. The format of the file and the required keys are mentioned in the setup section above.


### Beginning with vrs

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

Creating a web application container in the VRS:

``` puppet
webapp_create{"test":
		ensure => present,
 		url => 'test.blorpazort.com',
    		name => 'blorpazort',
    		waf_serial => '777942',  # WAF QA
    		waf_service => 'AutomationVS',
    		waf_policy_name => 'default',
    		verify_method => 'email',
    		verification_email => 'test@blorpazort.com',
    		notification_emails => 'dsavelski@blorpazort.com'
	}

```
Creating a scan for web application created in the VRS:

``` puppet
scan_create {"testing":
		ensure => present,
		name => 'testscan',
    		max_requests_per_second => '20',
    		scan_time_limit_hours => '9',
    		crawl_max_depth => '2',
    		browser_type => 'Firefox',
    		user_agent => 'Mozilla/5.0 (Windows NT 6.3; rv=>36.0) Gecko/20100101 Firefox/36.0',
    		evasion_techniques => 'False',
    		auth_type => 2,  # form
    		auth_html_form_username_parameter => 'username_param',
    		auth_html_username => 'username',
    		auth_html_form_password_parameter => 'password_param',
    		auth_html_password => 'password',
    		auth_html_form_test_url => 'http=>//test.blorpazort.com/welcome/',
    		auth_html_form_test_value => 'test_value',
    		auth_login_form_url => 'http=>//test.blorpazort.com/login/',
    		excluded_address_list => '["host1", "host2"]',  # excluded_address_list
    		excluded_url_list => '["*/patt1/*", "*patt2*"]',  # excluded_url_list
    		excluded_file_ext_list => '["ext1", "ext2"]',  # excluded_file_ext_list
    		webapp_id => 'webapp_id',
    		waf_bypass => 'False',
    		recurrence => 'manual'
	}

```
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
