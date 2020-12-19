require_relative '../lib/settings'

class Fighter
	attr_accessor :firstname, :lastname, :nickname, :age, :rank

	def punch?
		SharedMethods.roll_die(Settings::ROSTER_SIZE) >= rank
	end
end