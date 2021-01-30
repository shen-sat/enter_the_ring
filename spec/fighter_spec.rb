require_relative '../lib/fighter'
require_relative '../lib/shared_methods'

describe 'Fighter' do
	subject(:fighter) { Fighter.new }

	describe '#punch' do
		before { allow(SharedMethods).to receive(:roll_die).and_return(5) }

		context 'when fighter rank is lower than die roll' do
			before { allow(fighter).to receive(:rank).and_return(4) }

			it 'returns true' do
				expect(fighter.punch).to eq(true)
			end
		end

		context 'when fighter rank is equal to die roll' do
			before { allow(fighter).to receive(:rank).and_return(5) }

			it 'returns true' do
				expect(fighter.punch).to eq(true)
			end
		end

		context 'when fighter rank is greater than die roll' do
			before { allow(fighter).to receive(:rank).and_return(6) }

			it 'returns false' do
				expect(fighter.punch).to eq(false)
			end
		end
	end

	describe '#press?' do
		context 'when die roll is equal to fighter activity threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_ACTIVITY_CHANCE_THRESHOLD) }

			it 'returns true' do
				expect(fighter.press?).to eq(true)
			end
		end
		context 'when die roll is less than fighter activity threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_ACTIVITY_CHANCE_THRESHOLD - 1) }

			it 'returns true' do
				expect(fighter.press?).to eq(true)
			end
		end
		context 'when die roll is more than fighter activity threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_ACTIVITY_CHANCE_THRESHOLD + 1) }

			it 'returns false' do
				expect(fighter.press?).to eq(false)
			end
		end
	end
	describe '#cock_the_hammer?' do
		context 'when die roll is equal to fighter punch threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_PUNCH_CHANCE_THRESHOLD) }

			it 'returns true' do
				expect(fighter.cock_the_hammer?).to eq(true)
			end
		end
		context 'when die roll is less than fighter punch threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_PUNCH_CHANCE_THRESHOLD - 1) }

			it 'returns true' do
				expect(fighter.cock_the_hammer?).to eq(true)
			end
		end
		context 'when die roll is more than fighter punch threshold' do
			before { allow(SharedMethods).to receive(:roll_die).and_return(Settings::FIGHTER_PUNCH_CHANCE_THRESHOLD + 1) }

			it 'returns false' do
				expect(fighter.cock_the_hammer?).to eq(false)
			end
		end
	end
end