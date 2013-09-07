class CreateSupplier < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.text :contact_info
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
