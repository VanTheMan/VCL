class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, :type => String
  # field :vuicuoilen_count, :type => Integer, default => 0
  # field :chemgio_count, :type => Integer, default => 0
  field :valid, :type => Boolean

  field :voteup_ids, type: Array, default: []
  field :votedown_ids, type: Array, default: []
  
  #relation with user and comments
  belongs_to :user
  has_many :comments

end
