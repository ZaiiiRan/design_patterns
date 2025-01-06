class MarksController < BaseController
  attr_accessor :page, :per_page, :total_pages, :query
  def index
    self.page = (params[:page] || 1).to_i
    self.per_page = 10

    self.query = Student.all

    self.entities = query.offset((self.page - 1) * self.per_page).limit(self.per_page)
    self.total_pages = (query.count / self.per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
  end
end
