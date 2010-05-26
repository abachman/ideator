require 'dm-core'
require 'dm-validations'

class Idea
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, :required => true
  property :clarity_of_audience, Integer, :required => true
  property :clarity_of_problem, Integer, :required => true
  property :clarity_of_need, Integer, :required => true
  property :clarity_of_ability_to_meet_need, Integer, :required => true
end



