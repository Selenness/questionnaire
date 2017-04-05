class RenameBestAnswerToBest < ActiveRecord::Migration[5.0]
  def change
    rename_column :answers, :best_answer, :best
  end
end
