class ChangePriceToBeFloatInStocks < ActiveRecord::Migration[7.0]
  def change
    change_column :stocks, :price, :float
  end
end
