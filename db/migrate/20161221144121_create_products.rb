class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 8, scale: 2
      t.string :asin
      t.string :color
      t.string :department
      t.text :description
    end
  end
end
