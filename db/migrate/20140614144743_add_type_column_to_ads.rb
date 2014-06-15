class AddTypeColumnToAds < ActiveRecord::Migration
  def change
    add_column :ads, :ad_type, :string, default: 'LIST', index: true
  end
end
