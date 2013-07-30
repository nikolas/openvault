class CollectionsController < ApplicationController
  
  skip_authorization_check
  
  before_filter :get_collection, :only => [:show]
  
  def index
    @collections = Collection.all
  end

  def show
    # @collection is build with the before_filter
    #this will be needed for the sidebar
    @in_collection = []
  end
  
  private

  def get_collection
    if params[:id]
      @collection = Collection.find(params[:id])
    else
      @collection = Collection.where(:slug => params[:slug]).first
    end
    @collection or not_found
  end
end
