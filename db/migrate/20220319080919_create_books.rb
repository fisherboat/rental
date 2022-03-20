class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :name, null: false, index: true
      t.integer :borrow_times, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.integer :repay_times, null: false, default: 0
      t.decimal :price, precision: 10, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
