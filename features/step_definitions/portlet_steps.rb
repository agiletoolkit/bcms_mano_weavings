Given /^the (.+) exists and contains the (.+) portlet$/ do |page_name, portlet_name|
  path = path_to page_name
  page_id = Page.find_by_path path
  unless page_id
    # Create the page using the passed path
    page = Page.create!(:name => "Portlet Test", :section => Section.find(:first), :path => path, :template_file_name => "default.html.erb")
    page.publish!
    page_id = page.id
  end

  # Create portlet
  template = ''
  File.open(RAILS_ROOT + '/app/views/portlets/' + portlet_name.gsub(' ', '_') + '/render.html.erb', "r") { |f| template = f.read }
  portlet = (portlet_name.gsub(' ', '_') + '_portlet').classify.constantize.new("name" => portlet_name, "connect_to_page_id" => page_id, "handler" => "erb", "template" => template, "connect_to_container" => "main")
  portlet.save
end