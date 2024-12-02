module View_interface
  def show_error(message)
    raise NotImplementedError
  end

  def update_view(data)
    raise NotImplementedError
  end
  
  attr_accessor :presenter
end