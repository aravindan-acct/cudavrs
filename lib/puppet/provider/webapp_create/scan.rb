require "net/http"
require "net/https"
require "uri"
require "json"
require "base64"
# Puppet provider definition
	Puppet::Type.type(:webapp_create).provide :scan do
  		desc "Create a scan on VRS"
	Puppet.debug("Creating a scan on VRS....")
			mk_resource_methods

		def self.vrsauth
			user = `cat /etc/puppetlabs/puppet/bcc_credentials`
			userjson = JSON.parse(user)
			basic_auth_user = userjson ["username"]
			basic_auth_pass = userjson ["password"]
			http = Net::HTTP.new('vrs.barracudanetworks.com', 443)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			#step1 : Authenticate and fetch services
			parsed_uri = URI.parse("https://vrs.barracudanetworks.com/webapp/json")
			web_create = Net::HTTP::Get.new(parsed_uri.path)
			web_create.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
			response = http.request(web_create)
			output = response.body
			services = JSON.parse (output)
			@services_json = services ["name"]
		end
		  # Checks the ensurable property
		def exists?
		    Puppet.debug("Calling exists method ")
				@property_hash[:ensure] == :present
		end

	  def self.instances
	    Puppet.debug("Calling instances method")
			auth = vrsauth
			instances = []
			services_json_parsed = @services_json
			services_json_parsed.each do |key,value|
				val = value
				instances << new(
					:ensure => :present,
					:name		=> val["name"])
	    return instances
	  end

	  def self.prefetch(resources)
	    Puppet.debug("Calling prefetch method: ")
			auth = vrsauth
			instances.each do |prov|
    		if resource = resources[prov.name]
      		resource.provider = prov
    		end
  		end
	  end

		def message(object)
			opts=object.to_hash
			params=opts
			Puppet.debug("payload....................#{params}")
			return params
		end

	  def create
	    Puppet.debug("Calling create method:")
			#step2 : create the web app configuration to set up scans
			parsed_uri = URI.parse("https://vrs.barracudanetworks.com/api/v1/create_webapp")
			scancreate = Net::HTTP::Post.new(parsed_uri.path)
			scancreate.basic_auth "#{basic_auth_user}", "#{basic_auth_pass}"
			scancreate.set_form_data(message(resource))
			response = http.request(request)
			output = response.body
			parsed_json = JSON.parse (output)
			id = parsed_json ["id"]
			id_chomped = "#{id}".chomp
			puts "#{id_chomped}"
   	 @property_hash.clear
  	end
		

end
