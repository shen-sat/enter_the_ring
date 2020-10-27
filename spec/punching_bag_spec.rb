require_relative '../lib/punching_bag'

describe 'PunchingBag' do
	subject(:punching_bag) { PunchingBag.new }
		
	it 'returns intro text' do
		expected_output = "Start training by pressing x.\nHit the bag by pressing x again.\nYour target is 60\n"
		
		allow(punching_bag).to receive(:target).and_return(60)

		
		expect{ punching_bag.intro_text }.to output(expected_output).to_stdout
	end
	
	it 'picks target' do
		srand 1

		punching_bag.pick_target

		expect(punching_bag.target).to eq(55) 
	end
	
	describe '#hit?' do
		before { allow(punching_bag).to receive(:target).and_return(80) }
		
		context 'when on target' do
			before { allow(punching_bag).to receive(:throw_punch).and_return(85) }	

			it 'returns true' do
				expect(punching_bag.hit?).to eq(true)
			end
		end

		context 'when off target' do
			before { allow(punching_bag).to receive(:throw_punch).and_return(74) }
			
			it 'returns false' do
				expect(punching_bag.hit?).to eq(false)
			end
		end
	end
end