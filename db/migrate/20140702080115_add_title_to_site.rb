class AddTitleToSite < ActiveRecord::Migration
  def change
    add_column :friend_sites, :title, :string
  end
end
