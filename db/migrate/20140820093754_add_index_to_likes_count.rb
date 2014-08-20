class AddIndexToLikesCount < ActiveRecord::Migration
  def change
    add_index :comments, :likes_count
  end
end
