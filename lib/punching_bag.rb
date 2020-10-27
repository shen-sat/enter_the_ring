require 'io/console'
require 'timeout'

class PunchingBag
	attr_reader :target, :prompt, :punch

	def initialize
		@prompt = TTY::Prompt.new
	end

	def train
		clear_screen

		pick_target

		intro_text

		set_punch

		result

		show_options
	end

private

	def clear_screen
		system('clear')
	end

	def pick_target
		@target = rand(50..75)
	end

	def intro_text
		puts "Start training by pressing x.\nHit the bag by pressing x again.\nYour target is #{target}"
	end

	def result
		hit? ? 'Good punch!' : 'You missed the bag!'
	end

	def show_options
		choices = { retry: :retry }
		
		answer = prompt.select('What would you like to do?', choices)

		train if answer == :retry
	end

	def set_punch
		@punch = throw_punch
	end

	def hit?
		lower_range = target - 5
		upper_range = target + 5

		return punch <= upper_range && punch >= lower_range
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
end