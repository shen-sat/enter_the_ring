require 'tty-prompt'
require_relative 'fighter'

class FighterBuilder
	attr_reader :prompt, :fighter

	def initialize
		@prompt = TTY::Prompt.new
		@fighter = Fighter.new
	end

	def set_firstname
		@fighter.firstname = prompt.ask("What is your firstname?")
	end

	def set_lastname
		@fighter.lastname = prompt.ask("What is your lastname?")
	end

	def set_nickname
		@fighter.nickname = prompt.ask("What is your nickname?")
	end

	def set_age
		@fighter.age = prompt.ask("What is your age?")
	end

	def set_rank
		@fighter.rank = prompt.ask("What is your rank?")
	end

	def build
		built_fighter = @fighter

		@fighter = Fighter.new

		built_fighter
	end
end

