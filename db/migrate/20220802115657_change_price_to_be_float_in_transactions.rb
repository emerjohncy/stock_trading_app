class ChangePriceToBeFloatInTransactions < ActiveRecord::Migration[7.0]
  def change
    change_column :transactions, :price, :float
  end
end
