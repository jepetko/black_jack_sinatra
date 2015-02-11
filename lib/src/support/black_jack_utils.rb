class BlackJackUtils

  def self.create_game!(session)
    if session[:name].nil?
      raise 'session[:name] must not be nil'
    end
    if session[:black_jack].nil?
      raise 'session[:black_jack] must not be nil'
    end
    black_jack = BlackJack.new
    session[:black_jack] = black_jack
    black_jack.kick_off? { session[:name] }
  end

  def self.get_game_state_as_hash(session)
    if session[:black_jack].nil?
      raise 'session[:black_jack] must not be nil'
    end
    black_jack = session[:black_jack]
    if black_jack.check_done_conditions == true
      winner = black_jack.detect_winner
      if winner.nil?
        return {:state => 'done', :winner => nil}
      else
        return {:state => 'done', :winner => winner.as_hash}
      end
    end
    {:state => 'running'}
  end

  def self.get_players_as_hash(session)
    if session[:black_jack].nil?
      raise 'session[:black_jack] must not be nil'
    end
    black_jack = session[:black_jack]
    done = black_jack.check_done_conditions

    all_players = black_jack.players + [black_jack.dealer]
    hash = all_players.as_hash
    all_players.each_with_index do |p,idx|
      hash[idx][:busted] = p.busted?
      hash[idx][:winner] = done ? black_jack.won?(p) : false
      hash[idx][:sum] = p.sum
    end
    hash.to_json
  end

end