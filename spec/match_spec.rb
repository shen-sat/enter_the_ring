require_relative '../lib/match'

describe 'Match' do
	let(:commentary) { double() }
	let(:player) { double('player') }
	let(:opponent) { double('opponent') }
	let(:match) { Match.new(commentary, player, opponent) }

	describe 'attributes' do
		it 'has correct values' do
			expect(match.moments).to eq(6)

			punch_data = { punch: false, block_punch: false, counter: 1 }
			expect(match.punch_data.first).to eq(punch_data.merge(fighter: player))
			expect(match.punch_data.last).to eq(punch_data.merge(fighter: opponent))
		end
	end

	describe '#something_happens?' do
		let(:punch_set_to_true) { { punch: true, block_punch: false, counter: 1 } }
		let(:punch_set_to_false) { { punch: false, block_punch: false, counter: 1 } }

		before do 
			allow(match).to receive(:sleep)
			allow(match).to receive(:decide_punches)
		end

		context 'when player punch is true' do
			before { match.instance_variable_set(:@punch_data, [punch_set_to_true, punch_set_to_false] ) }

			it 'returns true' do
				expect(match.something_happens?).to eq(true)
			end
		end

		context 'when opponent punch is true' do
			before { match.instance_variable_set(:@punch_data, [punch_set_to_false, punch_set_to_true] ) }

			it 'returns true' do
				expect(match.something_happens?).to eq(true)
			end
		end

		context 'when player and opponent punch are false' do
			context 'when die roll is >= 5' do
				before { allow(match).to receive(:roll_die).and_return(5) }
				
				it 'returns true' do
					expect(match.something_happens?).to eq(true)
				end
			end

			context 'when die roll is <= 4' do
				before { allow(match).to receive(:roll_die).and_return(4) }
				
				it 'returns false' do
					expect(match.something_happens?).to eq(false)
				end
			end
		end
	end

	describe '#encounter' do
		let(:player_punch_data) { { fighter: player, punch: player_punch, block_punch: false, counter: 1 } }
		let(:opponent_punch_data) { { fighter: opponent, punch: opponent_punch, block_punch: false, counter: 1 } }

		before do
			allow(match).to receive(:sleep)

			match.instance_variable_set(:@punch_data, [player_punch_data, opponent_punch_data])
		end

		context 'when player has punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { false }

			it 'calls commentary with correct params' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
				expect(commentary).to receive(:action).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

				match.encounter
			end
		end

		context 'when opponent has punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { true }

			it 'calls commentary with correct params' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
				expect(commentary).to receive(:action).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

				match.encounter
			end
		end

		context 'when both fighters have punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { true }

			it 'calls commentary with correct params twice for prelude and twice for action' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
				expect(commentary).to receive(:action).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
				expect(commentary).to receive(:action).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

				match.encounter 
			end
		end

		context 'when no fighters have punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { false }

			before { allow(match).to receive(:pick_pressing_fighter).and_return(opponent) }

			it 'calls commentary with correct params once for prelude and once for action' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once
				expect(commentary).to receive(:action).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

				match.encounter 
			end
		end
	end

	describe '#decide_punches during a game loop'
		let(:player_punch_data) { match.punch_data.first }

		context 'when roll_die returns only 3' do
			before { allow(match).to receive(:roll_die).and_return(3) }
				it 'goes through game loop' do
					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(false)
					expect(player_punch_data[:block_punch]).to eq(false)
					expect(player_punch_data[:counter]).to eq(2)

					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(false)
					expect(player_punch_data[:block_punch]).to eq(false)
					expect(player_punch_data[:counter]).to eq(3)									

					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(true)
					expect(player_punch_data[:block_punch]).to eq(true)
					expect(player_punch_data[:counter]).to eq(4)

					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(false)
					expect(player_punch_data[:block_punch]).to eq(true)
					expect(player_punch_data[:counter]).to eq(5)

					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(false)
					expect(player_punch_data[:block_punch]).to eq(true)
					expect(player_punch_data[:counter]).to eq(6)

					match.send(:decide_punches)

					expect(player_punch_data[:punch]).to eq(false)
					expect(player_punch_data[:block_punch]).to eq(false)
					expect(player_punch_data[:counter]).to eq(1)
				end
		end
		context 'when roll_die returns only 6' do
			before { allow(match).to receive(:roll_die).and_return(6) }

			it 'goes through game loop' do
				match.send(:decide_punches)
				
				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(2)

				match.send(:decide_punches) #3
				match.send(:decide_punches) #4
				match.send(:decide_punches) #5
				match.send(:decide_punches) #6

				match.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(true)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(1)

				match.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(2)
			end
		end
end