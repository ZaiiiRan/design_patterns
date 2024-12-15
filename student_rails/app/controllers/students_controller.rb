class StudentsController < ApplicationController
  attr_accessor :page, :per_page, :students, :total_pages
  def index
    self.page = (params[:page] || 1).to_i
    self.per_page = 10
    self.students = Student.all.offset((@page - 1) * @per_page).limit(@per_page)
    self.total_pages = (Student.count / @per_page.to_f).ceil
  end
end
