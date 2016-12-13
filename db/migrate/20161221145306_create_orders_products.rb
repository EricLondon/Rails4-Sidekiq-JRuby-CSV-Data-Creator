class CreateOrdersProducts < ActiveRecord::Migration
  def change
    create_table :orders_products do |t|
      t.references :order, null: false, index: true, foreign_key: true
      t.references :product, null: false, index: true, foreign_key: true
    end
  end
end
