class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]

  def index
    @posts = Post.all.desc(:created_at)
    if params[:order_by] == "updated_at"
      @posts = Post.all.desc(:updated_at)
    elsif params[:order_by] == "created_at"
      @posts = Post.all.desc(:created_at)
    elsif params[:order_by] == "comments_num"
      @posts = Post.all.sort{|a,b| b.comments.count <=> a.comments.count }
      # @posts = Post.all(:include => :comments)
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

  def vote_down
    @post = Post.find(params[:id])
    if !@post.votedown_ids.include?(current_user.id)
      if !@post.voteup_ids.include?(current_user.id)
        @post.votedown_ids << current_user.id
        @post.save
        redirect_to posts_path
      else
        redirect_to posts_path, notice: 'you cannot vote down' 
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
    if @post.user == current_user
  	  @post.destroy
  	  redirect_to posts_path, notice: "you have deleted your post"
    else
      redirect_to posts_path, notice: "you cannot delete other user's post"
    end
  end
end
