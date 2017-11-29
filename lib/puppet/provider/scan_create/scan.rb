require "net/http"
require "net/https"
require "uri"
require "json"
require "base64"

# Puppet provider definition
	Puppet::Type.type(:scan_create).provide(:scan) do

  		desc "Create a scan on VRS"

		Puppet.debug("Creating a scan on VRS ")

		mk_resource_methods
		def basic
			creds = `cat /etc/puppetlabs/puppet/credentials.json`
	        	creds_json = JSON.parse(creds)
			Puppet.info (creds_json)
	        	pw = creds_json ["password"]
                	waf_ip = creds_json ["host"]
	        	login_token = `curl http://#{waf_ip}:8000/restapi/v3/login -X POST -H 'Content-Type: application/json' -d '{"username":"admin", "password":"#{pw}"}'`
        		response_json = JSON.parse (login_token)
	        	waf_login = response_json ["token"]
        		waf_serial_number = `curl http://#{waf_ip}:8000/restapi/v3/system -u '#{waf_login}:'`
			uri = ["wafs"]
			vrs = "https://vrs.barracudanetworks.com/api/v1"
			user = `cat /etc/puppetlabs/puppet/bcc_credentials`
			userjson = JSON.parse(user)
			basic_auth_user = userjson ["username"]
			basic_auth_pass = userjson ["password"]
			puts "#{basic_auth_user}"
			http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			#step1 : Authenticate and fetch services
			Puppet.info("Inside basic method")
			parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/wafs")
			path = parsed_uri.path
			puts "#{path}"
			puts "testing #{parsed_uri}"
			request = Net::HTTP::Get.new(parsed_uri.path)
			request.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
			response = http.request(request)
			output = response.body
			services = JSON.parse (output)
			services_json = services ["id"]
			return basic_auth_user, basic_auth_pass
		end  
		# Checks the ensurable property
		  def exists?
		Puppet.debug("Calling exists method ")
		    @property_hash[:ensure] == :present
		    name=@resource[:name]	           
			basic_auth_user, basic_auth_pass=basic
		Puppet.info ("111111 #{basic_auth_user}, #{basic_auth_pass}")	
		#Get the existing list of web apps
				http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
                		http.use_ssl = true
		                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/wafs")
				request = Net::HTTP::Get.new(parsed_uri.path)
				request.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
				response = http.request(request)
				output = response.body
				services = JSON.parse (output)  
		end

	  def self.instances
	    Puppet.debug("Callling self.instances method")
	    instances = []
	    return instances
	  end

	  def self.prefetch(resources)
	    Puppet.debug("Calling self.prefetch method: ")
	  end

	  def create
	    Puppet.debug("Calling create method:")
		#steps = 3 setup scan
		http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
	        http.use_ssl = true
        	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		basic_auth_user, basic_auth_pass = basic
		parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/scan_create")
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
