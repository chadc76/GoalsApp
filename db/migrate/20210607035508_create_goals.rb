class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.text :details
      t.integer :user_id, null: false
      t.boolean :private, default: false
      t.boolean :complete, default: false

      t.timestamps
    end
    add_index :goals, :user_id
  end
end
