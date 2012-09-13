class Admin::PostsController < ApplicationController
	before_filter :authenticated_admin

	def index
	    case params[:order_by]
	      when "updated_at" 
	        @list_posts = Post.valid.all.desc(:updated_at)
	      when "created_at"
	        @list_posts = Post.valid.all.desc(:created_at)  
	      when "comments_num"  
	        @list_posts = Post.valid.all.sort{|a,b| b.comments.count <=> a.comments.count }
	      when "random"
	        @random_num = rand(Post.all.count)
	        @list_posts = Post.all.sample(@random_num)
	      when "favourite"
	        @list_posts = current_user.favourites.map { |f| f.post }
	      else
	        @list_posts = Post.valid.all.desc(:created_at)
    	end

    	if @list_posts.is_a? Array
      		@posts = Kaminari.paginate_array(@list_posts).page(params[:page]).per(5)
   		else 
     	 	@posts = @list_posts.page(params[:page]).per(5)
    	end
  		@post = Post.new
  	end

	def show
	    @post = Post.find(params[:id])   
	    @comments = @post.comments
	end

	def edit
	  	@post = Post.find(params[:id])
	end

	def update
	  	@post = Post.find(params[:id])
	    
	    @post.update_attributes(params[:post])
	  	redirect_to posts_path
	end

	def destroy
	  	@post = Post.find(params[:id])
	  	@post.destroy
	  	redirect_to posts_path, notice: "admin, you have deleted a post"    
	end

	def disable
		@post = Post.find(params[:id])
		@post.valid = false
		@post.save
		redirect_to admin_posts_path
	end

	private
		def authenticated_admin
			if !current_user.is_a? Admin
				redirect_to posts_path
			end	
		end
end
