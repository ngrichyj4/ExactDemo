require './lib/app'
require './lib/model/user'

class ExactAPI < Grape::API

    format :json
    
    helpers do
      
      # Logs to console output
      def logger
    	request.logger
      end

      # Check if user is in store
      def user
         @user ||= User.authorize!(request)
      end

      # Authenticate user
      def authenticate!
        error!('401 Unauthorized', 401) unless user
      end

      def exists?(params)
		error!('Password empty', 500) if params["password"].empty?
		true
      end

    end

    # User routes
    resource :users do
	  
	  desc "Create user."
	  post :create do
		
	  	params = JSON.parse(request.body.read)
	  	logger.info params
	
	  	# Check for duplicates and check password
	    if  exists?(params)
	    	begin
		   User.create(params)
		   status 200
		rescue => error
		   error!(error, 500)
		end
				
	    end
	
	  end
	
	  
	  desc "Authenticate user."
	  post :authenticate do 
	 
	  	# Perform authentication step
	  	authenticate!
	  	status 200
	  end
	
    end

end

class Web < Sinatra::Base
  
   get '/' do
	"Working."
   end
  
end
