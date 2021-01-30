require_relative '../lib/settings'

class Round
	attr_reader :fighter_a, :fighter_b, :commentary

	def initialize(fighter_a, fighter_b, commentary)
		@fighter_a = fighter_a
		@fighter_b = fighter_b
		@commentary = commentary
		@no_of_slots = Settings::SLOTS
	end

	def run
		pressor = check_for_pressor

		if pressor
			receiver = get_receiver(pressor)

			commentary.build_up(pressor, receiver, special: false)

			if pressor.cock_the_hammer?
				commentary.build_up(pressor, receiver, special: true)

				if pressor.punch
					commentary.outcome(pressor, receiver, hit: true)
				else
					commentary.outcome(pressor, receiver, hit: false)
				end
			else
				commentary.outcome(pressor, receiver, hit: nil)
			end
		end
	end

	private

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

	def get_receiver(opponent)
		([fighter_a, fighter_b] - [opponent]).first
	end
end