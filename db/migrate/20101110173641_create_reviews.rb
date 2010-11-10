class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :reviewable_id
      t.string :reviewable_type
      t.text :review
      t.integer :service_rating
      t.integer :overall_rating
      t.integer :atmosphere_rating
      t.integer :value_rating
      t.boolean :approved, :default => false
      t.timestamps
    end
    add_column :locations, :reviews_count, :integer, :default => 0
    add_index :reviews, [:user_id]
    add_index :reviews, [:reviewable_id]
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end

  def self.down
    remove_column :locations, :reviews_count
    remove_index :reviews, [:user_id]
    remove_index :reviews, [:reviewable_id]
    remove_index :reviews, [:reviewable_id, :reviewable_type]
    drop_table :reviews
  end
end
