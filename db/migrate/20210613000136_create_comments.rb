class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :comment, null: false
      t.integer :author_id, null: false
      t.references :commentable, polymorphic: true
      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
