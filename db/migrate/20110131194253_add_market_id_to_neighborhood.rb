class AddMarketIdToNeighborhood < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :market_id, :integer
  end

  def self.down
    remove_column :neighborhoods, :market_id
  end
end
