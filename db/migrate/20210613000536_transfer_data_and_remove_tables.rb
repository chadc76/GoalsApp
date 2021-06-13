class TransferDataAndRemoveTables < ActiveRecord::Migration[6.1]
  def up
    UserComment.all.each do |c|
      Comment.create!(comment: c.comment, author_id: c.author_id, commentable_id: c.user_id, commentable_type: 'User')
    end
    drop_table :user_comments

    GoalComment.all.each do |c|
      Comment.create!(comment: c.comment, author_id: c.author_id, commentable_id: c.goal_id, commentable_type: 'Goal')
    end
    drop_table :goal_comments
  end

  def down
    create_table :user_comments do |t|
      t.string :comment, null: false
      t.integer :user_id, null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    add_index :user_comments, :user_id
    add_index :user_comments, :author_id


    create_table :goal_comments do |t|
      t.string :comment, null: false
      t.integer :goal_id, null: false
      t.integer :author_id, null: false

      t.timestamps
    end
    
    add_index :goal_comments, :goal_id
    add_index :goal_comments, :author_id

    Comment.all.each do |c|
      if c.commentable_type == 'User'
        UserComment.create!(comment: c.comment, author_id: c.author_id, user_id: c.user_id)
      else
        GoalComment.create!(comment: c.comment, author_id: c.author_id, gaol_id: c.goal_id)
      end
    end

    Comment.destroy_all
  end
end
