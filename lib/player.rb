class Player
	attr_reader :firstname, :lastname, :nickname, :age, :rank

	def initialize(firstname:, lastname:, nickname:, age:, rank:)
		@firstname = firstname 
		@lastname = lastname 
		@nickname = nickname 
		@age = age 
		@rank = rank	
	end
end