class CreateCampInstructors < ActiveRecord::Migration[5.1]
  def change
    create_table :camp_instructors do |t|
      t.references :camp, foreign_key: true
      t.references :instructor, foreign_key: true

      # t.timestamps
    end
  end
end
