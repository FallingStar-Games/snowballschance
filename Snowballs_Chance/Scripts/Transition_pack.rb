# encoding: utf-8
#==============================================================================
# ** Transition Pack
#------------------------------------------------------------------------------
# by Fantasist
# Version: 1.12a
# Date: 9-December-2009
#------------------------------------------------------------------------------
# Version History:
#
#   1.0 - First released version
#   1.1 - Added code to make battle scene use the transitions
#   1.11 - Transitions are used when switching maps, fixed some bugs
#	1.12a - orochii edited this thing
#------------------------------------------------------------------------------
# Description:
#
#     This script adds some exotic transitions which can't be attained by
#   regular transition graphics.
#------------------------------------------------------------------------------
# Compatibility:
#
#     This script replaces Scene_Map#transfer_player method.
#==============================================================================
# Instructions:
#
#     This script used to need "screenshot.dll", but not anymore cuz VXA yay.
#     Place this script below Scene_Debug and above Main. To use this, instead
#   of calling a scene directly like this:
#
#           $scene = Scene_Something.new
#
#   call it like this:
#
#           $scene = Transition.new(Scene_Something.new)
#
#     Before calling it, you can change "$game_temp.transition_type" to
#   activate the transiton.
#
#     As of version 1.11 and above, the battle, menu, name, shop and save scenes
#   automatically use the predefined transition effects, so all you have to do
#   is call the scenes using the event command.
#
#     You can also call a certain effect like this:
#
#           Transition.new(NEXT_SCENE, EFFECT_TYPE, EFFECT_TYPE_ARGUMENTS)
#
#
#   Here is the list of transitions (as of version 1.11):
#
#    -1 - Uses the default effect (in most cases, simple transition)
#     0 - Zoom In
#     1 - Zoom Out
#     2 - Shred Horizontal
#     3 - Shred Vertical
#     4 - Fade
#     5 - Explode
#     6 - Explode (Chaos Project Style)
#     7 - Transpose (by Blizzard)
#     8 - Shutter
#     9 - Drop Off
#     10- double_zoom
#     11- ff_IV_style
#     12- downward_spiral
#     13- blackhole
#     14- wave_distort
#     15- radial_break
#
#   For Scripters:
#
#     For adding new transitions, check the method Transition#call_effect.
#   Simply add a new case for "type" and add your method. Don't forget to
#   add the *args version, it makes it easier to pass arguments when calling
#   transitions. Check out the call_effect method for reference.
#------------------------------------------------------------------------------
# Configuration:
#
#     Scroll down a bit and you'll see the configuration.
#
#   BATTLE_EFFECT: Effect to be used for calling battles
#   SHOP_EFFECT: Effect to be used for calling the Shop scene
#   NAME_EFFECT: Effect to be used for calling the Name scene
#   MENU_EFFECT: Effect to be used for calling the Menu scene
#   SAVE_EFFECT: Effect to be used for calling the Save scene
#
#   - Set to any number (-1 to 9) to use the respective effect.
#   - Set to "nil" to use the effect defined in "$game_temp.transition_type".
#   - Use an array to use any random effect. For example, setting BATTLE_EFFECT
#     to [1, 3, 6, 8, 9] will use any of those effects each time the battle
#     scene is called.
#
#   Explosion_Sound: Filename of the SE for Explosion transitions
#       Clink_Sound: Filename of the SE for Drop Off transition
#------------------------------------------------------------------------------
# Issues:
#
#     None that I know of.
#------------------------------------------------------------------------------
# Credits and Thanks:
#
#   Fantasist, for making this script
#   Blizzard, for the Transpose effect
#   shdwlink1993, for keeping the demo for so long
#   Ryexander, for helping me with an important scripting aspect
#   Memor-X, for pointing out some bugs
#------------------------------------------------------------------------------
# Notes:
#
#     If you have any problems, suggestions or comments, you can find me at:
#
#  - forum.chaos-project.com
#
#   Enjoy ^_^
#==============================================================================

