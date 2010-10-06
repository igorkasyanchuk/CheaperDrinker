class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :comment, :default => nil
      t.references :commentable, :polymorphic => true
      t.references :user
      t.boolean :approved, :default => false
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
    
    add_column :locations, :comments_count, :integer, :default => 0
    Location.reset_column_information
    Location.all.each do |l|
      l.comments_count = l.comments.count
      l.save
    end
  end

  def self.down
    drop_table :comments
    remove_column :locations, :comments_count
  end
end