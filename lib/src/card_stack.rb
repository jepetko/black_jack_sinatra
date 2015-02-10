require_relative './card'

class CardStack
  BASIC_STACK = []

  attr_accessor :stack

  protected
  def initialize_basic_stack
    if BASIC_STACK.empty?
      (2..10).each do |n|
        BASIC_STACK << Card.new(n)
      end
      BASIC_STACK << Card.new('Jack',10)
      BASIC_STACK << Card.new('Queen',10)
      BASIC_STACK << Card.new('King',10)
      BASIC_STACK << Card.new('Ace',11)
    end
  end

  public
  def initialize
    initialize_basic_stack
    @stack = []
    Card::CARD_SORTS.each do |sort|
      BASIC_STACK.each do |card|
        card_copy = card.clone
        card_copy.sort = sort
        @stack << card_copy
      end
    end
    @stack.shuffle!
  end

  def give
    return nil if @stack.nil?
    return nil if @stack.empty?
    @stack.pop
  end

  def empty?
    @stack.empty?
  end
end