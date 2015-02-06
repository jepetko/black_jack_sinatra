class Card
  attr_accessor :type
  attr_accessor :default_value
  def initialize(type,default_value=type)
    self.type = type
    self.default_value = default_value
  end

  def value
    if block_given?
      yield self
    else
      default_value
    end
  end

  def ace?
    self.type == 'Ace'
  end
end