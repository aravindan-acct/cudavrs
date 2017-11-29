require "net/http"
require "net/https"
require "uri"
require "json"
require "base64"

# Puppet provider definition
	Puppet::Type.type(:webapp_create).provide(:scan) do

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
	    Puppet.debug("Calling self.instances method")
			instances = []
	    return instances
	  end

	  def self.prefetch(resources)
	    Puppet.debug("Calling self.prefetch method: ")
	    end

	  def create
	    Puppet.debug("Calling create method:")
			basic_auth_user, basic_auth_pass = basic
			#step2 : create the web app configuration to set up scans
			http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
	                http.use_ssl = true
        	        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/create_webapp")
			request = Net::HTTP::Post.new(parsed_uri.path)
			request.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
			request.set_form_data({'url' => 'http://staging.selahcloud.in:80/',
			    'name' => 'selahcloudstaging',
			    'waf_serial' => "'#{waf_serial_number}'",
			    'waf_service' => 'service_http_auto',
			    'waf_policy_name' => 'default',
			    'verify_method' => 'email',
			    'verification_email' => 'aravindan.acct@selahcloud.in',
			    'notification_emails' => 'aravindan.acct@selahcloud.in'}, ';')
			response = http.request(request)
			output = response.body
			parsed_json = JSON.parse (output)
			id = parsed_json ["id"]
			id_chomped = "#{id}".chomp
			puts "#{id_chomped}"

   	 @property_hash.clear
  	end


end
