#==============================================================================
# ** Arrow_Base
#------------------------------------------------------------------------------
#  This sprite is used as an arrow cursor for the battle screen. This class
#  is used as a superclass for the Arrow_Enemy and Arrow_Actor classes.
#==============================================================================

class Arrow_Base < Sprite
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = RPG::Cache.windowskin($game_system.windowskin_name)
    self.ox = 16 + Targer_Arrow_Adjust[0]
    self.oy = 96 + Targer_Arrow_Adjust[1]
    self.z = 2500
    @blink_count = 0 
    @index = 0
    @help_window = nil
    update
  end
  #--------------------------------------------------------------------------
  # * Multiples arrows update
  #--------------------------------------------------------------------------
  def update_multi_arrow
    return if @arrows.nil? or @arrows == []
    for i in 0...@arrows.size
      @blink_count = (@blink_count + 1) % 40 
      if @blink_count < 20
        @arrows[i].src_rect.set(128, 96, 32, 32) if @arrows[i] != nil
      else
        @arrows[i].src_rect.set(160, 96, 32, 32) if @arrows[i] != nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Multiples arrows dispose
  #--------------------------------------------------------------------------
  def dispose_multi_arrow
    for i in 0...@arrows.size
      @arrows[i].dispose if @arrows[i] != nil
    end
  end
end

#==============================================================================
# ** Arrow_Enemy
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose enemies. This class inherits from the 
#  Arrow_Base class.
#==============================================================================

class Arrow_Enemy < Arrow_Base
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    $game_troop.enemies.size.times do
      break if self.enemy.exist?
      @index += 1
      @index %= $game_troop.enemies.size
    end
    cursor_down if Input.repeat?(Input::RIGHT)
    cursor_down if Input.repeat?(Input::UP)
    cursor_up if Input.repeat?(Input::LEFT)
    cursor_up if Input.repeat?(Input::DOWN)
    update_arrows if self.enemy != nil
  end
  #--------------------------------------------------------------------------
  # * Move cursor to the previous battler
  #--------------------------------------------------------------------------
  def cursor_up
    $game_system.se_play($data_system.cursor_se)
    $game_troop.enemies.size.times do
      @index += $game_troop.enemies.size - 1
      @index %= $game_troop.enemies.size
      break if self.enemy.exist?
    end
  end
  #--------------------------------------------------------------------------
  # * Move cursor to the next battler
  #--------------------------------------------------------------------------
  def cursor_down
    $game_system.se_play($data_system.cursor_se)
    $game_troop.enemies.size.times do
      @index += 1
      @index %= $game_troop.enemies.size
      break if self.enemy.exist?
    end
  end  
  #--------------------------------------------------------------------------
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = self.enemy.actual_x
    self.y = self.enemy.actual_y
  end
end

#==============================================================================
# ** Arrow_Actor
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose an actor. This class inherits from the
#  Arrow_Base class.
#==============================================================================

class Arrow_Actor < Arrow_Base
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    cursor_down if Input.repeat?(Input::RIGHT)
    cursor_down if Input.repeat?(Input::DOWN)
    cursor_up if Input.repeat?(Input::LEFT)
    cursor_up if Input.repeat?(Input::UP)
    update_arrows if self.actor != nil
  end
  #--------------------------------------------------------------------------
  # * Move cursor to the previous battler
  #--------------------------------------------------------------------------
  def cursor_up
    $game_system.se_play($data_system.cursor_se)
    @index += $game_party.actors.size - 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  # * Move cursor to the next battler
  #--------------------------------------------------------------------------
  def cursor_down
    $game_system.se_play($data_system.cursor_se)
    @index += 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  # * Adjust cursor to the next battler
  #--------------------------------------------------------------------------
  def input_right
    @index += 1
    @index %= $game_party.actors.size
  end
  #--------------------------------------------------------------------------
  # * Adjust cursor if battler is not valid
  #--------------------------------------------------------------------------
  def input_update_target
    cursor_down if Input.repeat?(Input::RIGHT) and @index == self.actor.index
    cursor_down if Input.repeat?(Input::DOWN) and @index == self.actor.index
    cursor_up if Input.repeat?(Input::LEFT) and @index == self.actor.index
    cursor_up if Input.repeat?(Input::UP) and @index == self.actor.index
    update_arrows if self.actor != nil
  end
  #--------------------------------------------------------------------------
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = self.actor.actual_x
    self.y = self.actor.actual_y
  end
