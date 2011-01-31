class Admin::NeighborhoodsController < Admin::DashboardController
  belongs_to :state
  belongs_to :market
end