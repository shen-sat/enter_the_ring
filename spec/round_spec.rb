require_relative '../lib/round'
require_relative '../lib/fighter'
require_relative '../lib/commentary'

describe 'Round' do
	let(:fighter_a) { instance_double(Fighter) }
	let(:fighter_b) { instance_double(Fighter) }
	let(:commentary) { instance_double(Commentary) }
	
	let(:round) { Round.new(fighter_a, fighter_b, commentary) }

	describe '#check_for_pressor' do
		context 'when fighter_a presses' do
			before { allow(fighter_a).to receive(:press?).and_return(true) }

			context 'when fighter_b presses' do
				before { allow(fighter_b).to receive(:press?).and_return(true) }

				it 'returns a fighter at random' do
					srand 0

					expect(round.check_for_pressor).to eq(fighter_a)
				end
			end
			context 'when fighter_b does not press' do
				before { allow(fighter_b).to receive(:press?).and_return(false) }

				it 'returns fighter_a' do
					expect(round.check_for_pressor).to eq(fighter_a)
				end
			end
		end
		context 'when fighter_a does press' do
			before { allow(fighter_a).to receive(:press?).and_return(false) }

			context 'when fighter_b presses' do
				before { allow(fighter_b).to receive(:press?).and_return(true) }

				it 'returns fighter_b' do
					expect(round.check_for_pressor).to eq(fighter_b)
				end
			end
			context 'when fighter_b does not press' do
				before { allow(fighter_b).to receive(:press?).and_return(false) }

				it 'returns nil' do
					expect(round.check_for_pressor).to eq(nil)
				end
			end
		end
	end
end