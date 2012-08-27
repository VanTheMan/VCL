class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]

  def index
    @posts = Post.valid.all.desc(:created_at).page(params[:page]).per(7)
    if params[:order_by] == "updated_at"
      @posts = Post.valid.all.desc(:updated_at)
    elsif params[:order_by] == "created_at"
      @posts = Post.valid.all.desc(:created_at)
    elsif params[:order_by] == "comments_num"
      @posts = Post.valid.all.sort{|a,b| b.comments.count <=> a.comments.count }
    elsif params[:order_by] == "random"
      @random_num = rand(Post.all.count)
      @posts = Post.all.sample(@random_num)
    elsif params[:order_by] == "favourite"
      @posts = Post.find(current_user.favourite_posts_ids)
    end
  	@post = Post.new
  end

  def new
  	@post = Post.new
  end

  def vote_up
    @post = Post.find(params[:id])
    if @post.voteup_ids.include?(current_user.id) || @post.votedown_ids.include?(current_user.id)
      respond_to do |format|
        format.html  {redirect_to posts_path, notice: 'you cannot vote up' }
        format.json  { render json: { success: false } }
      end
    else
      @post.voteup_ids << current_user.id
      @post.save
      respond_to do |format|
        format.html  {redirect_to posts_path }
        format.json  {render json: { success: true, vote_up_count: @post.voteup_ids.count } }
      end
    end
  end

  def vote_down
    @post = Post.find(params[:id])
    if @post.votedown_ids.include?(current_user.id)  || @post.voteup_ids.include?(current_user.id)
      respond_to do |format|  
        format.html { redirect_to posts_path }
        format.html { render json: { success: false } }
      end
    else
      @post.votedown_ids << current_user.id
      @post.save
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: { success: true, vote_down_count: @post.votedown_ids.count } }
      end
    end
  end

  def show
    @post = Post.find(params[:id])   
    @comments = @post.comments
    @comment = Comment.new
    if @comments.count > 2
      @comments = @post.comments.skip(@comments.count - 2)
      if params[:show] == "all"        
        @comments = @post.comments
        html = render_to_string :partial => "comments/list", :locals => {comments: @comments}
        respond_to do |format|
          format.html
          format.json { render json: {success: true, html: html } }
        end
      end
    end
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

  def report
    @post = Post.find(params[:id])
    if !@post.reported_ids.include?(current_user.id)
      @post.reported_ids << current_user.id
      @post.reports_count += 1
      @post.save

      respond_to do |format|
        format.html { redirect_to posts_path } 
        format.json { render json: {success: true, reports_count: @post.reports_count }}
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: {success: false }}
      end
    end
  end

  def favourite
    @post = Post.find(params[:id])
    if !current_user.favourite_posts_ids.include?(@post.id)
      current_user.favourite_posts_ids << @post.id
      current_user.save
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: {success: true } }
      end
    else
      current_user.favourite_posts_ids = current_user.favourite_posts_ids - [@post.id]
      current_user.save
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: {success: false } }
      end
    end
  end

end
