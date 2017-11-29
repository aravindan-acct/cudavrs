class cudavrs::vrsconfig {

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

}
