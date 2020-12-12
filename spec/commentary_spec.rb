require_relative '../lib/commentary'
require_relative '../lib/fighter'

describe 'Commentary' do
	subject(:commentary) { Commentary.new(lines) }

	let(:receiving_fighter) { instance_double(Fighter, firstname: 'Rose', lastname: 'Namajunes', nickname: 'Thug Rose') }
	let(:pressing_fighter) { instance_double(Fighter, firstname: 'Weili', lastname: 'Zhang', nickname: 'Magnum') }
	
	let(:prelude_fluff_line) { "#{pressing_fighter.firstname} advances" }
	let(:postlude_fluff_line) { "#{receiving_fighter.firstname} moves out of range" }
	let(:prelude_punch_line) { "#{receiving_fighter.lastname} lowers her guard" }
	let(:postlude_punch_line) { "#{pressing_fighter.nickname} lands a devestating uppercut!" }

	let(:prelude_fluff_lines) { [prelude_fluff_line] }
	let(:prelude_punch_lines) { [prelude_punch_line] }
	let(:postlude_fluff_lines) { [postlude_fluff_line] }
	let(:postlude_punch_lines) { [postlude_punch_line] }

	let(:prelude_lines) { { fluff: prelude_fluff_lines, punch: prelude_punch_lines } }
	let(:postlude_lines) { { fluff: postlude_fluff_lines, punch: postlude_punch_lines } }

	let(:lines) { { prelude: prelude_lines, postlude: postlude_lines } }

	describe '#prelude' do
		context 'when punch is true' do
			it 'returns a punch prelude line with interpolated fighter' do
				expect(commentary.prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: true)).to eq(prelude_punch_line)
			end
		end

		context 'when punch is false' do
			it 'returns a fluff prelude line with interpolated fighter' do
				expect(commentary.prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: false)).to eq(prelude_fluff_line)
			end
		end
	end

	describe '#postlude' do
		context 'when punch is true' do
			it 'returns a punch postlude line with interpolated fighter' do
				expect(commentary.postlude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: true)).to eq(postlude_punch_line)
			end
		end

		context 'when punch is false' do
			it 'returns a fluff postlude line with interpolated fighter' do
				expect(commentary.postlude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: false)).to eq(postlude_fluff_line)
			end
		end
	end
end