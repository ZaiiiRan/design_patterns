class StudentShort
include Person
  include ActiveModel::Model
  attr_accessor :full_name, :contact, :id, :git

  def self.new_from_student_obj(student)
    StudentShort.new(
      id: student.id,
      full_name: student.get_full_name,
      git: student.git,
      contact: student.get_any_contact
    )
  end

  def self.new_from_string(string)
    data = parse_string(string)
    contact = data["telegram"] || data["email"] || "phone_number: #{data["phone_number"]}"
    StudentShort.new(
      id: data["id"].to_i,
      full_name: data["full_name"],
      git: data["git"],
      contact: contact
    )
  end

  def validate_contacts?
    contact.present?
  end
end
