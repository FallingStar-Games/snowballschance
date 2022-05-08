#===============================================================================
#
#           Heretic's Lightning [XP]
#           Authors: Heretic
#           Version 1.0
#           Date: Monday, October 21st, 2013
#
#------------------------------------------------------------------------------
#
#  The purpose of this script is to allow a Lightning Flash on the Screen
#  without using "Change Screen Color Tone".  The reason this is important
#  is that "Change Screen Color Tone" calls may conflict with using that
#  command to simulate Lightning for other purposes such as Transferring
#  between Maps.  It also fixes some issues where going into a Battle
#  where Lightning is controlled by Events causes the Screen to "get stuck"
#
#  Movie Lightning typically has one Bright Flash, returns to Normal Color
#  then a Secondary Flash that fades out slowly.  This script will simulate
#  that instead of needing to use the aforementioned "Change Screen Color
#  Tone" due to the inherit problems with Battles, Events, and Transfers
#  if you Fade to Black when changing maps like I do.
#
#  ---  Usage  ---
#
#  This script is simple.  From an Event Script:
#
#  * lightning(duration) 
#  * se_thunder(volume, pitch, filename[default 061-Thunderclap01])
#
#  ---  Thunder Sound Effects ---
#
#  I wanted a way to make Thunder Sound Effects play with a bit more variation
#  so I added "se_thunder(volume, pitch)" to allow for easier manipulation
#  of Thunder Sounds.  Its useful because you can throw Variables into the
#  arguments instead of always using a Static Number every time.  This allows
#  you to do something like this:
#
#  **  Event Script  **
#  pitch = rand(100) + 50
#  se_thunder(100, pitch)
#
#  This gives pitch a random number between 50 and 150 so the Pitch of the
#  sound of your Thunder can vary every time the Sound Effect Plays.
#
#  ---  Change Screen Color Tone  ---
#
#  The real purpose of this script is to prevent Change Screen Color Tone from
#  getting messed up by using it for both Lightning Flashes and any other time
#  that it is called.  This means that calling "Change Screen Color Tone" with
#  a Duration of say 30 Frames, then calling it again during that 30 Frames
#  causes either One or the Other to run, which is where Conflicts and Problems
#  come from.  If you have a Lightning Flash and the Player triggers "Change
#  Screen Color Tone", then "Change Screen Color Tone" will OVERRIDE the 
#  Lightning Flash and your Screen should NEVER get messed up as a result.
#  
#------------------------------------------------------------------------------

# Version Number
$heretics_lightning = 1.0

#==============================================================================
# ** Game_Screen
#------------------------------------------------------------------------------
#  This class handles screen maintenance data, such as change in color tone,
#  flashing, etc. Refer to "$game_screen" for the instance of this class.
#==============================================================================
class Game_Screen
  #--------------------------------------------------------------------------
  # * Initialization for Game_Screen - Alias
  #--------------------------------------------------------------------------
  unless method_defined?(:lightning_flash_game_screen_initialize)
    alias lightning_flash_game_screen_initialize initialize
  end
  def initialize
    # Call Original or Other Aliases
    lightning_flash_game_screen_initialize
    # New Properties
    @lightning_duration = 0
    @lightning = 0
  end
  #--------------------------------------------------------------------------
  # * Start Changing Color Tone
  #     tone : color tone
  #     duration : time
  #--------------------------------------------------------------------------
  unless method_defined?(:lightning_flash_start_tone_change)
    alias lightning_flash_start_tone_change start_tone_change
  end
  def start_tone_change(tone, duration)
    # Call Original or Other Aliases
    lightning_flash_start_tone_change(tone, duration)
    # Clear any Lightning Flashes - Half of fixing Color Tone Screw Ups
    @lightning_duration = 0
    @lightning = 0
    @last_tone = nil
  end
  #--------------------------------------------------------------------------
  # * Frame Update for Game_Screen 
  #--------------------------------------------------------------------------
  unless method_defined?(:lightning_flash_game_screen_update)
    alias lightning_flash_game_screen_update update
  end
  def update
    # Call Original or Other Aliases
    lightning_flash_game_screen_update
    # Save Game Fix
    @lightning_duration = 0 if @lightning_duration.nil?
    # If Lightning
    if @lightning_duration > 0
      # First Flash - Fully Grayed Out - Tone(R,G,B, Grayscale)
      if @lightning_duration == @lightning
        # Change Tone to Lightning Flash Tone
        @tone = Tone.new(34, 34, 51, 255)
      # End First Flash - Return to Last Color Tone
      elsif @lightning_duration == @lightning - 2
        # Set Tone to Last Tone
        @tone = @last_tone
      # Second Flash - Slightly Grayed Out - Tone(R,G,B, Grayscale)
      elsif @lightning_duration == @lightning - 6
        # Change Tone to Lightning Flash Tone
        @tone = Tone.new(34, 34, 51, 224)       
      # Lightning Flash Fade - Fade from Flash to Tone Target
      # This is half of what fixes Color Tone Screw Ups
      elsif @lightning_duration < @lightning - 6
        d = @lightning_duration
        @tone.red = (@tone.red * (d - 1) + @tone_target.red) / d
        @tone.green = (@tone.green * (d - 1) + @tone_target.green) / d
        @tone.blue = (@tone.blue * (d - 1) + @tone_target.blue) / d
        @tone.gray = (@tone.gray * (d - 1) + @tone_target.gray) / d
      end
      # Countdown
      @lightning_duration -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Lightning
  #     duration : time in Frames
  #--------------------------------------------------------------------------
  def lightning(duration=30)
    # Error Checking
    if (not duration.is_a?(Integer) or duration < 1) and $DEBUG
      # Display Error
      print "Warning: lightning(duration) expects\n",
            "duration to be a Positive Number!\n\n",
            "lightning(\"", duration, "\") Ignored!"
      # Prevent Execution of Lightning
      return
    end
    # If there is no Current Lightning Flash
    if @lightning_duration == 0 or @last_tone.nil?
      # Store Last Tone
      @last_tone = @tone_target.clone
    end
    # Set up Lightning Animation Values (+6 is offset for First Flash)
    @lightning_duration = duration * 2 + 6
    @lightning = duration * 2
  end
end

#==============================================================================
# ** Interpreter
#==============================================================================
class Interpreter
  #--------------------------------------------------------------------------
  # * Lightning
  #     duration : time in Frames
  #--------------------------------------------------------------------------
  def lightning(duration)
    # Call Game Screen for Command Execution
    $game_screen.lightning(duration)
  end
  #--------------------------------------------------------------------------
  # * Thunder
  #     volume : Numeric Value between 0 and 100 at which SE will Play
  #     pitch  : Numeric Value that SE will Play.  100 for Normal Pitch
  #     file   : Sound Effect File Name in SE Database
  #
  #   - Plays Thuder Sound Effect with Variations on Volume and Pitch
  #--------------------------------------------------------------------------
  def se_thunder(volume=100, pitch=100, file='PerfectThunder2056381765')
    # Call Game Screen for Command Execution (order is different than args)
    thunder = RPG::AudioFile.new(file, volume, pitch)
    # Play Sound
    $game_system.se_play(thunder)
  end
end