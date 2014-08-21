class AddSecretTokenColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :weibo_uid, :string, default: nil
    add_column :users, :weibo_token, :string, default: nil
    add_column :users, :qq_uid, :string, default: nil
    add_column :users, :qq_token, :string, default: nil    
  end
end
