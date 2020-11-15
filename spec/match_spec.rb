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

	describe '#decide_punch' do
		#TODO: look at what you did in dummy_spec.rb and do that here instead of the existing tests below
		let(:moments) { match.moments }

		context 'when player_counter is less than moments' do
			before { match.instance_variable_set(:@player_counter, moments - 1) }

			it 'increments player_counter' do
				expect{match.decide_punch}.to change{match.player_counter}.to(moments)
			end
			#beginning
			context 'when block_punch is false' do
				before { match.instance_variable_set(:@block_punch, false) }			
				
				context 'when punch is false' do
					before { match.instance_variable_set(:@punch, false) }

					context 'when player_counter is less than roll_die' do
						before { allow(match).to receive(:roll_die).with(moments).and_return(moments) }

						it 'does not change punch' do
							expect{match.decide_punch}.not_to change{match.punch}
						end

						it 'does not change block_punch' do
							expect{match.decide_punch}.not_to change{match.block_punch}
						end
					end

					context 'when player_counter is greater than or equal to roll_die' do
						before { allow(match).to receive(:roll_die).with(moments).and_return(moments - 1) }

						it 'changes punch to true' do
							expect{match.decide_punch}.to change{match.punch}.to(true)
						end

						it 'changes block_punch to true' do
							expect{match.decide_punch}.to change{match.block_punch}.to(true)
						end
					end
				end
			end
			#first loop after punch has been executed
			context 'when block_punch is true' do
				before { match.instance_variable_set(:@block_punch, true) }
				context 'when punch is true' do
					before { match.instance_variable_set(:@punch, true) }

					it 'changes punch to false' do
						expect{match.decide_punch}.to change{match.punch}.to(false)
					end

					it 'does not change block_punch' do
						expect{match.decide_punch}.not_to change{match.block_punch}
					end
				end
				#next loop after punch has been executed
				context 'when punch is false' do
					before { match.instance_variable_set(:@punch, false) }					
					it 'does not change punch' do
						expect{match.decide_punch}.not_to change{match.punch}
					end

					it 'does not change block_punch' do
						expect{match.decide_punch}.not_to change{match.block_punch}
					end
				end
			end
		end
		#final loop
		context 'when player_counter is greater than or equal to moments' do
			before { match.instance_variable_set(:@player_counter, moments) }

			it 'sets player_counter to 1' do
				expect{match.decide_punch}.to change{match.player_counter}.to(1)
			end

			context 'when block_punch is true' do
				before { match.instance_variable_set(:@block_punch, true) }

				context 'when punch is false' do
					before { match.instance_variable_set(:@punch, false) }

					it 'does not change punch' do
						expect{match.decide_punch}.not_to change{match.punch}
					end

					it 'changes block_punch to false' do
						expect{match.decide_punch}.to change{match.block_punch}.to(false)
					end
				end
			end
		end
	end
end