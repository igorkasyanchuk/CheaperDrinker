class AddApprovedToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :approved, :boolean, :default =>false
    add_index :posts, :approved
  end

  def self.down
    remove_index :posts, :approved
    remove_column :posts, :approved
  end
end
