class AddChartToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :chart, :string
  end
end
