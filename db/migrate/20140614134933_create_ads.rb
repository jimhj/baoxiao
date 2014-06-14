class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.string :version, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
