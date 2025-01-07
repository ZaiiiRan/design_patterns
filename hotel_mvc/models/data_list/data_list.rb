require_relative '../../modules/deep_dup/deep_dup.rb'

class Data_list
  include Deep_dup

  attr_accessor :index, :count

  def initialize(elements)
    self.data = elements
    self.selected = []
    self.index = 1
    self.observers = []
  end

  def select(number)
    raise IndexError, 'Индекс не корректен' unless valid_index?(number)
    self.selected << number unless self.selected.include?(number)
  end

  def get_selected
    ids = []
    self.selected.each do |key|
      ids << self.data[key].id
    end
    ids
  end

  def get_selected_nums
    self.selected
  end

  def deselect
    self.selected.delete(number) if self.selected.include?(number)
  end

  def clear_selected
    self.selected = []
  end

  def get_table
    result = self.get_data
    Data_table.new(result)
  end

  def get_names
    raise NotImplementedError 'Not implemented'
  end

  def get_data()
    result = []
    self.data.each do |key, value|
      row = build_row(key, value)
      result << row
    end
    result
  end

  def data=(data)
    @data = {}
    data.each do |element|
      @data[index] = deep_dup(element)
      self.index += 1
    end
    notify
  end

  def notify
    observers.each do |observer|
      observer.set_table_params(self.get_names, self.count)
      observer.set_table_data(self.get_table)
    end unless observers.nil?
  end

  def add_observer(observer)
    self.observers << observer
  end

  protected
  attr_reader :data
  attr_accessor :selected, :observers

  def valid_index?(index)
    self.data.key?(index)
  end

  def build_row(index, obj)
    raise NotImplementedError, 'Not implemented'
  end
end