class ChangeStatusInUserFromStringToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :status, 'integer USING CAST(status AS integer)'
  end
end
