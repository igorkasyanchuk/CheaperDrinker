class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true, :touch => true

  scope :not_approved, where(:approved => false)
  scope :recent, order('created_at DESC')

  belongs_to :user
  validates_presence_of :comment
  
  def approve!
    self.approved = true
    self.save
  end
  
  def status
    self.approved ? "accepted" : "pending"
  end
  
  def by_author
    user.try(:user_name)
  end

end
