require_relative '../lib/match'

describe 'Match' do
	let(:commentary) { double() }
	let(:target) { double() }
	let(:player) { double('player') }
	let(:opponent) { double('opponent') }
	let(:match) { Match.new(commentary, target, player, opponent) }

	describe 'attributes' do
		it 'has correct values' do
			expect(match.moments).to eq(10)
			expect(match.ambient_action_score).to eq(4)

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
			context 'when die roll is >= ambient_action_score' do
				before { allow(match).to receive(:roll_die).and_return(match.ambient_action_score) }
				
				it 'returns true' do
					expect(match.something_happens?).to eq(true)
				end
			end

			context 'when die roll is <= 4' do
				before { allow(match).to receive(:roll_die).and_return(match.ambient_action_score - 1) }
				
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
			allow(target).to receive(:punch)

			match.instance_variable_set(:@punch_data, [player_punch_data, opponent_punch_data])
		end

		context 'when player has punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { false }

			it 'calls prelude commentary with correct params' do
				allow(commentary).to receive(:postlude)

				expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

				match.encounter
			end
			context 'when player hits target' do
				before { allow(target).to receive(:punch).and_return(true) }

				it 'calls postlude commentary with correct params' do
					allow(commentary).to receive(:prelude)

					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

					match.encounter
				end
			end
			context 'when player misses target' do
				before { allow(target).to receive(:punch).and_return(false) }

				it 'calls postlude commentary with correct params' do
					allow(commentary).to receive(:prelude)

					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: false).once

					match.encounter
				end
			end
		end

		context 'when opponent has punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { true }

			it 'calls commentary with correct params' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
				expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

				match.encounter
			end
		end

		context 'when both fighters have punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { true }

			context 'when player hits target' do
				before { allow(target).to receive(:punch).and_return(true) }

				it 'calls commentary for player once with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

					expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

					match.encounter
				end
			end

			context 'when player misses target' do
				before { allow(target).to receive(:punch).and_return(false) }

				it 'calls commentary for player once with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: false).once

					expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

					match.encounter
				end
			end
		end

		context 'when no fighters have punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { false }

			before { allow(match).to receive(:pick_pressing_fighter).and_return(opponent) }

			it 'calls commentary with correct params once for prelude and once for postlude' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once
				expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

				match.encounter 
			end
		end
	end

	describe '#decide_punches during a game loop' do
		let(:player_punch_data) { match.punch_data.first }

		it 'when roll_die equals moments it goes through game loop' do
			roll_die_result = match.moments
			allow(match).to receive(:roll_die).and_return(roll_die_result)

			(roll_die_result - 1).times do
				counter = player_punch_data[:counter]

				match.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(counter + 1)
			end

			match.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(true)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(1)

			match.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(false)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(2)
		end

		it 'when roll_die is one less than moments it goes through game loop' do
			roll_die_result = match.moments - 1
			allow(match).to receive(:roll_die).and_return(roll_die_result)

			(roll_die_result - 1).times do
				counter = player_punch_data[:counter]

				match.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(counter + 1)
			end

			match.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(true)
			expect(player_punch_data[:block_punch]).to eq(true)
			expect(player_punch_data[:counter]).to eq(match.moments)

			match.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(false)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(1)
		end
	end
end