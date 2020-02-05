class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.references :camp, foreign_key: true
      t.references :student, foreign_key: true
      t.string :payment

      # t.timestamps
    end
  end
end
