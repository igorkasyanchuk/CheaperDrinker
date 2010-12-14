class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :city_id
    end
    add_index :neighborhoods, :city_id
  end

  def self.down
    remove_index :neighborhoods, :city_id
    drop_table :neighborhoods
  end
end
