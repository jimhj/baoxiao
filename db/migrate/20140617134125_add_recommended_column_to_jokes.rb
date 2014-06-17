class AddRecommendedColumnToJokes < ActiveRecord::Migration
  def change
    add_column :jokes, :recommended, :boolean, default: false, index: true
    add_index :jokes, [:recommended, :status]     
  end
end
