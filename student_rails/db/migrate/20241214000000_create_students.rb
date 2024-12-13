class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :name, null: false
      t.string :patronymic, null: false
      t.string :telegram, unique: true
      t.string :email, unique: true
      t.string :phone_number, unique: true
      t.string :git, unique: true
      t.date :birthdate, null: false

      t.timestamps
    end
  end
end
