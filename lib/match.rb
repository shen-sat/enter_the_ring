class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter, :player_counter, :punch, :block_punch, :moments

	def initialize(commentary)
		@commentary = commentary
		@player_counter = 0
		@moments = 6
		@punch = false
		@block_punch = false
	end

	def roll_die(max = 6)
		(rand max) + 1
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

	def increment_player_counter
		@player_counter += 1
	end

	def decide_punch
		if player_counter <= roll_die(moments) && !block_punch
			@punch = true
			@block_punch = true
		end
	end

end