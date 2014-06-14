class AddMoreIndexToJokes < ActiveRecord::Migration
  def change
    add_index :jokes, [:hot, :status]
    add_index :jokes, [:from, :status]
    add_index :jokes, [:from, :status, :published_at]       
  end
end
