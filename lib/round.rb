require_relative '../lib/settings'

class Round
	attr_reader :fighter_a, :fighter_b

	def initialize(fighter_a, fighter_b, commentary)
		@fighter_a = fighter_a
		@fighter_b = fighter_b
		@commentary = commentary
		@no_of_slots = Settings::SLOTS
	end

	def check_for_pressor
		fighter_a_presses = fighter_a.press?
		fighter_b_presses = fighter_b.press?

		if fighter_a_presses && fighter_b_presses
			[fighter_a, fighter_b].sample
		elsif fighter_a_presses
			fighter_a
		elsif fighter_b_presses
			fighter_b
		else
			nil
		end
	end
end