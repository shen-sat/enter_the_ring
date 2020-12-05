class Match
	attr_reader :commentary, :target, :moments, :punch_data, :ambient_action_score

	def initialize(commentary, target, player, opponent)
		@commentary = commentary
		@target = target
		@moments = 10
		@ambient_action_score = 4

		player_data = { fighter: player, punch: false, block_punch: false, counter: 1 }
		opponent_data = { fighter: opponent, punch: false, block_punch: false, counter: 1 }
		@punch_data = [ player_data, opponent_data ]
	end

	def run
		30.times { encounter if something_happens? }
	end

	def something_happens?
		sleep [1, 2].sample

		decide_punches
		return true if any_fighters_want_to_punch?

		roll_die >= ambient_action_score ? true : false
	end

	def encounter
		any_fighters_want_to_punch? ? run_punch_encounter : run_fluff_encounter
	end

private
	
	def decide_punches
		punch_data.each do |data|
			data[:punch] = false if data[:punch]

			if fighter_chooses_to_punch?(data)
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

	def fighter_chooses_to_punch?(data)
		data[:counter] >= roll_die(moments) && !data[:block_punch]
	end

	def roll_die(max = 6)
		(rand max) + 1
	end

	def any_fighters_want_to_punch?
		punch_data.any? { |data| data[:punch] }
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

				#if player, then run target.punch to determine if action is punch or failed punch, else it is punch true for opponent
				punch = (data == punch_data.first ? target.punch : true)

				action(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: punch)		
			end
		end
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
end

# class Commentary
# 	def prelude(pressing_fighter:, receiving_fighter:, punch:)
# 		if punch
# 			puts "#{pressing_fighter} winds up for a big punch!"
# 		else
# 			puts "#{pressing_fighter} throws a jab"
# 		end
# 	end

# 	def action(pressing_fighter:, receiving_fighter:, punch:)
# 		if punch
# 			puts "#{pressing_fighter} lands a sweet haymaker!"
# 		else
# 			puts "#{receiving_fighter} ducks and moves away"
# 		end
# 	end
# end

# commentary = Commentary.new

# Match.new(commentary,'Edgar','Mendes').run

