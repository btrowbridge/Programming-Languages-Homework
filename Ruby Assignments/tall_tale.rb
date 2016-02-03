#tall_tale


class Screen
	def cls
		puts "\n" * 25
		puts "\a"
	end
end

class Tale
	attr_accessor :monster, :villain, :object, :place, :location
	attr_accessor :P1, :P2, :P3, :P4
	def tell_story paragraph
		puts paragraph
	end
end

Console_Screen = Screen.new
Console_Screen.cls
print "Would you like to hear an interesting story" + "(y/n) \n\n: "
answer = STDIN.gets
answer.chomp

if answer == "n"
	Console_Screen.cls
	puts "Okay, Perhaps another time. \n\n"
else
	Story = Tale.new
	Console_Screen.cls
	print %Q{Type the name of a scary monster. (Press Enter) \n\n: }

	monster  = STDIN.gets
	monster.chomp
	Console_Screen.Console_Screen

	print %Q{What would a villain's name be? (Press Enter) \n\n: }

	villain = STDIN.gets
	#
	#
	# Unfinished
end