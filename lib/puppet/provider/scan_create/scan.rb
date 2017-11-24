require "net/http"
require "net/https"
require "uri"
require "json"
require "base64"

# Puppet provider definition
	Puppet::Type.type(:scan_create).provide :scan do

  		desc "Create a scan on VRS"

		Puppet.debug("Creating a scan on VRS ")

		mk_resource_methods
		def basic
		uri = ["wafs"]
		vrs = "https://vrs.barracudanetworks.com/api/v1"
		user = `cat /etc/puppetlabs/puppet/bcc_credentials`
		userjson = JSON.parse(user)
		basic_auth_user = userjson ["username"]
		basic_auth_pass = userjson ["password"]
		http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		#step1 : Authenticate and fetch services
		parsed_uri = URI.parse("#{vrs}/#{uri[0]}")
		web_create = Net::HTTP::Get.new(parsed_uri.path)
		web_create.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
		response = http.request(web_create)
		output = response.body
		services = JSON.parse (output)
		services_json = services ["id"]
		end
		  # Checks the ensurable property
		  def exists?
		    Puppet.debug("Calling exists method ")
		    @property_hash[:ensure] == :present
				basic
				parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/webapp")
				web_create = Net::HTTP::Get.new(parsed_uri.path)
				web_create.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
				response = http.request(web_create)
				output = response.body
				services = JSON.parse (output)
		  end

	  self.instances
	    Puppet.debug("Callling self.instances method")
	    instances = []
	    return instances
	  end

	  def self.prefetch(resources)
	    Puppet.debug("Calling self.prefetch method: ")
    		cloudobj = instances
	    resources.keys.each do |state|
	      if provider = cloudobj.find { |cloud| cloud.state == state}
       		 resources[state].provider=provider
	      end
	    end
	  end

	  def create
	    Puppet.debug("Calling create method:")
			#steps = 3 setup scan
			parsed_uri = URI.parse("#{vrs}/#{uri[2]}")
			request = Net::HTTP::Post.new(parsed_uri.path)
			request.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
			request.set_form_data({
		'name' => 'testscan',
		'max_requests_per_second' => '20',
		'scan_time_limit_hours' => '9',
		'crawl_max_depth' => '2',
		'browser_type' => 'Firefox',
		'user_agent' => 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0',
		'evasion_techniques' => 'False',
		#'auth_type' => '2',
		#'auth_html_form_username_parameter' => 'username_param',
		#'auth_html_username' => 'username',
		#'auth_html_form_password_parameter' => 'password_param',
		#'auth_html_password' => 'password',
		#'auth_html_form_test_url' => 'http://staging.selahcloud.in:8888/welcome/',
		#'auth_html_form_test_value' => 'test_value',
		#'auth_login_form_url' => 'http://staging.selahcloud.in:8888/login/',
		'excluded_address_list' => ["host1", "host2"],
		'excluded_url_list' => ["*/patt1/*", "*patt2*"],
		'excluded_file_ext_list' => ["ext1", "ext2"],
		'webapp_id' => "#{id_chomped}",
		'waf_bypass' =>'False',
		'recurrence' => 'manual'}, ';')
	response = http.request(request)
			 output = response.body
	puts "#{output}"
   	 @property_hash.clear
  	end
end
