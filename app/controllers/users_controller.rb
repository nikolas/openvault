class UsersController < ApplicationController
  
  def show
    @user = get_user
  end

  def scholar
    @user = get_user
    if @user.role == "scholar"
      render :show
    else
      not_found
    end
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
