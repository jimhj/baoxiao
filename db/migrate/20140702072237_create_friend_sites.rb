class CreateFriendSites < ActiveRecord::Migration
  def change
    create_table :friend_sites do |t|
      t.string :name
      t.string :url
      t.integer :priority, default: 1000, index: true
      t.integer :status, default: 0, index: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
