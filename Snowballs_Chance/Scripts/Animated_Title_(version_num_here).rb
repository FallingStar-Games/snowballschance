#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
# Zer0 Advanced Title 
# Author: ForeverZer0
# Version: 2.0
# Date: 10.03.2010
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
# Version History
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#  Version 1.0 (3.14.2010)
#  - Original write
# 
#  Version 1.1 (3.18.2010)
#  - Fixed a bug that would crash the game if you tried to return to the Title
#    Screen from the load screen when using the Load Transition.
#
#  Version 1.2 (3.21.2010)
#  - Added a part to pre-cache all the bitmaps before the animation begins,
#    which should drastically reduce the possibility of lagging.
#
#  Version 2.0 (10.03.2010)
#  - Totally re-written from scratch.
#  - Eliminated the unprofessional 'flicker' that would occur if the database 
#    had an image defined for the title graphic.
#  - Improved performance, compatibility, overview, and configurability.
#  - Added Features:
#     - More options to how animations operate, with easier configuration.
#     - Added scene linker to easily add new commands to the title window.
#     - Added config to work with custom save systems.
#     - Add option to display text on the background.
#     - Window appearance can now be easily changed.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#
# Compatibility:
#   - Should be compatible with just about anything other than scripts that 
#     add animation, etc. to the Title screen
#   - Compatible with SDK
#
# Explanation:
#   This system will allow you alter the title screen and add some different
#   effects that are not normally available.
#
# Features:
#   - Animated Title
#   - Easy display of picture on screen and/or over animation
#   - Random Title Screen each load
#   - Transition Effect on loading saved games
#   - Weather/Fog Effects
#   - BGS and SFX
#   - Window configuration.
#
# Instructions:
#  - All the below configurable values can be set to nil to disable the feature
#    with the exception of SAVE_DATA. It is already configured to the default
#    system so leave it alone if you are not using a custom save system.
#  - If using the animated title, all pictures need to be named exactly the
#    the same, but have a different number at the end. The numbers should be
#    consecutive and in the order that the animation should follow. The first
#    image should be 0. (Ex. pic0, pic1, pic2, pic3, etc.)
#  - Configuration is below. Individual explanation for the settings is in 
#    their respective sections. All Graphics, Fogs, SFX, BGS, etc. that you use
#    need to be in their normal folders.
#
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:

  $zer0_adv_title = 2.0

#===============================================================================
# ** Scene_Title
#===============================================================================

class Scene_Title
#=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
#                           BEGIN CONFIGURATION
#=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

  ANIMATED = ['title', 23, 2]
  # ['FILENAME', NUMBER_IMAGES, SPEED]
   ANIMATION_TYPE = 0
   # 0 = Do not loop. Run through images and stop on last one.
   # 1 = Changes back to first image after running course, then repeats.
   # 2 = Cycles backwards to the first image after running course, then repeats.
   # 3 = Continually shift through all the files in "Titles" folder randomly.
   CHANGE_SE = nil
   # ['FILENAME', VOLUME, PITCH]
   # Sound effect played when the image changes.
   
  RANDOM_BACKGROUNDS = false
  # Uses a random image for the title each load if ANIMATED is nil. There is no
  # need to configure the graphics. Any/all images from the "Titles" folder will
  # be used.
  
  WEATHER = nil # [1, 20]
  # [TYPE, POWER]
  # Weather effect to be used on title screen. 

  FOG = nil # ['001-Fog01', 0, 2, -2, 3, 60]
  # ['FILENAME', HUE, X-SPEED, Y-SPEED, ZOOM, OPACITY]
  # Fog to be displayed on the title screen.

  BGS = nil # ['032-Switch01', 100, 100]
  # ['FILENAME', VOLUME, PITCH]
  # Background sound to be played during title. 
  
  PIC = ['gametitleempty', 0, 0, 3001, 0, true, 2]
  # ['NAME', X, Y, Z, OPACITY, FADE-IN?, FADE-IN SPEED]
  # Picture to be displayed on title screen.
    
  SAVE_DATA = ['Save', '.rxdata', 4, '']
  # ['SAVENAMES', 'SAVE_EXTENSION', SAVE_NUMBER, SAVE_DIRECTORY]
  # If you are using a custom save system that alters the name of the save files,
  # extension, or number of possible save files, configure this to match. 
  # DO NOT SET THIS VALUE TO NIL!
  
  LOAD_OUT = ['battletransition', 20, 40]
  LOAD_IN = ['battletransition', 20, 40]
  # ['TRANSITION NAME', DURATION, VAGUE]
  # Transitions used from the load screen, and when game starts. Can use both or
  # only one. 
  
  
  TEXT = ["alpha 0.2", 8, 460, 'PlopDump', 18]
  # ['STRING', X, Y, FONTNAME, FONTSIZE]
  # Have text be displayed on the images such as the version number, etc.
   TEXT_COLOR = Color.new(50, 62, 77, 255)
   # [RED, GREEN, BLUE, ALPHA]
   # Color used for the text if being used. White is default.
   
   
  WINDOW_DATA = [470, 325, 0, 128, false]
  # [X, Y, OPACITY, WIDTH, SHOW_WINDOWSKIN?]
  # Coordinates used for the main window. Default settings will be used if nil.
  COMMANDS = ['New Game', 'Load Game','Quit']
  # Strings used for the commands on the title screen. Omitting the third item
  # in the array will also effectively get rid of the "Shutdown" option that
  # many do not like for its uselessness.
   
  def _SCENE_LINK(command_index)
    # Configure here any scenes you would like to link to the Title screen. You
    # must first configure the name of the command in COMMANDS. After that, just
    # fill in the name of the scene for the proper index. Any command index left
    # undefined will be assumed to be a 'Shutdown' option.
    
    # ex.   when 2 then Scene_MyOptions
    
    # Will make the third command (index starts at 0) start the defined scene.
    # Do not configue anything for index 0 or 1. It will not work. They are 
    # reserved for 'New Game' and 'Continue'.
    
    return case command_index
    when 2 then command_shutdown
    end
  end
  
