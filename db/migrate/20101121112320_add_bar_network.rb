class AddBarNetwork < ActiveRecord::Migration
  def self.up
    add_column :locations, :bar_network_id, :integer
    create_table :bar_networks do |t|
      t.string :name
    end
    add_index :locations, :bar_network_id
  end

  def self.down
    remove_index :locations, :bar_network_id
    drop_table :bar_networks
    remove_column :locations, :bar_network_id
  end
end
