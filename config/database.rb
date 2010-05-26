require 'rubygems'
require 'dm-core'
require 'models'

DataMapper.setup(:default, ENV['DATABASE_URL'] || {
  :database => 'ideator_dev',
  :adapter  => 'postgres'
})
