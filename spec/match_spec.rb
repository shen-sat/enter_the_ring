require_relative '../lib/match'

describe 'Match' do
	let(:commentary) { double() }
	let(:match) { Match.new(commentary) }

	describe '#something_happens?' do
		before { allow(match).to receive(:sleep) }

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

	describe '#set_fighters' do
		let(:fighter_one) { double() }
		let(:fighter_two) { double() }

		before { srand 1 }

		it 'sets fighter_two as pressing_fighter' do
			match.set_fighters(fighter_one, fighter_two)

			expect(match.pressing_fighter).to eq(fighter_two)
		end

		it 'sets fighter_one as other_fighter' do
			match.set_fighters(fighter_one, fighter_two)

			expect(match.other_fighter).to eq(fighter_one)
		end
	end

	describe '#prelude_to_action' do
		let(:pressing_fighter) { double() }
		let(:other_fighter) { double() }
		let(:prelude_line) { 'A prelude line' }


		before do
			allow(match).to receive(:pressing_fighter).and_return(pressing_fighter)
			allow(match).to receive(:other_fighter).and_return(other_fighter)

			allow(commentary).to receive(:prelude).with(pressing_fighter, other_fighter).and_return(prelude_line)
		end

		it 'returns a prelude line' do
			expect(match.prelude_to_action).to eq('A prelude line')
		end
	end

	describe '#action' do
		let(:pressing_fighter) { double() }
		let(:other_fighter) { double() }
		let(:action_line) { 'An action line' }


		before do
			allow(match).to receive(:sleep)

			allow(match).to receive(:pressing_fighter).and_return(pressing_fighter)
			allow(match).to receive(:other_fighter).and_return(other_fighter)

			allow(commentary).to receive(:action).with(pressing_fighter, other_fighter).and_return(action_line)
		end

		it 'returns an action line' do
			expect(match.action).to eq('An action line')
		end
	end

	describe '#reset_minigame' do
		it 'sets initiate_minigame to false' do
			match.reset_minigame
			expect(match.initiate_minigame).to eq(false)
		end
	end

	describe '#reset_player_counter_and_punch' do
		before do
			match.instance_variable_set(:@player_step_counter, 6)
			match.instance_variable_set(:@player_punch_thrown, true)
		end

		it 'resets player-related attributes' do
			match.reset_player_counter_and_punch

			expect(match.player_step_counter).to eq(1)
			expect(match.player_punch_thrown).to eq(false)
		end
	end

	describe '#roll_punch_die' do
		before do 
			match.instance_variable_set(:@steps_for_punch, 6)
			srand 1
		end

		it 'returns 6' do
			expect(match.roll_punch_die).to eq(6)
		end
	end

	describe '#throw_punch?' do
		context 'when roll_punch_die is less or equal to player_step_counter' do
			before do
				allow(match).to receive(:roll_punch_die).and_return(1)
				allow(match).to receive(:player_step_counter).and_return(1)
			end
			context 'when player_punch_thrown is false' do
				before { match.instance_variable_set(:@player_punch_thrown, false) }
				it 'returns true' do
					expect(match.throw_punch?).to eq(true)
				end
			end
			context 'when player_punch_thrown is true' do
				before { match.instance_variable_set(:@player_punch_thrown, true) }
				it 'returns false' do
					expect(match.throw_punch?).to eq(false)
				end
			end			
		end
		context 'when roll_punch_die is greater than player_step_counter' do
			before do
				allow(match).to receive(:roll_punch_die).and_return(6)
				allow(match).to receive(:player_step_counter).and_return(5)
			end
			it 'returns false' do
				expect(match.throw_punch?).to eq(false)
			end
		end
	end
end