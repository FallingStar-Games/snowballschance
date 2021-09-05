#================================
# Author: Zeriab                               Date:20-01-2006
#
# Last Modified: 20-01-2006
#
# Gamos.class:
# ---------------
# The mini-game Gamos's main class:
# It manages the stones and destinations.
# A stone is not tied to a specific destination
#
# The stone events must be named "Stone1", "Stone2"
# and so forth until all the used stones are named
# The destination events must be named "Destination1",
# "Destination2" and so forth until all the destinations
# are named. The game would not function properly if 
# this is not done
#================================

class Gamos
  #---------------------------------------------------------------
  # Constructor(variable, switch):
  # 'variable' is number of the variable to read the
  # amount of stones used from.
  # 'switch' is the number of the switch that will be
  # turned ON when the map have been completed.
  #---------------------------------------------------------------
  def initialize(variable, switch)
    @variable = variable
    @switch = switch
    @stones = {}
    @destinations = {}
    setup
    
    #-------------------------------------------------------------
    # Check is called to make sure any stone starting on
    # a destination is appropiately changed
    #-------------------------------------------------------------
    check
  end
  
  #---------------------------------------------------------------
  # Sets the game up.
  # Saves each used event's reference for later use.
  #---------------------------------------------------------------
  def setup()
    #New better setup
    for x in $game_map.events
      #name = x[1].event.name.gsub("Stone", "")
      name = x[1].name.gsub("Stone", "") #make this work!
      nameint = ((name.to_i - 1) / $game_variables[@variable])
      if nameint == 0
        @stones[name.to_i] = Stone.new(x[1])
      else
        name = x[1].name.gsub("Destination", "")
        nameint = ((name.to_i - 1) / $game_variables[@variable])
        if nameint == 0
          @destinations[name.to_i] = Destination.new(x[1])
        end
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
    counter = 0     # Counts the number of stones on 
                          # destinations
    #--------------------------------------------------------------
    # Goes through the stones.
    #--------------------------------------------------------------
    for i in 1..$game_variables[@variable]
      stone = @stones[i]
      stone.reached_destination(false)  #Marked 'false'
      #------------------------------------------------------------
      # Goes through the destinations for each stone.
      #------------------------------------------------------------
      for j in 1..$game_variables[@variable]
        destination = @destinations[j]
        #----------------------------------------------------------
        # If the stones x-coordinate is equal to the
        # destinations x-coordinate and likewise their
        # y-coordinates are equal the stone are thought
        # to be on top of the destination.
        #----------------------------------------------------------
        if (stone.x == destination.x) && (stone.y == destination.y)
          #---------------------------------------------------------
          # The stone is marked 'true'.
          #---------------------------------------------------------
          stone.reached_destination(true)
          counter = counter + 1
        end
      end
    end
    
    $game_map.need_refresh = true

    #------------------------------------------------------------
    # If the amount of correctly placed stones is equal
    # to the amount of stones registered the game is
    # completed.
    #------------------------------------------------------------
    if (counter == $game_variables[@variable])
      complete
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