# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

class LoadWeavingsSeedData < ActiveRecord::Migration
  extend Cms::DataLoader
    create_section(:weavings, :name => "Weavings", :parent => Section.find_by_path("/"), :path => "/weavings")
    Group.all.each{|g| g.sections = Section.all }

    create_page(:overview, :name => "Overview", :path => "/weavings", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
    create_page(:weaving_process, :name => "Weaving Process", :path => "/weavings/weaving-process", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
    create_page(:weavers, :name => "Weavers", :path => "/weavings/weavers", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
    create_page(:weavings, :name => "Weavings", :path => "/weavings/weavings", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
    create_page(:items_for_sale, :name => "Items for Sale", :path => "/weavings/items-for-sale", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
    create_page(:donate, :name => "Donate", :path => "/weavings/donate", :section => sections(:weavings), :template_file_name => "default.html.erb", :publish_on_save => true, :hidden => false, :cacheable => true)
end

# Create some initial pages the Weavings Module will need for portlets etc.
# Should put here because it is seed data and should be run after all the migrations.
LoadWeavingsSeedData.new
