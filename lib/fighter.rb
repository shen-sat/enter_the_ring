require_relative '../lib/settings'

class Fighter
	attr_accessor :firstname, :lastname, :nickname, :age, :rank

	def punch
		SharedMethods.roll_die(Settings::ROSTER_SIZE) >= rank
	end

	def press?
		SharedMethods.roll_die <= Settings::FIGHTER_ACTIVITY_CHANCE_THRESHOLD
	end

	def cock_the_hammer?
		SharedMethods.roll_die <= Settings::FIGHTER_PUNCH_CHANCE_THRESHOLD
	end
end