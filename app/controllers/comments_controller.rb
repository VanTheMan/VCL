class CommentsController < ApplicationController
	def new
		@post = Post.find(params[:post_id])
		@comment = Comment.new
	end

	def create
		@comment = current_user.comments.build(params[:comment])
		@comment.post = Post.find(params[:post_id])

		html = render_to_string :partial => "comment", :layout => false, :locals => { comment: @comment }
		#binding.pry

		if @comment.save 
			respond_to do |format|
				format.html { redirect_to post_path(@comment.post) }
				format.json { render json: { success: true, html: html } } 
			end
		else
			render action: "new"
		end
	end

	# def comment
	# 	@comment = current_user.comments.build(params[:comment])
	# 	@comment.post = Post.find(params[:post_id])
	# end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to post_path
	end
end