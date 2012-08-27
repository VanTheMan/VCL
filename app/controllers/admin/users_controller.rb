class Admin::UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(7)
  end

  def show
    @user = User.find(params[:id])    
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])  
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end
end
