#================================
# Author: lavendersiren/Zeriab                               Date:20-01-2021
#
# Last Modified: 20-01-2021
#
# Shooty.class:
# ---------------
# The mini-game Shooty's main class:
# It manages the stones and destinations.
# A stone is not tied to a specific destination
#
# The target events must be named "Target1", "Target2"
# and so forth until all the used
#The game would not function properly if this is not done.

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
      if nameint == 0
        @targets[name.to_i] = Target.new(x[1])
																											  
      end
    end
  end
    
  #---------------------------------------------------------------
  # Checks whether any given stone is present on any
  # given destination. Changes the stones accordingly.
  # If all destinations are covered the map will be
  # completed.
  #---------------------------------------------------------------
  def check()
    counter = 0     # Counts the number of hit targets
    #--------------------------------------------------------------
    # Goes through the targets.
    #--------------------------------------------------------------
    for i in 1..$game_variables[@variable]
      target = @targets[i]
      target.been_hit(false)  #Marked 'false' (previously reached_destination)
      #------------------------------------------------------------
      # Goes through the destinations for each stone.
      #------------------------------------------------------------
      for j in 1..$game_variables[@variable]
        target = @targets[j]
        #----------------------------------------------------------
        # check coordinates, direction, and items held after hitting button
        #----------------------------------------------------------
        #if (target.x == destination.x) && (stone.y == destination.y)
        case $game_player.direction
	      when 2
        unless $game_player.y+1==nil #prevents edge case breakage
          #check if event "target".y is more than player.y
          if target.y > $game_player.y && target.x == $game_player.x
                target.been_hit(true)
                counter = counter + 1
            end
			  end #done
	      when 4 
        unless $game_player.x-1==nil
          if target.x < $game_player.x && target.y == $game_player.y
                target.been_hit(true)
                counter = counter + 1
                p "facing left"
            end
        end #done
	      when 6  
        unless $game_player.x+1==nil
          if target.x > $game_player.x && target.y == $game_player.y
                target.been_hit(true)
                counter = counter + 1
                p "facing right"
            end
        end #done
	      when 8  
        unless $game_player.y-1==nil
          if target.y < $game_player.y && target.x == $game_player.x
                target.been_hit(true)
                counter = counter + 1
                p "facing up"
            end
        end
	    end #case done

    end #for loop done
    
    $game_map.need_refresh = true

    #------------------------------------------------------------
    # If you got all the targets in the room (defined in the variable)
    #------------------------------------------------------------
    if (counter == $game_variables[@variable])
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