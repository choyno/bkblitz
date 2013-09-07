class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :name
      t.decimal :wholesale_price, precision: 8, scale: 2
      t.decimal :retail_price, precision: 8, scale: 2
      t.text :description
      t.references :supplier

      t.timestamps
    end
  end
end
