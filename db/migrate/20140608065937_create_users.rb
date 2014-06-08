class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :avatar
      t.datetime :locked_at
      t.boolean :confirmed, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :login, unique: true
    add_index :users, :name, unique: true
  end
end
