class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter, :player_store, :opponent_store, :moments

	def initialize(commentary)
		@commentary = commentary
		@player_store = { punch: false, block_punch: false, counter: 1 }
		@opponent_store = { punch: false, block_punch: false, counter: 1 }
		@moments = 6
	end

	def roll_die(max = 6)
		(rand max) + 1
	end

	def something_happens?
		sleep [1, 2].sample

		decide_punch
		return true if @player_store[:punch] || @opponent_store[:punch] 

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


	def player_can_punch?(fighter_store)
		fighter_store[:counter] >= roll_die(moments) && !fighter_store[:block_punch]
	end

	def decide_punch
		[@player_store, @opponent_store].each do |fighter_store|
			fighter_store[:punch] = false if fighter_store[:punch]

			if player_can_punch?(fighter_store)
				fighter_store[:punch] = true
				fighter_store[:block_punch] = true
			end

			if fighter_store[:counter] >= moments
				fighter_store[:counter] = 1
				fighter_store[:block_punch] = false
			else
				fighter_store[:counter] += 1
			end 
		end
		
	end
end