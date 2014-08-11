class UsersController < ApplicationController
  
  def show
    @user = User.where(username: params[:username]).first

    # raise a Not Found exception if the user wasn't found
    not_found unless @user
  end

  def scholar
    @user = User.where(username: params[:username], role: "scholar").first
    # raise a Not Found exception if the user wasn't found.
    not_found unless @user

    # otherwise, render #show view.
    render :show
  end
  
  def scholars
    @users = User.scholars
  end

  def show_profile
    if !current_user
      flash[:alert] = "You must be logged in to view your profile"
      redirect_to root_path
      return
    end

    @user = current_user
    render :show
  end
  
end 
