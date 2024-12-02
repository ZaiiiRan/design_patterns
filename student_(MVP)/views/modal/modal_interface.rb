module Modal_interface
  attr_accessor :fields, :presenter

  def show_error(message)
    raise NotImplementedError
  end

  def update_view
    raise NotImplementedError
  end

  protected
  attr_accessor :ok_btn
end