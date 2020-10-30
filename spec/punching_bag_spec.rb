require_relative '../lib/punching_bag'

describe 'PunchingBag' do
	subject(:punching_bag) { PunchingBag.new }
		
	it 'returns intro text' do
		reader = double()
		allow(TTY::Reader).to receive(:new).and_return(reader)
		allow(reader).to receive(:read_char).and_return('x')

		allow(punching_bag).to receive(:target).and_return(60)

		expected_output = "Start training by pressing x.\nHit the bag by pressing x again.\nYour target is 60\n"

		expect{ punching_bag.send(:intro_text) }.to output(expected_output).to_stdout
	end
	
	it 'picks target' do
		srand 1

		punching_bag.send(:pick_target)

		expect(punching_bag.target).to eq(87) 
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
		before { allow(punching_bag).to receive(:punch).and_return(99) }
		context 'when bag is hit' do
			before { allow(punching_bag).to receive(:hit?).and_return(true) }

			it 'puts it was hit' do
				expect(punching_bag.send(:result)).to eq('You got 99 - good punch!')
			end
		end

		context 'when bag is missed' do
			before { allow(punching_bag).to receive(:hit?).and_return(false) }

			it 'puts it was not hit' do
				expect(punching_bag.send(:result)).to eq('You got 99 - you missed the bag!')
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