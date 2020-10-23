require_relative '../lib/player'

describe 'player' do
	it 'has attributes' do
		player = Player.new(firstname: 'Bob', lastname: 'Smith', nickname: 'Smokin', age: 40, rank: 10)

		expect(player.firstname).to eq('Bob')
		expect(player.lastname).to eq('Smith')
		expect(player.nickname).to eq('Smokin')
		expect(player.age).to eq(40)
		expect(player.rank).to eq(10)
	end
end