require_relative '../src/player.rb'
require_relative '../src/support/object_to_hash_serialization_support.rb'

describe 'ObjectToHashSerializationSupport' do

  before(:each) do
    @player = Player.new('PLAYER')
    @player.draw Card.new('10')
    class << @player
      include ObjectToHashSerializationSupport
    end
  end

  it 'should convert the object to a hash' do
    hash = @player.as_hash

    expected_hash = {:name => 'PLAYER', :dealer => false, :cards => [{:type => '10', :default_value => '10'}]}
    expect(hash).to eq(expected_hash)
  end

end