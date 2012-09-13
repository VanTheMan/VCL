module PostsHelper
	def current_user=(user)
		current_user = user
	end

	def favourited?(post)
		@favor = Favourite.where(user_id: current_user.id, post_id: post.id)
		if @favor.count == 0
			false
		else
			true
		end
	end

	def voted?(post)
		if post.voteup_ids.include?(current_user.id) && post.votedown_ids.include?(current_user.id)
			true
		else
			false
		end
	end
end
