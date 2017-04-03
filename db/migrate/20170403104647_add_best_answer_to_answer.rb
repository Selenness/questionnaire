class AddBestAnswerToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best_answer, :boolean
  end
end
