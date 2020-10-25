require_relative '../lib/punching_bag'

describe 'PunchingBag' do
		
	it 'puts intro text' do
		expect{ PunchingBag.new.intro_text }.to output(/Hit the bag/).to_stdout
	end
	
	it 'picks target' do
		srand 1

		punching_bag = PunchingBag.new

		punching_bag.pick_target

		expect(punching_bag.target).to eq(55) 
	end

	it 'sets punch' do
		punching_bag = PunchingBag.new

		allow(punching_bag).to receive(:throw_punch).and_return(75)

		punching_bag.set_punch

		expect(punching_bag.punch).to eq(75)
	end
	
	describe '#hit?' do
		let(:punching_bag) { PunchingBag.new }

		before { allow(punching_bag).to receive(:target).and_return(80) }
		
		context 'when on target' do
			before { allow(punching_bag).to receive(:punch).and_return(85) }	

			it 'returns true' do
				expect(punching_bag.hit?).to eq(true)
			end
		end

		context 'when off target' do
			before { allow(punching_bag).to receive(:punch).and_return(74) }
			
			it 'returns false' do
				expect(punching_bag.hit?).to eq(false)
			end
		end
	end
end