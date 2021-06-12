class CreateUserComments < ActiveRecord::Migration[6.1]
  def change
    create_table :user_comments do |t|
      t.string :comment, null: false
      t.integer :user_id, null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    add_index :user_comments, :user_id
    add_index :user_comments, :author_id
  end
end
