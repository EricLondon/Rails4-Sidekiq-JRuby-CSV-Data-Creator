class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :person, null: false, index: true, foreign_key: true
    end
  end
end
