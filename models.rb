require 'dm-core'

class Idea
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, :required => true
  property :clarity_of_audience, Integer, :required => true
  property :clarity_of_problem, Integer, :required => true
  property :clarity_of_need, Integer, :required => true
  property :clarity_of_ability_to_meet_need, Integer, :required => true
  property :bevy_id, Integer

  belongs_to :bevy

  def sum_of_fields
    clarity_of_audience +
      clarity_of_problem +
      clarity_of_need +
      clarity_of_ability_to_meet_need
  end
end

class Bevy
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :owner, String

  has n, :ideas
end