#=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
#                           END CONFIGURATION
#=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
  
  def main
    # If battle test
    if $BTEST
      battle_test
      return
    end
    # Load database
    $data_actors        = load_data('Data/Actors.rxdata')
    $data_classes       = load_data('Data/Classes.rxdata')
    $data_skills        = load_data('Data/Skills.rxdata')
    $data_items         = load_data('Data/Items.rxdata')
    $data_weapons       = load_data('Data/Weapons.rxdata')
    $data_armors        = load_data('Data/Armors.rxdata')
    $data_enemies       = load_data('Data/Enemies.rxdata')
    $data_troops        = load_data('Data/Troops.rxdata')
    $data_states        = load_data('Data/States.rxdata')
    $data_animations    = load_data('Data/Animations.rxdata')
    $data_tilesets      = load_data('Data/Tilesets.rxdata')
    $data_common_events = load_data('Data/CommonEvents.rxdata')
    $data_system        = load_data('Data/System.rxdata')
    # Create an instance of Game_System and a few other instance variables
    $game_system, @sprites, @bitmaps = Game_System.new, [], []
    # Create list of filenames of images found in Titles directory.
    @files = Dir.entries('Graphics/Titles').find_all {|file|
      ['.png', '.jpg'].include?(File.extname(file)) }
    # Play BGS if defined.
    # Stop playing ME and BGS (for when returning to title from game)
    Audio.me_stop
    if BGS != nil
      $game_system.bgs_play(RPG::AudioFile.new(BGS[0], BGS[1], BGS[2]))
    end
    # Play title BGM
    $game_system.bgm_play($data_system.title_bgm)
    # Prepare bitmap(s) for the backgound graphic.
    if ANIMATED != nil
      if ANIMATION_TYPE != 3
        (0...ANIMATED[1]).each {|i| 
          # Pre-cache the graphics now to prevent lag during animation.
          @bitmaps[i] = RPG::Cache.title("#{ANIMATED[0]}#{i}") }
      else
        @files.each {|file| @bitmaps.push(RPG::Cache.title(file)) }
      end
      @count, @index, @reverse = 0, 0, false
      # Create the audio file for later use if needed.
      if CHANGE_SE != nil
        @se = RPG::AudioFile.new(CHANGE_SE[0], CHANGE_SE[1], CHANGE_SE[2])
      end
    elsif RANDOM_BACKGROUNDS 
      # Cache a random image from the array.
      @bitmaps.push(RPG::Cache.title(@files[rand(@files.size)]))
    else
      # Else use the bitmap defined in the database.
      @bitmaps.push(RPG::Cache.title($data_system.title_name))
    end
    # Create weather sprite if needed.
    if WEATHER != nil
      @weather = RPG::Weather.new
      @weather.type, @weather.max = WEATHER[0], WEATHER[1]
      @sprites.push(@weather)
    end
    # Create Fog sprite if needed.
    if FOG != nil
      @fog = Plane.new
      @fog.bitmap = RPG::Cache.fog(FOG[0], FOG[1])
      @fog.z, @fog.opacity = 3000, FOG[5]
      @fog.zoom_x = @fog.zoom_y = FOG[4]
    end
    # Create picture graphic if needed.
    if PIC != nil
      @picture = Sprite.new
      @picture.bitmap = RPG::Cache.picture(PIC[0])
      @picture.x, @picture.y, @picture.z = PIC[1], PIC[2], PIC[3]
      @picture.opacity = PIC[4]
      @sprites.push(@picture)
    end
    # Draw text on background image(s) if configured.
    if TEXT != nil
      @bitmaps.each {|bitmap| 
        bitmap.font.name, bitmap.font.size = TEXT[3], TEXT[4]
        if TEXT_COLOR.is_a?(Color)
          bitmap.font.color = TEXT_COLOR
        end
        bitmap.draw_text(TEXT[1], TEXT[2], 640, TEXT[4]+8, TEXT[0])
      }
    end
    # Set graphic to background.
    @background = Sprite.new
    @background.bitmap = @bitmaps[0]
    # Create command window.
    commands = COMMANDS == nil ? ['New Game', 'Load Game', 'Exit'] : COMMANDS
    if WINDOW_DATA != nil
      @command_window = Window_Command.new(WINDOW_DATA[3], commands)
      @command_window.back_opacity = WINDOW_DATA[2]
      @command_window.x, @command_window.y = WINDOW_DATA[0], WINDOW_DATA[1]
      unless WINDOW_DATA[4]
        @command_window.opacity = 0
      end
    else
      @command_window = Window_Command.new(192, commands)
      @command_window.y, @command_window.back_opacity = 288, 160
      @command_window.x = 320 - @command_window.width / 2
    end
    # Determine if any save files exist.
    filenames = []
    (1..SAVE_DATA[2]).each {|i|
      filenames.push("#{SAVE_DATA[3]}#{SAVE_DATA[0]}#{i}#{SAVE_DATA[1]}") }
    @continue_enabled = filenames.any? {|filename| File.exist?(filename) }
    # Disable 'Continue' if no save files are found.
    if @continue_enabled
      @command_window.index = 1
    else
      @command_window.disable_item(1)
    end
    @sprites.push(@command_window, @background)
    # Transition the graphics.
    Graphics.transition
    # Main loop
    loop { Graphics.update; Input.update; update; break if $scene != self }
    # Prepare for transition.
    Graphics.freeze
    Audio.bgs_stop
    # Dispose the bitmaps, sprites, etc.
    (@sprites + @bitmaps).each {|object| object.dispose }
    @fog.dispose if @fog != nil
    # Clear Cache to free the graphics from the memory.
    RPG::Cache.clear
  end
  #-----------------------------------------------------------------------------
  def update
    # Update the sprites.
    @sprites.each {|sprite| sprite.update }
    # Scroll fog if needed.
    if @fog != nil
      @fog.ox += FOG[2]
      @fog.oy += FOG[3]
    end
    # Update picture if needed.
    if @picture != nil && @picture.opacity != 255 && PIC[5]
      @picture.opacity += PIC[6]
    end
    # Update animation if needed.
    if ANIMATED != nil
      @count += 1
      if @count == ANIMATED[2]
        case ANIMATION_TYPE
        when 0 # No looping
          @index += 1
        when 1 # Re-Start
          @index = (@index + 1) % ANIMATED[1]
        when 2 # Reverse Cycle
          @index += @reverse ? -1 : 1
          # Change reverse flag when needed.
          if @index == 0
            @reverse = false
          elsif @index == ANIMATED[1]
            @reverse = true
          end
        when 3 # Random Image
          old = @index
          @index = rand(@bitmaps.size)
          # Ensure images don't repeat consecutively.
          @index += 1 if old == @index
        end
        # Make sure bitmap index stays within permissible range.
        @index = [[@index, 0].max, ANIMATED[1]-1].min
        # Alter the image to the new bitmap.
        @background.bitmap = @bitmaps[@index]
        # Play the change SE if needed.
        if @se != nil
          $game_system.se_play(@se)
        end
        # Reset count.
        @count = 0
      end
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @command_window.index
      when 0 then command_new_game
      when 1 then command_continue
      else 
        scene = _SCENE_LINK(@command_window.index)
        scene == nil ? command_shutdown : $scene = scene.new
      end
    end
  end
end

#===============================================================================
# ** Scene_Load
#===============================================================================

class Scene_Load < Scene_File
  
  alias zer0_adv_title_main main
  def main
    zer0_adv_title_main
    # Only if next scene is Scene_Map.
    if $scene.is_a?(Scene_Map)
      # Set data in local variables.
      tran_out, tran_in = Scene_Title::LOAD_OUT, Scene_Title::LOAD_IN
      folder = 'Graphics/Transitions/'
      # Play "out" transition if so configured.
      if tran_out != nil
        Graphics.transition(tran_out[1], folder + tran_out[0], tran_out[2])
        Graphics.freeze
      end
      # Play "in" transition if so configured.
      if tran_in != nil
        # Create an instance of the map sprite.
        map = Spriteset_Map.new
        Graphics.transition(tran_in[1], folder + tran_in[0], tran_in[2])
        Graphics.freeze
        # Dispose sprite.
        map.dispose
      end
    end
  end
end