class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :author, null: false
      t.references :post, null: false, foreign_key: { to_table: :posts }
      t.references :parent_comment
      t.timestamps
    end
    remove_foreign_key :posts, column: :author_id
  end
end
