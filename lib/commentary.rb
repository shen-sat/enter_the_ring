class Commentary
	attr_reader :lines

	def initialize(lines)
		@lines = lines
	end

	def build_up(pressing_fighter, receiving_fighter, special: false)
		special ? lines[:build_up][:special].sample : lines[:build_up][:normal].sample
	end

	def outcome(pressing_fighter, receiving_fighter, hit: nil)
		if hit.nil?
			lines[:outcome][:normal].sample
		elsif hit
			lines[:outcome][:hit].sample
		else
			lines[:outcome][:miss].sample
		end
	end
end