class AddUserAgentToJokes < ActiveRecord::Migration
  def change
    add_column :jokes, :user_agent, :string
    add_column :jokes, :from_client, :boolean, default: false, index: true
  end
end
