module Base_view_interface
  attr_accessor :presenter, :current_page, :total_pages, :filters
  attr_reader :rows_per_page

  def show_error(message)
    raise NotImplementedError
  end

  def update_view(data)
    raise NotImplementedError
  end

  def update_button_states
    raise NotImplementedError
  end

  protected
  attr_writer :rows_per_page
end