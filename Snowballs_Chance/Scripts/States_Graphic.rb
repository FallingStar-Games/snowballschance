#==============================================================================
# States Graphic
# Por Atoa
#==============================================================================
# This script allows to change the battler graphic base on the states on him
#
# If used with 'Add | Equipment Sprte', put this script above it
#
# Remember that the state pose will need it's onw setting on the
# advanced setting.
#==============================================================================

module Atoa
  # Do not remove or change this line
  State_Battler = {} 
  # Do not remove or change this line
  
  # Change Character graphic on map
  Change_Map_Graphic = false
  
  # Graphic sufix
  #   State_Battler[StateID] = Sufix
  State_Battler[3] = '_Poison'
  # The battler name must be equal the original battler file name + sufix
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa State Graphic'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :state_ext
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_switchstates initialize
  def initialize
    initialize_switchstates
    @state_ext = ''
  end
  #--------------------------------------------------------------------------
  # * Add State
  #     state_id : state ID
  #     force    : forcefully added flag (used to deal with auto state)
  #--------------------------------------------------------------------------
  alias add_state_switchstates add_state
  def add_state(state_id, force = false)
    add_state_switchstates(state_id, force)
    $game_player.refresh if State_Battler.keys.include?(state_id)
  end
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_switchstates refresh
  def refresh
    refresh_switchstates
    if Change_Map_Graphic
      actor = $game_party.actors[0]
      ext = check_state_ext(actor)
      @character_name = actor.character_name + ext
    end
  end
  #--------------------------------------------------------------------------
  # * Check actor state sufix
  #     actor : actor
  #--------------------------------------------------------------------------
  def check_state_ext(actor)
    for state in actor.states.sort {|a,b| $data_states[b].rating <=> $data_states[a].rating}
      return State_Battler[state] if State_Battler[state] != nil
    end
    return ''
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     actor   : actor
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     opacity : face opacity
  #--------------------------------------------------------------------------
  alias draw_actor_battle_face_switchstates draw_actor_battle_face if $atoa_script['Battle Windows'] 
  def draw_actor_battle_face(actor, x, y, opacity = 255)
    begin
      ext = check_state_ext(actor)
      face_hue = Use_Character_Hue ? actor.character_hue : 0
      face = RPG::Cache.faces(actor.character_name + ext + Face_Extension, face_hue)
      fw = face.width
      fh = face.height
      src_rect = Rect.new(0, 0, fw, fh)
      self.contents.blt(x - fw / 2, y - fh, face, src_rect, opacity)
    rescue
      draw_actor_battle_face_switchstates(actor, x, y, opacity)
    end
  end
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Check battler change
  #--------------------------------------------------------------------------
  alias battler_change_verification_switchstates battler_change_verification
  def battler_change_verification
    check_state_ext
    value = battler_change_verification_switchstates
    return true if @battler.state_ext != @battler_state_ext
    return value
  end
  #--------------------------------------------------------------------------
  # * Make battler change
  #--------------------------------------------------------------------------
  alias make_battler_change_switchstates make_battler_change
  def make_battler_change
    @battler_state_ext = @battler.state_ext
    make_battler_change_switchstates
  end
  #--------------------------------------------------------------------------
  # * Set battler graphic name
  #--------------------------------------------------------------------------
  def set_battler_name
    return (@battler_state_ext.nil? ? @battler_name : @battler_name + @battler_state_ext)
  end
  #--------------------------------------------------------------------------
  # * Set graphic bitmap
  #--------------------------------------------------------------------------
  alias set_graphic_bitmap_switchstates set_graphic_bitmap
  def set_graphic_bitmap
    set_graphic_bitmap_switchstates
    dir = Battle_Style == 3 ? set_battler_direction : ''
    ext = @battler_state_ext
    old_bitmap = self.bitmap
    if @name_init == '%'
      begin
        self.bitmap = RPG::Cache.battler(@battler_name + ext + dir + '_' + @pattern, @battler_hue)
      rescue
        self.bitmap = old_bitmap
      end
    else
      begin
        self.bitmap = RPG::Cache.battler(@battler_name + ext + dir, @battler_hue)
      rescue
        self.bitmap = old_bitmap
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Bitmap update for multi graphics battlers
  #--------------------------------------------------------------------------
  alias uptade_battler_multi_bitmap_switchstates uptade_battler_multi_bitmap
  def uptade_battler_multi_bitmap
    uptade_battler_multi_bitmap_switchstates
    dir = Battle_Style == 3 ? set_battler_direction : ''
    ext = @battler_state_ext
    old_bitmap = self.bitmap
    begin
      self.bitmap = RPG::Cache.battler(@battler_name + ext + dir + '_' + @pattern, @battler_hue)
    rescue
      self.bitmap = old_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Check actor state sufix
  #--------------------------------------------------------------------------
  def check_state_ext
    for state in @battler.states.sort {|a,b| $data_states[b].rating <=> $data_states[a].rating}
      return @battler.state_ext = State_Battler[state] if State_Battler[state] != nil
    end
    @battler.state_ext = ''
  end
end