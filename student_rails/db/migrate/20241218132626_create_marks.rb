class CreateMarks < ActiveRecord::Migration[6.1]
  def change
    create_table :marks do |t|
      t.references :student, null: false, foreign_key: true
      t.references :lab, null: false, foreign_key: true
      t.string :grade, null: false
      t.date :due_date, null: false
      t.string :comment, limit: 100
      t.text :justification, limit: 1000
      t.boolean :final, default: false, null: false

      t.timestamps
    end
  end
end
