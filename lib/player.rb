require_relative 'fighter'

class Player < Fighter
	attr_reader :target

	def initialize(target)
		@target = target
	end

	def punch?(match = false)
		target.punch(match)
	end
end