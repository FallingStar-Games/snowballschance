

#==============================================================================
# ** [XP] Wave Effect
#------------------------------------------------------------------------------
# By:         Zecomeia
# Date:       01/03/2010
# Version:    1.5
# Edit by:    Wecoc
# Edit Date:  26/07/2017
#------------------------------------------------------------------------------
# www.colmeia-do-ze.blogspot.com
#==============================================================================

class Sprite

  attr_accessor   :wave_amp
  attr_accessor   :wave_length
  attr_accessor   :wave_speed
  attr_accessor   :wave_phase
  attr_accessor   :temp_bitmap

  alias wave_effect_ini initialize unless $@
  def initialize(viewport=nil)
    @wave_amp = 0
    @wave_length = 72
    @wave_speed = 520
    @wave_phase = 0.25
    wave_effect_ini(viewport)
    @temp_bitmap = nil
  end

  alias wave_effect_upd update unless $@
  def update
    # the wave effect only works if wave_amp
    # propertie is a number more than zero
    wave_effect if @wave_amp > 0
    wave_effect_upd
  end

  # Return the width of image, because when use
  # obj.bitmap.width the value will be more than
  # the original value(because effect)
  def width
    return (self.bitmap.width - @wave_amp * 2)
  end
 
  def wave_effect
    return if self.bitmap.nil?
    @temp_bitmap = self.bitmap if @temp_bitmap.nil?
    cw = @temp_bitmap.width + (@wave_amp * 2)
    ch = @temp_bitmap.height
    # Follow the VX wave effect, each horizontal line
    # has 8 pixel of height. This device provides less
    # lag in game.
    divisions = @temp_bitmap.height / 8
    divisions += 1 if @temp_bitmap.height % 8 != 0
    self.bitmap = Bitmap.new(cw, ch)
    for i in 0..divisions
      x = @wave_amp * Math.sin(i * 2 * Math::PI / (@wave_length / 8).to_i +
      (@wave_phase * Math::PI) / 180.0)
      src_rect = Rect.new(0, i*8, @temp_bitmap.width, 8)
      dest_rect = Rect.new(@wave_amp + x, i * 8, @temp_bitmap.width, 8)
      self.bitmap.stretch_blt(dest_rect, @temp_bitmap, src_rect)
    end
    # frame rate: VX = 60 | XP = 40
    # wave speed compatibility VX to XP: wave_speed * 60/40
    # then: wave_speed * 1.5
    @wave_phase += @wave_speed * 1.5 / @wave_length
    @wave_phase -= 360 if @wave_phase > 360
    @wave_phase += 360 if @wave_phase < 0
  end
end

for Klass in [Game_Character, Game_Battler, Game_Picture]
  class Klass
    attr_accessor   :wave_amp
    attr_accessor   :wave_length
    attr_accessor   :wave_speed
    alias wave_effect_ini initialize unless $@
    def initialize(*args)
      wave_effect_ini(*args)
      @wave_amp = 0
      @wave_length = 72
      @wave_speed = 720
    end
  end
end

class Spriteset_Map
  alias wave_effect_upd update unless $@
  def update
    wave_effect_upd
    for i in 0...@character_sprites.size
      sprite = @character_sprites[i]
      if i == @character_sprites.size - 1
        sprite.wave_amp     = $game_player.wave_amp
        sprite.wave_length  = $game_player.wave_length
        sprite.wave_speed   = $game_player.wave_speed
      else
        event = $game_map.events[i + 1]
        next if event.nil?
        sprite.wave_amp     = event.wave_amp
        sprite.wave_length  = event.wave_length
        sprite.wave_speed   = event.wave_speed
      end
    end
    for i in 0...@picture_sprites.size
      picture = $game_screen.pictures[i + 1]
      sprite = @picture_sprites[i]
      sprite.wave_amp     = picture.wave_amp
      sprite.wave_length  = picture.wave_length
      sprite.wave_speed   = picture.wave_speed
    end
  end
end

class Spriteset_Battle
  alias wave_effect_upd update unless $@
  def update
    wave_effect_upd
    for i in 0...@enemy_sprites.size
      enemy = $game_troop.enemies.reverse[i]
      next if enemy.nil? or !enemy.exist?
      sprite = @enemy_sprites[i]
      sprite.wave_amp     = enemy.wave_amp
      sprite.wave_length  = enemy.wave_length
      sprite.wave_speed   = enemy.wave_speed
    end
    for i in 0...@actor_sprites.size
      actor = $game_party.actors[i]
      next if actor.nil? or !actor.exist?
      sprite = @actor_sprites[i]
      sprite.wave_amp     = actor.wave_amp
      sprite.wave_length  = actor.wave_length
      sprite.wave_speed   = actor.wave_speed
    end
    for i in 0...@picture_sprites.size
      picture = $game_screen.pictures[i + 51]
      sprite = @picture_sprites[i]
      sprite.wave_amp     = picture.wave_amp
      sprite.wave_length  = picture.wave_length
      sprite.wave_speed   = picture.wave_speed
    end
  end
end

