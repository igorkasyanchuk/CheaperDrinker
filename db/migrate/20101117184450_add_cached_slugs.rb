class AddCachedSlugs < ActiveRecord::Migration
  def self.up
    add_column :cities, :cached_slug, :string
    add_column :states, :cached_slug, :string
  end

  def self.down
    remove_column :cities, :cached_slug
    remove_column :states, :cached_slug
  end
end
