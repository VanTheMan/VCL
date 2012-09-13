class Admin::PostsController < ApplicationController
	before_filter :authenticated_admin

	def index
	    @posts = Post.all.desc(:created_at)
	    if params[:order_by] == "updated_at"
	      @posts = Post.all.desc(:updated_at)
	    elsif params[:order_by] == "created_at"
	      @posts = Post.all.desc(:created_at)
	    elsif params[:order_by] == "comments_num"
	      @posts = Post.all.sort{|a,b| b.comments.count <=> a.comments.count }
	    elsif params[:order_by] == "reports_count"
	      @posts = Post.where(:reports_count => 3)
	    end
	  	@post = Post.new
  	end

  	def new
	  	@post = Post.new
	end

	def vote_up
	    @post = Post.find(params[:id])
	    if !@post.voteup_ids.include?(current_user.id)
	      if !@post.votedown_ids.include?(current_user.id)
	        @post.voteup_ids << current_user.id
	        @post.save
	        redirect_to posts_path
	      else
	        redirect_to posts_path, notice: 'you cannot vote up' 
	      end
	    end
	end

	def show
	    @post = Post.find(params[:id])   
	    @comments = @post.comments
	end

	def create
	  	@post = current_user.posts.build(params[:post])

	  	if @post.save
		    redirect_to posts_path, notice: 'post was successfully created.' 
		  else
	      render action: "new" 
	    end   
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
