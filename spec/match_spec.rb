require_relative '../lib/match'

describe 'Match' do
	let(:commentary) { double() }
	let(:match) { Match.new(commentary) }

	describe 'attributes' do
		it 'has correct values' do
			expect(match.moments).to eq(6)
			expect(match.punch).to eq(false)
			expect(match.block_punch).to eq(false)
			expect(match.player_counter).to eq(1)
		end
	end

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

	context 'a game loop'
		context 'when roll_die returns only 3' do
			before { allow(match).to receive(:roll_die).and_return(3) }
				it 'goes through game loop' do
					match.decide_punch

					expect(match.punch).to eq(false)
					expect(match.block_punch).to eq(false)
					expect(match.player_counter).to eq(2)

					match.decide_punch

					expect(match.punch).to eq(false)
					expect(match.block_punch).to eq(false)
					expect(match.player_counter).to eq(3)									

					match.decide_punch

					expect(match.punch).to eq(true)
					expect(match.block_punch).to eq(true)
					expect(match.player_counter).to eq(4)

					match.decide_punch

					expect(match.punch).to eq(false)
					expect(match.block_punch).to eq(true)
					expect(match.player_counter).to eq(5)

					match.decide_punch

					expect(match.punch).to eq(false)
					expect(match.block_punch).to eq(true)
					expect(match.player_counter).to eq(6)

					match.decide_punch

					expect(match.punch).to eq(false)
					expect(match.block_punch).to eq(false)
					expect(match.player_counter).to eq(1)
				end
		end
		context 'when roll_die returns only 6' do
			before { allow(match).to receive(:roll_die).and_return(6) }

			it 'goes through game loop' do
				match.decide_punch
				
				expect(match.punch).to eq(false)
				expect(match.block_punch).to eq(false)
				expect(match.player_counter).to eq(2)

				match.decide_punch #3
				match.decide_punch #4
				match.decide_punch #5
				match.decide_punch #6

				match.decide_punch

				expect(match.punch).to eq(true)
				expect(match.block_punch).to eq(false)
				expect(match.player_counter).to eq(1)

				match.decide_punch

				expect(match.punch).to eq(false)
				expect(match.block_punch).to eq(false)
				expect(match.player_counter).to eq(2)
			end
		end
end