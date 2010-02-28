class WeavingDetailsPortlet < Portlet

  def render
    @weaving = Weaving.find(params[:id])
  end

end