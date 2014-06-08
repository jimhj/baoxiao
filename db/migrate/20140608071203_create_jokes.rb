class CreateJokes < ActiveRecord::Migration
  def change
    create_table :jokes do |t|
      t.belongs_to :user, index: true
      t.boolean :anonymous
      t.string :title
      t.text :content, null: false
      t.string :picture
      t.integer :status, default: 0, index: true
      t.integer :up_votes_count, default: 0
      t.integer :down_votes_count, default: 0
      t.integer :comments_count, defualt: 0
      t.string :from
      t.float :hot, default: 0.0
      t.datetime :published_at

      t.timestamps
    end
  end
end
