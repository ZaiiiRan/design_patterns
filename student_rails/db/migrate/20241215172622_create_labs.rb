class CreateLabs < ActiveRecord::Migration[6.1]
  def change
    create_table :labs do |t|
      t.string :name, null: false, unique: true
      t.string :topics
      t.string :tasks
      t.date :date_of_issue, null: false
      t.timestamps
    end
  end
end
