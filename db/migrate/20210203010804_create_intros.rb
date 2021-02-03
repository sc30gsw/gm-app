class CreateIntros < ActiveRecord::Migration[6.0]
  def change
    create_table :intros do |t|
      t.text :profile
      t.string :website
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
