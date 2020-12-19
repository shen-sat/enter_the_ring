require_relative '../lib/fighter'
require_relative '../lib/shared_methods'

describe 'Fighter' do
	subject(:fighter) { Fighter.new }

	describe '#punch?' do
		before { allow(fighter).to receive(:rand).and_return(5) }

		context 'when fighter rank is lower than die roll' do
			before { allow(fighter).to receive(:rank).and_return(4) }

			it 'returns true' do
				expect(fighter.punch?).to eq(true)
			end
		end

		context 'when fighter rank is equal to die roll' do
			before { allow(fighter).to receive(:rank).and_return(5) }

			it 'returns true' do
				expect(fighter.punch?).to eq(true)
			end
		end

		context 'when fighter rank is greater than die roll' do
			before { allow(fighter).to receive(:rank).and_return(6) }

			it 'returns false' do
				expect(fighter.punch?).to eq(false)
			end
		end
	end
end