gem 'dm-core', '= 0.10.2'
require 'dm-core'
require 'models'

DataMapper.setup(:default, ENV['DATABASE_URL'] || {
  :database => 'ideator_dev',
  :adapter  => 'postgres'
})
