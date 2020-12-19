require_relative '../lib/shared_methods'

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

		SharedMethods.roll_die >= ambient_action_score ? true : false
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
		data[:counter] >= SharedMethods.roll_die(moments) && !data[:block_punch]
	end

	def any_fighters_want_to_punch?
		punch_data.any? { |data| data[:punch] }
	end

	def run_fluff_encounter
		pressing_fighter = pick_pressing_fighter
		receiving_fighter = pick_receiving_fighter(pressing_fighter)

		prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter)
		postlude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter)
	end

	def run_punch_encounter
		punch_data.each do |data|
			if data[:punch]
				pressing_fighter = data[:fighter]
				receiving_fighter = pick_receiving_fighter(pressing_fighter)

				prelude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: true)

				punch = pressing_fighter.punch_success?

				postlude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: punch)		
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

	def postlude(pressing_fighter:, receiving_fighter:, punch: false)
		sleep [1, 2].sample

		commentary.postlude(pressing_fighter: pressing_fighter, receiving_fighter: receiving_fighter, punch: punch)
	end
end

# class Commentary
# 	def prelude(pressing_fighter:, receiving_fighter:, punch:)
# 		if punch
# 			puts "#{pressing_fighter} winds up for a MASSIVE punch!"
# 		else
# 			puts "#{pressing_fighter} throws a jab"
# 		end
# 	end

# 	def postlude(pressing_fighter:, receiving_fighter:, punch:)
# 		if punch
# 			puts "#{pressing_fighter} lands a SWEET haymaker!"
# 		else
# 			puts "#{receiving_fighter} ducks and moves away"
# 		end
# 	end
# end

# class Target
# 	def punch
# 		puts 'x for punch, m for miss'
# 		answer = gets.chomp
# 		answer == 'x' ? true : false
# 	end
# end

# commentary = Commentary.new
# target = Target.new

# Match.new(commentary,target,'Edgar','Mendes').run

