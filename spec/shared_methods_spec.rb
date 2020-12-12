require_relative '../lib/shared_methods'

describe 'SharedMethods' do

	describe '.roll_die' do
		context 'with no arguments' do
			it 'returns 1' do
				srand 2

				expect(SharedMethods.roll_die).to eq(1)
			end
		end 
	end
end