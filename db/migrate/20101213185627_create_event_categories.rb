class CreateEventCategories < ActiveRecord::Migration
  def self.up
    create_table :event_categories do |t|
      t.string :name
    end
    add_column :events, :event_category_id, :integer
    add_index :events, :event_category_id
  end

  def self.down
    remove_column :events, :event_category_id
    remove_index :events, :event_category_id
    drop_table :event_categories
  end
end