#==============================================================================
# ** Transition
#------------------------------------------------------------------------------
#  This scene handles transition effects while switching to another scene.
#==============================================================================
class Transition
  attr_accessor :spriteset
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  # * CONFIG BEGIN
  #    -1 - Uses the default effect (in most cases, simple transition)
  #     0 - Zoom In
  #     1 - Zoom Out
  #     2 - Shred Horizontal
  #     3 - Shred Vertical
  #     4 - Fade
  #     5 - Explode
  #     6 - Explode (Chaos Project Style)
  #     7 - Transpose (by Blizzard)
  #     8 - Shutter
  #     9 - Drop Off
  #     10- double_zoom
  #     11- ff_IV_style
  #     12- downward_spiral
  #     13- blackhole
  #     14- wave_distort
  #     15- radial_break
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  DEFAULT_TRANSITION = 0
  BATTLE_EFFECT = [5] # randomly choose from any of those
  SHOP_EFFECT = 0
  NAME_EFFECT = nil # uses default effect set in $game_temp.transition_type
  MENU_EFFECT = -1
  SAVE_EFFECT = 4 # disable effect/use default
  
  
  Explosion_Sound = "explosion"
      Clink_Sound = nil
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  # * CONFIG END
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  
  #--------------------------------------------------------------------------
  # * Call Effect
  #     type : Transition type
  #     args : Arguments for specified transition type
  #--------------------------------------------------------------------------
  
  def tile_sprites(tilesize)
    tiles = []
    t_cx = @sprite.bitmap.width / tilesize
    t_cy = @sprite.bitmap.height / tilesize
    # Iterate through main sprite, creating sprites for each square.
    (0...t_cx).each {|x|
      (0...t_cy).each {|y|
        sprite = Sprite.new
        sprite.x, sprite.y = x*tilesize, y*tilesize
        sprite.bitmap = @sprite.bitmap
        sprite.src_rect = Rect.new(sprite.x, sprite.y, tilesize, tilesize)
        tiles.push(sprite)
      }
    }
    @sprite.opacity = 0
    return tiles
  end
  
  def double_zoom(frames = 30, zoom1 = 12, zoom2 = 32)
    # Calculate the stages. Account for final zoom being longer.
    stage3 = (frames * (zoom1.to_f / zoom2)).round
    stages = [(frames - stage3) / 2, (frames - stage3) / 2, stage3]
    # Calculate the zoom rates to apply each frame, for each stage.
    zoom_rates, opacity_rate = [zoom1-1, -zoom1+1, zoom2], (255 / frames.to_f)
    zoom_rates.each_index {|i| zoom_rates[i] /= stages[i].to_f }
    # Initialize local variable to keep track of current stage being executed.
    current_stage = 0
    3.times do
      # Iterate each stage, using the calculated rates for each one.
      stages[current_stage].times do
        @sprite.zoom_x += zoom_rates[current_stage]
        @sprite.zoom_y += zoom_rates[current_stage]
        @sprite.opacity -= opacity_rate
        Graphics.update
      end
      current_stage += 1
    end
  end
  
  def ff_IV_style(zoom1 = 1.2, zoom2 = 32)
    # Set number of frames and zoom rates for each stage.
    stages = [4, 4, 4, 4, 20]
    zooms = [zoom1, -zoom1, zoom1, -zoom1, zoom2]
    zooms.each_index {|i| zooms[i] /= stages[i].to_f }
    current_stage = 0
    5.times do
      # Begin processing.
      stages[current_stage].times do
        @sprite.zoom_x += zooms[current_stage]
        @sprite.zoom_y += zooms[current_stage]
        @sprite.opacity -= 12 if current_stage == 4
        Graphics.update
      end
      # Increase current stage.
      current_stage += 1
    end
  end
  
  def downward_spiral(frames = 40, rotation_speed = 15)
    # Calculate the zoom to subtract each frame.
    zoom, opacity = 1.0 / frames, 128.0 / frames
    frames.times do
      # Begin processing.
      @sprite.zoom_x -= zoom
      @sprite.zoom_y -= zoom
      @sprite.opacity -= opacity
      @sprite.angle += rotation_speed
      Graphics.update
    end
  end
  
  def blackhole(speed = 4, tilesize = 12, source = [320, 240])
    # Initialize squares array to hold each sprite.
    tiles = tile_sprites(tilesize)
    # Make each sprite slightly smaller than full size.
    tiles.each {|tile| tile.zoom_x = tile.zoom_y = 0.85 }
    # Begin looping until all sprites have been disposed.
    until tiles.compact == []
      # Iterate each tiles.
      tiles.each_index {|i|
        next if tiles[i] == nil
        # Get distance of this sprite from the source for each axis.
        sx = source[0] - tiles[i].x
        sy = source[1] - tiles[i].y
        # Calculate total distance and set base speed for each axis.
        dist = Math.hypot(sx, sy).to_f
        move_x = (dist / (sx == 0 ? 1 : sx)) 
        move_y = (dist / (sy == 0 ? 1 : sy))
        # Add a little randomness to the mix.
        move_x += move_x < 0 ? -rand(speed) : rand(speed)
        move_y += move_y < 0 ? -rand(speed) : rand(speed)
        # Apply movement.
        tiles[i].x += move_x
        tiles[i].y += move_y
        tiles[i].angle += rand(20)
        # If tile is within its own size from source, dispose it.
        if sx.abs <= tilesize && sy.abs <= tilesize
           tiles[i] = tiles[i].dispose
        end
      }
      Graphics.update
    end
  end
  
  def wave_distort(frames = 60, direction = 2, power = 0.4)
    radius, tiles = 0, tile_sprites(16)
    # Define starting point for zoom, depending on direction.
    origin = case direction
    when 2 then [@sprite.bitmap.width / 2, @sprite.bitmap.height]
    when 4 then [0, @sprite.bitmap.height / 2]
    when 6 then [@sprite.bitmap.width, @sprite.bitmap.height / 2]
    when 8 then [@sprite.bitmap.width / 2, 0]
    end
    # Initialize local variable for the rate the radius will increase.
    rate = Math.hypot(@sprite.bitmap.width, @sprite.bitmap.height) / frames
    # Begin processing.
    frames.times do
      # Iterate through each tile, calculating distance from focal point.
      tiles.each {|tile|
        dist = Math.hypot((origin[0] - tile.x), (origin[1] - tile.y))
        # Zoom tile on one axis, depending on direction.
        next if radius < dist 
        [4, 6].include?(direction) ? tile.zoom_x += power : tile.zoom_y += power
      }
      # Increase radius for next iteration.
      radius += rate
      Graphics.update
    end
    # Dispose each bitmap and sprite used for the tiles.
    tiles.each {|tile| tile.dispose }
  end
  
  def radial_break(frames = 30, tilesize = 32, direction = 4, speed = 9)
    radius, tiles = 0, tile_sprites(tilesize)
    # Define starting point for zoom, depending on direction.
    origin = case direction
    when 2 then [@sprite.bitmap.width / 2, @sprite.bitmap.height]
    when 4 then [0, @sprite.bitmap.height / 2]
    when 6 then [@sprite.bitmap.width, @sprite.bitmap.height / 2]
    when 8 then [@sprite.bitmap.width / 2, 0]
    end
    # Initialize local variable for the rate the radius will increase.
    rate = Math.hypot(@sprite.bitmap.width, @sprite.bitmap.height) / frames
    # Begin processing.
    until tiles == []
      tiles.compact!
      # Iterate through each tile, calculating distance from focal point.
      tiles.each_index {|i|
        # Get distance of this sprite from the source for each axis.
        sx = origin[0] - tiles[i].x
        sy = origin[1] - tiles[i].y
        dist = Math.hypot(sx, sy).to_f
        # Zoom tile on one axis, depending on direction.
        next if radius < dist 
        # Calculate total distance and set base speed for each axis.
        move_x = (dist / (sx == 0 ? 1 : sx)) 
        move_y = (dist / (sy == 0 ? 1 : sy))
        # Add a little randomness to the mix.
        move_x += move_x < 0 ? -rand(speed) : rand(speed)
        move_y += move_y < 0 ? -rand(speed) : rand(speed)
        # Half distance of one axis, depending on rate.
        [2, 8].include?(direction) ? move_x /= 2 : move_y /= 2
        # Apply movement.
        tiles[i].x += move_x
        tiles[i].y += move_y
        angle = (tiles[i].object_id % 2 == 0) ? rand(25) : -rand(25) 
        tiles[i].angle += (angle + 5)
        # If tile is within its own size from source, dispose it.
        if sx.abs <= tilesize || sy.abs <= tilesize
           tiles[i] = tiles[i].dispose
        end
      }
      # Increase radius for next iteration.
      radius += rate / 2
      Graphics.update
    end
  end
  
  def wave_explode(wave_mode=1,frames=320,wave_amp=360,wave_length=180,wave_speed=360,wave_size=16)
    # @sprite
    @sprite.color = Color.new(255,0,0,255)
    @sprite.wave_speed = wave_speed
    @sprite.wave_size = wave_size
    @sprite.wave_mode = wave_mode
    for i in (0..frames)
      # Lerp through wave
      t = i * (1.0 / frames)
      if (wave_mode > 7)
        @sprite.wave_amp = 10
        @sprite.wave_length = wave_length
      else
        @sprite.wave_amp = OZMath.lerp(t,0,wave_amp).to_i
        @sprite.wave_length = OZMath.lerp(t,wave_length,0).to_i
      end
      # Update color
      f = OZMath.lerp(t,0,255).to_i
      @sprite.opacity = 255 - f
      @sprite.color.alpha = f
      @sprite.update
      Graphics.update
    end
  end
  
  def heroen_style(tilesize=64,tileTime=32, tileDelay=2)
    tiles = tile_sprites(tilesize)
    frame = 0
    nextTileDelay = tileDelay
    total_frames = tiles.size + tileTime
    opacityStep = 256 / tileTime
    angleStep = 180 / tileTime
    # Fix tile center
    tiles.each {|t|
      t.ox = tilesize/2
      t.oy = t.ox
      t.x += t.ox
      t.y += t.ox
    }
    # Iter trough frames
    while(frame < total_frames)
      tiles.each_with_index {|t,i|
        # Update tile
        if (i <= frame && t.visible)
          t.opacity -= opacityStep
          t.angle += angleStep
          t.visible = false if t.opacity==0
        end
        t.update
      }
      nextTileDelay -= 1
      if nextTileDelay < 0
        nextTileDelay = tileDelay if (frame < tiles.size)
        frame += 1
      end
      Graphics.update
    end
    # Clean
    tiles.each {|t| t.dispose}
  end
  
  def call_effect(type, args)
    # if "type" is an array, choose a random element.
    if type.is_a?(Array)
      type = type[rand(type.size)]
    end
    # Call appropriate method with or without arguments depending
    # on values of type and args.
    no_args = args.nil? || args == []
    if no_args
      case type
      when 0 then zoom_in
      when 1 then zoom_out
      when 2 then shred_h
      when 3 then shred_v
      when 4 then fade
      when 5 then explode
      when 6 then explode_cp
      when 7 then transpose
      when 8 then shutter
      when 9 then drop_off
      when 10 then double_zoom
      when 11 then ff_IV_style
      when 12 then downward_spiral
      when 13 then blackhole
      when 14 then wave_distort
      when 15 then radial_break
      when 16 then wave_explode
      when 17 then heroen_style
      end
    else
      case type
      when 0 then zoom_in(*args)
      when 1 then zoom_out(*args)
      when 2 then shred_h(*args)
      when 3 then shred_v(*args)
      when 4 then fade(*args)
      when 5 then explode(*args)
      when 6 then explode_cp(*args)
      when 7 then transpose(*args)
      when 8 then shutter(*args)
      when 9 then drop_off(*args)
      when 10 then double_zoom(*args)
      when 11 then ff_IV_style(*args)
      when 12 then downward_spiral(*args)
      when 13 then blackhole(*args)
      when 14 then wave_distort(*args)
      when 15 then radial_break(*args)
      when 16 then wave_explode(*args)
      when 17 then heroen_style(*args)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Initialize
  #     next_scene : Instance of the scene to transition into
  #           type : Transition type
  #          *args : Arguments for specified transition type
  #--------------------------------------------------------------------------
  def initialize(next_scene=Scene_Menu.new, type=nil, *args)
    @next_scene = next_scene
    @args = args
    # If transition type is specified, use it.
    # Otherwise, use default.
    @type = type.nil? ? $game_temp.transition_type : type
    if ($game_temp.background_bitmap==nil)
      $game_temp.background_bitmap = Graphics.snap_to_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  def main
    if @type == -1
      $scene = @next_scene
      return
    end
    # Take screenshot and prepare sprite
    #path = ENV['appdata'] + "\\scrn_tmp"
    #Screen.snap(path)
    @sprite = Sprite.new
    @sprite.bitmap = $game_temp.background_bitmap.clone #Bitmap.new(path)
