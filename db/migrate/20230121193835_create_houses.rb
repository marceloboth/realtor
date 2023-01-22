class CreateHouses < ActiveRecord::Migration[7.0]
  def change
    create_table :houses do |t|
      t.integer :bathrooms
      t.integer :bedrooms
      t.decimal :price
      t.string :address
      t.string :real_state
      t.string :origin_url
      t.string :image

      t.timestamps
    end
  end
end
