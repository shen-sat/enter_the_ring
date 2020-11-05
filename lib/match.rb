class Match
	attr_reader :commentary, 
							:pressing_fighter, 
							:other_fighter, 
							:initiate_minigame, 
							:player_step_counter,
							:player_punch_thrown,
							:steps_for_punch,
							:total_steps,
							:punch_max

	def initialize(commentary)
		@commentary = commentary
		@total_steps = 18
		@punch_max = 3
		@steps_for_punch = total_steps/punch_max
		@initiate_minigame = false
		@player_step_counter = 1
		@player_punch_thrown = false
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

	def reset_minigame
		@initiate_minigame = false
	end

	def reset_player_counter_and_punch
		@player_step_counter = 1
		@player_punch_thrown = false
	end

	def roll_punch_die
		rand(steps_for_punch) + 1
	end

	def throw_punch?
		roll_punch_die <= player_step_counter && !player_punch_thrown
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