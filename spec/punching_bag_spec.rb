require_relative '../lib/punching_bag'

describe 'PunchingBag' do
	subject(:punching_bag) { PunchingBag.new }
		
	it 'returns intro text' do
		expected_output = "Start training by pressing x.\nHit the bag by pressing x again.\nYour target is 60\n"
		
		allow(punching_bag).to receive(:target).and_return(60)

		
		expect{ punching_bag.send(:intro_text) }.to output(expected_output).to_stdout
	end
	
	it 'picks target' do
		srand 1

		punching_bag.send(:pick_target)

		expect(punching_bag.target).to eq(55) 
	end

	describe '#set_punch' do
		before { allow(punching_bag).to receive(:throw_punch).and_return(40) }

		it 'sets punch' do
			punching_bag.send(:set_punch)

			expect(punching_bag.punch).to eq(40)
		end
	end
	
	describe '#hit?' do
		before { allow(punching_bag).to receive(:target).and_return(80) }
		
		context 'when on target' do
			before { allow(punching_bag).to receive(:punch).and_return(85) }	

			it 'returns true' do
				expect(punching_bag.send(:hit?)).to eq(true)
			end
		end

		context 'when off target' do
			before { allow(punching_bag).to receive(:punch).and_return(74) }
			
			it 'returns false' do
				expect(punching_bag.send(:hit?)).to eq(false)
			end
		end
	end

	describe '#result' do
		context 'when bag is hit' do
			before { allow(punching_bag).to receive(:hit?).and_return(true) }

			it 'puts it was hit' do
				expect(punching_bag.send(:result)).to eq('Good punch!')
			end
		end

		context 'when bag is not hit' do
			before { allow(punching_bag).to receive(:hit?).and_return(false) }

			it 'puts it was not hit' do
				expect(punching_bag.send(:result)).to eq('You missed the bag!')
			end
		end
	end

	describe '#show_options' do
		let(:prompt) { double() }
		before { allow(TTY::Prompt).to receive(:new).and_return(prompt) }

		context 'when user selects retry' do
			before do 
				allow(prompt).to receive(:select).and_return(:retry)
			end
			
			it 'retries' do
				expect(punching_bag).to receive(:train)

				punching_bag.send(:show_options)
			end
		end
	end
end