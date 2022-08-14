class AddLogoUrlToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :logo_url, :string
  end
end
