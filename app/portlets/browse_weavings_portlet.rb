class BrowseWeavingsPortlet < Portlet
  def render
    @weaving_types = WeavingType.find(:all)

    if params[:type]
      # We should search by weaving type
      @weavings_to_browse = Weaving.find(:all, :conditions => ["published = ? AND weaving_type_id = ?", true, params[:type]])
      @search_results_summary = 'Found ' + @weavings_to_browse.size.to_s + ' weavings of type ' + WeavingType.find(params[:type]).name
    end
  end
end