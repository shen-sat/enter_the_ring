class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter, :initiate_minigame

	def initialize(commentary)
		@commentary = commentary
	end

	def roll_die
		(rand 6) + 1
	end

	def something_happens?
		sleep [1, 2].sample

		roll_die >= 5 ? true : false
	end

	def set_fighters(fighter_one, fighter_two)
		fighters = [ fighter_one, fighter_two ]

		@pressing_fighter = fighters.sample
		@other_fighter = (fighters - [ pressing_fighter ]).first
	end

	def prelude_to_action
		commentary.prelude(pressing_fighter, other_fighter)
	end

	def action
		sleep [1, 2].sample

		commentary.action(pressing_fighter, other_fighter)
	end

	def reset
		@initiate_minigame = false
	end

	def start(fighter_one, fighter_two)
		if something_happens?
			set_fighters(fighter_one, fighter_two)
			puts prelude_to_action
			puts action
			reset
		end
	end
end