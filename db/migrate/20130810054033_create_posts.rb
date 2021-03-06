class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :brand
      t.string :title
      t.string :size
      t.integer :price_cents, default: 0
      t.string :body
      t.integer :user_id
      t.boolean :visible, default: true

      t.timestamps
    end
    add_index :posts, :user_id
  end
end
