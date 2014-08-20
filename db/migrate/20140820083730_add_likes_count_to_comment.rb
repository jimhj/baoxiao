class AddLikesCountToComment < ActiveRecord::Migration
  def change
    add_column :comments, :likes_count, :integer, default: 0
    add_column :users, :liked_comment_ids, :integer, array: true, default: []
  end
end
