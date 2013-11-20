## Setup
	
	$ bundle install

Start Redis

    $ redis-server /usr/local/etc/redis.conf

Start App
	
	$ thin start

Post data

	$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"username":"usern", "password":"pass"}' http://localhost:3000/users/create