end

#==============================================================================
# ** Arrow_Self
#------------------------------------------------------------------------------
# This arrow cursor is used to choose the user.
#==============================================================================

class Arrow_Self < Arrow_Base
  #--------------------------------------------------------------------------
  # * Get Actor Indicated by Cursor
  #--------------------------------------------------------------------------
  def actor
    return $game_party.actors[@index]
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_arrows if self.actor != nil
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_actor(self.actor)
  end
  #--------------------------------------------------------------------------
  # * Update cursor position
  #--------------------------------------------------------------------------
  def update_arrows
    self.x = self.actor.actual_x
    self.y = self.actor.actual_y
  end
end

#==============================================================================
# ** Arrow_Actor_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all actors.
#==============================================================================

class Arrow_Actor_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    @arrows = []
    for battler in $game_party.actors
      if battler.exist?
        @arrows[battler.index] = Arrow_Actor.new(viewport)
        @arrows[battler.index].index = battler.index
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    for i in 0...@arrows.size
      actor = $game_party.actors[i]
      update_arrows(i) if actor  != nil and @arrows[i] != nil and @arrows[i].actor != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update cursor position
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows(index)
    @arrows[index].x = @arrows[index].actor.actual_x
    @arrows[index].y = @arrows[index].actor.actual_y
  end
end

#==============================================================================
# ** Arrow_Enemy_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all enemies.
#==============================================================================

class Arrow_Enemy_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    @arrows = []
    for battler in $game_troop.enemies
      if battler.exist?
        @arrows[battler.index] = Arrow_Enemy.new(viewport)
        @arrows[battler.index].index = battler.index
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    for i in 0...@arrows.size
      enemy = $game_troop.enemies[i] 
      update_arrows(i) if enemy  != nil and @arrows[i] != nil and @arrows[i].enemy != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update cursor position
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows(index)
    @arrows[index].x = @arrows[index].enemy.actual_x
    @arrows[index].y = @arrows[index].enemy.actual_y
  end
end

#==============================================================================
# ** Arrow_Battler_All
#------------------------------------------------------------------------------
#  This arrow cursor is used to choose all battlers.
#==============================================================================

class Arrow_Battler_All < Arrow_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    @arrows = []
    s = 0
    for battler in $game_party.actors + $game_troop.enemies
      @arrows[s] = Arrow_Actor.new(viewport) if battler.actor?
      @arrows[s] = Arrow_Enemy.new(viewport) if battler.is_a?(Game_Enemy)
      @arrows[s].index = battler.index
      s += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_multi_arrow
    super
    s = 0
    for i in 0...@arrows.size
      if @arrows[i].is_a?(Arrow_Actor)
        actor = $game_party.actors[i] 
        if @arrows[i].actor != nil
          update_arrows_actor(i)
          s += 1
        end
      elsif @arrows[i].is_a?(Arrow_Enemy)
        enemy = $game_troop.enemies[i - s]
        update_arrows_enemy(i) if @arrows[i].enemy != nil or @arrows[i] != nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update cursor position for actors
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows_actor(index)
    @arrows[index].x = @arrows[index].actor.actual_x
    @arrows[index].y = @arrows[index].actor.actual_y
    @arrows[index].z = 3000
  end
  #--------------------------------------------------------------------------
  # * Update cursor position for enemies
  #     index : index
  #--------------------------------------------------------------------------
  def update_arrows_enemy(index)
    @arrows[index].x = @arrows[index].enemy.actual_x
    @arrows[index].y = @arrows[index].enemy.actual_y
  end  
end