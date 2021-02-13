class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :man_id
      t.integer :comment_id
      t.string :action, default: '', null: false
      t.boolean :cheked, default: false, null: false
      t.timestamps
    end
  end
end
