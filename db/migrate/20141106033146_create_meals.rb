class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :confirmation_id
      t.text :url

      t.timestamps
    end
  end
end
