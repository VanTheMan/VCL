class UsersController < ApplicationController
	before_filter :authenticate_user!

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

end