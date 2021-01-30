require_relative '../lib/target'

describe 'Target' do
	subject(:target) { Target.new }
		
	it 'returns intro text' do
		reader = double()
		allow(TTY::Reader).to receive(:new).and_return(reader)
		allow(reader).to receive(:read_char).and_return('x')

		allow(target).to receive(:bullseye).and_return(60)

		expected_output = "Initiate punch by pressing x.\nLand punch by pressing x again.\nYour target is 60\n"

		expect{ target.send(:intro_text) }.to output(expected_output).to_stdout
	end
	
	it 'sets bullseye' do
		srand 1

		target.send(:set_bullseye)

		expect(target.bullseye).to eq(87) 
	end

	describe '#throw_fist' do
		before { allow(target).to receive(:land_fist).and_return(40) }

		it 'sets score' do
			target.send(:throw_fist)

			expect(target.score).to eq(40)
		end
	end
	
	describe '#hit?' do
		before { allow(target).to receive(:bullseye).and_return(80) }
		
		context 'when on target' do
			before { allow(target).to receive(:score).and_return(85) }	

			it 'returns true' do
				expect(target.send(:hit?)).to eq(true)
			end
		end

		context 'when off target' do
			before { allow(target).to receive(:score).and_return(74) }
			
			it 'returns false' do
				expect(target.send(:hit?)).to eq(false)
			end
		end
	end

	describe '#punch' do
		let(:hit_outcome) { double(:hit_outcome) }

		before do
			allow(target).to receive(:clear_screen)
			allow(target).to receive(:set_bullseye)
			allow(target).to receive(:intro_text)
			allow(target).to receive(:throw_fist)
			allow(target).to receive(:hit?).and_return(hit_outcome)
		end

		it 'executes the correct behaviour and returns the correct value' do
			expect(target).to receive(:clear_screen)
			expect(target).to receive(:set_bullseye)
			expect(target).to receive(:intro_text)
			expect(target).to receive(:throw_fist)

			outcome = target.punch

			expect(outcome).to eq(hit_outcome)
		end	
	end
end