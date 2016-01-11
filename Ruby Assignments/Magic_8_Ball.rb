#Magic_8_Ball.rb
#Bradley Trowbridge
#Programming Languages
#Prof: Dean Bushey

#Static method to clear screen
class Screen
	def self.cls
		print "\n" * 50
		print "\a"
	end
end

#This is a player class that holds the user name
#used by Magic 8 Ball class for greeting
class Player
	attr_reader :name

	def initialize(n = nil)
		if n == nil
			requestName()
		else
			@name = n
		end
	end

	def requestName()
		print "Type your name and hit enter: "
		@name = STDIN.gets
		

	end
end


#This class will ask the player if they want to play,
#ask for a question, respond and then ask to play again, 
#repeating unless the user types 'y'
class Magic8Ball
	def greeting (name)
		print "Welcome #{name} to The Magic 8 Ball  program. (Press enter to continue) \n\n"
		STDIN.gets
		Screen.cls
	end
	def play()
		running = true
		print "Would you like to play? (type y and hit enter to play)\n\n"

		while running
		response = STDIN.gets
		Screen.cls
		response.chomp()
			if response.include?("Y") or response.include?("y")
				shakeBall()
				print "Would you like to play again? (type y and hit enter to play)\n\n"
			else
				
				running = false
			end
		end
		print "Goodbye"
	end

	def shakeBall()
		print "What is your question?\n\n"
		STDIN.gets
		Screen.cls
		r = Random.new
		randint = r.rand(6)
		case randint
			when 0
				print "Without a doubt"
			when 1
				print "Most likely"
			when 2
				print "Ask again later"
			when 3
				print "Better not tell you now"
			when 4
				print "Dont count on it"
			when 5
				print "Very doubtful"
			else
				print "ERROR: bad random number"
		end
		print "\n"
	end
end


player = Player.new
ball = Magic8Ball.new
ball.greeting(player.name)
ball.play()
