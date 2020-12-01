class Match
	attr_reader :commentary, :pressing_fighter, :other_fighter, :moments, :punch_data

	def initialize(commentary, player, opponent)
		@commentary = commentary
		@moments = 6

		player_data = { fighter: player, punch: false, block_punch: false, counter: 1 }
		opponent_data = { fighter: opponent, punch: false, block_punch: false, counter: 1 }
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

	def pick_pressing_fighter
		[ @punch_data.first[:fighter], @punch_data.last[:fighter] ].sample
	end

	def pick_receiving_fighter(pressing_fighter)
		([ @punch_data.first[:fighter], @punch_data.last[:fighter] ] - [ pressing_fighter ]).first
	end

	def prelude(pressing_fighter:, receiving_fighter:, punch: false)
		sleep [1, 2].sample

		commentary.prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: punch)
	end

	def action(pressing_fighter:, receiving_fighter:, punch: false)
		sleep [1, 2].sample

		commentary.action(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: punch)
	end

	def run_fluff_encounter
		pressing_fighter = pick_pressing_fighter
		receiving_fighter = pick_receiving_fighter(pressing_fighter)

		prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter)
		action(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter)
	end

	def run_punch_encounter
		punch_data.each do |data|
			if data[:punch]
				pressing_fighter = data[:fighter]
				receiving_fighter = pick_receiving_fighter(pressing_fighter)

				prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: true)
				action(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: true)		
			end
		end
	end

	def encounter
		punch_data.any? { |data| data[:punch] } ? run_punch_encounter : run_fluff_encounter
	end


	def fighter_can_punch?(data)
		data[:counter] >= roll_die(moments) && !data[:block_punch]
	end

	def decide_punch
		punch_data.each do |data|
			data[:punch] = false if data[:punch]

			if fighter_can_punch?(data)
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