Puppet::Type.newtype(:scan_create) do
    @doc = "Creates a scan"

    ensurable

    newparam(:name, :namevar => true) do
    desc "Name"
    validate do |value|
      fail("Invalid name #{value}, Illegal characters present") unless value =~ /^[a-zA-Z][a-zA-Z0-9\._:\-]*$/
    end
    end

    newproperty(:max_requests_per_second) do
      desc "Maximum requests to be sent to the web app by the scanner in a second"
    end 
    
    newproperty(:auth_type) do
      desc "Authentication type"
    end

    newproperty(:evasion_techniques) do
	desc "Evasion Techniques to be used during crawling"
	end
    newproperty(:user_agent) do
	desc "the user agent for the scan requests"
    end

    newproperty(:browser_type) do
      desc "Browser type to be used"
    end

    newproperty(:scan_time_limit_hours) do
      desc "Sets the scan limit"
    end

    newproperty(:auth_html_username) do
      desc "User name for authenticating to the application"
    end 

    newproperty(:auth_html_form_password_parameter) do
      desc "Parameter name for the password field"
    end 

    newproperty(:crawl_max_depth) do
      desc "Sets the max depth for crawler"
    end

    newproperty(:auth_html_password) do
      desc "Password for authenticating to the application"
    end    
    newproperty(:auth_html_form_test_url) do
      desc "Test URL"
    end 

    newparam(:auth_html_form_test_value) do
      desc "Test value"
    end 
    newproperty(:auth_html_form_username_parameter) do
      desc "Username parameter"
    end

    newparam(:auth_login_form_url) do
      desc "Auth login form URL"
    end 

    newproperty(:webapp_id) do
      desc "Web Application ID"
    end 

    newproperty(:waf_bypass) do
      desc "Whether to bypass the WAF for scanning the application"
    end 
    newproperty(:recurrence) do
      desc "Run the scan manually or schedule automated scans"
    end
    newproperty(:excluded_address_list) do
      desc "Addresses to be excluded"
    end
    newproperty(:excluded_url_list) do
      desc "URL lists to be excluded"
    end
    newproperty(:excluded_file_ext_list) do
      desc "List of the files to be excluded from scanning"
    end
end
