class UsersController < ApplicationController
  
  before_filter :get_user, :only => [:show]
  
  def show
    @user = @user
    # @collections = CustomCollection.where(:owner_id => @user.id).includes(:custom_collection_items)
    @collections = @user.collections
  end
  
  def scholars
    @users = User.scholars
  end
  
  private
  
  def get_user
    if params[:id]
      @user = User.find(params[:id])
    elsif params[:username]
      @user = User.where(:username => params[:username]).first
    elsif current_user
      @user = User.find(current_user.id)
    end
    
    @user or not_found
  end
  
end 
