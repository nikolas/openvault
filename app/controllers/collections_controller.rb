class CollectionsController < ApplicationController
  
  skip_authorization_check
  
  def index
    @collections = Collection.all
  end

  def show
    #need to make this dynamic for both id and slug
    @collection = Collection.where(:slug => params[:id]).first
    # if params[:slug]
#       @collection = Collection.find(params[:id])
#     else
#       slug = params[:slug]
#       @collection = Collection.where(:slug => slug)
#     end
  end
end
