require_relative '../lib/player'

describe 'Player' do
	let(:target) { double() }
	let(:player) { Player.new(target) }

	describe '#punch?' do
		context 'when player is in a match' do
			before { allow(target).to receive(:punch).with(true).and_return(hit) }

			context 'when Target is hit' do
				let(:hit) { true }

				it 'returns true' do
					expect(player.punch?(true)).to eq(true)
				end
			end

			context 'when Target is missed' do
				let(:hit) { false }

				it 'returns false' do
					expect(player.punch?(true)).to eq(false)
				end
			end
		end

		context 'when player is training' do
			before { allow(target).to receive(:punch).with(false).and_return(hit) }
			
			context 'when Target is hit' do
				let(:hit) { true }

				it 'returns true' do
					expect(player.punch?).to eq(true)
				end
			end

			context 'when Target is missed' do
				let(:hit) { false }

				it 'returns false' do
					expect(player.punch?).to eq(false)
				end
			end
		end
	end
end