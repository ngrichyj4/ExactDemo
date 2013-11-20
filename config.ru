require './lib/app/serve'

run Sinatra::Application
use Rack::Logger
use Rack::Session::Cookie, key: 'N&monhSDH',
    domain: "localhost",
    path: '/',
    expire_after: 14400,
    secret: '*&(^B567'
    
run Rack::Cascade.new [ExactAPI, Web]
