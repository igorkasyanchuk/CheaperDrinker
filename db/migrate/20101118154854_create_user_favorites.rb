class CreateUserFavorites < ActiveRecord::Migration
  def self.up
    create_table :user_favorites do |t|
      t.integer :user_id
      t.integer :location_id
    end
    add_index :user_favorites, :user_id
    add_index :user_favorites, :location_id
  end

  def self.down
    remove_index :user_favorites, :user_id
    remove_index :user_favorites, :location_id
    drop_table :user_favorites
  end
end
