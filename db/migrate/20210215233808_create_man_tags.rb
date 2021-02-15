class CreateManTags < ActiveRecord::Migration[6.0]
  def change
    create_table :man_tags do |t|

      t.timestamps
    end
  end
end
