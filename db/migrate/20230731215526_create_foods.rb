class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.string :measurement_unit
      t.decimal :price, precision: 10, scale: 2
      t.decimal :quantity, limit: 5, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
