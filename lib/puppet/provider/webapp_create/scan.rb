require "net/http"
require "net/https"
require "uri"
require "json"
require "base64"

	def auth_req
	
        uri = ["wafs", "create_webapp", "create_scan", "run_scan_now", "scan_status", "scan_results?webapp_id=", "mitigate_on_waf"]
        vrs = "https://vrs.barracudanetworks.com/api/v1"
        user = `cat /etc/puppetlabs/puppet/bcc_credentials`
        userjson = JSON.parse(user)
        basic_auth_user = userjson ["username"] 
        basic_auth_pass = userjson ["password"]
	http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        def get
	#step1 : Authenticate and fetch services
 	parsed_uri = URI.parse("#{vrs}/#{uri[0]}")
	web_create = Net::HTTP::Get.new(parsed_uri.path)
	web_create.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
	response = http.request(web_create)
	output = response.body
	services = JSON.parse (output)
	services_json = services ["id"]
	end

	def post
	#step2 : create the web app configuration to set up scans
	parsed_uri = URI.parse("#{vrs}/#{uri[1]}")
	scancreate = Net::HTTP::Post.new(parsed_uri.path)
	scancreate.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
	scancreate.set_form_data({'url' => 'http://staging.selahcloud.in:80/',
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
	end

# Puppet provider definition
	Puppet::Type.type(:webapp_create).provide :scan do

  		desc "Create a scan on VRS"

		Puppet.debug("Creating a scan on VRS ")

		mk_resource_methods
		  # Checks the ensurable property 
		  def exists?
		    Puppet.debug("Calling exists method ")
		    @property_hash[:ensure] == :present
			webapp_get = get
			
		  end

	  self.instances
	    Puppet.debug("Callling self.instances method")
	    instances = []
	    return instances
	  end
  
	  def self.prefetch(resources)
	    Puppet.debug("Calling self.prefetch method: ")
	    end
	  end

	  def create
	    Puppet.debug("Calling create method:")
		webapp_create = post
   	 @property_hash.clear
  	end
	  
  
end
