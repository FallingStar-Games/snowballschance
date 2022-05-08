# Autoscrolling Panoramas
# by RPG Advocate


#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :autoscroll_x_speed       # panorama horizontal speed
  attr_accessor :autoscroll_y_speed       # panorama vertical speed
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias autopan_initialize initialize
  def initialize
    autopan_initialize
    @autoscroll_x_speed = 0
    @autoscroll_y_speed = 0
  end
end



#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc.
#  It's used within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias autopan_initialize initialize
  def initialize
    @scroll_point_x   = 0
    @scroll_point_y   = 0
    @scroll_frames_x  = 0
    @scroll_frames_y  = 0
    @scroll_speed_x   = $game_system.autoscroll_x_speed
    @scroll_speed_y   = $game_system.autoscroll_y_speed
    # The original call
    autopan_initialize
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias autopan_update update
  def update
    # Apply new scroll speed from $game_system
    if $game_system.autoscroll_x_speed != @scroll_speed_x
      @scroll_speed_x = $game_system.autoscroll_x_speed
    end
    if $game_system.autoscroll_y_speed != @scroll_speed_y
      @scroll_speed_y = $game_system.autoscroll_y_speed
    end
    # The original call
    autopan_update
    # Perform panorama scrolling
    scroll
    # Update panorama plane    
    if $game_system.autoscroll_x_speed == 0
      if $game_system.autoscroll_y_speed == 0
        @panorama.ox = $game_map.display_x / 8
        @panorama.oy = $game_map.display_y / 8
      end
    end
    a = $game_system.autoscroll_x_speed != 0
    b = $game_system.autoscroll_y_speed != 0
    if a or b
      @panorama.ox = @scroll_point_x
      @panorama.oy = @scroll_point_y
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Panorama
  #--------------------------------------------------------------------------
  def scroll
    if @panorama.bitmap!=nil
      
    w = @panorama.bitmap.width
    h = @panorama.bitmap.height
    @scroll_frames_x += @scroll_speed_x
    @scroll_frames_y += @scroll_speed_y
    while @scroll_frames_x >= 8
      @scroll_frames_x -= 8
      @scroll_point_x += 1
    end
    while @scroll_frames_x <= -8
      @scroll_frames_x += 8
      @scroll_point_x -= 1
    end
    while @scroll_frames_y >= 8
      @scroll_frames_y -= 8
      @scroll_point_y += 1
    end
    while @scroll_frames_y <= -8
      @scroll_frames_y += 8
      @scroll_point_y -= 1
    end
    @scroll_point_x -= w  if @scroll_point_x > w
    @scroll_point_x += w  if @scroll_point_x < -w
    @scroll_point_y -= h  if @scroll_point_y > h
    @scroll_point_y += h  if @scroll_point_y < -h
    end
  end
end