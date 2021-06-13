class RemoveIndexFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :commentable_type, :string
    remove_column :comments, :commentable_id, :bigint
    change_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
    end
  end
end
