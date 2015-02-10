class Card
  CARD_SORTS = [:clubs, :diamonds, :hearts, :spades]

  attr_accessor :type
  attr_accessor :sort
  attr_accessor :default_value

  def initialize(type,sort=nil,default_value=type)
    self.type = type
    self.sort = sort
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