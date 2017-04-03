class RemoveBestAnswerIdFromQuestion < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :best_answer_id
  end
end
