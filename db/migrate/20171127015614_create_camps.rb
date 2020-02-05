class CreateCamps < ActiveRecord::Migration[5.1]
  def change
    create_table :camps do |t|
      t.references :curriculum, foreign_key: true
      t.references :location, foreign_key: true
      t.float :cost
      t.date :start_date
      t.date :end_date
      t.string :time_slot
      t.integer :max_students
      t.boolean :active, default: true

      # t.timestamps
    end
  end
end
