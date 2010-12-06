class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.date :start
      t.date :end
      t.time :start_time
      t.date :publish_on
      t.integer :location_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.boolean :approved
      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :location_id
    add_column :locations, :logo_file_name,    :string
    add_column :locations, :logo_content_type, :string
    add_column :locations, :logo_file_size,    :integer
    add_column :locations, :logo_updated_at,   :datetime
  end

  def self.down
    remove_index :events, :location_id
    remove_index :events, :user_id
    drop_table :events
    remove_column :locations, :logo_file_name
    remove_column :locations, :logo_content_type
    remove_column :locations, :logo_file_size
    remove_column :locations, :logo_updated_at
  end
end
