gem 'dm-core', '= 0.10.2'
require 'dm-core'
require 'models'

if ENV['RACK_ENV'] == 'cucumber'
  puts "using cucumber database"
  DataMapper.setup(:default, {
    :database => 'ideator_cuke',
    :adapter  => 'postgres'
  })
else
  DataMapper.setup(:default, ENV['DATABASE_URL'] || {
    :database => 'ideator_dev',
    :adapter  => 'postgres'
  })
end
