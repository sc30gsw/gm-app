class CreateMen < ActiveRecord::Migration[6.0]
  def change
    create_table :men do |t|
      t.string :name, null: false
      t.text :content
      t.integer :category_id, null: false
      t.string :address, null: false
      t.float :latitude, null: false
      t.float :longtude, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