=begin
    if ($config_manager.config[2]==1)
      d_r = Rect.new(0,0,640,480)
      s_r = Rect.new(0,0,320,240)
      b = @sprite.bitmap.dup
      @sprite.bitmap.dispose
      @sprite.bitmap = Bitmap.new(640,480)
      @sprite.bitmap.stretch_blt(d_r, b, s_r)
      b.dispose
    end
=end
    @sprite.x = @sprite.ox = @sprite.bitmap.width / 2
    @sprite.y = @sprite.oy = @sprite.bitmap.height / 2
    # Activate effect
    Graphics.transition(0)
    call_effect(@type, @args)
    # Freeze screen and clean up and switch scene
    Graphics.freeze
    @sprite.bitmap.dispose unless @sprite.bitmap.nil?
    @sprite.dispose unless @sprite.nil?
    #File.delete(path)
    $scene = @next_scene
  end
  #--------------------------------------------------------------------------
  # * Play SE
  #     filename : Filename of the SE file in Audio/SE folder
  #        pitch : Pitch of sound (50 - 100)
  #       volume : Volume of sound (0 - 100)
  #--------------------------------------------------------------------------
  def play_se(filename, pitch=nil, volume=nil)
    se = RPG::AudioFile.new(filename)
    se.pitch  = pitch unless pitch.nil?
    se.volume = volume unless volume.nil?
    Audio.se_play('Audio/SE/' + se.name, se.volume, se.pitch)
  end
  
  #==========================================================================
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  # ** Effect Library
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  #==========================================================================
  
  #--------------------------------------------------------------------------
  # * Zoom In
  #     frames : Effect duration in frames
  #   max_zoom : The max amount the screen zooms out
  #--------------------------------------------------------------------------
  def zoom_in(frames=20, max_zoom=12)
    # Calculate difference b/w current and target
    # zooms (1 and max_zoom)
    zoom_diff = max_zoom - 1
    # Calculate unit values
    ox_logic = @sprite.ox
    oy_logic = @sprite.oy
    unit_zoom = zoom_diff.to_f / frames
    unit_opacity = (255.0 / frames).ceil
    
    $game_temp.player_old_scr_x = 0 if $game_temp.player_old_scr_x==nil
    $game_temp.player_old_scr_y = 0 if $game_temp.player_old_scr_y==nil
    unit_x = ( ($game_temp.player_old_scr_x-320.0) / frames)
    unit_y = ( ($game_temp.player_old_scr_y-240.0) / frames)
    
    # Apply unit values to sprite
    frames.times do
      ox_logic += unit_x
      oy_logic += unit_y
      @sprite.ox = ox_logic
      @sprite.oy = oy_logic
      @sprite.zoom_x += unit_zoom
      @sprite.zoom_y += unit_zoom
      @sprite.opacity -= unit_opacity
      Graphics.update
    end
  end
  #--------------------------------------------------------------------------
  # * Zoom Out
  #     frames : Effect duration in frames
  #--------------------------------------------------------------------------
  def zoom_out(frames=20)
    # Calculate unit values
    unit_zoom = 1.0 / frames
    unit_opacity = (255.0 / frames).ceil
    # Apply unit values to sprite
    frames.times do
      @sprite.zoom_x -= unit_zoom
      @sprite.zoom_y -= unit_zoom
      @sprite.opacity -= unit_opacity
      Graphics.update
    end
  end
  #--------------------------------------------------------------------------
  # * Shred Horizontal
  #      thickness : Shred thickness
  #       slowness : How slow the screens move out
  #    start_speed : Speed of first step in pixels
  #--------------------------------------------------------------------------
  def shred_h(thickness=4, slowness=4, start_speed=8)
    t = thickness
    # Shred screen
    sprite2 = Sprite.new
    sprite2.bitmap = Bitmap.new(@sprite.bitmap.width, @sprite.bitmap.height)
    sprite2.x = sprite2.ox = sprite2.bitmap.width / 2
    sprite2.y = sprite2.oy = sprite2.bitmap.height / 2
    for i in 0..(480/t)
      sprite2.bitmap.blt(0, i*t*2, @sprite.bitmap, Rect.new(0, i*t*2, 640, t))
      @sprite.bitmap.fill_rect(0, i*t*2, 640, t, Color.new(0, 0, 0, 0))
    end
    # Make sure starting step is not zero
    start_speed = slowness if start_speed < slowness
    # Move sprites
    dist = 640 - @sprite.x + start_speed
    loop do
      x_diff = (dist - (640 - @sprite.x)) / slowness
      @sprite.x += x_diff
      sprite2.x -= x_diff
      Graphics.update
      break if @sprite.x >= 640 + 320
    end
    sprite2.bitmap.dispose
    sprite2.dispose
  end
  #--------------------------------------------------------------------------
  # * Shred Vertical
  #      thickness : Shred thickness
  #       slowness : How slow the screens move out
  #    start_speed : Speed of first step in pixels
  #--------------------------------------------------------------------------
  def shred_v(thickness=4, slowness=4, start_speed=8)
    t = thickness
    # Shred screen
    sprite2 = Sprite.new
    sprite2.bitmap = Bitmap.new(@sprite.bitmap.width, @sprite.bitmap.height)
    sprite2.x = sprite2.ox = sprite2.bitmap.width / 2
    sprite2.y = sprite2.oy = sprite2.bitmap.height / 2
    # Shred bitmap
    for i in 0..(640/t)
      sprite2.bitmap.blt(i*t*2, 0, @sprite.bitmap, Rect.new(i*t*2, 0, t, 480))
      @sprite.bitmap.fill_rect(i*t*2, 0, t, 480, Color.new(0, 0, 0, 0))
    end
    # Make sure starting step is not zero
    start_speed = slowness if start_speed < slowness
    # Move sprites
    dist = 480 - @sprite.y + start_speed
    loop do
      y_diff = (dist - (480 - @sprite.y)) / slowness
      @sprite.y += y_diff
      sprite2.y -= y_diff
      Graphics.update
      break if @sprite.y >= 480 + 240
    end
    sprite2.bitmap.dispose
    sprite2.dispose
  end
  #--------------------------------------------------------------------------
  # * Fade
  #     target_color : Color to fade to
  #           frames : Effect duration in frames
  #--------------------------------------------------------------------------
  def fade(target_color=Color.new(255, 255, 255), frames=10)
    loop do
      r = (@sprite.color.red   * (frames - 1) + target_color.red)   / frames
      g = (@sprite.color.green * (frames - 1) + target_color.green) / frames
      b = (@sprite.color.blue  * (frames - 1) + target_color.blue)  / frames
      a = (@sprite.color.alpha * (frames - 1) + target_color.alpha) / frames
      @sprite.color.red   = r
      @sprite.color.green = g
      @sprite.color.blue  = b
      @sprite.color.alpha = a
      frames -= 1
      Graphics.update
      break if frames <= 0
    end
    Graphics.freeze
  end
  #--------------------------------------------------------------------------
  # * Explode
  #     explosion_sound : The SE filename to use for explosion sound
  #--------------------------------------------------------------------------
  def explode(explosion_sound=Explosion_Sound)
    shake_count = 2
    shakes = 40
    tone = 0
    shakes.times do
      @sprite.ox = 320 + (rand(2) == 0 ? -1 : 1) * shake_count
      @sprite.oy = 240 + (rand(2) == 0 ? -1 : 1) * shake_count
      shake_count += 0.2
      tone += 128/shakes
      @sprite.tone.set(tone, tone, tone)
      Graphics.update
    end
    @sprite.ox, @sprite.oy = 320, 240
    Graphics.update
    bitmap = @sprite.bitmap.clone
    @sprite.bitmap.dispose
    @sprite.dispose
    # Slice bitmap and create nodes (sprite parts)
    hor = []
    20.times do |i|
      ver = []
      15.times do |j|
        # Set node properties
        s = Sprite.new
        s.ox, s.oy = 8 + rand(25), 8 + rand(25)
        s.x, s.y = s.ox + 32 * i, s.oy + 32 * j
        s.bitmap = Bitmap.new(32, 32)
        s.bitmap.blt(0, 0, bitmap, Rect.new(i * 32, j * 32, 32, 32))
        s.tone.set(128, 128, 128)
        # Set node physics
        angle  = (rand(2) == 0 ? -1 : 1) * (4 + rand(4) * 10)
        zoom_x = (rand(2) == 0 ? -1 : 1) * (rand(2) + 1).to_f / 100
        zoom_y = (rand(2) == 0 ? -1 : 1) * (rand(2) + 1).to_f / 100
        (zoom_x > zoom_y) ? (zoom_y = -zoom_x) : (zoom_x = -zoom_y)
        x_rand = (2 + rand(2) == 0 ? -2 : 2)
        y_rand = (1 + rand(2) == 0 ? -1 : 1)
        # Store node and it's physics
        ver.push([s, angle, zoom_x, zoom_y, x_rand, y_rand])
      end
      hor.push(ver)
    end
    bitmap.dispose
    # Play sound
    play_se(explosion_sound) if explosion_sound != nil
    # Move pics
    40.times do |k|
      hor.each_with_index do |ver, i|
        ver.each_with_index do |data, j|
          # Get node and it's physics
          s, angle, zoom_x, zoom_y = data[0], data[1], data[2], data[3]
          x_rand, y_rand = data[4], data[5]
          # Manipulate nodes
          s.x += (i - 10) * x_rand
          s.y += (j - 8) * y_rand + (k - 20)/2
          s.zoom_x += zoom_x
          s.zoom_y += zoom_y
          tone = s.tone.red - 8
          s.tone.set(tone, tone, tone)
          s.opacity -= 13 if k > 19
          s.angle += angle % 360
        end
      end
      Graphics.update
    end
    # Dispose
    for ver in hor
      for data in ver
        data[0].bitmap.dispose
        data[0].dispose
      end
    end
    hor = nil
  end
  #--------------------------------------------------------------------------
  # * Explode (Chaos Project Style)
  #     explosion_sound : The SE filename to use for explosion sound
  #--------------------------------------------------------------------------
  def explode_cp(explosion_sound=Explosion_Sound)
    bitmap = @sprite.bitmap.clone
    @sprite.bitmap.dispose
    @sprite.dispose
    # Slice bitmap and create nodes (sprite parts)
    hor = []
    20.times do |i|
      ver = []
      15.times do |j|
        # Set node properties
        s = Sprite.new
        s.ox = s.oy = 16
        s.x, s.y = s.ox + 32 * i, s.oy + 32 * j
        s.bitmap = Bitmap.new(32, 32)
        s.bitmap.blt(0, 0, bitmap, Rect.new(i * 32, j * 32, 32, 32))
        # Set node physics
        angle  = (rand(2) == 0 ? -1 : 1) * rand(8)
        zoom_x = (rand(2) == 0 ? -1 : 1) * (rand(2) + 1).to_f / 100
        zoom_y = (rand(2) == 0 ? -1 : 1) * (rand(2) + 1).to_f / 100
        # Store node and it's physics
        ver.push([s, angle, zoom_x, zoom_y])
      end
      hor.push(ver)
    end
    bitmap.dispose
    # Play sound
    play_se(explosion_sound) if explosion_sound != nil
    # Move pics
    40.times do |k|
      hor.each_with_index do |ver, i|
        ver.each_with_index do |data, j|
          # Get node and it's physics
          s, angle, zoom_x, zoom_y = data[0], data[1], data[2], data[3]
          # Manipulate node
          s.x += i - 9
          s.y += j - 8 + k
          s.zoom_x += zoom_x
          s.zoom_y += zoom_y
          s.angle += angle % 360
        end
      end
      Graphics.update
    end
    # Dispose
    for ver in hor
      for data in ver
        data[0].bitmap.dispose
        data[0].dispose
      end
    end
    hor = nil
  end
  #--------------------------------------------------------------------------
  # * Transpose (bt Blizzard)
  #     frames : Effect duration in frames
  #   max_zoom : The max amount the screen zooms out
  #      times : Number of times screen is zoomed (times * 3 / 2)
  #--------------------------------------------------------------------------
  def transpose(frames=80, max_zoom=12, times=3)
    max_zoom -= 1 # difference b/w zooms
    max_zoom = max_zoom.to_f / frames / times # unit zoom
    unit_opacity = (255.0 / frames).ceil
    spr_opacity = (255.0 * times / 2 / frames).ceil
    @sprites = []
    (times * 3 / 2).times {
      s = Sprite.new
      s.x, s.y, s.ox, s.oy = 320, 240, 320, 240
      s.bitmap = @sprite.bitmap
      s.blend_type = 1
      s.opacity = 128
      s.visible = false
      @sprites.push(s)}
    count = 0
    loop {
        @sprites[count].visible = true
        count += 1 if count < times * 3 / 2 - 1
        (frames / times / 2).times {
            @sprites.each {|s|
                break if !s.visible
                s.zoom_x += max_zoom
                s.zoom_y += max_zoom
                s.opacity -= spr_opacity}
            @sprite.opacity -= unit_opacity
        Graphics.update}
        break if @sprite.opacity == 0}
    @sprites.each {|s| s.dispose}
  end
  #--------------------------------------------------------------------------
  # * Shutter
  #       open_gap : How much the shutters open before moving away
  #       flip_dir : Whether or not the direction of shutters if reversed
  #       slowness : How slow the screens move out
  #    start_speed : Speed of first step in pixels
  #--------------------------------------------------------------------------
  def shutter(flip_dir=true, open_gap=16, slowness=4, start_speed=8)
    # Shred screen
    sprite2 = Sprite.new
    sprite2.bitmap = Bitmap.new(@sprite.bitmap.width, @sprite.bitmap.height)
    sprite2.x = sprite2.ox = sprite2.bitmap.width / 2
    sprite2.y = sprite2.oy = sprite2.bitmap.height / 2
    if flip_dir
      ver_step = 1
      sprite2.bitmap.blt(0, 240, @sprite.bitmap, Rect.new(0, 240, 640, 240))
      @sprite.bitmap.fill_rect(0, 240, 640, 240, Color.new(0, 0, 0, 0))
    else
      ver_step = -1
      sprite2.bitmap.blt(0, 0, @sprite.bitmap, Rect.new(0, 0, 640, 240))
      @sprite.bitmap.fill_rect(0, 0, 640, 240, Color.new(0, 0, 0, 0))
    end
    # Move the shutters apart
    open_gap.times do
      @sprite.y -= ver_step
      sprite2.y += ver_step
      Graphics.update
    end
    # Make sure starting step is not zero
    start_speed = slowness if start_speed < slowness
    # Move sprites
    dist = 640 - @sprite.x + start_speed
    loop do
      x_diff = (dist - (640 - @sprite.x)) / slowness
      @sprite.x += x_diff
      sprite2.x -= x_diff
      Graphics.update
      break if @sprite.x >= 640 + 320
    end
    sprite2.bitmap.dispose
    sprite2.dispose
  end
  #--------------------------------------------------------------------------
  # * Drop Off
  #     clink_sound : The SE filename to use for clinking sound
  #--------------------------------------------------------------------------
  def drop_off(clink_sound=Clink_Sound)
    bitmap = @sprite.bitmap.clone
    @sprite.bitmap.dispose
    @sprite.dispose
    # Slice bitmap and create nodes (sprite parts)
    max_time = 0
    hor = []
    10.times do |i|
      ver = []
      8.times do |j|
        # Set node properties
        s = Sprite.new
        s.ox = rand(32)
        s.oy = 0
        s.x = s.ox + 64 * i
        s.y = s.oy + 64 * j
        s.bitmap = Bitmap.new(64, 64)
        s.bitmap.blt(0, 0, bitmap, Rect.new(i * 64, j * 64, 64, 64))
        # Set node physics
        angle = rand(4) * 2
        angle *= rand(2) == 0 ? -1 : 1
        start_time = rand(30)
        max_time = start_time if max_time < start_time
        # Store node and it's physics
        ver.push([s, angle, start_time])
      end
      hor.push(ver)
    end
    bitmap.dispose
    # Play sound
    play_se(clink_sound) if clink_sound != nil
    # Move pics
    (40 + max_time).times do |k|
      hor.each_with_index do |ver, i|
        ver.each_with_index do |data, j|
          # Get node and it's physics
          s, angle, start_time = data[0], data[1], data[2]
          # Manipulate node
          if k > start_time
            tone = s.tone.red - 6
            s.tone.set(tone, tone, tone)
            s.y += k - start_time
            s.angle += angle % 360
          elsif k == start_time
            tone = 128
            s.tone.set(tone, tone, tone)
            $game_system.se_play(Clink_Sound) if clink_sound != nil
          end
        end
      end
      Graphics.update
    end
    # Dispose
    for ver in hor
      for data in ver
        data[0].bitmap.dispose
        data[0].dispose
      end
    end
    hor = nil
  end
