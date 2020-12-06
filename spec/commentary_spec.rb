require_relative '../lib/commentary'

describe 'Commentary' do
	# initializes with hash, prelude and action keys, each with punch and non-punch keys,
	#each with an array, each with only one value inside
	#each value is a string with an interpolat-able value. For action do receiving fighter, action do pressing
	
	# setup up pressing and receiving fighters

	describe '#prelude' do
		context 'when punch is true' do
			it 'returns a punch prelude line with interpolated fighter' do
			end
		end

		context 'when punch is false' do
			it 'returns a fluff prelude line with interpolated fighter' do
			end
		end
	end

	describe '#action' do
		context 'when punch is true' do
			it 'returns a punch action line with interpolated fighter' do
			end
		end

		context 'when punch is false' do
			it 'returns a fluff action line with interpolated fighter' do
			end
		end
	end
end