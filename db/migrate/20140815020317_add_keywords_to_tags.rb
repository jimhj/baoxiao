class AddKeywordsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :keywords, :string
  end
end
