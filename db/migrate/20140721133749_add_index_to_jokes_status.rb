class AddIndexToJokesStatus < ActiveRecord::Migration
  def change
    add_index :jokes, :status
  end
end
