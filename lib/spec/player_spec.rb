require_relative '../src/player.rb'

describe 'Player' do

  before(:each) do
    module Player::Interactive
      def draw?
        true
      end
    end
  end

  before(:each) do
    @dealer = Player.new 'Dealer', true
    @players = []
    3.times { |i| @players << Player.new("Player #{i}")}
  end

  context 'for dealer' do
    it 'should_draw? returns true if the dealer has less than 17 points' do
      @dealer.draw Card.new(10)
      @dealer.draw Card.new(6)
      expect(@dealer.should_draw?).to be(true)
    end

    it 'should_draw? returns false if the dealer has more than 17 points' do
      @dealer.draw Card.new(10)
      @dealer.draw Card.new(6)
      @dealer.draw Card.new(2)
      expect(@dealer.should_draw?).to be(false)
    end
  end

  context 'for the player' do

    before(:each) do
      @p = @players.first
    end

    it 'should_draw? returns true if the player says YES' do
      expect(@players.first.should_draw?).to be(true)
    end

    describe 'SUM computation' do

      before(:each) do
        @p.draw Card.new(4)
        @p.draw Card.new(10)
      end

      it 'computes the sum of all cards' do
        expect(@p.sum).to be(14)
      end

      context 'when there is an ace and the 21 points mark is exceeded' do
        it 'counts an ace card as 1 (one) point' do
          @p.draw Card.new('Ace', 1)
          expect(@p.sum).to be(15)
        end
      end

    end

    describe 'busted? method' do
      it 'returns true if the SUM is greater than 21' do
        @p.draw Card.new(2)
        @p.draw Card.new(10)
        @p.draw Card.new('King',10)

        expect(@p.busted?).to be(true)
      end
    end

  end
end