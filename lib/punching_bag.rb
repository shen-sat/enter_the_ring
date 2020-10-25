require 'io/console'
require 'timeout'

class PunchingBag
	attr_reader :target, :punch

	def intro_text
		puts 'Hit the bag'
	end

	def pick_target
		@target = rand(50..75)
	end

	def throw_punch(n = 0)
		begin
			print "===> #{n}" + "\r"
		  status = Timeout::timeout(0.01) { answer = STDIN.getch until answer == "x" }
		  return n
		rescue Timeout::Error
		  n > 100 ? 0 : throw_punch(n + 1)
		end
	end

	def set_punch
		@punch = throw_punch
	end

	def hit?
		lower_range = target - 5
		upper_range = target + 5

		return punch <= upper_range && punch >= lower_range
	end
end