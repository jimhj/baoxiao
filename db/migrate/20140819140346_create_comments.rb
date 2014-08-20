class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :joke, index: true
      t.text :body
      t.datetime :deleted_at, default: nil
      
      t.timestamps
    end
  end
end
