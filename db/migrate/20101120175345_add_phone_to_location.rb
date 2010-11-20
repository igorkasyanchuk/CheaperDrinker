class AddPhoneToLocation < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    create_table :location_schedules do |t|
      t.integer :location_id 
      t.integer :starts_monday_at, :default => -1
      t.integer :ends_monday_at, :default => -1
      t.integer :starts_tuesday_at, :default => -1
      t.integer :ends_tuesday_at, :default => -1
      t.integer :starts_wednesday_at, :default => -1
      t.integer :ends_wednesday_at, :default => -1
      t.integer :starts_thursday_at, :default => -1
      t.integer :ends_thursday_at, :default => -1
      t.integer :starts_friday_at, :default => -1
      t.integer :ends_friday_at, :default => -1
      t.integer :starts_saturday_at, :default => -1
      t.integer :ends_saturday_at, :default => -1
      t.integer :starts_sunday_at, :default => -1
      t.integer :ends_sunday_at, :default => -1
    end
    add_index :location_schedules, :location_id
    Location.all.each do |l|
      l.create_location_schedule unless l.location_schedule
    end
  end

  def self.down
    remove_column :users, :twitter, :string
    remove_column :users, :facebook, :string
    remove_index :location_schedules, :location_id
    drop_table :location_schedules
  end
end
