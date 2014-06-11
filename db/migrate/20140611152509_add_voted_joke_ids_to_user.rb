class AddVotedJokeIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :voted_joke_ids, :integer, array: true, default: []
  end
end
