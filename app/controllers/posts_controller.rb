class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]

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

  def new
  	@post = Post.new
  end

  def vote_up
    @post = Post.find(params[:id])
    if !voted?(@post)
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
    if !voted?(@post)
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
        html = render_to_string :partial => "comments/list", :locals => { comments: @comments }
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
      html = render_to_string :partial => "post", :layout => false, :locals => { post: @post }
      respond_to do |format|
	      format.html { redirect_to posts_path }
        format.json { render json: { success: true, html: html } }
      end
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
    
    if favourited?(@post)
      @favor = Favourite.where(user_id: current_user.id, post_id: @post.id)
      @favor.delete
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: {success: false } }
      end
    else
      @favor = Favourite.new(user_id: current_user.id, post_id: @post.id)
      @favor.save
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.json { render json: {success: true } }
      end
    end
  end

end
