class Review < ActiveRecord::Base
  belongs_to :reviewable, :polymorphic => true, :counter_cache => true

  scope :not_approved, where(:approved => false)
  scope :approved, where(:approved => true)
  scope :recent, order('created_at DESC')
  scope :from_pending_to_approved, order('approved ASC')

  belongs_to :user
  validates_presence_of :review
  
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