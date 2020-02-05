class CreateInstructors < ActiveRecord::Migration[5.1]
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name
      t.text :bio
      t.references :user, foreign_key: true
      t.boolean :active, default: true

      # t.timestamps
    end
  end
end
