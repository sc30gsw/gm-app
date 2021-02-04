class CreateMen < ActiveRecord::Migration[6.0]
  def change
    create_table :men do |t|

      t.timestamps
    end
  end
end
