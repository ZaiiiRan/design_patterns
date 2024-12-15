class StudentsController < ApplicationController
  attr_accessor :page, :per_page, :students, :total_pages, :query
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
