class AddProToUserVote < ActiveRecord::Migration[5.0]
  def change
    add_column :user_votes, :pro, :integer, null: false
  end
end
