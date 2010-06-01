namespace :db do
  require 'config/database'

  desc "Migrate the database"
  task :migrate do
    DataMapper.auto_migrate!
  end

  desc "Upgrade the database schema"
  task :upgrade do
    DataMapper.auto_upgrade!
  end

  desc "Add some test data"
  task :generate do
    10.times do |n|
      Idea.create(
        :name => "A good idea #{n}",
        :clarity_of_audience => rand(10).to_i,
        :clarity_of_problem => rand(10).to_i,
        :clarity_of_need => rand(10).to_i,
        :clarity_of_ability_to_meet_need => rand(10).to_i
      )
    end
  end

  desc "Clear test data"
  task :clean do
    Idea.all.map {|i| i.destroy!}
  end
end

