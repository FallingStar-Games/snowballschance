#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
# DRG - Pixel Movement
# Version: 1.15
# Author : LiTTleDRAgo
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
($imported ||= {})[:drg_pixel_movement] = 1.15
#==============================================================================
#
# Introduction :
#
#   This script makes player's movement became pixel movement.
#   Event pixel movement turned off by default.
#
#   To activate / deactivate pixel movement
#   - $game_player.pixel_movement               = true / false
#   - $game_map.events[EVENT_ID].pixel_movement = true / false
#
#   If used in Script call
#   - get_character(ID).pixel_movement = true / false
#   where ID : -1 (player),
#               0 (self event),
#               1.. (event ID)
#
#==============================================================================
#==============================================================================
# ** Game_Character 
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :pixel_movement, :direction_fix
  attr_writer   :revise_x,       :revise_y
  #--------------------------------------------------------------------------
  # * Others
  #--------------------------------------------------------------------------
  define_method(:x_with_direction)  {|x, d| x + (d==6 ?   1 : d==4 ?   -1 : 0)}
  define_method(:y_with_direction)  {|y, d| y + (d==2 ?   1 : d==8 ?   -1 : 0)}
  define_method(:x_pixel_direction) {|x, d| x + (d==6 ? 0.5 : d==4 ? -0.5 : 0)}
  define_method(:y_pixel_direction) {|y, d| y + (d==2 ? 0.5 : d==8 ? -0.5 : 0)}
  define_method(:revise_x)          { pixel_disable? ? 0    : @revise_x ||= 0 }
  define_method(:revise_y)          { pixel_disable? ? 0    : @revise_y ||= 0 }
  #--------------------------------------------------------------------------
  # * Constant
  #--------------------------------------------------------------------------
  ALIASING_PIXEL = lambda do |x|
    [:move_down,:move_left,:move_right,:move_up, :move_lower_left,
    :move_lower_right,:move_upper_left,:move_upper_right].each do |meth|
      $@ || alias_method(:"#{meth}_unpixel_#{x}", :"#{meth}")
      define_method(:"#{meth}") do |*args|
        respond_to?(:"#{meth}_pixel") && !pixel_disable? ? 
        send(:"#{meth}_pixel",*args) : 
        reset_pixel && send(:"#{meth}_unpixel_#{x}",*args) 
      end
    end
  end  
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  $@ || alias_method(:update_move_unpixel, :update_move)
  $@ || alias_method(:moving_unpixel, :"moving?")
  unless $Modular_Passable
    $@ || alias_method(:passable_unpixel, :passable?)
  else
    $@ || alias_method(:passable_conditions_unpixel, :"passable_conditions?")
    $@ || alias_method(:player_conditions_unpixel,   :"player_conditions?")
  #--------------------------------------------------------------------------
  # * Aliased method: passable_conditions?
  #--------------------------------------------------------------------------
    def passable_conditions?(x, y, d, new_x, new_y, event, *args)
      result = passable_conditions_unpixel(x, y, d, new_x, new_y, event, *args)
      unless result
        if ((event.x + event.revise_x) - new_x).abs < 1 and 
            ((event.y + event.revise_y) - new_y).abs < 1 and
              not event.through and event != self
          return true
        end
      end
      return result
    end
  #--------------------------------------------------------------------------
  # * Aliased method: player_conditions?
  #--------------------------------------------------------------------------
    def player_conditions?(x, y, d, *args)
      result = player_conditions_unpixel(x, y, d, *args)
      return true unless result || player_collition_passable?(x,y,d)
      return result
    end  
  end
  #--------------------------------------------------------------------------
  # * Aliased method: passable?
  #--------------------------------------------------------------------------
  unless $Modular_Passable
    def passable?(x, y, d)
      result = passable_unpixel(x, y, d)
      unless @through || !result 
        return false unless pixel_disable? || passable_pixel?(x, y, d)
      end
      return result
    end
  end
  #--------------------------------------------------------------------------
  # * Passable Pixel
  #--------------------------------------------------------------------------
  def passable_pixel?(x, y, d)
    event_collition_passable?(x, y, d) && player_collition_passable?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * Determine if Collided with Events
  #--------------------------------------------------------------------------
  def event_collition_passable?(x, y, d)
    unless @through
      new_x = x_with_direction(x, d) 
      new_y = y_with_direction(y, d) 
      for event in $game_map.events.values
        #----------------------------------------------------------
        unless event.through || (self == event)
          if ((event.x + event.revise_x) - new_x).abs < 1 and 
            ((event.y + event.revise_y) - new_y).abs < 1
        #----------------------------------------------------------
            return false if self != $game_player
            return false if event.character_name != ""
          end
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Collided with Player
  #--------------------------------------------------------------------------
  def player_collition_passable?(x,y,d)
    unless self == (pl = $game_player) || @through
      new_x = x_with_direction(x,d) 
      new_y = y_with_direction(y,d) 
      #----------------------------------------------------------
      if @character_name != "" && !pl.through &&
        ((pl.x + pl.revise_x) - new_x).abs < 1 && 
        ((pl.y + pl.revise_y) - new_y).abs < 1
      #----------------------------------------------------------
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Aliased method: update_move
  #--------------------------------------------------------------------------
  def update_move
    if pixel_disable?
      reset_pixel && update_move_unpixel
    else
      distance = 2 ** @move_speed
      _x,_y = (@x + revise_x), (@y + revise_y)
      @real_y = [@real_y + distance, _y * 128].min if _y * 128 > @real_y
      @real_x = [@real_x - distance, _x * 128].max if _x * 128 < @real_x
      @real_x = [@real_x + distance, _x * 128].min if _x * 128 > @real_x
      @real_y = [@real_y - distance, _y * 128].max if _y * 128 < @real_y
      @anime_count += @walk_anime ? 1.5 : @step_anime ? 1 : 0
    end
  end
  #--------------------------------------------------------------------------
  # * Aliased method: moving?
  #--------------------------------------------------------------------------
  def moving?
    if pixel_disable?
      moving_unpixel
    else
      (@real_x != (@x + revise_x) * 128 || @real_y != (@y + revise_y) * 128)
    end
  end
  #--------------------------------------------------------------------------
  # * xy_pixel_correction
  #--------------------------------------------------------------------------
  def xy_pixel_correction(direction)
    _x, _y = (@x + revise_x), (@y + revise_y)
    case direction
    when 2
      if revise_x % 1 != 0
        unless passable?(_x.ceil,_y.floor, 2) or passable?(_x.ceil,_y.ceil, 2)
          if passable?(_x.floor,_y.floor, 2) or passable?(_x.floor,_y.ceil, 2)
            @revise_x = (_x = (@x += revise_x.floor)) * 0
          end
        end
      end
      if revise_x % 1 != 0
        unless passable?(_x.floor,_y.floor, 2) or passable?(_x.floor,_y.ceil, 2)
          if passable?(_x.ceil,_y.floor, 2) or  passable?(_x.ceil,_y.ceil, 2) 
            @revise_x = (_x = (@x += revise_x.ceil)) * 0   
          end
        end
      end
    when 4
      if revise_y % 1 != 0
        unless passable?(_x.ceil,_y.ceil, 4) or passable?(_x.floor,_y.ceil, 4)
          if passable?(_x.ceil,_y.floor, 4) or passable?(_x.floor,_y.floor, 4)
            @revise_y = (_y = (@y += revise_y.floor)) * 0
          end
        end
      end
      if revise_y % 1 != 0
        unless passable?(_x.ceil,_y.floor, 4) or passable?(_x.floor,_y.floor, 4)
          if passable?(_x.ceil,_y.ceil, 4) or passable?(_x.floor,_y.ceil, 4)
            @revise_y = (_y = (@y += revise_y.ceil)) * 0
          end
        end
      end
    when 6
      if revise_y % 1 != 0
        unless passable?(_x.floor,_y.ceil, 6) or passable?(_x.ceil,_y.ceil, 6)
          if passable?(_x.floor,_y.floor, 6) or passable?(_x.ceil,_y.floor, 6)
            @revise_y = (_y = (@y += revise_y.floor)) * 0
          end
        end
      end
      if revise_y % 1 != 0
        unless passable?(_x.floor,_y.floor, 6) or passable?(_x.ceil,_y.floor, 6)
          if passable?(_x.floor,_y.ceil, 6) or passable?(_x.ceil,_y.ceil, 6)
            @revise_y = (_y = (@y += revise_y.ceil)) * 0
          end
        end
      end
    when 8
      if revise_x % 1 != 0
        unless passable?(_x.ceil,_y.ceil, 8) or passable?(_x.ceil,_y.floor, 8)
          if passable?(_x.floor,_y.ceil, 8) or passable?(_x.floor,_y.floor, 8)
            @revise_x = (_x = (@x += revise_x.floor)) * 0
          end
        end
      end
      if revise_x % 1 != 0
        unless passable?(_x.floor,_y.ceil, 8) or passable?(_x.floor,_y.floor, 8)
          if passable?(_x.ceil,_y.ceil, 8) or passable?(_x.ceil,_y.floor, 8)
            @revise_x = (_x = (@x += revise_x.ceil)) * 0
          end
        end
      end
    end  
    direction
  end
  #--------------------------------------------------------------------------
  # * add_revise_coord
  #--------------------------------------------------------------------------
  def add_revise_coord
    @revise_x % 1 == 0 && @revise_x = (@x += @revise_x.round) * 0
    @revise_y % 1 == 0 && @revise_y = (@y += @revise_y.round) * 0
  end
  #--------------------------------------------------------------------------
  # * Pixel Disable
  #--------------------------------------------------------------------------
  def pixel_disable?
    return true unless self.pixel_movement  
    return true if @move_route_forcing && @move_route.list.any? do |s| 
      (1..14).include?(s.code)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * reset_pixel
  #--------------------------------------------------------------------------
  def reset_pixel
    return 0 if (@revise_x ||= 0) == 0 && (@revise_y ||= 0) == 0
    xy_pixel_correction(@direction) 
    @revise_x = (@x += revise_x.floor) * 0
    @revise_y = (@y += revise_y.floor) * 0
  end
  #--------------------------------------------------------------------------
  # * Move Down
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_down_pixel(turn_enabled = true)
    @quarter = false
    turn_enabled && turn_down 
    if passable?(@x, ((@y + revise_y).floor), xy_pixel_correction(2)) or
       passable?(@x, ((@y + revise_y).ceil), 2)
      turn_down
      @revise_y = y_pixel_direction(@revise_y,2)
      add_revise_coord
      increase_steps
    else
      @revise_y = revise_y.ceil 
      add_revise_coord
      check_event_trigger_touch(@x, y_with_direction(@y,2))
    end
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_left_pixel(turn_enabled = true)
    @quarter = false
    turn_enabled && turn_left 
    if passable?((@x + revise_x).ceil, @y, xy_pixel_correction(4)) or
       passable?((@x + revise_x).floor, @y, 4)
      turn_left
      @revise_x = x_pixel_direction(@revise_x,4)
      add_revise_coord
      increase_steps
    else
      @revise_x = @revise_x.floor
      add_revise_coord
      check_event_trigger_touch(x_with_direction(@x,4), @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_right_pixel(turn_enabled = true)
    @quarter = false
    turn_enabled && turn_right 
    if passable?((@x + revise_x).floor, @y, xy_pixel_correction(6)) or
       passable?((@x + revise_x).ceil, @y, 6) 
      turn_right
      @revise_x = x_pixel_direction(@revise_x,6)
      add_revise_coord
      increase_steps
    else
      @revise_x = @revise_x.ceil
      add_revise_coord
      check_event_trigger_touch(x_with_direction(@x,6), @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move up
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_up_pixel(turn_enabled = true)
    @quarter = false
    turn_enabled && turn_up 
    if passable?(@x, (@y + revise_y).ceil, xy_pixel_correction(8)) or
       passable?(@x, (@y + revise_y).floor, 8)
      turn_up
      @revise_y = y_pixel_direction(@revise_y, 8) 
      add_revise_coord
      increase_steps
    else
      @revise_y = revise_y.floor
      add_revise_coord
      check_event_trigger_touch(@x, y_with_direction(@y,8))
    end
  end    
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================
class Game_Player
  #--------------------------------------------------------------------------
  # * Constant
  #--------------------------------------------------------------------------
  ALIASING_PIXEL.call(0)
  #--------------------------------------------------------------------------
  # * Alias Method
  #--------------------------------------------------------------------------
  $@ || alias_method(:pixel_initialize, :initialize)
  #--------------------------------------------------------------------------
  # * Pixel Movement
  #--------------------------------------------------------------------------
  def initialize(*args)
    pixel_initialize(*args)
    @pixel_movement = true
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
#  switching via condition determinants, and running parallel process events.
#  It's used within the Game_Map class.
#==============================================================================
class Game_Event
  #--------------------------------------------------------------------------
  # * Constant
  #--------------------------------------------------------------------------
  ALIASING_PIXEL.call(1)
  #--------------------------------------------------------------------------
  # * Alias Method
  #--------------------------------------------------------------------------
  $@ || alias_method(:pixel_initialize, :initialize)
  #--------------------------------------------------------------------------
  # * Pixel Movement
  #--------------------------------------------------------------------------
  def initialize(*args)
    pixel_initialize(*args)
    @pixel_movement = false
  end
end