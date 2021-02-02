require_relative '../lib/round'
require_relative '../lib/fighter'
require_relative '../lib/commentary'

describe 'Round' do
	let(:fighter_a) { instance_double(Fighter) }
	let(:fighter_b) { instance_double(Fighter) }
	let(:commentary) { instance_double(Commentary) }
	
	let(:round) { Round.new(fighter_a, fighter_b, commentary) }

	describe '#run' do
		context 'when there is no pressor' do
			before { allow(fighter_a).to receive(:press?).and_return(false) }
			before { allow(fighter_b).to receive(:press?).and_return(false) }

			it 'does nothing' do #B
				round.run
			end			
		end
		context 'when there is a pressor' do
			before { allow(fighter_a).to receive(:press?).and_return(false) }
			before { allow(fighter_b).to receive(:press?).and_return(true) }

			context 'when pressor has no intention to punch' do
				before { allow(fighter_b).to receive(:cock_the_hammer?).and_return(false) }

				it 'commentates appropriately' do
					expect(commentary).to receive(:build_up).with(fighter_b, fighter_a, special: false)
					expect(commentary).to receive(:outcome).with(fighter_b, fighter_a, hit: nil)

					round.run
				end				
			end
			context 'when pressor has intention to punch' do
				before { allow(fighter_b).to receive(:cock_the_hammer?).and_return(true) }

				context 'when pressor misses punch' do
					before { allow(fighter_b).to receive(:punch).and_return(false) }

					it 'commentates appropriately' do
						expect(commentary).to receive(:build_up).with(fighter_b, fighter_a, special: false)
						expect(commentary).to receive(:build_up).with(fighter_b, fighter_a, special: true)
						expect(commentary).to receive(:outcome).with(fighter_b, fighter_a, hit: false)

						round.run
					end
				end
				context 'when pressor connects' do
					before { allow(fighter_b).to receive(:punch).and_return(true) }

					it 'commentates appropriately and adds to score' do
						expect(commentary).to receive(:build_up).with(fighter_b, fighter_a, special: false)
						expect(commentary).to receive(:build_up).with(fighter_b, fighter_a, special: true)
						expect(commentary).to receive(:outcome).with(fighter_b, fighter_a, hit: true)

						round.run

						expect(round.scores).to eq( { fighter_b => 1} )
					end
				end
			end
		end
	end

	describe '#check_for_pressor' do
		context 'when fighter_a presses' do
			before { allow(fighter_a).to receive(:press?).and_return(true) }

			context 'when fighter_b presses' do
				before { allow(fighter_b).to receive(:press?).and_return(true) }

				it 'returns a fighter at random' do
					srand 0

					expect(round.send(:check_for_pressor)).to eq(fighter_a)
				end
			end
			context 'when fighter_b does not press' do
				before { allow(fighter_b).to receive(:press?).and_return(false) }

				it 'returns fighter_a' do
					expect(round.send(:check_for_pressor)).to eq(fighter_a)
				end
			end
		end
		context 'when fighter_a does press' do
			before { allow(fighter_a).to receive(:press?).and_return(false) }

			context 'when fighter_b presses' do
				before { allow(fighter_b).to receive(:press?).and_return(true) }

				it 'returns fighter_b' do
					expect(round.send(:check_for_pressor)).to eq(fighter_b)
				end
			end
			context 'when fighter_b does not press' do
				before { allow(fighter_b).to receive(:press?).and_return(false) }

				it 'returns nil' do
					expect(round.send(:check_for_pressor)).to eq(nil)
				end
			end
		end
	end
end