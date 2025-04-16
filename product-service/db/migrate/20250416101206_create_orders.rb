class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, index: true, null: false
      t.decimal :total, precision: 10, scale: 2
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
