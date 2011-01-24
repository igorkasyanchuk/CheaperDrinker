class CreateMarkets < ActiveRecord::Migration
  def self.up
    create_table :markets do |t|
      t.string :name
      t.string :cached_slug
      t.integer :state_id
    end
    add_column :markets, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :markets, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :markets, :accuracy, :integer, :default => -1     
    
    add_column :cities, :market_id, :integer
    add_index :cities, :market_id
  end

  def self.down
    remove_index :cities, :market_id
    remove_column :cities, :market_id
    drop_table :markets
  end
end