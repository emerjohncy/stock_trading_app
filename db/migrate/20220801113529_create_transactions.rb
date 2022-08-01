class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.text :action
      t.text :status
      t.decimal :price
      t.integer :units

      t.timestamps
    end
  end
end
