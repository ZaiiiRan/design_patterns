require_relative './modal_interface.rb'
require_relative '../text_field.rb'

class Modal
  include Modal_interface
  attr_accessor :title, :error_msg, :fields_titles, :ok_btn

  def initialize(title)
    self.title = title
    self.ok_btn = false
  end

  def setup_form(labels)
    self.fields = {}
    self.fields_titles = {}

    labels.each do |field_name, label_text|
      self.fields[field_name] = Text_field.new
      self.fields_titles[field_name] = label_text
    end
  end

  def show_error_message(message)
    self.error_msg = message
  end

  def update_view(data)
    data.each do |field_name, value|
      self.fields[field_name].text = value
    end
  end

  def enable_ok_btn
    data = self.fields.transform_values(&:text)
    self.ok_btn = self.presenter.valid_data?(data)
  end

  def operation
    data = self.fields.transform_values(&:text)
    self.presenter.operation(data)
  end

  def close
    # в вебе не нужно
  end
end