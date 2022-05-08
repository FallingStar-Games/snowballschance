  #--------------------------------------------------------------------------
  # * Turn Towards event
  # by lavendersiren (because nobody else fucking wanted to make it)
  #--------------------------------------------------------------------------
 
class Game_Character
  
 def turn_toward_event(id)
    #the subject's x minus the target's x
    sx = @x - $game_map.events[id].x
    sy = @y - $game_map.events[id].y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end   
  
end