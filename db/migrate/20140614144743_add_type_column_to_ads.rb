class AddTypeColumnToAds < ActiveRecord::Migration
  def change
    add_column :ads, :ad_type, :string, default: 'LIST'
  end
end
