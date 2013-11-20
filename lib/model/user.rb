class User
	attr_accessor :auth

	@redis ||= Redis.new

	# Create endpoint
	def self.create(params)
		
		prepare
		json = JSON.parse(@auth)

		raise 'Duplicate user' unless !duplicate?(params, json)
		@redis.set("auth", (json << { 
				username: params["username"], 
				password: params["password"] 
		}).to_json)
		

		true
	end

	def self.authorize!(request)
		params = JSON.parse(request.body.read)
	
		prepare
	
		# Convert credential to json objects
		json = JSON.parse(@auth)
	
		# Search for k,v pairs corresponding to user & pass
		validate = json.select {|u| u["username"] == params["username"] && u["password"] == params["password"] }

		validate.empty? ? false : true
		
	end

	# Check for duplicates credentials
	def self.duplicate?(params, json)
			duplicate = json.select {|u| u["username"] == params["username"]  }
			duplicate.empty? ? false : true
	 end

	# Setup data
	def self.prepare
		puts "-- user loaded"
		if @auth.nil? 
			puts "-- init user"
			@redis.set("auth", []) 
			@auth = "[]" 
		else
			@auth = @redis.get("auth")
		end
	end


end