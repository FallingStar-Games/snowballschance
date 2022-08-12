#================================
# Author: lavendersiren/Zeriab                               Date:20-01-2021
# with help from narcodis
# Last Modified: 20-01-2021
#
# Shooty.class:
# ---------------
# The mini-game Shooty's main class:
#
# The target events must be named "Target1", "Target2"
# and so forth until all the used
# The game will not function properly if this is not done.

# call Shooty.check when you're shooting something!
#================================

class Shooty
  #---------------------------------------------------------------
  # Constructor(variable, switch):
  # 'variable' is number of the variable to read the
  # amount of targets used from.
  # 'switch' is the number of the switch that will be
  # turned ON when the map have been completed.
  #---------------------------------------------------------------
  def initialize(variable, switch)
    @variable = variable
    @switch = switch
    @targets = {}
    @counter = 0
    setup
    # there is no need to call check when you start because 
    # you can't hit a target that fast.
  end
  
  #---------------------------------------------------------------
  # Sets the game up.
  # Saves each used event's reference for later use.
  #---------------------------------------------------------------
  def setup()
    for x in $game_map.events
      name = x[1].name.gsub("Target", "")
      nameint = ((name.to_i - 1) / $game_variables[@variable])
      #name becomes a string containing a number	
      #nameint turns the number (actually a string) from name 
      #and turns it into an int, and then goes down by 1
      #and then divides it by the stated variable's current amount
      
      #I'm guessing this tells it when to stop counting targets
      if nameint == 0
        @targets[name.to_i] = Target.new(x[1])
				#this crams allll of the target event data into the targets array								  
      end
    end
  end
    
  #---------------------------------------------------------------
  # this does all the magic!
  #---------------------------------------------------------------
  def check()
    #--------------------------------------------------------------
    # Goes through the targets.
    #--------------------------------------------------------------
    #p "let's check this"
      for j in 1..$game_variables[@variable]
        target = @targets[j]
        #p @counter
        #----------------------------------------------------------
        # check coordinates, direction, and items held after hitting button
        #----------------------------------------------------------
        case $game_player.direction
	      when 2
        unless $game_player.y+1==nil #prevents edge case breakage
          #check if event "target".y is more than player.y
          if target.y > $game_player.y && target.x == $game_player.x && !target.is_hit?
                target.been_hit(true)
                @counter = @counter + 1
                #p "hit 2"
            end
			  end #done
	      when 4 
        unless $game_player.x-1==nil
          if target.x < $game_player.x && target.y == $game_player.y && !target.is_hit?
                target.been_hit(true)
                @counter = @counter + 1
                #p "hit 4"
            end
        end #done
	      when 6  
        unless $game_player.x+1==nil
          if target.x > $game_player.x && target.y == $game_player.y && !target.is_hit?
                target.been_hit(true)
                @counter = @counter + 1
                #p "hit 6"
            end
        end #done
	      when 8  
        unless $game_player.y-1==nil
          if target.y < $game_player.y && target.x == $game_player.x && !target.is_hit?
                target.been_hit(true)
                @counter = @counter + 1
                #p "hit 8"
            end
        end
	    end #case done
    $game_map.need_refresh = true

    #------------------------------------------------------------
    # If you got all the targets in the room (defined in the variable)
    #------------------------------------------------------------
    if (@counter == $game_variables[@variable])
      complete
    end
  end
  end
  #---------------------------------------------------------------
  # When you have completed the level the chosen
  # switch will be turned ON.
  #---------------------------------------------------------------
  def complete()
    $game_switches[@switch] = true
  end
  
end