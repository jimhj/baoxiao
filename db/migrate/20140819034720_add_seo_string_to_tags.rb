class AddSeoStringToTags < ActiveRecord::Migration
  def change
    add_column :tags, :seo_title, :string
  end
end
