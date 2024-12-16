class StudentsController < ApplicationController
  attr_accessor :page, :per_page, :students, :total_pages, :query, :student
  before_action :set_student, only: %i[update show]
  def index
    self.page = (params[:page] || 1).to_i
    self.per_page = 10

    self.query = Student.all
    self.apply_filters
    self.apply_sort

    self.students = query.offset((self.page - 1) * self.per_page).limit(self.per_page)
    self.total_pages = (query.count / self.per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
  end

  def create
    self.student = Student.new(student_params)
    if self.student.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: self.student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: self.student
  end

  def update
    if no_data_changes?
      render json: { success: false, errors: "Данные не были изменены" }, status: :unprocessable_entity
      return
    end

    if self.student.update(student_params)
      render json: { success: true }
    else
      render json: { success: false, errors: self.student.errors }, status: :unprocessable_entity
    end
  end

  def delete_multiple
    student_ids = params[:student_ids]
    if student_ids.nil? || student_ids.empty?
      render json: { error: "Ни одного студента не выбрано" }, status: :unprocessable_entity
      return
    end

    Student.where(id: student_ids).destroy_all

    render json: { message: "Студенты удалены" }, status: :ok
  end

  private

  # set student
  def set_student
    self.student = Student.find(params[:id])
  end

  # student params
  def student_params
    params.require(:student).permit(:first_name, :name, :patronymic, :birthdate, :git, :telegram, :email, :phone_number)
  end

  # apply_filters
  def apply_filters
    if params[:full_name].present?
      self.query = self.query.where("CONCAT(LOWER(first_name), ' ', LOWER(SUBSTR(name, 1, 1)), '.', LOWER(SUBSTR(patronymic, 1, 1)), '.') LIKE ?",
        "%#{params[:full_name]}%")
    end

    apply_field_filter(:git, params[:git], params[:git_value])
    apply_field_filter(:email, params[:email], params[:email_value])
    apply_field_filter(:phone_number, params[:phone], params[:phone_value])
    apply_field_filter(:telegram, params[:telegram], params[:telegram_value])
  end

  # apply_field_filter
  def apply_field_filter(field, param_value, param_value_field)
    return if param_value.nil? || param_value == "nil"

    if param_value == "yes"
      if param_value_field.present?
        self.query = self.query.where("#{field} LIKE ?", "%#{param_value_field}%")
      else
        self.query = self.query.where("#{field} IS NOT NULL AND #{field} != ''")
      end
    elsif param_value == "no"
      self.query = self.query.where(field => nil)
    end
  end

  # apply sort
  def apply_sort
    sort_column = params[:sort_column] || "id"
    sort_order = params[:sort_order] || "asc"

    if sort_column == "contact"
      sort_column = "telegram, email, phone_number"
    end

    if sort_column == "telegram, email, phone_number"
      self.query = self.query.order(Arel.sql("
        COALESCE(telegram, '') = '',
        COALESCE(email, '') = '',
        COALESCE(phone_number, '') = '',
        #{sort_column} #{sort_order}
      "))
    else
      self.query = self.query.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_order}"))
    end
  end

  # check no data changes
  def no_data_changes?
    fields = %i[first_name name patronymic birthdate git telegram email phone_number]

    fields.all? do |field|
      next true if self.student_params[field].nil?
      new_value = field == :birthdate ? Date.parse(student_params[:birthdate]) : student_params[field]
      new_value == self.student.public_send(field)
    end
  end
end
