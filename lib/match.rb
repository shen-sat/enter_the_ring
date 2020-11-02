class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter

	def initialize(commentary)
		@commentary = commentary
	end

	def roll_die
		(rand 6) + 1
	end

	def something_happens?
		sleep 2

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
		sleep 2

		commentary.action(pressing_fighter, other_fighter)
	end

	def start
		if something_happens?
			set_fighters
			puts prelude_to_action
			puts action
		end
	end
end