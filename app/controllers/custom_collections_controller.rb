class CustomCollectionsController < ApplicationController
  
  before_filter :get_collection, :only => [:show]
  
  load_and_authorize_resource
  
  # GET /custom_collections
  # GET /custom_collections.json
  def index
    @custom_collections = CustomCollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_collections }
    end
  end

  # GET /custom_collections/1
  # GET /custom_collections/1.json
  def show
    #commenting out because before filter gets this for custom routes
    #@custom_collection = CustomCollection.find(params[:id])

    # respond_to do |format|
#       format.html # show.html.erb
#       format.json { render json: @custom_collection }
#     end
  end

  # GET /custom_collections/new
  # GET /custom_collections/new.json
  def new
    @custom_collection = CustomCollection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_collection }
    end
  end

  # GET /custom_collections/1/edit
  def edit
    @custom_collection = CustomCollection.find(params[:id])
  end

  # POST /custom_collections
  # POST /custom_collections.json
  def create
    @custom_collection = CustomCollection.new(params[:custom_collection])

    respond_to do |format|
      if @custom_collection.save
        format.html { redirect_to @custom_collection, notice: 'Custom collection was successfully created.' }
        format.json { render json: @custom_collection, status: :created, location: @custom_collection }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_collections/1
  # PUT /custom_collections/1.json
  def update
    @custom_collection = CustomCollection.find(params[:id])

    respond_to do |format|
      if @custom_collection.update_attributes(params[:custom_collection])
        format.html { redirect_to @custom_collection, notice: 'Custom collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @custom_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_collections/1
  # DELETE /custom_collections/1.json
  def destroy
    @custom_collection = CustomCollection.find(params[:id])
    @custom_collection.destroy

    respond_to do |format|
      format.html { redirect_to custom_collections_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def get_collection
    if params[:id]
      @custom_collection = CustomCollection.find(params[:id])
    else
      slug = params[:custom_collection_slug]
      user = User.where(:username => params[:username]).first
      not_found unless user && slug
      @custom_collection = CustomCollection.where(:user_id => user.id, :slug => slug).first
    end
    
    @custom_collection or not_found
  end
  
end
