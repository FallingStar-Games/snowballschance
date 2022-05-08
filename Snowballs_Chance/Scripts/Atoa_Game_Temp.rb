#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :hide_windows
  attr_accessor :skip_intro
  attr_accessor :battle_start
  attr_accessor :battle_end
  attr_accessor :battle_victory
  attr_accessor :battle_escape
  attr_accessor :party_escaped
  attr_accessor :status_hide
  attr_accessor :no_actor_intro_bc
  attr_accessor :no_enemy_intro_bc
  attr_accessor :no_actor_victory_bc
  attr_accessor :no_enemy_victory_bc
  attr_accessor :battlers_viweport
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_gametemp initialize
  def initialize
    acbs_initialize_gametemp
    @hide_windows = false
    @skip_intro = false
    @battle_start = false
    @battle_end = false
    @battle_victory = false
    @battle_escape = false
    @party_escaped = false
    @status_hide = false
    @no_actor_intro_bc = true
    @no_enemy_intro_bc = true
    @no_actor_victory_bc = true
    @no_enemy_victory_bc = true
  end
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler_positions
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_gamesys initialize
  def initialize
    acbs_initialize_gamesys
    @battler_positions = Custom_Postions
  end
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles actions in battle. It's used within the Game_Battler 
#  class.
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :hit_times
  attr_accessor :combo_times
  attr_accessor :action_sequence
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  alias acbs_clear clear
  def clear
    acbs_clear
    @hit_times = 0
    @combo_times = 0
    @action_sequence = []
  end
end

#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class deals with troops. Refer to "$game_troop" for the instance of
#  this class.
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear_actions
    for enemies in @enemies
      enemies.current_action.clear
    end
  end
  #--------------------------------------------------------------------------
  # * Get stat avarage value
  #     stat : status
  #--------------------------------------------------------------------------
  def avarage_stat(stat)
    value = 0
    for target in @enemies
      value += eval("target.#{stat}")
    end
    value /= [@enemies.size, 1].max
    return value
  end
  #--------------------------------------------------------------------------
  # * Get battlers avarage position
  #--------------------------------------------------------------------------
  def avarage_position
    x = 0
    y = 0
    for target in @enemies
      x += target.actual_x
      y += target.actual_y
    end
    x /= [@enemies.size, 1].max
    y /= [@enemies.size, 1].max
    return [x, y]
  end
end

#==============================================================================
# ** Interpreter 
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # * Enemy Transform
  #--------------------------------------------------------------------------
  def command_336
    enemy = $game_troop.enemies[@parameters[0]]
    if enemy != nil
      enemy.transform(@parameters[1])
      $scene.spriteset.battler(enemy).change_pose(0)
    end
    return true
  end
end
