# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
# Just invoke the rake task since the current mano_browsercms repo does not use a rails version that supports
# The db:seed rake task
Rake::Task['db:seed:weavings'].invoke
