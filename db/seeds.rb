# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Initialize IEX client
client = IEX::Api::Client.new

# Get all stocks
# symbols = client.ref_data_symbols()
# all_stocks = symbols.map{ |obj| {name: obj.name, code: obj.symbol} }
# nyse_arca = symbols.select{ |obj| obj.exchange_name == "Nyse Arca" }
# nyse_stocks = nyse_arca.map{ |obj| {name: obj.name, code: obj.symbol} }

# Get top 100 most active stocks
top20_stocks = client.stock_market_list(:mostactive, :listLimit => 20)
stocks = top20_stocks.map{ |obj| {name: obj.company_name, code: obj.symbol, price: obj.latest_price} }

stocks.each do |stock|
    stock_params = {
        name: stock[:name],
        code: stock[:code],
        price: stock[:price],
        logo_url: client.logo(stock[:code]).url,
        chart: client.chart(stock[:code])
    }
    Stock.create(stock_params)
end