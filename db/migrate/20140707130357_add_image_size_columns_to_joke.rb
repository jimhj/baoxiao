class AddImageSizeColumnsToJoke < ActiveRecord::Migration
  def change
    add_column :jokes, :picture_meta_info, :text
  end
end
