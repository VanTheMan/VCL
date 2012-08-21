class Comment
	include Mongoid::Document
	field :content, :type => String

	#relation with user and post
	belongs_to :post
	belongs_to :user
end