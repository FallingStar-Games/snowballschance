#==============================================================================
# ** Transition Pack
#------------------------------------------------------------------------------
# by Fantasist
# Version: 1.11
# Date: 9-December-2009
#------------------------------------------------------------------------------
# Version History:
#
#   1.0 - First released version
#   1.1 - Added code to make battle scene use the transitions
#   1.11 - Transitions are used when switching maps, fixed some bugs
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
#     This script NEEDS "screenshot.dll"! Place it in the game folder.
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
#     10- downward Spiral
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
=begin
#==============================================================================
# ** Screen Module
#------------------------------------------------------------------------------
#  This module handles taking screenshots for the transitions.
#==============================================================================
module Screen
# this shit needs to be edited
  @screen = Win32API.new 'screenshot.dll', 'Screenshot', %w(l l l l p l l), ''
  @readini = Win32API.new 'kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 'l'
  @findwindow = Win32API.new 'user32', 'FindWindowA', %w(p p), 'l'
  #--------------------------------------------------------------------------
  # * Snap (take screenshot)
  #--------------------------------------------------------------------------
  def self.snap(file_name='scrn_tmp', file_type=0)
    game_name = "\0" * 256
    @readini.call('Game', 'Title', '', game_name, 255, '.\Game.ini')
    game_name.delete!('\0')
    window = @findwindow.call('RGSS Player', game_name)
    @screen.call(0, 0, 640, 480, file_name, window, file_type)
  end
end

#==============================================================================
# ** Transition
#------------------------------------------------------------------------------
#  This scene handles transition effects while switching to another scene.
#==============================================================================
class Transition
  
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  # * CONFIG BEGIN
  #::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  BATTLE_EFFECT = [5]#[2,3,6,7,8,9] # randomly choose from any of those
  SHOP_EFFECT = 0
  NAME_EFFECT = nil # uses default effect set in $game_temp.transition_type
  MENU_EFFECT = -1
  SAVE_EFFECT = -1 # disable effect/use default
  
  
  
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
      when 10 then downward_spiral
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
      when 10 then downward_spiral(*args)
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
    path = ENV['appdata'] + "\\scrn_tmp"
    Screen.snap(path)
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(path)
    @sprite.x = @sprite.ox = @sprite.bitmap.width / 2
    @sprite.y = @sprite.oy = @sprite.bitmap.height / 2
    # Activate effect
    Graphics.transition(0)
    call_effect(@type, @args)
    # Freeze screen and clean up and switch scene
    Graphics.freeze
    @sprite.bitmap.dispose unless @sprite.bitmap.nil?
    @sprite.dispose unless @sprite.nil?
    File.delete(path)
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
    unit_zoom = zoom_diff.to_f / frames
    unit_opacity = (255.0 / frames).ceil
    # Apply unit values to sprite
    frames.times do
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
  #--------------------------------------------------------------------------
  # * Downward Spiral
  #     FRAMES: Total number of frames the transition takes to fall away completely.
  #     ROTATION SPEED: Defines how fast the screen rotates in degrees.
  #--------------------------------------------------------------------------
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
    @transition_type = 0
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
    transpack_call_battle
    $scene = Transition.new($scene, Transition::BATTLE_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Shop Call
  #--------------------------------------------------------------------------
  alias transpack_call_shop call_shop
  def call_shop
    transpack_call_shop
    $scene = Transition.new($scene, Transition::SHOP_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Name Input Call
  #--------------------------------------------------------------------------
  alias transpack_call_name call_name
  def call_name
    transpack_call_name
    $scene = Transition.new($scene, Transition::NAME_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Menu Call
  #--------------------------------------------------------------------------
  alias transpack_call_menu call_menu
  def call_menu
    transpack_call_menu
    $scene = Transition.new($scene, Transition::MENU_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Save Call
  #--------------------------------------------------------------------------
  alias transpack_call_save call_save
  def call_save
    transpack_call_save
    $scene = Transition.new($scene, Transition::SAVE_EFFECT)
  end
  #--------------------------------------------------------------------------
  # * Player Place Move
  #--------------------------------------------------------------------------
  def transfer_player
    # Clear player place move call flag
    $game_temp.player_transferring = false
    # If move destination is different than current map
    if $game_map.map_id != $game_temp.player_new_map_id
      # Set up a new map
      $game_map.setup($game_temp.player_new_map_id)
    end
    # Set up player position
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y)
    # Set player direction
    case $game_temp.player_new_direction
    when 2  # down
      $game_player.turn_down
    when 4  # left
      $game_player.turn_left
    when 6  # right
      $game_player.turn_right
    when 8  # up
      $game_player.turn_up
    end
    # Straighten player position
    $game_player.straighten
    # Update map (run parallel process event)
    $game_map.update
    # Remake sprite set
    @spriteset.dispose
    @spriteset = Spriteset_Map.new
    # If processing transition
    if $game_temp.transition_processing
      # Clear transition processing flag
      $game_temp.transition_processing = false
      # Execute transition
      $scene = Transition.new($scene)
    end
    # Run automatic change for BGM and BGS set on the map
    $game_map.autoplay
    # Frame reset
    Graphics.frame_reset
    # Update input information
    Input.update
  end
end
=end