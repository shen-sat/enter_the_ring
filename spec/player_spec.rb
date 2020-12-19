require_relative '../lib/player'

describe 'Player' do
	let(:target) { double() }
	let(:player) { Player.new(target) }

	describe '#punch?' do
		context 'when Target is hit' do
			before { allow(target).to receive(:punch).and_return(true) }

			it 'returns true' do
				expect(player.punch?).to eq(true)
			end
		end

		context 'when Target is missed' do
			before { allow(target).to receive(:punch).and_return(false) }

			it 'returns false' do
				expect(player.punch?).to eq(false)
			end
		end
	end
end