class CreateCities < ActiveRecord::Migration
  def self.up
    add_column :locations, :city_id, :integer
    add_column :locations, :state_id, :integer
    Location.reset_column_information
    create_table :states do |t|
      t.string :name
    end
    create_table :cities do |t|
      t.string :name
      t.integer :state_id
    end
    add_index :cities, :state_id
    Location.all.each do |location|
      state = State.find_or_create_by_name(location.state)
      location.state_id = state.id
      location.save(:validate => false)
    end
  end

  def self.down
    remove_column :locations, :city_id
    remove_column :locations, :state_id
    remove_index :cities, :state_id
    drop_table :states
    drop_table :cities
  end
end
