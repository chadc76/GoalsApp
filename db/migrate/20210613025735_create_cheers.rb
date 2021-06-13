class CreateCheers < ActiveRecord::Migration[6.1]
  def change
    create_table :cheers do |t|
      t.integer :goal_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_index :cheers, :goal_id
    add_index :cheers, :user_id
    add_index :cheers, [:user_id, :goal_id], unique: true
  end
end
