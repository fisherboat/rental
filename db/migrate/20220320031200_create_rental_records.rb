class CreateRentalRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :rental_records do |t|
      t.references :book, null: false
      t.references :user, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.00
      t.string :kind, index: true

      t.timestamps
    end
  end
end
