class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.integer :owner_id, index: true, null: false
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.text :description

      t.timestamps
    end
  end
end
