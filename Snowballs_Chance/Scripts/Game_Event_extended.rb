#===============================================================================
# Author: Zeriab                               Date:03-06-2006
# Last Modified: 31-07-2006
#
# Game_Event: (Extension)
# ----------------------
# Adds the ability to change the id
# Adds the ability to copy the event
# Loads the name of an event in the editor into the event.
#===============================================================================
class Game_Event < Game_Character
  attr_reader   :name   #The name in the editor

  # Refers intialize to Game Event
  alias game_event_initialize initialize
  
  #--------------------------------------------------------------------------
  # Loads the name of the event
  #--------------------------------------------------------------------------
  def initialize(map_id, event)
    game_event_initialize(map_id, event)
    @name = event.name
  end
  
  #--------------------------------------------------------------------------
  # * Sets @id and @event.id to the given value
  #--------------------------------------------------------------------------
  def id=(value)
    @id = value
    @event.id = value
  end

  #--------------------------------------------------------------------------
  # * Copies the event
  #--------------------------------------------------------------------------
  def copy
    temp = Game_Event.new(@map_id, @event.dup)
    temp.id = @id
    return temp
  end
end