#================================
#Author: lavendersiren/Zeriab                               Date:20-01-2021
#
# Last Modified: 20-01-2021
#
# Target.class:
# --------------------
# Represents a target by an event
#================================
class Target
    #---------------------------------------------------------------
  #  Constructor, basically stores the given event
  #---------------------------------------------------------------
  def initialize(event)
    @event = event
  end
  
  #---------------------------------------------------------------
  #  Returns the x-value of the target
  #---------------------------------------------------------------
  def x()
    return @event.x
  end

  #---------------------------------------------------------------
  # Returns the y-value of the target
  #---------------------------------------------------------------
  def y()
    return @event.y
  end
  
  #---------------------------------------------------------------
  # Sets the local switch A on the stored event to 'value'
  #---------------------------------------------------------------
  def been_hit(value)
    $game_self_switches[[$game_map.map_id, @event.id, "A"]] = value
  end
end