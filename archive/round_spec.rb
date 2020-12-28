require_relative '../lib/round'

describe 'Round' do
	let(:commentary) { double() }
	let(:player) { double('player') }
	let(:opponent) { double('opponent') }
	let(:round) { Round.new(commentary, player, opponent) }

	describe 'attributes' do
		it 'has correct values' do
			expect(round.moments).to eq(10)
			expect(round.ambient_action_score).to eq(4)

			punch_data = { punch: false, block_punch: false, counter: 1 }
			expect(round.punch_data.first).to eq(punch_data.merge(fighter: player))
			expect(round.punch_data.last).to eq(punch_data.merge(fighter: opponent))
		end
	end

	describe '#something_happens?' do
		let(:punch_set_to_true) { { punch: true, block_punch: false, counter: 1 } }
		let(:punch_set_to_false) { { punch: false, block_punch: false, counter: 1 } }

		before do 
			allow(round).to receive(:sleep)
			allow(round).to receive(:decide_punches)
		end

		context 'when player punch is true' do
			before { round.instance_variable_set(:@punch_data, [punch_set_to_true, punch_set_to_false] ) }

			it 'returns true' do
				expect(round.something_happens?).to eq(true)
			end
		end

		context 'when opponent punch is true' do
			before { round.instance_variable_set(:@punch_data, [punch_set_to_false, punch_set_to_true] ) }

			it 'returns true' do
				expect(round.something_happens?).to eq(true)
			end
		end

		context 'when player and opponent punch are false' do
			context 'when die roll is >= ambient_action_score' do
				before { allow(SharedMethods).to receive(:roll_die).and_return(round.ambient_action_score) }
				
				it 'returns true' do
					expect(round.something_happens?).to eq(true)
				end
			end

			context 'when die roll is <= 4' do
				before { allow(SharedMethods).to receive(:roll_die).and_return(round.ambient_action_score - 1) }
				
				it 'returns false' do
					expect(round.something_happens?).to eq(false)
				end
			end
		end
	end

	describe '#encounter' do
		let(:player_punch_data) { { fighter: player, punch: player_punch, block_punch: false, counter: 1 } }
		let(:opponent_punch_data) { { fighter: opponent, punch: opponent_punch, block_punch: false, counter: 1 } }

		before do
			allow(round).to receive(:sleep)

			round.instance_variable_set(:@punch_data, [player_punch_data, opponent_punch_data])
		end

		context 'when player has punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { false }

			context 'when player hits target' do
				before { allow(player).to receive(:punch_success?).and_return(true) }

				it 'calls postlude and prelude commentary with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

					expect(round.encounter).to eq([player])
				end
			end
			context 'when player misses target' do
				before { allow(player).to receive(:punch_success?).and_return(false) }

				it 'calls postlude and prelude commentary with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: false).once

					expect(round.encounter).to eq([])
				end
			end
		end

		context 'when opponent has punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { true }

			context 'when opponent hits target' do
				before { allow(opponent).to receive(:punch_success?).and_return(true) }
				
				it 'calls postlude and prelude commentary with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

					expect(round.encounter).to eq([opponent])
				end
			end

			context 'when opponent misses target' do
				before { allow(opponent).to receive(:punch_success?).and_return(false) }

				it 'calls postlude and prelude commentary with correct params' do
					expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
					expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

					expect(round.encounter).to eq([])
				end
			end
		end

		context 'when both fighters have punch true' do
			let(:player_punch) { true }
			let(:opponent_punch) { true }

			context 'when player hits target' do
				before { allow(player).to receive(:punch_success?).and_return(true) }

				context 'when opponent misses target' do
					before { allow(opponent).to receive(:punch_success?).and_return(false) }

					it 'calls postlude and prelude commentary with correct params' do
						expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

						expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

						expect(round.encounter).to eq([player])
					end
				end

				context 'when opponent hits target' do
					before { allow(opponent).to receive(:punch_success?).and_return(true) }

					it 'calls postlude and prelude commentary with correct params' do
						expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once

						expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

						expect(round.encounter).to eq([player, opponent])
					end
				end
			end

			context 'when player misses target' do
				before { allow(player).to receive(:punch_success?).and_return(false) }

				context 'when opponent misses target' do
					before { allow(opponent).to receive(:punch_success?).and_return(false) }

					it 'calls postlude and prelude commentary with correct params' do
						expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: false).once

						expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

						expect(round.encounter).to eq([])
					end
				end

				context 'when opponent hits target' do
					before { allow(opponent).to receive(:punch_success?).and_return(true) }

					it 'calls postlude and prelude commentary with correct params' do
						expect(commentary).to receive(:prelude).with(pressing_fighter: player, receiving_fighter: opponent, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: player, receiving_fighter: opponent, punch: false).once

						expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once
						expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: true).once

						expect(round.encounter).to eq([opponent])
					end
				end
			end
		end

		context 'when no fighters have punch true' do
			let(:player_punch) { false }
			let(:opponent_punch) { false }

			before { allow(round).to receive(:pick_pressing_fighter).and_return(opponent) }

			it 'calls commentary with correct params once for prelude and once for postlude' do
				expect(commentary).to receive(:prelude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once
				expect(commentary).to receive(:postlude).with(pressing_fighter: opponent, receiving_fighter: player, punch: false).once

				expect(round.encounter).to eq([])
			end
		end
	end

	describe '#decide_punches during a game loop' do
		let(:player_punch_data) { round.punch_data.first }

		it 'when roll_die equals moments it goes through game loop' do
			roll_die_result = round.moments
			allow(SharedMethods).to receive(:roll_die).and_return(roll_die_result)

			(roll_die_result - 1).times do
				counter = player_punch_data[:counter]

				round.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(counter + 1)
			end

			round.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(true)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(1)

			round.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(false)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(2)
		end

		it 'when roll_die is one less than moments it goes through game loop' do
			roll_die_result = round.moments - 1
			allow(SharedMethods).to receive(:roll_die).and_return(roll_die_result)

			(roll_die_result - 1).times do
				counter = player_punch_data[:counter]

				round.send(:decide_punches)

				expect(player_punch_data[:punch]).to eq(false)
				expect(player_punch_data[:block_punch]).to eq(false)
				expect(player_punch_data[:counter]).to eq(counter + 1)
			end

			round.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(true)
			expect(player_punch_data[:block_punch]).to eq(true)
			expect(player_punch_data[:counter]).to eq(round.moments)

			round.send(:decide_punches)
			expect(player_punch_data[:punch]).to eq(false)
			expect(player_punch_data[:block_punch]).to eq(false)
			expect(player_punch_data[:counter]).to eq(1)
		end
	end
end