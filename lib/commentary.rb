class Commentary
	attr_reader :lines

	def initialize(lines)
		@lines = lines
	end

	def prelude(pressing_fighter:, receiving_fighter:, punch:)
		punch ? lines[:prelude][:punch].sample : lines[:prelude][:fluff].sample 
	end

	def postlude(pressing_fighter:, receiving_fighter:, punch:)
		punch ? lines[:postlude][:punch].sample : lines[:postlude][:fluff].sample
	end
end