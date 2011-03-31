require 'dm-core'
require 'digest/md5'

class Idea
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, :required => true
  property :clarity_of_audience, Integer, :required => true
  property :clarity_of_problem, Integer, :required => true
  property :clarity_of_need, Integer, :required => true
  property :clarity_of_ability_to_meet_need, Integer, :required => true

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

  property :name, String
  property :owner, String
  property :token, String, :key => true

  has n, :ideas, :child_key => [:bevy_token]

  def self.generate_token
    salt = "#{ Time.now.to_i + rand(10000000000) } this is salt"
    digest = Digest::MD5.hexdigest(salt)
    digest[0, 15]
  end
end

