class CreateUserVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_votes do |t|
      t.references :user, foreign_key: true
      t.integer :votable_id
      t.string :votable_type

      t.timestamps
    end
    add_index :user_votes, :votable_id
  end
end
