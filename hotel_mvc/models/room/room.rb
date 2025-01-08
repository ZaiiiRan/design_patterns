class Room
  attr_reader :number, :capacity, :price
  attr_accessor :id

  def initialize(number:, capacity:, price:, id: nil)
    self.number = number
    self.capacity = capacity
    self.price = price
    self.id = id
  end

  def self.new_from_hash(hash)
    self.new(**hash.transform_keys(&:to_sym))
  end

  def self.valid_number?(number)
    number.to_s =~ /^\d{2,}$/
  end

  def self.valid_capacity?(capacity)
    capacity.between?(1, 5)
  end

  def self.valid_price?(price)
    if price.to_i < 0
      false
    end
    true
  end

  private
  def number=(number)
    unless self.class.valid_number?(number)
      raise ArgumentError, "Неверный формат номера комнаты"
    end
    @number = number.to_s
  end

  def capacity=(capacity)
    unless self.class.valid_capacity?(capacity)
      raise ArgumentError, "Комната должна вмещать не более 5 человек, а также это число не должно быть отрицательным"
    end
    @capacity = capacity.to_i
  end

  def price=(price)
    unless self.class.valid_price?(price)
      raise ArgumentError, "Цена не может быть отрицательной"
    end
    @price = price.to_i
  end
end