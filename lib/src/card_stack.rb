require_relative './card'

class CardStack
  BASIC_STACK = []

  attr_accessor :stack

  protected
  def initialize_basic_stack
    4.times do
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
  end

  public
  def initialize(packages_count=1)
    packages_count.times { self.initialize_basic_stack }
    @stack = BASIC_STACK.shuffle
  end

  def give
    return nil if @stack.nil?
    return nil if @stack.empty?
    @stack.pop
  end
end