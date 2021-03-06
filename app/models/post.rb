class Post < ActiveRecord::Base  
  before_save :formatted_body

  has_many :attachments
  belongs_to :forum, :counter_cache => true
  belongs_to :topic, :counter_cache => true
  belongs_to :user, :counter_cache => true
  
  def body_to_html
    #textilize body and save as body_html
  end
  
  def formatted_body
    write_attribute(:body_html, RedCloth.new(Whistler.white_list(body)).to_html  )
  end
  
  def attachments=(upload)
    self.attachments.build(upload) unless upload.empty?
  end
  
  
end