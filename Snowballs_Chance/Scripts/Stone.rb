#================================
#Author: Zeriab                               Date:20-01-2006
#
# Last Modified: 20-01-2006
#
# Stone.class:
# --------------
# Represents a stone by an event
#================================

class Stone
  #---------------------------------------------------------------
  #  Constructor, basically stores the given event
  #---------------------------------------------------------------
  def initialize(event)
    @event = event
  end
  
  #---------------------------------------------------------------
  #  Returns the x-value of the stone
  #---------------------------------------------------------------
  def x()
    return @event.x
  end

  #---------------------------------------------------------------
  # Returns the y-value of the stone
  #---------------------------------------------------------------
  def y()
    return @event.y
  end
  
  #---------------------------------------------------------------
  # Sets the local switch A on the stored event to 'value'
  #---------------------------------------------------------------
  def reached_destination(value)
    $game_self_switches[[$game_map.map_id, @event.id, "A"]] = value
  end
end