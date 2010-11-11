class Review < ActiveRecord::Base
  belongs_to :reviewable, :polymorphic => true, :counter_cache => true

  scope :not_approved, where(:approved => false)
  scope :approved, where(:approved => true)
  scope :recent, order('created_at DESC')
  scope :from_pending_to_approved, order('approved ASC')

  belongs_to :user
  validates_presence_of :review
  validates_presence_of :service_rating
  validates_presence_of :overall_rating
  validates_presence_of :atmosphere_rating
  validates_presence_of :value_rating
  
  before_save :calculate_overall_rating
  
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
  
  def calculate_overall_rating
    self.overall_rating = (self.atmosphere_rating + self.service_rating + self.value_rating) / 3.0;
  end
  
  after_save :calculate_bar_average
  after_destroy :calculate_bar_average
  
  def calculate_bar_average
    self.reviewable.update_attribute(:average_rating, self.reviewable.reviews.approved.average(:overall_rating).to_f)
  end  

end