#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within
#  the Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites
  attr_accessor :battleback_width
  attr_accessor :battleback_height
  attr_reader   :viewport3
  attr_reader   :viewport4
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    set_viewport
    set_sprites
    update
  end
  #--------------------------------------------------------------------------
  # * Set viewport
  #--------------------------------------------------------------------------
  def set_viewport
    screen_pos_x = Battle_Screen_Position[0]
    screen_pos_y = Battle_Screen_Position[1]
    screen_width = Battle_Screen_Dimension[0]
    screen_height = Battle_Screen_Dimension[1]
    @viewport1 = Viewport.new(screen_pos_x, screen_pos_y, screen_width, screen_height)
    @viewport2 = Viewport.new(screen_pos_x, screen_pos_y, screen_width, screen_height)
    @viewport3 = Viewport.new(screen_pos_x, screen_pos_y, screen_width, screen_height)
    @viewport4 = Viewport.new(screen_pos_x, screen_pos_y, screen_width, screen_height)
    @viewport2.z = Battler_High_Priority ? 2001 : 101
    @viewport3.z = Battler_High_Priority ? 2200 : 200
    @viewport4.z = 5000
    $game_temp.battlers_viweport = @viewport2
  end
  #--------------------------------------------------------------------------
  # * Set sprites
  #--------------------------------------------------------------------------
  def set_sprites
    @battleback_sprite = Sprite.new(@viewport1)
    @enemy_sprites = []
    for enemy in $game_troop.enemies
      @enemy_sprites << Sprite_Battler.new(@viewport2, enemy)
    end
    @actor_sprites = []
    for i in 0...$game_party.actors.size
      @actor_sprites << Sprite_Battler.new(@viewport2, $game_party.actors[i])
      $game_party.actors[i].battler_position_setup
    end
    @old_party = $game_party.actors.dup
    @weather = RPG::Weather.new(@viewport2)
    @picture_sprites = []
    for i in 51..100
      @picture_sprites << Sprite_Picture.new(@viewport3, $game_screen.pictures[i])
    end
    @timer_sprite = Sprite_Timer.new
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_battlers
    update_sprites
    update_viewport
  end
  #--------------------------------------------------------------------------
  # * Battlers update
  #--------------------------------------------------------------------------
  def update_battlers
    if $game_party.actors != @old_party
      empty_slot = []
      for i in 0...@actor_sprites.size
        next if $game_party.actors.include?(@actor_sprites[i].battler)
        @actor_sprites[i].dispose
        @actor_sprites[i] = nil
      end
      for i in 0...$game_party.actors.size
        next if @old_party.include?($game_party.actors[i])
        @actor_sprites << Sprite_Battler.new(@viewport2, $game_party.actors[i])
        $game_party.actors[i].battler_position_setup
      end
      @actor_sprites.compact!
      @old_party = $game_party.actors.dup
    end
  end
  #--------------------------------------------------------------------------
  # * Sprites update
  #--------------------------------------------------------------------------
  def update_sprites
    update_battleback if @battleback_name != $game_temp.battleback_name
    for sprite in @enemy_sprites + @actor_sprites
      sprite.update
      sprite.set_battler_patterns
    end
    @weather.type = $game_screen.weather_type
    @weather.max = $game_screen.weather_max
    @weather.update
    for sprite in @picture_sprites do sprite.update end
    @timer_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Battleback update
  #--------------------------------------------------------------------------
  def update_battleback
    @battleback_name = $game_temp.battleback_name
    @battleback_sprite.bitmap.dispose if @battleback_sprite.bitmap != nil
    @battleback_sprite.bitmap = RPG::Cache.battleback(@battleback_name)
    @battleback_width = @battleback_sprite.bitmap.width
    @battleback_height = @battleback_sprite.bitmap.height
    @battleback_sprite.src_rect.set(0, 0, @battleback_width, @battleback_height)
  end
  #--------------------------------------------------------------------------
  # * Viewport update
  #--------------------------------------------------------------------------
  def update_viewport
    @viewport1.ox = $game_screen.shake
    @viewport2.ox = $game_screen.shake
    @viewport2.tone = $game_screen.tone
    @viewport4.color = $game_screen.flash_color
    @viewport1.update
    @viewport2.update
    @viewport4.update
  end
  #--------------------------------------------------------------------------
  # * Select an battler sprite
  #--------------------------------------------------------------------------
  def battler(battler)
    for sprite in @actor_sprites + @enemy_sprites
      return sprite if sprite.battler == battler
    end
    return nil
  end
end