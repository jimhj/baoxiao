class AddPrivateTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :private_token, :string, index: true
  end
end
