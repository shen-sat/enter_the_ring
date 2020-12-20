require 'io/console'
require 'timeout'
require 'tty-prompt'
require 'tty-reader'

class Target
	attr_reader :bullseye, :prompt, :score, :reader

	def initialize
		@prompt = TTY::Prompt.new
		@reader = TTY::Reader.new
	end

	def train	
		punch

		result

		show_options
	end


	def punch
		clear_screen
		
		set_bullseye

		intro_text

		throw_fist

		hit?
	end

private

	def clear_screen
		system('clear')
	end

	def set_bullseye
		@bullseye = rand(50..90)
	end

	def intro_text
		puts "Initiate punch by pressing x.\nLand punch by pressing x again.\nYour target is #{bullseye}"
		loop do
			answer = reader.read_char
			
			break if answer == 'x'
		end
	end

	def result
		output = "You got #{score} - "
		output + (hit? ? 'good punch!' : 'you missed the bag!')
	end

	def show_options
		choices = { retry: :retry }
		
		answer = prompt.select('What would you like to do?', choices)

		punch if answer == :retry
	end

	#This can be removed in game code (and just use land_fist), for now it makes testing easier 
	def throw_fist
		@score = land_fist
	end

	def hit?
		lower_range = bullseye - 5
		upper_range = bullseye + 5

		return score <= upper_range && score >= lower_range
	end

	def land_fist(n = 0)
		begin
			print "===> #{n}" + "\r"
		  status = Timeout::timeout(0.01) { answer = STDIN.getch until answer == "x" }
		  return n
		rescue Timeout::Error
		  n > 100 ? 0 : land_fist(n + 1)
		end
	end
end