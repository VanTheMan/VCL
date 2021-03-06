class ApplicationController < ActionController::Base
  protect_from_forgery
  include PostsHelper
  def after_sign_in_path_for(user)
  	if current_user.is_a? Admin
  		admin_posts_path
  	else
  		root_path
  	end
  end
end
