require_relative '../lib/commentary'
require_relative '../lib/fighter'

describe 'Commentary' do
	subject(:commentary) { Commentary.new(lines) }

	let(:receiving_fighter) { instance_double(Fighter, firstname: 'Rose', lastname: 'Namajunes', nickname: 'Thug Rose') }
	let(:pressing_fighter) { instance_double(Fighter, firstname: 'Weili', lastname: 'Zhang', nickname: 'Magnum') }
	
	let(:build_up_normal_lines) { ["#{pressing_fighter.firstname} advances"] }
	let(:build_up_special_lines) { ["#{receiving_fighter.lastname} lowers her guard"] }

	let(:build_up_lines) { { normal: build_up_normal_lines, special: build_up_special_lines } }

	let(:outcome_normal_lines) { ["#{receiving_fighter.firstname} moves out of range"] }
	let(:outcome_hit_lines) { ["#{pressing_fighter.nickname} lands a devestating uppercut!"] }
	let(:outcome_miss_lines) { ["#{pressing_fighter.lastname} swings and misses!"] }
	
	let(:outcome_lines) { { normal: outcome_normal_lines, hit: outcome_hit_lines, miss: outcome_miss_lines } }

	let(:lines) { { build_up: build_up_lines, outcome: outcome_lines } }

	describe '#build_up' do
		context 'when special is true' do
			it 'returns a build-up special line with interpolated fighter' do
				expect(commentary.build_up(pressing_fighter, receiving_fighter, special: true)).to eq(build_up_special_lines.first)
			end
		end

		context 'when special is false' do
			it 'returns a normal build-up line with interpolated fighter' do
				expect(commentary.build_up(pressing_fighter, receiving_fighter)).to eq(build_up_normal_lines.first)
			end
		end
	end

	describe '#outcome' do
		context 'when hit is nil' do
			it 'returns a normal outcome line with interpolated fighter' do
				expect(commentary.outcome(pressing_fighter, receiving_fighter)).to eq(outcome_normal_lines.first)
			end
		end

		context 'when hit is true' do
			it 'returns a outcome hit line with interpolated fighter' do
				expect(commentary.outcome(pressing_fighter, receiving_fighter, hit: true)).to eq(outcome_hit_lines.first)
			end
		end

		context 'when hit is false' do
			it 'returns a outcome miss line with interpolated fighter' do
				expect(commentary.outcome(pressing_fighter, receiving_fighter, hit: false)).to eq(outcome_miss_lines.first)
			end
		end
	end
end