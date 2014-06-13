class AddIndexToJokes < ActiveRecord::Migration
  def change
    add_index :jokes, :hot
    add_index :jokes, :from    
  end
end
