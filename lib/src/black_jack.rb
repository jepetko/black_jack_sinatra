require_relative './player'
require_relative './card_stack'

class BlackJack

  module Interactive
    def say(text)
      puts text
    end
    def ask_for_number_of_players
      gets.chomp
    end
    def ask_for_the_player_name
      gets.chomp
    end
    def kick_off?
      say 'Welcome to Black Jack. Have fun.'
      say 'Give the number of players at the table:'
      num_of_players = ask_for_number_of_players
      if !num_of_players.match(/^[0-9]+$/).nil?
        num_of_players.to_i.times do |i|
          say "Player ##{i+1}:"
          players << Player.new(ask_for_the_player_name)
        end
      else
        say 'The number of players is not valid.'
      end
      !players.empty?
    end
    def print_results(&players_score)
      (players + [dealer]).each_with_index do |player,idx|
        say "##{idx+1} #{player.name}: #{players_score.call(player)}"
      end
    end
    def print_winner(winner)
      if winner.nil?
        say '-+-+-+-+-+-+ Winner is no one. -+-+-+-+-+-+'
      else
        say "-+-+-+-+-+-+ Winner is #{winner.name}. -+-+-+-+-+-+"
      end
    end
  end

  module BusinessLogic
    module PlayerIterator
      def all_players
        players + [dealer]
      end
      def next_player(accept_player_block)

        all = all_players
        @current_player_idx ||= -1

        idx = @current_player_idx
        loop do
          if idx >= all.length-1
            # fix endless loop
            return nil if @current_player_idx == -1
            idx = 0
          else
            idx += 1
          end
          #there is no available player anymore..everyone busted?
          if idx == @current_player_idx
            return nil
          end
          if accept_player_block.call(all[idx])
            @current_player_idx = idx
            return all[idx]
          end
        end
        nil
      end
    end
    include PlayerIterator

    def handle_player(player)
      loop do
        say player.drawn_cards_as_str
        break if !player.should_draw?
        card = stack.give
        say "Your card is: [ #{card.type} ]"
        player.draw(card)
        break if player.busted? {|sum| say ".. #{player.name}, you are busted! Your sum: #{sum}."}
      end
    end


    def won?(player)
      player.sum == 21 && !detect_winner.nil?
    end

    def detect_winner
      eligible_players = all_players.select { |p| !p.busted?}
      sorted = eligible_players.sort do |p1,p2|
        p1.sum - p2.sum
      end
      len = sorted.length
      # tie
      if len > 1
        return nil if sorted.last.sum == sorted[sorted.length-2].sum
      end
      sorted.last
    end

    def play
      # give everyone two cards
      say '*********************************'
      say 'Giving cards:'
      2.times do
        all_players.each do |player|
          card = stack.give
          player.draw card
        end
        print_results {|player| player.sum}
      end
      say '*********************************'

      loop do
        if dealer.busted?
          say "Dealer lost! Dealer's score: #{dealer.sum}"
          say 'Here are the final results:'
          print_results {|player| player.sum}
          break
        elsif won?(dealer)
          say "Dealer won! Dealer's score: #{dealer.sum}"
          break
        elsif dealer.should_stay?
          say "Dealer's limit reached: #{dealer.sum}"
          say 'Here are the final results:'
          print_results {|player| player.sum}
          break
        else
          # detect the next player. Player can be asked:
          # a) if he is not busted
          # b) if he is not the *dealer* whose score >= 17 (then he must stay)
          accept_player = lambda {|player|
            if player.busted?
              return false
            else
              if player.dealer?
                return !player.should_stay?
              end
            end
            true
          }
          player = next_player accept_player
          say '*********************************'
          say "Dear #{player.name}, you are the next player."
          handle_player player
        end
      end
      print_winner detect_winner
    end
  end

  include Interactive
  include BusinessLogic

  attr_accessor :dealer
  attr_accessor :players
  attr_accessor :stack

  def initialize
    @dealer = Player.new '<DEALER>',true
    @players = []
    @stack = CardStack.new
  end

  def start
    if kick_off?
      play
    end
  end

end