class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::FullTextSearch

  field :content, type: String
  # field :vuicuoilen_count, :type => Integer, default => 0
  # field :chemgio_count, :type => Integer, default => 0
  field :reports_count, type: Integer, default: 0
  field :valid, type: Boolean, default: true

  scope :valid, where(valid: true)

  field :reported_ids, type: Array, default: []
  field :voteup_ids, type: Array, default: []
  field :votedown_ids, type: Array, default: []

  validates_presence_of :content
  validates_length_of :content, minimum: 10, maximum: 300
  
  #relation with user and comments
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favourites, dependent: :destroy
  # embeds_many :comments, as: :locatable

  fulltext_search_in :content
end