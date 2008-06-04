class Topic < ActiveRecord::Base
  
  has_many :posts, :dependent => :destroy
  belongs_to :forum, :counter_cache => true
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :title
  validates_presence_of :body, :if => :new_record?
  
  after_create  :add_first_post
  before_save   :create_permalink
  
  attr_accessor :body
  
  def to_param
    "#{id}-#{permalink}"
  end

  def create_permalink
    self.permalink = self.title.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '-') if permalink.blank?
  end
  
  def add_first_post
    self.posts.create({ :user_id => user.id,
                        :body => body,
                        :topic_id => id,
                        :forum_id => forum.id})
  end
  
end
