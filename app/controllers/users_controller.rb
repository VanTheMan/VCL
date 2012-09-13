class UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
		@users = User.fulltext_search(params[:search])
	end

	def show
		@user = User.find(params[:id])		
		@posts = @user.posts
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])	
		@user.update_attributes(params[:user])
		redirect_to user_path(@user)
	end

end