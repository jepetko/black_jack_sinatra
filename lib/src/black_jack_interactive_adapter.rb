module BlackJack::Interactive

  # log the text said in a buffer
  attr_accessor :text_buff

  def say(text)
    if @text_buff.nil?
      @text_buff = []
    end
    @text_buff << text
  end

  def ask_for_number_of_players
    '3'
  end

  def ask_for_the_player_name
    @counter ||= 0
    name = ''
    case @counter
      when 0
        name = 'Ramin'
      when 1
        name = 'Kati'
      when 2
        name = 'Juje'
    end
    @counter = @counter + 1
    name
  end
end