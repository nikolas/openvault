class UsersController < ApplicationController
  
  before_filter :get_user, :only => [:show]
  
  def show
    @user = @user
    @collections = CustomCollection.where(:user_id => @user.id)
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
    elsif
      @user = User.find(current_user.id)
    end
    
    @user or not_found
  end
  
end 