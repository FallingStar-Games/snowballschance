#================================
#Author: Zeriab                               Date:20-01-2006
#
# Last Modified: 20-01-2006
#
# Destination.class:
# --------------------
# Represents a destination by an event
#================================

class Destination
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
end