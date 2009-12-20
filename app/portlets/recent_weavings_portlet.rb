class RecentWeavingsPortlet < Portlet

  def render
    @weavings = Weaving.all(:order => "created_at desc", :limit => self.limit)
  end
    
end