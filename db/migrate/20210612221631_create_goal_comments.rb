class CreateGoalComments < ActiveRecord::Migration[6.1]
  def change
    create_table :goal_comments do |t|
      t.string :comment, null: false
      t.integer :goal_id, null: false
      t.integer :author_id, null: false

      t.timestamps
    end
    
    add_index :goal_comments, :goal_id
    add_index :goal_comments, :author_id
  end
end
