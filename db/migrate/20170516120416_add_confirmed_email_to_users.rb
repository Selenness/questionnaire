class AddConfirmedEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmed_email, :boolean
  end
end
