class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter, :moments, :punch_data

	def initialize(commentary)
		@commentary = commentary
		@moments = 6
		player_data = { punch: false, block_punch: false, counter: 1 }
		opponent_data = player_data.dup
		@punch_data = [ player_data, opponent_data ]
	end

	def roll_die(max = 6)
		(rand max) + 1
	end

	def something_happens?
		sleep [1, 2].sample

		decide_punch
		return true if punch_data.any? { |data| data[:punch] }

		roll_die >= 5 ? true : false
	end

	def set_fighters(player:, opponent:)
		fighters = [ player, opponent ]

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


	def player_can_punch?(data)
		data[:counter] >= roll_die(moments) && !data[:block_punch]
	end

	def decide_punch
		punch_data.each do |data|
			data[:punch] = false if data[:punch]

			if player_can_punch?(data)
				data[:punch] = true
				data[:block_punch] = true
			end

			if data[:counter] >= moments
				data[:counter] = 1
				data[:block_punch] = false
			else
				data[:counter] += 1
			end 
		end
		
	end
end