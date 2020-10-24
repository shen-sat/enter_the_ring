require_relative '../lib/fighter_builder'

describe 'FighterBuilder' do
	let(:fighter_builder) { FighterBuilder.new }

	it 'intializes with Prompt' do
		expect(fighter_builder.prompt).to be_a TTY::Prompt
	end

	it 'intializes with Fighter' do
		fighter_builder = FighterBuilder.new

		expect(fighter_builder.fighter).to be_a Fighter
	end

	context 'when setting attributes' do
		let(:prompt) { double() }
		

		before { allow(TTY::Prompt).to receive(:new).and_return(prompt) }

		it 'sets fighter firstname' do
			allow(prompt).to receive(:ask).and_return('Bob')

			fighter_builder.set_firstname

			expect(fighter_builder.fighter.firstname).to eq('Bob')
		end

		it 'sets fighter lastname' do
			allow(prompt).to receive(:ask).and_return('Smith')

			fighter_builder.set_lastname

			expect(fighter_builder.fighter.lastname).to eq('Smith')
		end

		it 'sets fighter age' do
			allow(prompt).to receive(:ask).and_return(40)

			fighter_builder.set_age

			expect(fighter_builder.fighter.age).to eq(40)
		end

		it 'sets fighter rank' do
			allow(prompt).to receive(:ask).and_return(10)

			fighter_builder.set_rank

			expect(fighter_builder.fighter.rank).to eq(10)
		end
	end

	context '#build' do
		let(:built_fighter) { double() }
		let(:new_fighter) { double() }

		before { allow(Fighter).to receive(:new).and_return(built_fighter, new_fighter) }

		it 'returns built fighter' do
			expect(fighter_builder.build).to eq(built_fighter)
		end

		it 'creates a new Fighter' do
			fighter_builder.build

			expect(fighter_builder.fighter).to eq(new_fighter)
		end
	end
end