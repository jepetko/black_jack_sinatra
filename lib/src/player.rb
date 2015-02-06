require_relative './card'

class Player
  module Interactive
    def say(text)
      puts text
    end
    def draw?
      say 'Draw a card?'
      answer = gets.chomp.upcase.start_with? 'Y'
      if !answer
        say 'You stay.'
      end
      answer
    end
  end
  include Interactive

  attr_accessor :name
  attr_accessor :cards

  def initialize(name, dealer=false)
    @name = name
    @dealer = dealer
  end

  private
  def total
    return 0 if @cards.nil?
    total = 0
    @cards.each do |c|
      total += c.value
    end
    total
  end

  public
  def dealer?
    @dealer
  end

  def draw(card)
    @cards = [] if @cards.nil?
    @cards << card
  end

  def drawn_cards_as_str
    str = ''
    @cards.each do |c|
      str << " [ #{c.type} ] "
    end
    str
  end

  def should_draw?
    if dealer?
      !should_stay?
    else
      draw?
    end
  end

  def sum
    t = total
    if t > 21
      t = 0
      @cards.each do |c|
        if c.ace?
          t += c.value {1}
        else
          t += c.value
        end
      end
    end
    t
  end

  def busted?(&when_busted)
    s = sum
    busted = s > 21
    if busted && !when_busted.nil?
      when_busted.call s
    end
    busted
  end

  def should_stay?
    dealer? && sum >= 17
  end
end