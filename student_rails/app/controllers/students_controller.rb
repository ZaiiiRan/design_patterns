class StudentsController < BaseController
  attr_accessor :page, :per_page, :total_pages, :query
  def index
    self.page = (params[:page] || 1).to_i
    self.per_page = 10

    self.query = Student.all
    self.apply_filters
    self.apply_sort

    self.entities = query.offset((self.page - 1) * self.per_page).limit(self.per_page)
    self.total_pages = (query.count / self.per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
  end

  def create
    self.entity = Student.new(entity_params)
    super
  end

  def delete_multiple
    student_ids = params[:student_ids]
    if student_ids.nil? || student_ids.empty?
      render_error("Ни одного студента не выбрано")
      return
    end

    Student.where(id: student_ids).destroy_all

    render json: { message: "Студенты удалены" }, status: :ok
  end


  private
  # set entity
  def set_entity
    self.entity= Student.find(params[:id])
  end

  # entity params
  def entity_params
    params.require(:student).permit(:first_name, :name, :patronymic, :birthdate, :git, :telegram, :email, :phone_number)
  end

  # check no data changes
  def no_data_changes?
    fields = %i[first_name name patronymic birthdate git telegram email phone_number]

    fields.all? do |field|
      next true if self.entity_params[field].nil?
      new_value = field == :birthdate ? Date.parse(entity_params[:birthdate]) : entity_params[field]
      new_value == self.entity.public_send(field)
    end
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
end
