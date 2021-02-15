class CreateManTags < ActiveRecord::Migration[6.0]
  def change
    create_table :man_tags do |t|
      t.references :man, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
  end
end