end
#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  Added transition_type attribute which controls transition shown.
#==============================================================================
class Game_Temp  
  attr_accessor :transition_type  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias transpack_game_temp_init initialize
  def initialize
    @transition_type = Transition::DEFAULT_TRANSITION
    transpack_game_temp_init
  end
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Scene_Map modded to use the transition effect when battle begins.
#==============================================================================
class Scene_Map
  #--------------------------------------------------------------------------
  # * Battle Call
  #--------------------------------------------------------------------------
  alias transpack_call_battle call_battle
  def call_battle
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
    transpack_call_battle
    if $game_switches[10] == false
      $scene = Transition.new($scene, Transition::BATTLE_EFFECT)
    else
      $scene = Transition.new($scene, nil)
    end
  end
  #--------------------------------------------------------------------------
  # * Shop Call
  #--------------------------------------------------------------------------
  alias transpack_call_shop call_shop
  def call_shop
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
    transpack_call_shop
    $scene = Transition.new($scene, Transition::SHOP_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Name Input Call
  #--------------------------------------------------------------------------
  #alias transpack_call_name call_name
  #def call_name
  #  transpack_call_name
  #  $scene = Transition.new($scene, Transition::NAME_EFFECT)
  #end
  #--------------------------------------------------------------------------
  # * Menu Call
  #--------------------------------------------------------------------------
  alias transpack_call_menu call_menu
  def call_menu
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
    transpack_call_menu
    $scene = Transition.new($scene, Transition::MENU_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Save Call
  #--------------------------------------------------------------------------
  alias transpack_call_save call_save
  def call_save
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
    transpack_call_save
    $scene = Transition.new($scene, Transition::SAVE_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Player Place Move
  #--------------------------------------------------------------------------
  def transfer_player
    $game_temp.player_old_scr_x = $game_player.screen_x
    $game_temp.player_old_scr_y = $game_player.screen_y
    # Clear player place move call flag
    $game_temp.player_transferring = false
    
    if $game_temp.player_new_map_id != $game_map.map_id
    _change = true
    $game_temp.transition_processing = true
  else
    _change = false
    p "waitwhat"
      end
    #
    #self.transfer_player($game_temp.player_new_map_id, $game_temp.player_new_x, $game_temp.player_new_y, $game_temp.player_new_direction)
    # If move destination is different than current map
    if _change == true
      # Remake sprite set
      @spriteset.dispose
      @spriteset = Spriteset_Map.new
      # Set fade
      if $game_temp.transition_processing
        p "ass"
      # Execute transition
      #Graphics.transition(20)
        #$game_screen.tone = Tone.new(-128,-128,-128,0)
      end
    end
=begin    
    if !($game_map.exterior)
      @spriteset.clear_weather
    end
=end    
    # AAAA
    # If processing transition
    if $game_temp.transition_processing
      # Clear transition processing flag
      p "super ass"
      $game_temp.transition_processing = false
      # Execute transition
      $scene = Transition.new($scene)
    else
      $scene = Transition.new($scene, -1)
    end
    # Frame reset
    Graphics.frame_reset
    # Update input information
    Input.update
=begin
    $game_player.update_player_sprite
    unless SaveFile::QUICKSAVE_EXCEPTIONS.include?($game_map.map_id)
      SaveFile.quicksave
      $game_player.set_autosave_count
    end
=end
  end
end
