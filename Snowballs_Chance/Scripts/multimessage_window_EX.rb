#==============================================================================
# ** Multiple Message Windows Ex 1.6d                                 2016-08-21
#------------------------------------------------------------------------------
# Originally written by Wachunga
# Optimized and De-SDK'ed by ForeverZer0
# Ex Version by LiTTleDRAgo
#==============================================================================
=begin

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  ForeverZer0's Notes
  
- Credit for the original script is 100% Wachunga. Original map and events
  are also Wachunga's original.
- Edits have been made by ForeverZer0 to eliminate the SDK requirement
  and improve coding and performance
- I have added a compatibility switch for Blizzard's simple shaded text if you
  are you using that, because it doesn't look right with message text. The 
  switch will disable it whenever a message is showing, but otherwise will
  shade everything else.
- This script must be placed below Blizzard's Tons-of-Add-ons if you are
  using it. If you don't you will get an error. It has something to do with
  the Lagless HUD script. Some bug I couldn't isolate... If you find it, let
  me know, else just keep it under Tons.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  LiTTleDRAgo's Notes
  
- This script is edited and remodeled a bit by me to make it compatible with 
  Blizz ABS (and pst... H Mode 7)
- Although this version is de-SDK-ed by F0, This version should be 80% 
  compatible with SDK 
- Some features were added to enchanche this script functionality

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  This custom message system adds numerous features on top of the default
  message system, the most notable being the ability to have multiple message
  windows open at once. The included features are mostly themed around turning
  messages into speech (and thought) balloons, but default-style messages are
  of course still possible.

  The original version of the script uses the SDK, seems to be lost
  
  FEATURES
  New in 1.6 (feature by ThallionDarkshine)
      \ani[TYPE]
         TYPE - Which type of animation the text should have
           0  - Turn off Animation
           1  - Grow             4  - Shake
           2  - Rock             5  - Float
           3  - Shrink           6  - Color Rotate
           
           7  - Bounce           10 - Letter Grow (2)
           8  - Fade             11 - Letter Swivel
           9  - Letter Grow (1)  12 - Letter Colorize
           
           13 - Letter Fade (1)   16 - Letter Shrink (2)
           14 - Letter Fade (2)   17 - Letter Bounce <---YES!
           15 - Letter Shrink (1) 18 - Letter Float
           
  New in 1.5x
  
  * \f[face_image] = display faceset image
                   image must be placed in folder pictures and the size
                   is 80x80
  * \a[name]       = display message name
  * \r[string]     = display furigana text
  * \F+  = character puts their Foot Forward
  * \F*  = character puts their Other Foot Forward
  * \F-  = character resets their Foot Forward
  
  * \font[fontname,fontsize] = change font name and font size
  * \z[value]      = change z value from message  
  
  - message.auto_comma_pause = true/false
  - message.auto_comma_delay = n
  - message.opacity = (0-255)
  - message.sound = true / false
  - message.sound_audio = '001-System01' 
  - message.sound_volume = n
  - message.sound_pitch = n
  - message.sound_pitch_range = n
  - message.sound_frequency = n
  - message.sound_vary_pitch = true / false / 'random' 
  - message.shortcut[:(shortcut)] = 'Message'
  - message.speech_windowskin  = [windowskin_name,tail_windowskin_name]
  - message.thought_windowskin = [windowskin_name,tail_windowskin_name]
  - message.message_log = true / false
  
  * fixed face sprite bug
  * added message log  

  New in 1.5:
  * \C[#ffffff] for hexadecimal color
  * \C for return to default color
  * display name of item, weapon, armor or skill
    * \N[In] = display name of item with id n (note the "I")
    * \N[Wn] = display name of weapon with id n (note the "W")
    * \N[An] = display name of armor with id n (note the "A")
    * \N[Sn] = display name of skill with id n (note the "S")
  * display icon of item, weapon, armor or skill
    * \I[In] = display icon of item with id n (note the "I")
    * \I[Wn] = display icon of weapon with id n (note the "W")
    * \I[An] = display icon of armor with id n (note the "A")
    * \I[Sn] = display icon of skill with id n (note the "S")
  * display icon and name of item, weapon, armor or skill
    * \I&N[In] = display icon and name of item with id n (note the "I")
    * \I&N[Wn] = display icon and name of weapon with id n (note the "W")
    * \I&N[An] = display icon and name of armor with id n (note the "A")
    * \I&N[Sn] = display icon and name of skill with id n (note the "S")
  * new windowskins available
  * speech windowskin now definable separately from default windowskin
  * fixed bold bug where degree sign would occasionally appear
  * input number window now shares parent window's font
  * changed \Var[n] back to default of \V[n]
  
  New in 1.1:
  * message.autocenter for automatically centering text within messages
  * \N[en] for displaying name of enemy with id n (note the "e")
  * \MAP for displaying the name of the current map
  
  At a glance:
  * multiple message windows
  * speech balloons
    * position over player/event (follows movement and scrolling)
    * optional message tail (for speech or thought balloons)
    * can specify location relative to player/event (up, down, left, right)
  * thought balloons
    * can use different windowskin, message tail and font color
  * letter-by-letter mode
    * variable speed (and delays)
    * skippable on button press
  * autoresize messages
  * player movement allowed during messages
    * if speaker moves offscreen, message closes (like ChronoTrigger)
  * everything also works during battle
  * settings configurable at anytime  
  
  Full list of options:

  (Note that all are case *insensitive*.)
  
  =============================================================================
   Local (specified in message itself and resets at message end)
  =============================================================================
  - \L = letter-by-letter mode toggle
  - \S[n] = set speed at which text appears in letter-by-letter mode
  - \D[n] = set delay (in frames) before next text appears
  - \P[n] = position message over event with id n
            * use n=0 for player
            * in battle, use n=a,b,c,d for actors (e.g. \P[a] for first actor)
              and n=1,...,n for enemies (e.g. \P[1] for first enemy)
              where order is actually the reverse of troop order (in database)
  - \P = position message over current event (default for floating messages)
  - \^ = message appears directly over its event
  - \v = message appears directly below its event
  - \< = message appears directly to the left of its event
  - \> = message appears directly to the right of its event
  - \B = bold text
  - \I = italic text
  - \C[#xxxxxx] = change to color specified by hexadecimal (eg. ffffff = white)
  - \C = change color back to default
  - \! = message autoclose
  - \? = wait for user input before continuing
  - \+ = make message appear at same time as preceding one
         * note: must be at the start of message to work
  - \# = insert the last message with line text the preceding one       
  - \@ = thought balloon
  - \N[En] = display name of enemy with id n (note the "E")
  - \N[Pn] = display name of event with id n (note the "P")
  - \N[In] = display name of item with id n (note the "I")
  - \N[Wn] = display name of weapon with id n (note the "W")
  - \N[An] = display name of armor with id n (note the "A")
  - \N[Sn] = display name of skill with id n (note the "S")
  - \I[In] = display icon of item with id n (note the "I")
  - \I[Wn] = display icon of weapon with id n (note the "W")
  - \I[An] = display icon of armor with id n (note the "A")
  - \I[Sn] = display icon of skill with id n (note the "S")
  - \I&N[In] = display icon and name of item with id n (note the "I")
  - \I&N[Wn] = display icon and name of weapon with id n (note the "W")
  - \I&N[An] = display icon and name of armor with id n (note the "A")
  - \I&N[Sn] = display icon and name of skill with id n (note the "S")
  - \MAP = display the name of the current map

  These are, of course, in addition to the default options:
  - \V[n] = display value of variable n
  - \N[n] = display name of actor with id n
  - \C[n] = change color to n
  - \G = display gold window
  - \\ = show the '\' character
  
  * Foot Forward Notes * - Sprite Sheets only have 16 total Frames of Animation
    and of which, 4 are duplicates.  Foot Forward Options allow access to
    ALL of the frames of animation available in Default Sprite Sheets.
    
  - \F+  = character puts their Foot Forward
  - \F*  = character puts their Other Foot Forward
  - \F-  = character resets their Foot Forward
  
  *NOTE* - Foot Forward Animation will RESET if the event is moved off screen.
         - Change @auto_ff_reset if this feature causes you trouble with
           character animations.
    
    It also ONLY works with the following conditions
    - Direction Fix is OFF
    - Move Animation is ON
    - Stop Animation is OFF (technically thats Step, they typo'd)
    - @auto_ff_reset is TRUE
    - * These settings are the DEFAULT when a New Event is created
    
  =============================================================================
   Global (specified below or by Call Script and persist until changed)
  =============================================================================
  
  Zer0 Note:
  If you use any of these in another script, etc. and not a script call, you
  will need to place "$game_system." before each command.
  
  Miscellaneous:
  - message.move_during = true/false
    * allow/disallow player to move during messages
  - message.show_pause = true/false
    * show/hide "waiting for player" pause graphic
  - message.autocenter = true/false
    * enable/disable automatically centering text within messages
  - message.auto_comma_pause = true/false
    * inserts a delay before the next character after these characters ,!.?
    * expects correct punctuation.  One space after a comma, the rest 2 spaces
  - message.auto_comma_delay = n
    * changes how long to wait after a pausable character
  - message.auto_shrink = true/false
    * shrink the balloon message to one liner, but enlarge after 
      exceeding one line
  - message.opacity = (0-255)
    * change opacity for every message
  - message.speech_windowskin = [windowskin_name,tail_windowskin_name]
  - message.thought_windowskin = [windowskin_name,tail_windowskin_name]
  
  Speech/thought balloon related:
  - message.resize = true/false
    * enable/disable automatic resizing of messages (only as big as necessary)
  - message.floating = true/false
    * enable/disable positioning messages above current event by default
      (i.e. equivalent to including \P in every message)
  - message.location = TOP, BOTTOM, LEFT or RIGHT
    * set default location for floating messages relative to their event
  - message.show_tail = true/false
    * show/hide message tail for speech/thought balloons

  Letter-by-letter related:
  - message.letter_by_letter = true/false
    * enable/disable letter-by-letter mode (globally)
  - message.text_speed = 0-20
    * set speed at which text appears in letter-by-letter mode (globally)
  - message.skippable = true/false
    * allow/disallow player to skip to end of message with button press

  Font:
  - message.font_name = font
    * set font to use for text, overriding all defaults
      (font can be any TrueType from Windows/Fonts folder)
  - message.font_size = size
    * set size of text  (default 22), overriding all defaults
  - message.font_color = color
    * set color of text, overriding all defaults
    * you can use same 0-7 as for \C[n] or "#xxxxxx" for hexadecimal
    
  Sound related:

  - message.sound = true / false
    * Enables or Disables Text Sounds  
  - message.sound_audio = '001-System01'     
    * Audio SE (in DB) to play
  - message.sound_volume = n
    * Text Sound Volume (0 - 100)
  - message.sound_pitch = n
    * Text Sound Pitch (100 is default)
  - message.sound_pitch_range = n
    * How Much to vary the Pitch (10 = pitch of 90 to 110 with base 100)
  - message.sound_frequency = n
    * Plays a sound this many letters  
  - message.sound_vary_pitch = true / false / 'random'     
    *  Whether to Vary the Pitch or not, or totally randomize
    ** If random, use quotes and lower case: 'random'    

  Note that the default thought and shout balloon windowskins don't
  stretch to four lines very well (unfortunately).
    
  Thanks:
  XRXS code for self-close and wait for input
  Slipknot for a convenient approach to altering settings in-game
  SephirothSpawn for bitmap rotate method
  Heretic86 for Sound related method, auto comma delay and fixed choice bug
  ThallionDarkshine for Animated Letter
  
=end

#==============================================================================
# Settings
#==============================================================================

  # Zer0 Edit. Blizzard's Simple Shaded Text just looks kinda funny when used
  # on black text (which is default for MMS). If you are using Shaded Text and
  # do not want it to display for the message windows, set this to true. It will
  # still show for everything else.
  
  Blizzard_Shaded_Text_Fix = true
  
  #----------------------------------------------------------------------------
  # Windowskins
  #----------------------------------------------------------------------------
  # Note: all files must be in the Graphics/Windowskins/ folder
  # Tip: tails don't look right on windowskins with gradient backgrounds
  
  # filenames of tail and windowskin used for speech balloons
  FILENAME_SPEECH_TAIL = "maintail.png"
  FILENAME_SPEECH_WINDOWSKIN = "mainskin.png"

  # filenames of tail and windowskin used for thought balloons
  FILENAME_THOUGHT_TAIL = "dottail.png"
  FILENAME_THOUGHT_WINDOWSKIN = "mainskin.png" 
  #----------------------------------------------------------------------------
  # MESSAGE LOG
  #----------------------------------------------------------------------------
  # this will used for message log
  MESSAGE_LOG_TEXT            = 'MESSAGE LOG'
  MESSAGE_LOG_FONT            = [$defaultfont, "PlopDump", 30]
  MESSAGE_LOG_WINDOWSKIN      = "mainskin.png" 
  MESSAGE_LOG_OPACITY         = 255
  #----------------------------------------------------------------------------
  # Fonts
  #----------------------------------------------------------------------------
  # Note: if floating or resize (i.e. "speech balloons") are disabled,
  # Font.default_name, Font.default_size and Font.default_color are used
  # (you can change these in Main)
  # During gameplay, you can use message.font_name etc to override all defaults
  
  # defaults for speech text
  SPEECH_FONT_COLOR = "#FFFFFF"
  SPEECH_FONT_NAME = $defaultfont
  SPEECH_FONT_SIZE = 20
  

  
  # defaults for thought text
  THOUGHT_FONT_COLOR = "#EEEEEE"
  THOUGHT_FONT_NAME = $defaultfont
  THOUGHT_FONT_SIZE = 20

  # note that you can use an array of fonts for SPEECH_FONT_NAME, etc.
  # e.g. ['Komika Slim', 'Arial']
  # (if Verdana is not available, MS PGothic will be used instead)
  
  #----------------------------------------------------------------------------
  # Misc
  #----------------------------------------------------------------------------
  # If using a specialty windowskin (e.g. the default thought balloon one),
  # you can force the window width to always be a multiple of the number
  # specified in this constant (even when using the resize feature).
  # This allows, for example, the windowskin frame to be designed to
  # repeat every 16 pixels so that the frame never looks cut off.
  THOUGHT_WIDTH_MULTIPLE = 16
  # (set to 0 if you're not using any such windowskins)

class Game_Message

  # Any of the below can be changed by a Call Script event during gameplay.
  # E.g. turn letter-by-letter mode off with: message.letter_by_letter = false
  
  attr_accessor :speech_windowskin 
  attr_accessor :thought_windowskin
  attr_accessor :message_log
  attr_accessor :move_during
  attr_accessor :letter_by_letter
  attr_accessor :text_speed
  attr_accessor :skippable
  attr_accessor :resize
  attr_accessor :floating
  attr_accessor :autocenter
  attr_accessor :show_tail
  attr_accessor :show_pause
  attr_accessor :location
  attr_accessor :font_name
  attr_accessor :font_size
  attr_accessor :font_color
  attr_accessor :auto_shrink
  attr_accessor :opacity
  attr_accessor :auto_comma_pause
  attr_accessor :auto_comma_delay
  attr_accessor :allow_cancel_numbers
  
  attr_accessor :sound            
  attr_accessor :sound_audio 
  attr_accessor :sound_volume 
  attr_accessor :sound_pitch 
  attr_accessor :sound_pitch_range 
  attr_accessor :sound_vary_pitch 
  attr_accessor :sound_frequency   
  attr_accessor :shortcut  
  attr_accessor :auto_ff_reset 
  attr_accessor :cinema 
  attr_accessor :cinema_z
  attr_accessor :reposition_on_turn
  attr_accessor :allow_offscreen
  attr_accessor :dist_exit 
  attr_accessor :dist_max
  
  def default_setting
    # change windowskin at message 
    @speech_windowskin  = [FILENAME_SPEECH_WINDOWSKIN,  FILENAME_SPEECH_TAIL ]
    @thought_windowskin = [FILENAME_THOUGHT_WINDOWSKIN, FILENAME_THOUGHT_TAIL]
    
    # enable/disable message log
    @message_log = true
  
    # whether or not messages appear one letter at a time
    @letter_by_letter = true
    # note: can also change within a single message with \L

    # the default speed at which text appears in letter-by-letter mode
    @text_speed = 1
    # note: can also change within a single message with \S[n]
    
    # whether or not players can skip to the end of (letter-by-letter) messages
    @skippable = true
    
    # whether or not messages are automatically resized based on the message
    @resize = true
    
    # whether or not message windows are positioned above
    # characters/events by default, i.e. without needing \P every message
    # (only works if resize messages enabled -- otherwise would look very odd)
    @floating = false
    
    # whether or not to automatically center lines within the message
    @autocenter = false
    
    # whether or not event-positioned messages have a tail(for speech balloons)
    # (only works if floating and resized messages enabled -- otherwise would
    # look very odd indeed)
    @show_tail = false
    
    # whether or not to display "waiting for user input" pause graphic 
    # (probably want this disabled for speech balloons)
    @show_pause = true

    # whether the player is permitted to move while messages are displayed
    @move_during = false
    
    # the default location for floating messages (relative to the event)
    # note that an off-screen message will be "flipped" automatically
    @location = TOP
    
    # font details
    # overrides all defaults; leave nil to just use defaults (e.g. as above)
    @font_name = nil
    @font_size = nil
    @font_color = nil
    
    # auto shrink (buggy)
    @auto_shrink = false
    
    # message opacity, insert 0-255
    @opacity = 255
    
    
    # pause on these characters ,.?!
    # pause for delay number of frames if this is true, toggle with \A in Text
    @auto_comma_pause = true
    # inserts this number of frames to ,!.? characters, nil for off    
    @auto_comma_delay = 10
    
    # designers can allow or disallow choices, why not number windows too?
    @allow_cancel_numbers = false
    
    # Sounds While Speaking Related
    @sound = true                       # Enables or Disables Text Sounds  
    @sound_audio = 'coda'          # Audio SE (in DB) to play
    @sound_volume = 80                     # Text Sound Volume
    @sound_pitch = 100                      # Text Sound Pitch
    @sound_pitch_range = 10                # How Much to vary the Pitch
    @sound_vary_pitch = true               # Whether to Vary the Pitch or not
    @sound_frequency = 3                   # Plays a sound this many letters
    
    # reset foot_forward stance on auto-close due to Event going off-screen
    @auto_ff_reset = true
    
    # For shortcut reference
    @shortcut = { 
       :A => 'This is for shortcut purposes',
       :Wdyt => 'What do you think?',
    }
    
    @cinema = false # Cinema movie flag (don't change it)
    @cinema_z = 900 # Screen z for cinema movie mode
    
    # reposition the message window if the speaker turns
    @reposition_on_turn = true
    @allow_offscreen = false
    
    # exit if distance from speaker is too great
    @dist_exit = true
    # distance player can be before window closes
    @dist_max = 4
  end
  
#==============================================================================
# Private constants (don't edit)
#==============================================================================

  # used for message.location
  TOP    = 8
  BOTTOM = 2
  LEFT   = 4
  RIGHT  = 6
  
end
#==============================================================================
# ? SG::Skin
#==============================================================================

class Skin_Windowskin
  #--------------------------------------------------------------------------
  # ? instances settings
  #--------------------------------------------------------------------------
  attr_accessor  :margin, :bitmap
  #--------------------------------------------------------------------------
  # ? initialize
  #--------------------------------------------------------------------------
  def initialize
    @bitmap = nil
    @values = {}
    @values['bg'] = Rect.new(0, 0, 128, 128)
    @values['pause0'] = Rect.new(160, 64, 16, 16)
    @values['pause1'] = Rect.new(176, 64, 16, 16)
    @values['pause2'] = Rect.new(160, 80, 16, 16)
    @values['pause3'] = Rect.new(176, 80, 16, 16)
    @values['arrow_up'] = Rect.new(152, 16, 16, 8)
    @values['arrow_down'] = Rect.new(152, 40, 16, 8)
    @values['arrow_left'] = Rect.new(144, 24, 8, 16)
    @values['arrow_right'] = Rect.new(168, 24, 8, 16)
    self.margin = 16
  end
  #--------------------------------------------------------------------------
  # ? width
  #--------------------------------------------------------------------------
  def margin=(width)
    @margin = width
    set_values
  end
  #--------------------------------------------------------------------------
  # ? set_values
  #--------------------------------------------------------------------------
  def set_values
    w = @margin
    @values['ul_corner'] = Rect.new(128, 0, w, w)
    @values['ur_corner'] = Rect.new(192-w, 0, w, w)
    @values['dl_corner'] = Rect.new(128, 64-w, w, w)
    @values['dr_corner'] = Rect.new(192-w, 64-w, w, w)
    @values['up'] = Rect.new(128+w, 0, (64-2*w), w)
    @values['down'] = Rect.new(128+w, 64-w, (64-2*w), w)
    @values['left'] = Rect.new(128, w, w, (64-2*w))
    @values['right'] = Rect.new(192-w, w, w, (64-2*w))
  end
  #--------------------------------------------------------------------------
  # ? []
  #--------------------------------------------------------------------------
  def [](value) @values[value] end
end

#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================
class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #-------------------------------------------------------------------------- 
  attr_accessor :choice_window, :event_id
  # Characters that produce Text Sounds - a to z and 0 thru 9
  CHARACTERS = [('a'..'z'),('0'..'9')].map{|i| i.to_a}.flatten
  #--------------------------------------------------------------------------
  # * Initialize
  #-------------------------------------------------------------------------- 
  def initialize(msgindex=0) 
    super(80, 304, 480, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = false
    self.z = 1000 + msgindex * 10 # permits messages to overlap legibly
    $game_system.update if !$game_system.message
    message_eval('message.default_setting if !message.text_speed')
    @fade_in = @fade_out = @contents_showing = false
    @cursor_width = 0
    self.active = false
    self.index = -1
    @msgindex = msgindex
    @tail = Sprite.new
    create_bitmap_tail
    # make origin the center, not top left corner
    @tail.ox = @tail.bitmap.width/2
    @tail.oy = @tail.bitmap.height/2
    @tail.z = self.z + 10
    @tail.visible = false
    create_bitmap_windowskin
    refresh_font
    @update_text = true
    @letter_by_letter = $game_system.message.letter_by_letter
    @text_speed       = $game_system.message.text_speed
    # id of character for speech balloons
    @float_id = nil
    # location of box relative to speaker
    @location         = $game_system.message.location
    @auto_ff_reset    = $game_system.message.auto_ff_reset 
    @fwindowskin      = Sprite.new
    @fwindowskin.bitmap = Bitmap.new(640,480)
  end
  #--------------------------------------------------------------------------
  # * create_bitmap_tail
  #-------------------------------------------------------------------------- 
  def create_bitmap_tail
    @tail.bitmap = if @speech_windowskin && @speech_windowskin.is_a?(Array) &&
      FileTest.exist?('Graphics/Windowskins/'+@speech_windowskin[1])
        if @msgindex == 0
          RPG::Cache.windowskin(@speech_windowskin[1])
        else
          # don't use cached version or else all tails
          # are rotated when multiple are visible at once
          Bitmap.new('Graphics/Windowskins/'+@speech_windowskin[1])
        end
      else
        RPG::Cache.windowskin('')
      end
    # keep track of orientation of tail bitmap
    @tail.bitmap.orientation = 0 if @tail.bitmap.orientation == nil
  end
  #--------------------------------------------------------------------------
  # * create_bitmap_windowskin
  #-------------------------------------------------------------------------- 
  def create_bitmap_windowskin
    @windowskin = if $game_system.message.floating && @speech_windowskin &&
        $game_system.message.resize &&  @speech_windowskin.is_a?(Array) &&
         FileTest.exist?('Graphics/Windowskins/'+@speech_windowskin[0])
        @speech_windowskin[0]
      else
        # use windowskin specified in database
        $game_system.windowskin_name
      end
  end
  #--------------------------------------------------------------------------
  # * refresh font
  #-------------------------------------------------------------------------- 
  def refresh_font
    if $game_system.message.floating && $game_system.message.resize
      # if used as speech balloons, use constants
      @font_name  = ($game_system.message.font_name || SPEECH_FONT_NAME)
      @font_size  = ($game_system.message.font_size || SPEECH_FONT_SIZE)
      @font_color = check_color(($game_system.message.font_color ||
                    SPEECH_FONT_COLOR))
    else
      # use default font
      @font_name  = $defaultfonttype
      @font_size  = $defaultfontsize
      @font_color = Font.default_color
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #-------------------------------------------------------------------------- 
  def dispose
    terminate_message
    # have to check all windows before claiming that no window is showing
    if $game_temp.message_text.compact.empty?
      $game_temp.message_window_showing = false
    end
    @fwindowskin.dispose if !@fwindowskin.disposed?
    @input_number_window.dispose if @input_number_window != nil
    super
  end
  #--------------------------------------------------------------------------
  # * Terminate Message
  #-------------------------------------------------------------------------- 
  def terminate_message
    return if $game_temp.input_in_window
    self.active = false
    self.pause = false
    self.index = -1
    self.contents.clear
    @fwindowskin.bitmap.clear if @fwindowskin && !@fwindowskin.disposed?
    # Clear showing flag
    @contents_showing = false
    # Clear variables related to text, choices, and number input
    @tail.visible = false
    # note that these variables are now indexed arrays
    $game_temp.message_text = [] if !$game_temp.message_text.is_a?(Array)
    $game_temp.message_proc = [] if !$game_temp.message_proc.is_a?(Array)
    $game_temp.message_text[@msgindex] = nil
    # Call message callback
    if $game_temp.message_proc[@msgindex] != nil
      # make sure no message boxes are displaying
      if $game_temp.message_text.compact.empty?
        $game_temp.message_proc[@msgindex].call
        message_interpreter.class.send(:attr_accessor,:message_waiting)
        #message_interpreter.class.send(:attr_accessor,:wait_count)
        #message_interpreter.wait_count += 2
        $game_temp.message_window_showing = false  
        message_interpreter.message_waiting = false
      end
      $game_temp.message_proc[@msgindex] = nil
    end
    @update_text = true
    $game_temp.choice_start = 99
    $game_temp.choice_max = 0
    $game_temp.choice_cancel_type = 0
    $game_temp.choice_proc = nil
    $game_temp.num_input_start = 99
    $game_temp.num_input_variable_id = 0
    $game_temp.num_input_digits_max = 0
    # Open gold window
    if @gold_window != nil
      @gold_window.dispose
      @gold_window = nil
    end
  end 
  #--------------------------------------------------------------------------
  # * replace_basic_code
  #-------------------------------------------------------------------------- 
  def replace_basic_code
    # Change "\\\\" to "\000" for convenience
    @text.gsub!(/\\\\/) { "\000" }
    @text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
    @text.gsub!('\$') { $game_party.gold.to_s }
    @text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
       $game_actors[$1.to_i] ? $game_actors[$1.to_i].name : ''
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias Listing
  #-------------------------------------------------------------------------- 
  $@ || alias_method(:replace_basic_code_addition, :replace_basic_code)
  #--------------------------------------------------------------------------
  # * replace_basic_code
  #-------------------------------------------------------------------------- 
  def replace_basic_code
    @text.gsub!(/\\[Nn][Aa][Mm][Ee]\[([0-9]+)\]/) {  "\\n[#{$1}]" }
    replace_basic_code_addition
    @text.gsub!(/\\[Gg]/) { "\002" }
    # display icon of item, weapon, armor or skill
    @text.gsub!(/\\[Ii]\[([IiWwAaSs][0-9]+)\]/) { "\013[#{$1}]" }
    # display name of enemy, item, weapon, armor or skill
    @text.gsub!(/\\[Nn]\[([EeIiWwAaSsPp])([0-9]+)\]/) {
      entity = case $1.downcase
        when 'e' then $data_enemies[$2.to_i]
        when 'i' then $data_items[$2.to_i]
        when 'w' then $data_weapons[$2.to_i]
        when 'a' then $data_armors[$2.to_i]
        when 's' then $data_skills[$2.to_i]
        when 'p' then $game_map.events[$2.to_i]
      end
      entity != nil ? entity.name : ''   }
    # display icon and name of item, weapon, armor or skill
    @text.gsub!(/\\[Ii]&[Nn]\[([IiWwAaSs])([0-9]+)\]/) {
      entity = case $1.downcase
        when 'e' then $data_enemies[$2.to_i]
        when 'i' then $data_items[$2.to_i]
        when 'w' then $data_weapons[$2.to_i]
        when 'a' then $data_armors[$2.to_i]
        when 's' then $data_skills[$2.to_i]
      end
      entity != nil ? "\013[#{$1+$2}] " + entity.name : ''  }      
    # display name of current map
    @text.gsub!(/\\[Mm][Aa][Pp]/) { $game_map.name }
    # change font color
    @text.gsub!(/\\[Cc]\[([0-9]+|#[0-9A-Fa-f]{6,6})\]/) { "\001[#{$1}]" }
    # return to default color
    @text.gsub!(/\\[Cc]/) { "\001" }
    # toggle letter-by-letter mode
    @text.gsub!(/\\[Ll]/) { "\003" }
    # change text speed (for letter-by-letter)
    @text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\004[#{$1}]" }
    # insert delay
    @text.gsub!(/\\[Dd]\[([0-9]+)\]/) { "\005[#{$1}]" }      
    # change z
    @text.gsub!(/\\[Zz]\[([0-9]+)\]/) { "\024[#{$1}]" }      
    
    
    # self close message
    @text.gsub!(/\\[!]/) { "\006" }
    # wait for button input
    @text.gsub!(/\\[?]/) { "\007" }
    # bold
    @text.gsub!(/\\[Bb]/) { "\010" }
    # italic
    @text.gsub!(/\\[Ii]/) { "\011" }
    # new line
    @text.gsub!(/\\[n]/) { "\n" }
    # name
    @text.gsub!(/\\[Ff][Oo][Nn][Tt]\[(.+?),([0-9]+)\]/) { "\023[#{$1},#{$2}]" }
    @text.gsub!(/\\[Ff]\+/) { "\020" }
    @text.gsub!(/\\[Ff]\-/) { "\021" }      
    @text.gsub!(/\\[Ff]\*/) { "\022" }        
    @text.gsub!(/\\[Ff]\[(.+?)(?:,(\d+))?\]/) { "\014[#{$1}]" }
    @text.gsub!(/\\[Aa]\[([0-9]+),([0-9]+)\]/) { "\015[#{$1},#{$2}]" }
    @text.gsub!(/\\[Aa]\[(.+?)(?:(\d+))?\]/) { "\016[#{$1}]" } #name
    @text.gsub!(/\\[Rr]\[(.+?)\]/) { "\017[#{$1}]" }
    # insert delays for commas, periods, questions and exclamations
    @text.gsub!(/, /) { ", \017[#d]" }    # Comma with One Space
    @text.gsub!(/!  /) { "!  \017[#d]" }  # Exclamation Point with Two Spaces
    @text.gsub!(/\?  /) { "?  \017[#d]"} # Question Mark with Two Spaces
    @text.gsub!(/\.  /) { ".  \017[#d]" } # Period with Two Spaces
    @text.gsub!(/\\[.]/) { "\017[#d]" }    # the \. command (New!!)
    
    @text.gsub!(/\\[*]/, '<!@multi_message, @message_waiting = true, false>')
    @text.gsub!(/\\[Mm][Oo][Vv]/) { '<!message.cinema = !message.cinema>' }
    @text.gsub!(/\\[Dd][Ii][Ss][Tt]\[([0-9]+)\]/) { "<@@dist = #{$1}>" } 
    @text.gsub!(/[<][!](.+?)[>]/) { "\017[#si#{$1}]" }
    @text.gsub!(/[<][@](.+?)[>]/) { "\017[#ss#{$1}]" }
  end
  #--------------------------------------------------------------------------
  # * replace_technical_code
  #-------------------------------------------------------------------------- 
  def replace_technical_code
    if @text.gsub!(/\\[Ee]\[([0-9]+),([0-9]+)\]/, '') != nil
      @float_id = $1.to_i
      @location = case $2.to_i
        when 1..2 then 2
        when 3..4 then 4
        when 5..6 then 6
        else 8
      end
    end
    # thought balloon
    if @text.gsub!(/\\[@]/, '') != nil
      @windowskin = @thought_windowskin && @thought_windowskin.is_a?(Array) && 
          FileTest.exist?('Graphics/Windowskins/'+@thought_windowskin[0]) ?
          @thought_windowskin[0] : $game_system.windowskin_name
      @font_name = THOUGHT_FONT_NAME
      @font_size = THOUGHT_FONT_SIZE
      @font_color = check_color(THOUGHT_FONT_COLOR)
      @tail.bitmap = if @thought_windowskin && 
        @thought_windowskin.is_a?(Array) &&
        FileTest.exist?('Graphics/Windowskins/'+@thought_windowskin[1])
          if @msgindex == 0
            RPG::Cache.windowskin(@thought_windowskin[1])
          else
            Bitmap.new('Graphics/Windowskins/'+@thought_windowskin[1])
          end
        else
          RPG::Cache.windowskin('')
        end
      @tail.bitmap.orientation ||= 0 
    end
    # Get rid of "\\+" (multiple messages)
    @text.gsub!(/\\[+]/, '')
    @text.gsub!(/\\[#]/, '')
    # Get rid of "\\P" (position window to given character)
    if @text.gsub!(/\\[Pp]\[([0-9]+),([0-9]+)\]/, '') != nil
      @float_id = [$1.to_i,$2.to_i]
    elsif @text.gsub!(/\\[Pp]\[([0-9]+)\]/, '') != nil
      @float_id = $1.to_i
    elsif @text.gsub!(/\\[Pp]\[([a-zA-Z])\]/, '') != nil &&
        $game_temp.in_battle
      @float_id = $1.downcase
    elsif @text.gsub!(/\\[Pp]/, '') != nil ||
      ($game_system.message.floating && $game_system.message.resize) &&
      (!$game_temp.in_battle)
      message_interpreter.class.send(:attr_reader, :event_id)
      @float_id = message_interpreter.event_id
    end
    
    # Get rid of "\\^", "\\v", "\\<", "\\>" (relative message location)
    if @text.gsub!(/\\\^/, '') != nil
      @location = 8
    elsif @text.gsub!(/\\[Vv]/, '') != nil
      @location = 2
    elsif @text.gsub!(/\\[<]/, '') != nil
      @location = 4
    elsif @text.gsub!(/\\[>]/, '') != nil
      @location = 6
    elsif @text.gsub!(/\\[%]/, '') != nil && !$game_temp.in_battle    
      e = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
      @auto_orient = 1    
      @location = case e.direction
      when 8 then 2
      when 2 then 8
      when 6 then 4
      when 4 then 6
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #-------------------------------------------------------------------------- 
  def refresh
    self.contents.clear
    @fwindowskin.bitmap.clear if @fwindowskin && !@fwindowskin.disposed? 
    @x = @y = 0 # now instance variables
    @float_id = nil
    @location = $game_system.message.location
    @speech_windowskin  = $game_system.message.speech_windowskin
    @thought_windowskin = $game_system.message.thought_windowskin
    refresh_font
    # override font defaults
    @line_widths = nil
    @wait_for_input = false
    create_bitmap_windowskin
    create_bitmap_tail
    @dist_exit = $game_system.message.dist_exit
    @dist_max = $game_system.message.dist_max
    @text_speed = $game_system.message.text_speed
    @letter_by_letter = $game_system.message.letter_by_letter
    @delay = @text_speed
    @player_skip = false
    @cursor_width = 0
    # Indent if choice
    if $game_temp.choice_start == 0
      @x = 8
    end
    # If waiting for a message to be displayed
    if $game_temp.message_text[@msgindex] != nil
      @text = $game_temp.message_text[@msgindex] # now an instance variable
      # Control text processing
      begin
        last_text = @text.clone
        @text.gsub!(/\[:(.+?)\]/) { $game_system.message.shortcut[$1.to_sym] }
        @text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until @text == last_text      
      replace_basic_code
      replace_technical_code
      ufmt = @text.clone
      ufmt.gsub!(/[\001-\007](\[[#A-Fa-f0-9]+\])?/, '')
      ufmt.gsub!(/\013\[(.+?)\]/, '\013')
      ufmt.gsub!(/[\014-\017](\[(.+?)(?:(\d+))?\])?/, '')
      ufmt.gsub!(/\016\[(.+?),(.+?)\]/, '')
      ufmt.gsub!(/[\020-\025]\[(.+?),([0-9]+)\]?/, '')
      @text.gsub!(/\\[Aa][Nn][Ii](?:\[([0-9]+)\])?/, '')
      if $game_system.message.resize || $game_system.message.autocenter
        # calculate length of lines
        text = ufmt.clone
        temp_bitmap = Bitmap.new(1,1)
        temp_bitmap.font.name = @font_name
        temp_bitmap.font.size = @font_size
        @linerenew = false 
        @line_widths = [0,0,0,0,0,0,0,0]
        #(0..@line_widths.size-1).each  do |i|
        @line_widths.each_with_index  do |a,i|
          line = text.split(/\n/)[@line_widths.size-1-i]
          next if line.nil?
          line.gsub!(/\\[Aa][Nn][Ii](?:\[([0-9]+)\])?/, '')
          line.chomp.split(//).each do |c|
            case c
            when "\000" 
              c = "\\"
            when "\010"
              # bold
              temp_bitmap.font.bold = !temp_bitmap.font.bold
              next
            when "\011"
              # italics
              temp_bitmap.font.italic = !temp_bitmap.font.italic
              next
            when "\013"
              # icon
              @line_widths[@line_widths.size-1-i] += 24
              next
            end
            @line_widths[@line_widths.size-1-i] += temp_bitmap.text_size(c).width
          end
          if (@line_widths.size-1-i) >= $game_temp.choice_start
            # account for indenting
            @line_widths[@line_widths.size-1-i] += 8 unless $game_system.message.autocenter
          end
        end
        if $game_temp.num_input_variable_id > 0
          # determine cursor_width as in Window_InputNumber
          # (can't get from @input_number_window because it doesn't exist yet)
          cursor_width = temp_bitmap.text_size('0').width + 8
          # use this width to calculate line width (+8 for indent)
          input_number_width = cursor_width*$game_temp.num_input_digits_max
          input_number_width += 8 unless $game_system.message.autocenter
          @line_widths[$game_temp.num_input_start] = input_number_width
        end
        temp_bitmap.dispose
      end
      resize
      @float_id && reposition
      self.contents.font.name = @font_name
      self.contents.font.size = @font_size
      self.contents.font.color = @font_color
      self.windowskin = RPG::Cache.windowskin(@windowskin)
      # autocenter first line if enabled
      # (subsequent lines are done as '\n' is encountered)
      if $game_system.message.autocenter && @text != ''
        @x = (self.width-40)/2 - @line_widths[0]/2
      end
      @animations && @animations.each { |ani|
        ani.disposed? ||  [ani.bitmap.dispose, ani.dispose]
      } 
      @letter_animations && @letter_animations.each { |ani| ani.dispose } 
      @animations, @letter_animations = [], []
      temp_bitmap = Bitmap.new(1,1)
      temp_bitmap.font.name = @font_name
      temp_bitmap.font.size = @font_size
      animation = [0, []]
      lanimation = [0, []]
      x, y = 0, 0
      center = $game_system.message.autocenter
      if (center && x == (self.width-40)/2 - @line_widths[0]/2)  ||
         (!center && x == 0)
         x = center ? ((self.width-40)/2 - @line_widths[0]/2) : 0
      end
      # Update cursor width if choice
      if $game_temp.choice_start == 0
        width = $game_system.message.autocenter ? @line_widths[y]+8 : x
      end
      ufmt.gsub!(/\\[Aa][Nn][Ii]/) { "\001" }
      if $game_system.message.autocenter && ufmt != ''
        x = (self.width-40)/2 - @line_widths[y]/2 if @line_widths[y]
      else
        x = 0
        # Indent if choice
        x = 8 if $game_temp.choice_start == 0
      end
      while ((c = ufmt.slice!(/./m)) != nil)
        case c
        when "\000"
          c = "\\"
        when "\010"
          temp_bitmap.font.bold = !temp_bitmap.font.bold
          next
        when "\011"
          temp_bitmap.font.italic = !temp_bitmap.font.italic
          next
        when "\001"
          if animation[0] != 0
            animation[1][-1].width = x + 4 - animation[1][-1].x
            @animations.push(animation)
          elsif lanimation[0] != 0
            @letter_animations.push(lanimation)
          end
          animation = [0, []]
          lanimation = [0, []]
          if ufmt.index(/\[(\d+)\]/) == 0
            ufmt.sub!(/\[(\d+)\]/, '')
            type = $1.to_i
            if type == 0
              animation[1] = []
            elsif type <= 8
              animation[0] = $1.to_i
              animation[1].push(Rect.new(4 + x, 32 * y, 0, 32))
            else
              lanimation[0] = $1.to_i - 8
            end
          else
            animation[0] = 0
            lanimation[0] = 0
          end
          next
        when "\n"
          if animation[0] != 0
            animation[1][-1].width = x + 4 - animation[1][-1].x
          end
          center = $game_system.message.autocenter
          if (center && x == (self.width-40)/2 - @line_widths[y]/2)  ||
             (!center && x == 0)
             x = center ? ((self.width-40)/2 - @line_widths[y]/2) : 0
          end
          # Update cursor width if choice
          if y >= $game_temp.choice_start
            width = $game_system.message.autocenter ? @line_widths[y]+8 : x
          end
          # Add 1 to y
          y += 1
          if $game_system.message.autocenter && ufmt != ''
            x = (self.width-40)/2 - @line_widths[y]/2 if @line_widths[y]
          else
            x = 0
            # Indent if choice
            x = 8 if y >= $game_temp.choice_start
          end
          if animation[0] != 0
            animation[1].push(Rect.new(x + 4, y * 32, 0, 32))
          end
          # go to next text
          next
        end
        size = contents.text_size(c)
        if lanimation[0] != 0
          lanimation[1].push(Rect.new(x + 4, y * 32, size.width, 32))
        end
        x += size.width
      end
      if animation[0] != 0
        animation[1][-1].width = x + 4 - animation[1][-1].x
        @animations.push(animation)
      elsif lanimation[0] != 0
        @letter_animations.push(lanimation)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Resize Window
  #-------------------------------------------------------------------------- 
  def resize
    if !$game_system.message.resize
      # reset to defaults
      self.width = 480
      self.height = 160
      self.contents = Bitmap.new(width - 32, height - 32)
      self.x = 80 # undo any centering
      return
    end
    max_x = @line_widths.max
    max_y = 8
    @line_widths.each {|line| max_y -= 1 if line == 0 && max_y > 1}
    if $game_temp.choice_max  > 0
      # account for indenting
      max_x += 8 unless $game_system.message.autocenter
    end
    new_width = max_x + 40
    t = @thought_windowskin && @thought_windowskin.is_a?(Array)
    if t && @windowskin == @thought_windowskin[0] && THOUGHT_WIDTH_MULTIPLE >0
      # force window width to be a multiple of THOUGHT_WIDTH_MULTIPLE
      # so that specialty windowskins (e.g. thought balloon) look right
      if new_width % THOUGHT_WIDTH_MULTIPLE != 0
        new_width += THOUGHT_WIDTH_MULTIPLE-(new_width%THOUGHT_WIDTH_MULTIPLE)
      end
    end
    self.width = new_width
    new_height = max_y * 32 + 32
    self.height = $game_system.message.auto_shrink ? 1 * 32 + 32 : new_height    
    self.contents = Bitmap.new(width - 32, new_height - 32)
    self.x = 320 - (self.width/2) # center
  end
  #--------------------------------------------------------------------------
  # * Reposition Window
  #-------------------------------------------------------------------------- 
  def reposition
    if @float_id.is_a?(Array)
      char_height = 1
      char_width = 1
      char_x = @float_id[0]
      char_y = @float_id[1]
    elsif $game_temp.in_battle 
      if 'abcde'.include?(@float_id) # must be between a and d
        @float_id = @float_id[0] - 97 # a = 0, b = 1, c = 2, d = 3
        return if $scene.spriteset.actor_sprites[@float_id] == nil
        sprite = $scene.spriteset.actor_sprites[@float_id]
      else
        @float_id -= 1 # account for, e.g., player entering 1 for index 0
        return if $scene.spriteset.enemy_sprites[@float_id] == nil
        sprite = $scene.spriteset.enemy_sprites[@float_id]
      end
            if sprite.frame_height != nil #ATOA COMPATIBLE!!!!
        char_height = sprite.frame_height
        char_width = sprite.frame_width
        char_x = sprite.x
        char_y = sprite.y - char_height/2
      else
        return
      end
  
=begin  
      char_height = sprite.height
      char_width = sprite.width
      char_x = sprite.x
      char_y = sprite.y - char_height/2
=end    
    else # not in battle...
      char = (@float_id == 0 ? $game_player : $game_map.events[@float_id])
      if char == nil
        # no such character
        @float_id = nil
        return 
      end
      # close message (and stop event processing) if speaker is off-screen
      if speaker_offscreen(char) ||  
        ($game_system.message.allow_offscreen && !$game_temp.in_battle &&
        (self.height - self.y > 480 || self.height + self.y < 0 ||
          self.width - self.x > 640 || self.width + self.x < 0)) ||
         ($game_system.message.move_during &&  @dist_exit && 
           @float_id > 0 && !char.within_range?(@dist_max, @float_id) && 
           @float_id == @event_id )
        terminate_message
        message_interpreter.command_115
        if !@fwindowskin.nil? && !@fwindowskin.disposed?
          @fwindowskin.visible = false
          @fwindowskin.bitmap.dispose if !@fwindowskin.bitmap.disposed?
          @fwindowskin.dispose 
          @fwindowskin = nil
        end
        char.foot_forward_off  if @auto_ff_reset && !char.no_ff
        @auto_ff_reset = false
        return
      end
      if char.character_name =~ /[8]/i
        char_height = RPG::Cache.character(char.character_name,0).height / 8
      else
        char_height = RPG::Cache.character(char.character_name,0).height / 4
      end
      if char.character_name =~ /[s]/i
        char_width = RPG::Cache.character(char.character_name,0).width / 8
      else
        char_width = RPG::Cache.character(char.character_name,0).width / 4
      end
      # record coords of character's center
      char_x = record_screen_xy(char)[0]
      char_y = record_screen_xy(char)[1] - char_height/2
    end
    params = [char_height, char_width, char_x, char_y]
    # position window and message tail
    vars = new_position(params)
    x,y = vars[0], vars[1]
    # check if any window locations need to be 'flipped'
    offsc = (!$game_system.message.allow_offscreen || $game_temp.in_battle)
    flip = need_flip?(@float_id, @location, x, y, params)
    loc4 = ((x < 0 && !@face) || (x < 90 && @face)) && offsc
    if @location == 4 && (loc4 || flip)
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 6)
      else  # switch to right
        @location = 6
      end
      vars = new_position(params)
      x = vars[0]
      if (x + self.width) > 640 && offsc
        # right is no good either...
        if y >= 0
          # switch to top
          @location = 8
          vars = new_position(params)
        else
          # switch to bottom
          @location = 2
          vars = new_position(params)
        end
      end
    elsif @location == 6 && (((x + self.width) > 640 && offsc) || flip)
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 4)
      else     # switch to left
        @location = 4
      end
      vars = new_position(params)
      x = vars[0]
      if x < 0 && offsc
        # left is no good either...
        if y >= 0
          # switch to top
          @location = 8
          vars = new_position(params)
        else
          # switch to bottom
          @location = 2
          vars = new_position(params)
        end
      end
    elsif @location == 8 && ((y < 0 && offsc) || flip)
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 2)
      else     # switch to bottom
        @location = 2
      end
      vars = new_position(params)
      y = vars[1]
      if (y + self.height) > 480 && offsc
        # bottom is no good either...
        # note: this will probably never occur given only 3 lines of text
        x = vars[0]
        if x >= 0
          # switch to left
          @location = 4
          vars = new_position(params)
        else
          # switch to right
          @location = 6
          vars = new_position(params)
        end
      end
    elsif @location == 2 && (((y + self.height) > 480 && offsc) || flip)
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 8)
      else   # switch to top
        @location = 8
      end
      vars = new_position(params)
      y = vars[1]
      if y < 0 && offsc
        # top is no good either...
        # note: this will probably never occur given only 3 lines of text
        x = vars[0]
        if x >= 0
          # switch to left
          @location = 4
          vars = new_position(params)
        else
          # switch to right
          @location = 6
          vars = new_position(params)
        end
      end
    end
    x = vars[0]
    y = vars[1]
    tail_x = vars[2]
    tail_y = vars[3]    
    # adjust windows if near edge of screen
    if offsc
      if x < 0 && !@face
        x = 0
      elsif x < 90 && @face
        x = 90
      elsif (x + self.width) > 640
        x = 640 - self.width
      end
      if y < 0
        y = [y, 0].max
      elsif (y + self.height) > 480
        y = 480 - self.height
      elsif $game_temp.in_battle && @location == 2 && (y > (320 - self.height))
        # when in battle, prevent enemy messages from overlapping battle status
        # (note that it could still happen from actor messages, though)
        y = 320 - self.height
        tail_y = y
      end
    end
    # finalize positions
    self.x = x
    self.y = y
    @tail.x = tail_x
    @tail.y = tail_y
    v = case @location 
    when 2, 6 then -15
    when 4, 8 then -17
    end
    if @contents_showing  #!$game_temp.message_text.compact.empty?
      draw_window
      @fwindowskin.dispose if !@fwindowskin.nil? && !@fwindowskin.disposed?
      @fwindowskin = Sprite.new
      @fwindowskin.z = self.z - 10
      @fwindowskin.bitmap = Bitmap.new(640,480)
      @fwindowskin.bitmap.blt(x,y,@frame.bitmap,@frame.bitmap.rect)
      @fwindowskin.bitmap.blt(tail_x+v,tail_y+v,@tail.bitmap,
                 @tail.bitmap.rect) if show_message_tail?
      @fwindowskin.opacity = $game_system.message.opacity
      if @face && self.height > 64
        a = 80
        while a >= -10 
          @fwindowskin.bitmap.blt(@face.x+a,y,@frame.bitmap,
            Rect.new(0,0,@face.bitmap.width-45,@frame.bitmap.height))
          a = (a == 5) ? 15 : a - 25
        end
      end
      self.opacity = @tail.opacity = 0
      @frame.dispose
    end
    bit = @tail.bitmap
  end
  #--------------------------------------------------------------------------
  # Prevent Player from walking under Message Bubbles
  #--------------------------------------------------------------------------
  def need_flip?(event_id, loc, x, y, params = nil)
    return false if !@auto_orient || @fade_out ||  event_id.nil? || 
                    (event_id != 0 && $game_map.events[event_id].erased) ||
                    $game_temp.in_battle ||
                    !$game_system.message.reposition_on_turn ||
                    !$game_system.message.move_during
    # vars for speaker
    event = (event_id > 0) ? $game_map.events[event_id] : $game_player
    dir = event.direction
    # if an argument is passed called params and not allowed offscreen   
    if params and not $game_system.message.allow_offscreen
      case loc
        when 2 then new_loc = 8
        when 4 then new_loc = 6
        when 6 then new_loc = 4
        when 8 then new_loc = 2
      end
      # check what the new coordinates of a repositioned window will be  
      new_vars = new_position(params, new_loc, no_rotate = true)
      new_x = new_vars[0]
      new_y = new_vars[1]
      # return false if not allowed off screen and new position is off screen
      if (new_x < 0 && new_loc == 4) ||    (new_x + self.width > 640) ||
         (new_y < 0) ||    (new_y + self.height > 480)
        # if not allowed offscreen and trying to flip offscreen
        return false 
      end
    end
    # default result
    result = false
    result = true if @auto_orient == 2 &&  dir == loc 
    if @auto_orient == 1
      if event_id > 1
        # If Auto Orient Any Direction, try to put preference on top / bottom
        # Top / Bottom Preference was made for readability of Msgs
        # because it is easier to go off screen left and right
        if dir == loc ||  ((dir == 2 || dir == 8) && (loc == 4 || loc == 6))
          result = true
        end
      elsif event_id == 0 
        if ((dir == 2 && loc != 8) || (dir == 4 && loc != 6) ||
           (dir == 6 && loc != 4) ||  (dir == 8 && loc != 2))
          result = true
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # Place Message Bubble behind Speaker
  #--------------------------------------------------------------------------
  def put_behind(event_id, default_loc)
    return default_loc if event_id.nil? or $game_temp.in_battle
    dir = (event_id > 0 ) ? $game_map.events[event_id].direction : 
          $game_player.direction
    return 2 if dir == 8
    return 4 if dir == 6
    return 6 if dir == 4
    return 8 if dir == 2
    return default_loc
  end  
  #--------------------------------------------------------------------------
  # ? speaker_offscreen
  #--------------------------------------------------------------------------
  def speaker_offscreen(char)
    return record_screen_xy(char)[0] <= 0 || record_screen_xy(char)[0] >= 640 ||
           record_screen_xy(char)[1] <= 0 || record_screen_xy(char)[1] > 480
  end
  #--------------------------------------------------------------------------
  # ? record_screen_xy
  #--------------------------------------------------------------------------
  def record_screen_xy(char)
    return char.rev_scr_xy || [char.screen_x,char.screen_y]
  end
  #--------------------------------------------------------------------------
  # ? draw_window
  #--------------------------------------------------------------------------
  def draw_window(width = self.width, height = self.height,win = @windowskin )
    @skin = Skin_Windowskin.new
    @skin.bitmap = RPG::Cache.windowskin(win)
    @frame,@bg   = Sprite.new, Sprite.new()
    @width,@height = width, height
    return if @skin.bitmap == nil
    return if @width == 0 or @height == 0
    m = @skin.margin
    decrement = 2
    @frame.bitmap ||= Bitmap.new(@width, @height)
    @bg.bitmap    ||= Bitmap.new(@width-(decrement*2), @height-(decrement*2))
    @frame.bitmap.clear
    @bg.bitmap.clear
    dest_rect = Rect.new(0, 0, @width-(decrement*2), @height-(decrement*2))
    #dest_rect = Rect.new(0, 0, @width, @height)
    @bg.bitmap.stretch_blt(dest_rect, @skin.bitmap, @skin['bg'])
    bx = Integer((@width - m*2) / @skin['up'].width) + 1
    by = Integer((@height - m*2) / @skin['left'].height) + 1
    (0..bx).each { |x|
      w = @skin['up'].width
      @frame.bitmap.blt(x * w + m, 0, @skin.bitmap, @skin['up'])
      @frame.bitmap.blt(x * w + m, @height - m, @skin.bitmap, @skin['down'])}
    @frame.bitmap.stretch_blt(Rect.new(decrement, decrement, 
         @frame.bitmap.width-(decrement*2),
         @frame.bitmap.height-(decrement*2)), @bg.bitmap, @bg.bitmap.rect)
    (0..by).each { |y|
      h = @skin['left'].height
      @frame.bitmap.blt(0, y * h + m, @skin.bitmap, @skin['left'])
      @frame.bitmap.blt(@width - m, y * h + m, @skin.bitmap, @skin['right'])}
    @frame.bitmap.erase(@width - m, 0, m, m)
    @frame.bitmap.erase(0, @height - m, m, m)
    @frame.bitmap.erase(@width - m, @height - m, m, m)
    @frame.bitmap.stretch_blt(Rect.new(decrement, decrement, 
         @frame.bitmap.width-(decrement*2),
         @frame.bitmap.height-(decrement*2)), @bg.bitmap, @bg.bitmap.rect)
    @frame.bitmap.blt(0, 0, @skin.bitmap, @skin['ul_corner'])
    @frame.bitmap.blt(@width - m, 0, @skin.bitmap, @skin['ur_corner'])
    @frame.bitmap.blt(0, @height - m, @skin.bitmap, @skin['dl_corner'])
    @frame.bitmap.blt(@width - m, @height - m, @skin.bitmap, @skin['dr_corner'])
    @frame.bitmap.blt(@width - m, @height - m, @skin.bitmap, @skin['dr_corner'])
    @bg.dispose
  end
  #--------------------------------------------------------------------------
  # * Determine New Window Position
  #--------------------------------------------------------------------------  
  def new_position(params, location = @location, no_rotate = nil)
    char_height, char_width, char_x, char_y = params
    if location == 8
      # top
      x = char_x - self.width/2
      y = char_y - char_height/2 - self.height - @tail.bitmap.height/2
      @tail.bitmap.rotation(0)  unless no_rotate
      tail_x = x + self.width/2 
      tail_y = y + self.height
    elsif location == 2
      # bottom
      x = char_x - self.width/2
      y = char_y + char_height/2 + @tail.bitmap.height/2
      @tail.bitmap.rotation(180) unless no_rotate
      tail_x = x + self.width/2
      tail_y = y
    elsif location == 4
      # left
      x = char_x - char_width/2 - self.width - @tail.bitmap.width/2
      y = char_y - self.height/2
      @tail.bitmap.rotation(270) unless no_rotate
      tail_x = x + self.width
      tail_y = y + self.height/2
    elsif location == 6
      # right
      x = char_x + char_width/2 + @tail.bitmap.width/2
      y = char_y - self.height/2
      @tail.bitmap.rotation(90) unless no_rotate
      tail_x = x
      tail_y = y + self.height/2
    end
    return [x,y,tail_x,tail_y]
  end  
  #--------------------------------------------------------------------------
  # * eval_text
  #--------------------------------------------------------------------------
  def eval_text(bitmap)
    # If \\
    if @c == "\000"
      # Return to original text
      @c = "\\"
    end
    # If \C[n] or \C[#xxxxxx] or \C
    if @c == "\001"
      # Change text color
      @text.sub!(/\[([0-9]+|#[0-9A-Fa-f]{6,6})\]/, '')
      if $1 != nil
        bitmap.font.color = check_color($1)
      else
        # return to default color
        if $game_system.message.font_color != nil
          color = check_color($game_system.message.font_color)
        elsif $game_system.message.floating && $game_system.message.resize
          color = check_color(SPEECH_FONT_COLOR)
        else
          # use defaults
          color = Font.default_color
        end
        bitmap.font.color = color
      end
      # go to next text
      return 1 
    end
    # If \G
    if @c == "\002"
      # Make gold window
      if @gold_window == nil
        @gold_window = Window_Gold.new
        @gold_window.x = 560 - @gold_window.width
        if $game_temp.in_battle
          @gold_window.y = 192
        else
          @gold_window.y = self.y >= 128 ? 32 : 384
        end
        @gold_window.opacity = $game_system.message.opacity
        @gold_window.back_opacity = self.back_opacity
      end
      # go to next text
      return 1
    end
    # If \L
    if @c == "\003"
      # toggle letter-by-letter mode
      @letter_by_letter = !@letter_by_letter
      # go to next text
      return 1
    end
    # If \S[n]
    if @c == "\004"
      @text.sub!(/\[([0-9]+)\]/, '')
      speed = $1.to_i
      if speed >= 0
        @text_speed = speed
        # reset player skip after text speed change
        @player_skip = false            
      end
      return 0
    end
    # If \D[n]
    if @c == "\005"
      @text.sub!(/\[([0-9]+)\]/, '')
      delay = $1.to_i
      if delay >= 0
        @delay += delay
        # reset player skip after delay
        @player_skip = false
      end
      return 0
    end   
    # If \!
    if @c == "\006"
      # close message and return from method
      terminate_message
      return 0
    end
    # If \?
    if @c == "\007"
      @wait_for_input = true
      return 0
    end
    if @c == "\010"
      # bold
      bitmap.font.bold = !bitmap.font.bold
      return 0
    end
    if @c == "\023"
      # change font
      @text.sub!(/\[(.+?),([0-9]+)\]/,  '')
      bitmap.font.name = $1
      bitmap.font.size = $2.to_i
      return 0
    end
    if @c == "\011"
      # italics
      bitmap.font.italic = !bitmap.font.italic
      return 0
    end
    if @c == "\013"
      # display icon of item, weapon, armor or skill
      @text.sub!(/\[([IiWwAaSs])([0-9]+)\]/, '')
      return 0 if $1.nil?
      item = case $1.downcase
      when 'i' then $data_items[$2.to_i]
      when 'w' then $data_weapons[$2.to_i]
      when 'a' then $data_armors[$2.to_i]
      when 's' then $data_skills[$2.to_i]
      end
      if item == nil
        return 0
      end
      icon = RPG::Cache.icon(item.icon_name)
      bitmap.blt(4+@x, 32*@y+4, icon, Rect.new(0, 0, 24, 24))
      @x += 24
      #bitmap.draw_text(x + 28, y, 212, 32, item.name)
      return 0
    end
    if @c == "\014"
      @text.sub!(/\[(.+?)(?:,(\d+))?\]/, '')
      face = $1.to_s
      if  face != '' && face['|'] 
        face = face.split('|')
        create_portrait(face)
        return 0
      end
      create_face_sprite(face) if face != ''   
      return 0
    end
    if @c == "\015" || @c == "\016" #name show
      if @c == "\015" 
        @text.sub!(/\[([0-9]+),([0-9]+)\]/, '')
        name = $game_actors[$1.to_i].name.dup
        face = case $1.to_i
        when 1 then sprintf("zdc-%02d", $2.to_i)
        when 2 then sprintf("spc-%02d", $2.to_i)
        when 3 then sprintf("freya-%02d", $2.to_i)
        when 4 then sprintf("chris-%02d", $2.to_i)
        end
      elsif @c == "\016"
        @text.sub!(/\[(.+?)(?:(\d+))?\]/, '')
        name = $1.to_s
      end
      create_name_sprite(name) if name != ''
      create_face_sprite(face) 
    end
    if @c == "\017"
      @text.sub!(/\[(.+?)\]/, '')
      text = [$1.to_s]
      if text[0] == "#d"
        if $game_system.message.auto_comma_pause && @letter_by_letter
          delay = @text_speed + $game_system.message.auto_comma_delay
          if delay >= 0
            @delay += delay
            # reset player skip after delay
            @player_skip = false
          end
        end
        return 0     
      elsif text[0].sub!(/#si/, '') != nil
        text[0].gsub!('(!', '[')
        text[0].gsub!('!)', ']')
        message_eval(text[0])
      elsif text[0].sub!(/#ss/, '') != nil
        text[0].gsub!('(!', '[')
        text[0].gsub!('!)', ']')
        eval(text[0])
      else
        #bitmap.font.size -= 4
        text[1] = bitmap.text_size( text[0]  ).width
        bitmap.draw_text(4 + @x, 32 * @y-10, 10*text[1], 32,text[0] )
        #bitmap.font.size += 4
      end
    end
    # if \F+ (Foot Forward Animation On)
    if @c == "\020" && @float_id && !@float_id.is_a?(Array)
      speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
      speaker.foot_forward_on
      return 0
    end
    # if \F- (Foot Forward Animation Off)  
    if @c == "\021" && @float_id && !@float_id.is_a?(Array)
      speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
      speaker.foot_forward_off
      return 0
    end
    # if \F* (Foot Forward Animation On "Other" Foot)
    if @c == "\022" && @float_id && !@float_id.is_a?(Array)
      speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
      speaker.foot_forward_on(frame = 1)
      return 0
    end          
    # If \Z[n]
    if @c == "\024"
      @text.sub!(/\[([0-9]+)\]/, '')
      self.z = $1.to_i
      @tail.z = self.z + 10
      @face.z = self.z  if @face
      @fwindowskin.z = self.z if @fwindowskin
      @name_sprite.z = self.z + 101 if @name_sprite
      return 0
    end  
    # Picture display!!
        if @c == "\026" #and @string_id
          @text.sub!(/\[([\w]+)\]/, "")
          bitmap = RPG::Cache.picture($1.to_s)
          rect = Rect.new(0, 0, bitmap.width, bitmap.height)
          contents.blt(4+@x, 32*@y, bitmap, rect)
          #contents.blt(4+@x, 32*@y+4, bitmap, rect)
          @x += bitmap.width + 4
          #@y += bitmap.height
          next
        end
        
    extra = eval_extra(bitmap)
    return extra if extra
    # If new line text
    if @c == "\n"
      center = $game_system.message.autocenter
      if (center && @x == (self.width-40)/2 - @line_widths[@y]/2)  ||
          (!center && @x == 0)   
        @line_widths[@y] = nil
        @line_widths.compact!
        @x = center ? ((self.width-40)/2 - @line_widths[@y]/2) : 0
        return 0
      end
      # Update cursor width if choice
      if @y >= $game_temp.choice_start
        width = $game_system.message.autocenter ? @line_widths[@y]+8 : @x
        @cursor_width = [@cursor_width, width].max
      end
      # Add 1 to y
      @y += 1
      if $game_system.message.auto_shrink
        while self.height < @y * 32 + 32
          Graphics.update
          self.height += 1
          reposition
        end
        face_position
        self.height = @y * 32 + 32
      end
      if $game_system.message.autocenter && @text != ''
        @x = (self.width-40)/2 - @line_widths[@y]/2 if @line_widths[@y]
      else
        @x = 0
        # Indent if choice
        @x = 8 if @y >= $game_temp.choice_start
      end
      # go to next text
      return 1
    end
  end
  #--------------------------------------------------------------------------
  # * eval_extra
  #--------------------------------------------------------------------------
  def eval_extra(bitmap) return false end
  #--------------------------------------------------------------------------
  # * Play Sound
  #--------------------------------------------------------------------------
  def play_sound
    if $game_system.message.sound && @letter_by_letter && !@player_skip &&
        CHARACTERS.include?(@c.downcase)
      # Increment for each Letter Sound Played
      @sound_counter = (@sound_counter || 0) + 1
      # Prevents Division by Zero, allows 0 to play a sound every letter
      frequency = $game_system.message.sound_frequency
      frequency = (frequency == 0) ? @sound_counter : frequency
      # Play Sound for each New Word or if Remainder is 0
      if @sound_counter == 1 or @sound_counter % frequency == 0
        # Play correct sound for each letter
        play_text_sound(@c.downcase)
      end
    else
      @sound_counter = 0
    end       
  end
  #--------------------------------------------------------------------------
  # * Update Text
  #--------------------------------------------------------------------------  
  def update_text
    if @text != nil
      
      # Get 1 text character in c (loop until unable to get text)
      while ((@c = @text.slice!(/./m)) != nil)
        # Plays Sounds for each Letter, Numbers and Spaces Excluded
        play_sound 
        case eval_text(self.contents)
        when 0 then return
        when 1 then next
        end
        # Draw text
        self.contents.draw_text(4 + @x, 32 * @y, 40, 32, @c)
        # Add x to drawn text width
        @x += self.contents.text_size( @c ).width
        # add text speed to time to display next character
        @delay += @text_speed unless !@letter_by_letter || @player_skip
        return if @letter_by_letter && !@player_skip
      end
      height = self.contents.height+10
      height = [height, @face.bitmap.height+20].max if @face
      saved_bitmap = Bitmap.new(640,height)
      saved_bitmap.blt(100,10,self.contents,self.contents.rect)
      saved_bitmap.blt(@face.x-self.x+100,@face.y-self.y+10,
                    @face.bitmap,@face.bitmap.rect) if @face
      saved_bitmap.blt(@name_sprite.x-self.x+100,@name_sprite.y-self.y+10,
                @name_sprite.bitmap,@name_sprite.bitmap.rect) if @name_sprite
      save_message_bitmap(saved_bitmap)
      @animations = @animations.map { |ani| 
             AnimationSprite.new(ani[0], self.x + 16, 
             self.y + 16, self.z + 1, ani[1], self.contents) }
      @letter_animations = @letter_animations.map { |ani| 
                AnimationLetters.new(ani[0], self.x + 16, 
                self.y + 16, self.z + 1, ani[1], self.contents) }
      @animations.each { |i| i.opacity = self.contents_opacity }
      @letter_animations.each { |i| i.opacity = self.contents_opacity }
    end
    # If choice
    if $game_temp.choice_max > 0 && @choice_window
      @item_max = $game_temp.choice_max
      self.active = true
      if $choice_index && $choice_index.is_a?(Integer) &&
         $choice_index < $game_temp.choice_max
        self.index = $choice_index
      else
        self.index = 0
      end
    end
    # If number input
    if $game_temp.num_input_variable_id > 0 && @choice_window  
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.set_font(@font_name, @font_size, @font_color)
      @input_number_window.number = number
      @input_number_window.x =
        if $game_system.message.autocenter
          offset = (self.width-40)/2-@line_widths[$game_temp.num_input_start]/2
          self.x + offset + 4
        else
          self.x + 8
        end
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
    @update_text = false
  end
  #--------------------------------------------------------------------------
  # * save_message_bitmap
  #--------------------------------------------------------------------------
  def save_message_bitmap(saved_bitmap)
    d =  $multiple_message_windows['saved'] 
    $multiple_message_windows['saved'] = [] unless d && d.is_a?(Array)  
    $multiple_message_windows['saved'].push(saved_bitmap)
    if d && d.size + 1 > 20
      bitmap = $multiple_message_windows['saved'].shift 
      bitmap.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Message_Eval
  #--------------------------------------------------------------------------
  def message_eval(v)
    message_interpreter.send(:eval,v)
  end
  #--------------------------------------------------------------------------
  # * Message_Interpreter
  #--------------------------------------------------------------------------
  def message_interpreter
    if $scene.is_a?(Scene_Map)
      $game_system.map_interpreter
    elsif $scene.is_a?(Scene_Battle)
      $game_system.battle_interpreter
    else
      Interpreter.new
    end
  end
  #--------------------------------------------------------------------------
  # * Reset Window
  #--------------------------------------------------------------------------
  def reset_window
    case $game_system.message_position
    when 0 then self.y = 16  # up
    when 1 then self.y = 160 # middle
    when 2 then self.y = 304 # down
    end
    self.y =16  if $game_temp.in_battle
    self.y =394 if $game_system.message.cinema && $game_system.message_frame > 0
    $game_system.message.opacity ||= 255 
    self.opacity = $game_system.message_frame == 0 ? 
      $game_system.message.opacity.to_i : 0
    @tail.opacity = $game_system.message.opacity.to_i
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if @animations && !@fade_out &&
        @animations.all? { |ani|  ani.is_a?(AnimationSprite) } && 
        @letter_animations.all? { |ani| ani.is_a?(AnimationLetters) } 
      @animations.each { |ani| ani.update(self.x + 16, self.y + 16) }
      @letter_animations.each { |ani| ani.update(self.x + 16, self.y + 16) }
    end
    # If fade in
    if @fade_in
      self.contents_opacity += 24
      if @input_number_window != nil
        @input_number_window.contents_opacity += 24
      end
      if !@animations.nil? &&  !@fade_out &&
          @animations.all? { |ani| ani.is_a?(AnimationSprite) } && 
          @letter_animations.all? { |ani| ani.is_a?(AnimationLetters) } 
        @animations.each { |ani| ani.opacity = self.contents_opacity }
        @letter_animations.each { |ani| ani.opacity = self.contents_opacity }
      end
      if self.contents_opacity == 255
        @fade_in = false
      end
    end
    # If inputting number
    if @input_number_window != nil
      @input_number_window.update
      # Confirm
      if Input.trigger?(Input::C)
        # Allows windows to be closed
        $game_temp.input_in_window = false
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] =
          @input_number_window.number
        $game_system.number_cancelled = false        
        $game_map.need_refresh = true
        
        s = $multiple_message_windows['saved']
        if s.is_a?(Array) 
          bitmap = s[-1]
          if bitmap.is_a?(Bitmap)
            input_contents = @input_number_window.contents
            if $game_system.message.autocenter
              pos_x = (self.contents.width - input_contents.width) / 2
            else
              pos_x = 0
            end
            bitmap.blt(100 + pos_x,(bitmap.height - input_contents.height),
              input_contents,input_contents.rect)
          end
        end
        # Dispose of number input window
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
        return
      elsif Input.trigger?(Input::B) and 
            $game_system.message.allow_cancel_numbers
        # play cancel sound effect
        $game_system.se_play($data_system.cancel_se)
        # Allows windows to be closed
        $game_temp.input_in_window = false
        # Set Variable to identify the Number Window was Cancelled
        $game_system.number_cancelled = true
        # Dispose of number input window
        @input_number_window.dispose
        @input_number_window = nil        
        if $scene.multi_message_window.compact.size > 1
          $scene.multi_message_window.each {|msg| msg.terminate_message }
        else
          terminate_message
        end
      end
    end
    # If message is being displayed
    if @contents_showing
      # Confirm or cancel finishes waiting for input or message
      if Input.trigger?(Input::C) || Input.trigger?(Input::B)
        if @wait_for_input
          @wait_for_input = false
          self.pause = false
        elsif $game_system.message.skippable
          @player_skip = true
        end
        # Dont close the window if waiting for choices to be displayed
        if $game_temp.input_in_window && 
           $game_temp.message_text.compact.size > 1 &&
           !$input_window_wait
          # wait until next input to confirm any choices
          $input_window_wait = true
          return 
        else
          $input_window_wait = false          
        end
      end
      if need_reposition?
        reposition # update message position for character/screen movement
        if @contents_showing == false
          # i.e. if char moved off screen
          return 
        end
      end
      if @update_text && !@wait_for_input
        if @delay == 0
          update_text
        else
          @delay -= 1
        end
        return
      end
      # If choice isn't being displayed, show pause sign
      if !self.pause && ($game_temp.choice_max == 0 || @wait_for_input)
        self.pause = true if $game_system.message.show_pause
      end
      # Cancel
      if Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 && $game_temp.choice_cancel_type > 0
          # Allow ALL windows to be closed
          $game_temp.input_in_window = false
          $game_system.se_play($data_system.cancel_se)
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          # If multi window cancel choice
          if $scene.multi_message_window.compact.size > 1
            $scene.multi_message_window.each {|msg| msg.terminate_message }
          else
            terminate_message
          end
        end
        # personal preference: cancel button should also continue
        terminate_message 
      end
      # Confirm
      if Input.trigger?(Input::C)
        if $game_temp.choice_max > 0
          $game_temp.input_in_window = false
          if $scene.multi_message_window.compact.size > 1
            $scene.multi_message_window.compact.each { |window|
              if window.choice_window
                # return selection position by index of the choice window
                @index = window.index
              end    }
          end          
          $game_system.se_play($data_system.decision_se)
          $game_temp.choice_proc.call(self.index)
        end
        # If Preceeding Window not closed because choice displayed
        if $scene.multi_message_window.compact.size > 1
          choice = false
          $scene.multi_message_window.compact.each { |window|
            if window.choice_window
              choice = true
              break
            end }
          # If window is a choice window and other windows held open
          if choice
            # close all the message windows
            $scene.multi_message_window.each {|msg|  msg.terminate_message }
          else
            # close the single message window            
            terminate_message
          end
        else
          if $game_temp.choice_max > 0
            $game_system.se_play($data_system.decision_se)
            $game_temp.choice_proc.call(self.index)
          end
          terminate_message
        end
      end
        return
    end
    # If display wait message or choice exists when not fading out
    $game_temp.message_text = [] if !$game_temp.message_text.is_a?(Array)
    $game_temp.message_proc = [] if !$game_temp.message_proc.is_a?(Array)
    if @fade_out == false && $game_temp.message_text[@msgindex] != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      reset_window
      refresh
      Graphics.frame_reset
      self.visible = true
      if show_message_tail?
        @tail.visible = true
      elsif @tail.visible
        @tail.visible = false
      end
      self.contents_opacity = 0
      if !@animations.nil?  && !@fade_out &&
          @animations.all? { |ani| ani.is_a?(AnimationSprite) } &&
          @letter_animations.all? { |ani| ani.is_a?(AnimationLetters) }
        @animations.each { |ani| ani.opacity = self.contents_opacity }
        @letter_animations.each { |ani| ani.opacity = self.contents_opacity }
      end
      if @input_number_window != nil
        @input_number_window.contents_opacity = 0
      end
      @fade_in = true
      return
    end
    # If message which should be displayed is not shown, but window is visible
    if self.visible 
      @fade_out = true
      self.opacity -= 96
      @tail.opacity -= 96 if @tail.opacity > 0 
      if !@animations.nil?  && !@fade_out &&
        @animations.all? { |ani| ani.is_a?(AnimationSprite) } && 
        @letter_animations.all? { |ani| ani.is_a?(AnimationLetters) }
        @animations.each { |ani| ani.opacity = 
                 self.opacity * self.contents_opacity / 255 }
        @letter_animations.each { |ani| ani.opacity = 
                 self.opacity * self.contents_opacity / 255 }
      end
      if need_reposition?
        reposition # update message position for character/screen movement
      end
      if self.opacity == 0 #@fwindowskin.opacity == 0 
        self.visible = false
        unless @animations.nil? || @animations.any? { |i| i.is_a?(Array) } || 
          @letter_animations.any? { |i| i.is_a?(Array) }
          @animations.each { |ani| ani.bitmap.dispose;ani.dispose }
          @letter_animations.each { |ani| ani.dispose }
        else
          @animations = @letter_animations = []
        end
      @fade_out = false
        @tail.visible = false if @tail.visible
        # have to check all windows before claiming that no window is showing
        if $game_temp.message_text.compact.empty?
          $game_temp.message_window_showing = false  
        end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Repositioning Determination
  #--------------------------------------------------------------------------
  def need_reposition?
    if (!$game_temp.in_battle) && $game_system.message.floating &&
        $game_system.message.resize && @float_id != nil
      char = (@float_id == 0 ? $game_player : $game_map.events[@float_id])
      if !char.nil? && @screen_xy != record_screen_xy(char)
        @screen_xy = record_screen_xy(char)
        return true
      elsif $game_system.message.move_during && @float_id == 0 &&
          (($game_player.last_real_xy[0] != $game_player.real_x) ||
          ($game_player.last_real_xy[1] != $game_player.real_y))
          # player with floating message moved
          # (note that relying on moving? leads to "jumpy" message boxes)
          return true
      elsif ($game_map.last_disp_xy[1] != $game_map.display_y) ||
         ($game_map.last_disp_xy[0] != $game_map.display_x)
        # player movement or scroll event caused the screen to scroll
        return true 
      else
        char = $game_map.events[@float_id]
        if char != nil && 
          ((char.last_real_xy[0] != char.real_x) ||
          (char.last_real_xy[1] != char.real_y))
          # character moved
          return true
        end
      end    
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Show Message Tail Determination
  #--------------------------------------------------------------------------
  def show_message_tail?
    if $game_system.message.show_tail && $game_system.message.floating &&
      $game_system.message.resize && $game_system.message_frame == 0 &&
      @float_id != nil
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * update_cursor_rect
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index >= 0
      n = $game_temp.choice_start + @index
      if $game_system.message.autocenter
        x = 4 + (self.width-40)/2 - @cursor_width/2
      else
        x = 8
      end
      self.cursor_rect.set(x, n * 32, @cursor_width, 32)
    else
      self.cursor_rect.empty
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg128_term terminate_message unless method_defined?(:drg128_term)
  alias drg128_upd update unless method_defined?(:drg128_upd)
  alias drg128_rep reposition unless method_defined?(:drg128_rep)
  #--------------------------------------------------------------------------
  # * Create Face_Sprite
  #--------------------------------------------------------------------------
  def create_face_sprite(face='')
    terminate_face rescue return
    return if face.nil? || face == ' '
    dir = 'Graphics/Pictures'
    Dir.mkdir(dir) unless File.directory?(dir)
    face = Bitmap.new("#{dir}/#{face}") 
    bitmap = Bitmap.new(96,96)
    bitmap.stretch_blt(bitmap.rect, face, face.rect) 
    create_face_cont(bitmap)
  end
  #--------------------------------------------------------------------------
  # * Create Face_Sprite
  #--------------------------------------------------------------------------
  def create_face_cont(bitmap)
    @face = Sprite.new
    @face.bitmap = bitmap
    @face.opacity = $game_system.message.opacity
    face_position rescue return
    reposition
  end
  #--------------------------------------------------------------------------
  # * Create Name_Sprite
  #--------------------------------------------------------------------------
  def create_name_sprite(name='')
    terminate_name_sprite
    bitmap = Bitmap.new(name.length*10, 32)
    bitmap.font = self.contents.font
    #bitmap.font.size += 4
    bitmap.font.color = check_color("#BACAFE") #normal_color
      (0...2).each {|i|
        #bitmap.draw_text(-i, i, name.length*10, 32, name)
        #bitmap.draw_text(i, -i, name.length*10, 32, name)
       # bitmap.draw_text(-i, -i, name.length*10, 32, name)
        bitmap.draw_text(i, i, name.length*10, 32, name)  
        }
    bitmap.font.color = self.contents.font.color
      (0...1).each {|i|
        #bitmap.draw_text(-i, i, name.length*10, 32, name)
        #bitmap.draw_text(i, -i, name.length*10, 32, name)
        bitmap.draw_text(-i, -i, name.length*10, 32, name)
        #bitmap.draw_text(i, i, name.length*10, 32, name)   
        }
    @name_sprite = Sprite.new
    @name_sprite.bitmap = bitmap
    name_sprite_position
  end
  #--------------------------------------------------------------------------
  # * Face Position
  #--------------------------------------------------------------------------
  def face_position
    return if !@face || @face.disposed?   
    if $game_system.message.floating
      @face.x = self.x - (@face.bitmap.width * @face.zoom_x + 2)
      @face.y = self.y  + 20 * ([64-64, 0].max/32).floor
      @face.y -= [(10 - (self.height - 64)), -6].max
    else
      @face.zoom_x = 1.2
      @face.zoom_y = 1.2
      @face.x = self.x + (self.width - (@face.bitmap.width * @face.zoom_x + 8))
      @face.y = self.y + 10
    end
    @face.z = self.z 
  end
  #--------------------------------------------------------------------------
  # * Name_Sprite Position
  #--------------------------------------------------------------------------
  def name_sprite_position
    return if !@name_sprite || @name_sprite.disposed?
    @name_sprite.y = self.y - 15
    @name_sprite.x = self.x + 10
    @name_sprite.z = self.z + 101
  end
  #--------------------------------------------------------------------------
  # * Terminate Face
  #--------------------------------------------------------------------------
  def terminate_face()  eval ('@face.dispose; @face = nil') if @face   end
  #--------------------------------------------------------------------------
  # * Terminate Name_Sprite
  #--------------------------------------------------------------------------
  def terminate_name_sprite()
    eval('@name_sprite.dispose; @name_sprite = nil')if @name_sprite
  end
  #--------------------------------------------------------------------------
  # * Terminate Message
  #--------------------------------------------------------------------------
  def terminate_message
    @fwindowskin.bitmap.clear if !@fwindowskin.nil? && !@fwindowskin.disposed? 
    terminate_face
    terminate_name_sprite 
    drg128_term
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    temp = $game_temp.in_battle
    $game_temp.in_battle = $scene.is_a?(Scene_Battle)
    drg128_upd
    $game_temp.in_battle = temp
  end
  #--------------------------------------------------------------------------
  # * Reposition Window
  #-------------------------------------------------------------------------- 
  def reposition
    drg128_rep
    face_position
    name_sprite_position
  end
  
  #--------------------------------------------------------------------------
  # * Text Sound
  #--------------------------------------------------------------------------  
  def play_text_sound(char)
    sound = 'Audio/SE/' + $game_system.message.sound_audio
    volume = $game_system.message.sound_volume
    @sound_pitch =       $game_system.message.sound_pitch
    
    if $game_system.message.sound_vary_pitch and @sound_pitch
      @sound_pitch_range = $game_system.message.sound_pitch_range
      # Prevent Negative Numbers...
      sound_pitch_range = (@sound_pitch_range > @sound_pitch) ?
          @sound_pitch : @sound_pitch_range      
      # If we want to Randomize the Sounds
      if @sound_vary_pitch == 'random'
        # Random within the Range
        pitch = rand(sound_pitch_range * 2) + @sound_pitch - sound_pitch_range
      # Vary Sound Pitch to be based on Letter Sounds
      else
        # Note to Self - Reorganize based on actual Letter Sounds, not so Random
        if ['l','m','n','q','u','w','2'].include?(char)
          pitch = @sound_pitch - sound_pitch_range
          #print(sound + "_aa")
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_aa.wav" )
            sound = sound + "_aa"
            #print(sound)
            end
        elsif ['a','f','h','j','k','o','r','x','1','4','7','8'].include?(char)
          pitch = @sound_pitch - sound_pitch_range / 2
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_ee.wav" )
            sound = sound + "_ee"
            end
        elsif ['b','c','d','e','g','p','t','v','z','0','3','6'].to_a.include?(char)
          pitch = @sound_pitch
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_ii.wav" )
            sound = sound + "_ii"
            end
        elsif ['s','7'].to_a.include?(char)
          pitch = @sound_pitch + sound_pitch_range / 2
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_oo.wav" )
            sound = sound + "_oo"
            end
        elsif ['i','y','5','9'].to_a.include?(char)
          pitch = @sound_pitch + sound_pitch_range
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_uu.wav" )
            sound = sound + "_uu"
            end
        else
          pitch = rand(@sound_pitch_range * 2) + @sound_pitch
        end
      end
    else
      pitch=(@sound_pitch and @sound_pitch.is_a?(Numeric)) ? @sound_pitch : 100
    end
    # Play the Sound
    Audio.se_play(sound, volume, pitch)
  end
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias upd_mess_log update unless method_defined?(:upd_mess_log)
  alias dis_mess_log dispose unless method_defined?(:dis_mess_log)
  #--------------------------------------------------------------------------
  # * Create Message Log
  #--------------------------------------------------------------------------
  def create_message_log(win = MESSAGE_LOG_WINDOWSKIN)
    log_opacity = MESSAGE_LOG_OPACITY
    @message_log_sprite = [@message_log = Sprite.new,
                          @message_log_text = Sprite.new]
    @message_log.bitmap = Bitmap.new(600,460)
    @message_log_text.bitmap = @message_log.bitmap.dup
    @message_log.bitmap.clear
    @message_log_text.bitmap.clear
    @message_log.x, @message_log.y = 20, 10
    @message_log.z = self.z * 2
    @message_log.opacity = 200
    @message_log_text.opacity = 255
    @message_log_text.z = @message_log.z + 10
    draw_window(@message_log.bitmap.width, @message_log.bitmap.height, win)
    frame, mess = @frame.bitmap, @message_log.bitmap
    cls = [Color.new(0,0,0,0), Color.new(255,255,255,255)]
    @message_log.bitmap.blt(0,0,frame,frame.rect, log_opacity)
    @message_log_height = 0
    $multiple_message_windows['saved'].reverse.each_with_index do |i,s|
      next if s < @message_log_index
      @message_log_height +=(i.height+20)
      v = mess.height - @message_log_height
      @message_log_text.bitmap.blt(20 ,v ,i, i.rect)
      @message_log.bitmap.fill_rect( Rect.new(30,v-15,mess.width-60,2),cls[0])
    end
    @message_log.bitmap.blt(0,0,frame, Rect.new(0,0,frame.width,50),log_opacity)
    @message_log.bitmap.fill_rect( Rect.new(10,40, mess.width-20,2), cls[1])
    @message_log_text.bitmap.fill_rect( Rect.new(0,0,frame.width,55), cls[0])
    @message_log.bitmap.font.name = MESSAGE_LOG_FONT.flatten
    @message_log.bitmap.font.size = [MESSAGE_LOG_FONT[-1].to_i, 12].max
    @message_log.bitmap.draw_text(10,0,mess.width,  45,MESSAGE_LOG_TEXT)
    [@frame].each {|i| i.dispose}
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    message_log_input if $game_system.message.message_log
    upd_mess_log unless @message_log
  end
  #--------------------------------------------------------------------------
  # * message_log_input
  #--------------------------------------------------------------------------
  def message_log_input
    if (saved_image = $multiple_message_windows['saved']) && 
      !saved_image.empty? && !@message_log && @msgindex == 0 
      if input_message_log(sc = mouse_scroll) || @force_message_log == 1
        @message_log_move = [$game_system.message.move_during,
                            $game_temp.message_window_showing]
        $game_temp.message_window_showing = true
        $game_system.message.move_during = false
        $game_system.se_play($data_system.decision_se)
        @message_log_index = @force_message_log = 0
        return create_message_log
      end
    elsif @message_log && @msgindex == 0 
      if cansel_mesage_log
        $game_system.message.move_during = @message_log_move[0]
        $game_temp.message_window_showing = @message_log_move[1]
        $game_system.se_play($data_system.cancel_se)
        @message_log_sprite.compact.each {|i| i.dispose}
        @message_log = nil
      elsif elmessage_log(sc = mouse_scroll)
        @message_log_index = [(s=@message_log_index)+1,saved_image.size-1].min
        $game_system.se_play($data_system.cursor_se) if s != @message_log_index
        @message_log_sprite.compact.each {|i| i.dispose}
        create_message_log
      elsif ermessage_log(sc)
        @message_log_index = [(s=@message_log_index)-1,0].max
        $game_system.se_play($data_system.cursor_se) if s != @message_log_index
        @message_log_sprite.compact.each {|i| i.dispose}
        create_message_log
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Forcefully Show Message Log
  #--------------------------------------------------------------------------
  def show_message_log
    @force_message_log = 1
  end
  #--------------------------------------------------------------------------
  # * input_message_log
  #--------------------------------------------------------------------------
  def input_message_log(sc = 0)
    return true if Input.trigger?(Input::F8) 
    return true if sc > 0
    return false
  end
  #--------------------------------------------------------------------------
  # * Cancel Message Log
  #--------------------------------------------------------------------------
  def cansel_mesage_log
    begin
      return true if Input.trigger?(Input::F8)
      return true if Input.trigger?(Input::B)
      if $mouse_controller || $BlizzABS
        return true if Input.trigger?(Input::Key['Mouse Right'])
      elsif (($imported ||= {})[:drg_custom_input] || 0) >= 2.00
        return true if Mouse.press?(Mouse::SECONDARY)
      end
    rescue
      false
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * elmessage_log
  #--------------------------------------------------------------------------
  def elmessage_log(sc = 0)
    return true if Input.trigger?(Input::L)
    return true if Input.repeat?(Input::UP)
    return true if sc > 0
    return false
  end
  #--------------------------------------------------------------------------
  # * ermessage_log
  #--------------------------------------------------------------------------
  def ermessage_log(sc = 0)
    return true if Input.trigger?(Input::R)
    return true if Input.repeat?(Input::DOWN)
    return true if sc < 0
    return false
  end
  #--------------------------------------------------------------------------
  # * mouse_scroll
  #--------------------------------------------------------------------------
  def mouse_scroll
    @scroll_count = (@scroll_count || 0) + 1
    return 0 if @scroll_count < 5
    @scroll_count = 0
    if Input.respond_to?(:scroll?) 
      return 1  if Input.scroll_up?
      return -1 if Input.scroll_down?
    end
    if (($imported ||= {})[:drg_custom_input] || 0) >= 2.00
      return 1  if Mouse.scroll_up?
      return -1 if Mouse.scroll_down?
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    dis_mess_log
    @message_log_sprite.compact.each {|i| i.dispose} if @message_log_sprite
  end
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias upd_portrait update unless method_defined?(:upd_portrait)
  alias term_face_por terminate_face unless method_defined?(:term_face_por)
  #--------------------------------------------------------------------------
  # * create_portrait
  #--------------------------------------------------------------------------
  def create_portrait(face)
    terminate_face rescue return
    return if face.nil? || face == ' ' #\f [portrait,face,coord,color,xy] 
    dir, a, b = 'Graphics/Portrait', [204+5,28,204,204], [0,0]
    Dir.mkdir(dir) unless File.directory?(dir)
    a = face[2].split(',').map {|x| x.to_i } if face[2] && face[2] != ' '
    b = face[4].split(',').map {|x| x.to_i } if face[4] && face[4] != ' '
    c = face[3]
    d = Bitmap.new("#{dir}/#{face[0]}") 
    e = Bitmap.new("#{dir}/#{face[1]}")  if face[1] && face[1][0].chr != ' ' 
    f = Bitmap.new(96,96) #80
    @portrait = Sprite.new
    @portrait.bitmap, @portrait.opacity = d, 0
    @portrait.x, @portrait.y = b[0], b[1]
    @portrait.bitmap.blt(0, 0, e || Bitmap.new(1,1), 
        Rect.new(0,0,@portrait.bitmap.width,a[1]+a[3])) 
    unless  c == ' '    
      f.fill_rect(Rect.new(0,0,96,96),check_color(0)) if c
      f.stretch_blt(f.rect, @portrait.bitmap, Rect.new(*a)) if face[1] != ' '
      f.fill_rect(Rect.new(0,0,96,2),check_color(c))  if c
      f.fill_rect(Rect.new(0,78,96,2),check_color(c)) if c
      f.fill_rect(Rect.new(0,0,2,96),check_color(c))  if c
      f.fill_rect(Rect.new(78,0,2,96),check_color(c)) if c
    end
    create_face_cont(f)
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    @portrait.opacity = [@portrait.opacity+15, 255].min if @portrait
    upd_portrait
  end
  #--------------------------------------------------------------------------
  # * terminate_face
  #--------------------------------------------------------------------------
  def terminate_face
    term_face_por
    eval '@portrait.dispose;  @portrait = nil' if @portrait
  end
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg3x4dkc2dy_repbcod replace_basic_code
  #--------------------------------------------------------------------------
  # * Replace Basic Code
  #--------------------------------------------------------------------------
  def replace_basic_code
    @text.gsub!(/\\[Ii][Ff]\[(.*?),(.*?)\]/) do 
      cond, result = "#$1", "#$2"
      message_eval(cond.gsub!("(!","[").gsub!("!)","]")) ? result : ""
    end
    @text.gsub!(/\\[Uu][Nn][Ll][Ee][Ss][Ss]\[(.*?),(.*?)\]/) do 
      cond, result = "#$1", "#$2"
      message_eval(cond.gsub!("(!","[").gsub!("!)","]")) ?  "" : result
    end
    drg3x4dkc2dy_repbcod
  end
end
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
  attr_accessor   :no_ff, :rev_scr_xy 
  attr_reader     :erased
  #--------------------------------------------------------------------------
  # * Name
  #---------------------------------------------------------------------------
  def name() self.is_a?(Game_Event) ? @event.name : $game_party.actors[0].name end
  #--------------------------------------------------------------------------
  # * last_real_xy
  #--------------------------------------------------------------------------
  def last_real_xy() [@real_x, @real_y] end
  #----------------------------------------------------------------------------
  # * Allows Animation Change regardless of Direction
  #----------------------------------------------------------------------------
  unless self.method_defined?('foot_forward_on')  
    def foot_forward_on(frame = 0)
      return if @direction_fix || !@walk_anime || @step_anime || 
                $game_temp.in_battle
      @pattern = case @direction
      when 2       then frame == 0 ? 3 : 1
      when 4, 6, 8 then frame == 0 ? 1 : 3
      end || 0
      @original_pattern = @pattern
      refresh
    end
    def foot_forward_off
      # If called by walking off screen, dont affect a Sign or Stepping Actor
      return if $game_temp.in_battle || @direction_fix || !@walk_anime || @no_ff
      @pattern, @original_pattern = 0, 0
    end
  end
  #----------------------------------------------------------------------------
  # * within_range?
  #----------------------------------------------------------------------------
  def within_range?(range = 4, id = @event_id)
    e = $game_map.events[id]
    # using real_x and real_y to support BlizzABS pixel movement
    e = (Math.hypot((e.x-$game_player.real_x/128),
        (e.y-$game_player.real_y/128))).abs if e 
    return (e <= range) if e
  end  
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================
['Sprite_Battler','Spriteset_Battle'].each {|i| eval "
class #{i}
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  # necessary for positioning messages relative to battlers
  attr_reader :height, :width, :actor_sprites, :enemy_sprites
end#"}

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================
class Game_Temp
  attr_accessor :num_input_variable_id_backup, :input_in_window
  attr_accessor :input_type
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================
['Scene_Map','Scene_Battle'].each_with_index {|klass,i| eval "
class #{klass}
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  # necessary for accessing actor/enemy sprites in battle
  attr_accessor :spriteset, :multi_message_window, :message_window
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg128_upd update unless method_defined?(:drg128_upd)
  alias drg128_main main unless method_defined?(:drg128_main) 
  #--------------------------------------------------------------------------
  # * drg152_main
  #--------------------------------------------------------------------------
  def drg152_main
    drg128_main  
    dispose_mmw_variable(@multi_message_window + @cinemasks)
  end
  #--------------------------------------------------------------------------
  # * dispose_multi_message_window
  #--------------------------------------------------------------------------
  def dispose_mmw_variable(var = [])
    var.each {|mw| mw.disposed? || mw.dispose}  
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main()  drg152_main end
  #--------------------------------------------------------------------------
  # * New Message Window Addition
  #--------------------------------------------------------------------------
  def new_message_window(index)
    if @multi_message_window[index] != nil
      # clear message windows at and after this index
      (@multi_message_window.size - 1).downto(index) { |i|
        next if @multi_message_window[i] == nil
        @multi_message_window[i].dispose
        @multi_message_window[i] = nil }
      @multi_message_window.compact!
    end
    @multi_message_window.push(Window_Message.new(index))
  end
  #--------------------------------------------------------------------------
  # * Cinemaskie
  #--------------------------------------------------------------------------
  def create_cinema(a=640,b=48,x=0,y=0,z=nil,o= nil)
    mask,@cinema_fadecount = Sprite.new, 24
    mask.bitmap = Bitmap.new(a,b)
    mask.bitmap.fill_rect(0,0,a,b, Color.new(0,0,0,255))
    mask.x, mask.y, mask.opacity = [x,y,o||255]
    mask.z = z || $game_system.message.cinema_z
    return mask
  end
  #--------------------------------------------------------------------------
  # Update Cinema
  #--------------------------------------------------------------------------
  def update_cinema
    cii = $game_system.message.cinema
    @cinemasks ||= []
    @cinema_fadecount ||= 24
    if (cii && @cinema_fadecount >  0) || (!cii && @cinema_fadecount < 24)
      if @cinemasks.empty?
        @cinemasks << create_cinema(640,48,0,-48)
        @cinemasks << create_cinema(640,72,0,480)
        @cinemasks << create_cinema(640,480,0,0,199,0)
      end             
      @cinema_fadecount = (@cinema_fadecount || 24) + (cii ? -1 : 1)
      @cinemasks[0].y =   0 -  6 *       @cinema_fadecount  / 3
      @cinemasks[1].y = 480 -  9 * (24 - @cinema_fadecount) / 3
      @cinemasks[2].opacity =  4 * (24 - @cinema_fadecount)
    elsif !@cinemasks.empty? && @cinemasks[0].y <= -48
      dispose_mmw_variable(@cinemasks)
      @cinemasks = []
    end      
  end
  #--------------------------------------------------------------------------
  # * update_scene_cinema
  #--------------------------------------------------------------------------
  def update_scene_cinema
    @multi_message_window ||= [@message_window]  
    @multi_message_window.each_with_index {|mw,i| mw.disposed? || i == 0 || mw.update}    
    update_cinema
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_scene_cinema
    drg128_upd
  end
end#"}
#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player 
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg128_upd update unless method_defined?(:drg128_upd)
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_mmw_moving
    drg128_upd
  end
  #--------------------------------------------------------------------------
  # * update_mmw_moving
  #--------------------------------------------------------------------------
  def update_mmw_moving
    message_showing = $game_temp.message_window_showing
    unless moving? || @move_route_forcing ||
      ($game_system.map_interpreter.running? && !message_showing) ||
      (message_showing && !$game_system.message.move_during) || 
      ($game_temp.choice_max > 0 || $game_temp.num_input_digits_max > 0) 
      if (input = Input.dir4)
        case input
        when 2 then move_down
        when 4 then move_left
        when 6 then move_right
        when 8 then move_up
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  # This is a fix if Blizzard's Optimized default scripts are being used
  if method_defined?(:check_event_trigger_touch)
    alias_method(:check_event_trigger_fix, :check_event_trigger_touch)
    def check_event_trigger_touch(*args)
      return false if $game_system.map_interpreter.running?
      return check_event_trigger_fix(*args)
    end
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :number_cancelled
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg128_upd update unless method_defined?(:drg128_upd)
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_shaded_fix
    drg128_upd
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def message()  @message ||= Game_Message.new  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_shaded_fix
    if message && @SHADED_TEXT != nil && Blizzard_Shaded_Text_Fix == true
      if $game_temp.message_window_showing
        @SHADED_TEXT = false
      else
        @SHADED_TEXT = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # Can Move?
  #--------------------------------------------------------------------------
  def blizzabs_can_move?(type=0)
    player = $BlizzABS.actors[0]
    message_showing = $game_temp.message_window_showing
    interpreter = $game_system.map_interpreter.running?
    return type == 0 ? (((player.ai.act.defend? && player.attacked == 0) ||
          $game_system.turn_button && Input.press?(Input::Turn)) &&
          !player.moving? && !player.move_route_forcing &&
          (!interpreter || message_showing) &&
          (!message_showing || $game_system.message.move_during) && 
          $game_temp.choice_max <= 0 && $game_temp.num_input_digits_max <= 0) :
          (player.move_route_forcing ||  (interpreter && !message_showing) ||
          (message_showing && !$game_system.message.move_during) || 
          ($game_temp.choice_max > 0 || $game_temp.num_input_digits_max > 0)) 
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
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias drg128_setup setup unless method_defined?(:drg128_setup)
  alias drg128_upd update unless method_defined?(:drg128_upd)
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup(*args)
    drg128_setup(*args)
    # index of window for the message
    @msgindex = 0
    $game_temp.message_text, $game_temp.message_proc = [],[] 
    #if @list.size > 1
      templist = @list.pop
      @list << RPG::EventCommand.new(106,0,[1]) << templist
    #end
    # whether multiple messages are displaying
    @multi_message = false
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update(*args)
    @message_waiting = $game_temp.message_window_showing
    drg128_upd(*args)
  end
  #--------------------------------------------------------------------------
  # * Message
  #--------------------------------------------------------------------------
  def message() $game_system.message end
  #--------------------------------------------------------------------------
  # * Setup Choices
  #--------------------------------------------------------------------------
  def setup_choices(parameters)
    # Set choice item count to choice_max
    $game_temp.choice_max = parameters[0].size
    # Set choice to message_text
    parameters[0].each {|text| $game_temp.message_text[@msgindex] += text + "\n"}
    # Set cancel processing
    $game_temp.choice_cancel_type = parameters[1]
    # Set callback
    current_indent = @list[@index].indent
    $game_temp.choice_proc = Proc.new { |n| @branch[current_indent] = n }
  end
  #--------------------------------------------------------------------------
  # * Show Text
  #--------------------------------------------------------------------------
  def command_101
    # If other text has been set to message_text
    if $game_temp.message_text[@msgindex] != nil
      if @multi_message
        @msgindex += 1
        $scene.new_message_window(@msgindex)
      else
        # End
        return false
      end
    end
    @msgindex = 0 if !@multi_message
    @multi_message = false
    # Set message end waiting flag and callback
    @message_waiting = true
    # just adding indexes
    $game_temp.message_proc[@msgindex] = Proc.new { @message_waiting = false }
    # Set message text on first line
    $game_temp.message_text[@msgindex] = @list[@index].parameters[0] + "\n"
    $scene.multi_message_window[@msgindex].event_id = @event_id 
    line_count = 1
    # Loop
    loop do
      # If next event command text is on the second line or after
      if @list[@index+1].code == 401 || @list[@index+1].code == 101 &&
          @list[@index+1].parameters[0][0..1] == '\\#'
        # just adding index
        $game_temp.message_text[@msgindex] += @list[@index+1].parameters[0]+"\n"
        line_count += 1
      # If event command is not on the second line or after
      else
        # If next event command is show choices
        if @list[@index+1].code == 102
          # If choices fit on screen
          if @list[@index+1].parameters[0].size <= 4 - line_count
            # Prevent the closure of a single window with multiple windows
            $game_temp.input_in_window = true            
            # Flag this window as having choices displayed for multi
            $scene.multi_message_window[@msgindex].choice_window = @msgindex
            # Advance index
            @index += 1
            # Choices setup
            $game_temp.choice_start = line_count
            setup_choices(@list[@index].parameters)
          end
        # If next event command is input number
        elsif @list[@index+1].code == 103
          # If number input window fits on screen
          if line_count < 4
            # Prevent the closure of a single window with multiple windows
            $game_temp.input_in_window = true
            # Flag this window as having choices displayed
            $scene.multi_message_window[@msgindex].choice_window = @msgindex
            # Advance index
            @index += 1
            # Number input setup
            $game_temp.num_input_start = line_count
            $game_temp.num_input_variable_id = @list[@index].parameters[0]
            $game_temp.num_input_digits_max = @list[@index].parameters[1]
            $game_temp.num_input_variable_id_backup = 
              @list[@index].parameters[0]
          end
        # start multimessage if next line is "Show Text" starting with "\\+"
        elsif @list[@index+1].code == 101
          if @list[@index+1].parameters[0][0..1]=='\\+'
            @multi_message,@message_waiting = true, false
          end
        end
        # Continue
        return true
      end
      # Advance index
      @index += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Show Choices
  #--------------------------------------------------------------------------
  def command_102
    # Prevent the closure of a single window with multiple windows
    $game_temp.input_in_window = true
    # Flag this window as having choices displayed for multi
    $scene.multi_message_window[@msgindex].choice_window = @msgindex   
    # If text has been set to message_text
    # just adding index
    return false if $game_temp.message_text[@msgindex] != nil 
    # Set message end waiting flag and callback
    @message_waiting = true
    # adding more indexes
    $game_temp.message_proc[@msgindex] = Proc.new { @message_waiting = false }
    # Choices setup
    $game_temp.message_text[@msgindex] = ''
    $game_temp.choice_start = 0
    setup_choices(@parameters)
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Input Number
  #--------------------------------------------------------------------------
  def command_103
    # Prevent the closure of a single window with multiple windows
    $game_temp.input_in_window = true
    # Flag this window as having choices displayed for multi
    $scene.multi_message_window[@msgindex].choice_window = @msgindex   
    # If text has been set to message_text
    # just adding index
    return false if $game_temp.message_text[@msgindex] != nil
    # Set message end waiting flag and callback
    @message_waiting = true
    # adding more indexes
    $game_temp.message_proc[@msgindex] = Proc.new { @message_waiting = false }
    # Number input setup
    $game_temp.message_text[@msgindex] = ''
    $game_temp.num_input_start = 0
    $game_temp.num_input_variable_id = @parameters[0]
    $game_temp.num_input_digits_max = @parameters[1]
    $game_temp.num_input_variable_id_backup = @list[@index].parameters[0]
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # ● Redefined method: same_map?, next_event_code
  #--------------------------------------------------------------------------
  def same_map?()        @map_id == $game_map.map_id    end
  def next_event_code()  @list[@index + 1].code         end
  SCRIPT_WAIT_RESULTS = [:wait, FalseClass]
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  # Fix for RMXP bug: call script boxes that return false hang the game
  # See, e.g., http://rmxp.org/forums/showthread.php?p=106639  
  #--------------------------------------------------------------------------
  def command_355
    script = @list[index = @index].parameters[0] + "\n"
    while [655, 355].include?(next_event_code) do
      script += @list[@index+=1].parameters[0] + "\n"
    end
    wait = SCRIPT_WAIT_RESULTS.include?(eval(script)) 
    return wait ? !(@index = index) : true
  end  
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles the map. It includes scrolling and passable determining
#  functions. Refer to "$game_map" for the instance of this class.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Define Method
  #--------------------------------------------------------------------------
  define_method(:last_disp_xy) { [@display_x, @display_y] }
  define_method(:name) { load_data('Data/MapInfos.rxdata')[@map_id].name  }
end
#==============================================================================
# ** Bitmap
#------------------------------------------------------------------------------
#  This class is for all in-game bitmap.
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :orientation
  #--------------------------------------------------------------------------
  # * Rotation Calculation
  #--------------------------------------------------------------------------
  def rotation(t)
    return if not [0, 90, 180, 270].include?(t) # invalid orientation
    rotate(t - @orientation + (t-@orientation < 0 ? 360 : 0)) if @rotation != t
  end
  #--------------------------------------------------------------------------
  # * Rotate Square (Clockwise)
  #--------------------------------------------------------------------------
  def rotate(degrees = 90)
    # method originally by SephirothSpawn
    # would just use Sprite.angle but its rotation is buggy
    return if not [90, 180, 270].include?(degrees)
    copy = self.clone
    if degrees == 90
      # Passes Through all Pixels on Dummy Bitmap
      (0...self.height).each {|i| (0...self.width).each {|j|
          self.set_pixel(width - i - 1, j, copy.get_pixel(j, i))}}
    elsif degrees == 180
      (0...self.height).each {|i| (0...self.width).each {|j|
          self.set_pixel(width - j - 1, height - i - 1, copy.get_pixel(j, i))} }      
    elsif degrees == 270
      (0...self.height).each {|i| (0...self.width).each {|j|
          self.set_pixel(i, height - j - 1, copy.get_pixel(j, i)) } }
    end
    @orientation = (@orientation + degrees) % 360
  end
  #--------------------------------------------------------------------------
  # ? erase
  #--------------------------------------------------------------------------
  def erase(*args)
    case args.size
    when 1 then fill_rect( args[0], Color.new(0, 0, 0, 0))
    when 4 then fill_rect(Rect.new(*args), Color.new(0, 0, 0, 0))
    end
  end
end
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================
class Window_Base
  #--------------------------------------------------------------------------
  # * Check Color
  #     color : color to check
  #--------------------------------------------------------------------------
  def check_color(color)
    if color.type == Color
      # already a Color object
      return color
    elsif color[0].chr == "#"
      # specified as hexadecimal
      r = color[1..2].hex
      g = color[3..4].hex
      b = color[5..6].hex
      return Color.new(r,g,b)
    else
      # specified as integer (0-7)
      color = color.to_i if color
      if color && color >= 0 && color <= 7
        return text_color(color)
      end
    end
    return normal_color
  end
end
#==============================================================================
# ** Window_InputNumber
#------------------------------------------------------------------------------
#  This window is for inputting numbers, and is used within the
#  message window.
#==============================================================================
class Window_InputNumber < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     digits_max : digit count
  #--------------------------------------------------------------------------
  def initialize(digits_max)
    @character_array = get_characters
    @digits_max = digits_max
    @letter_array = [0] * @digits_max
    super(0, 0, cursor_width * @digits_max + 32, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z += 9999
    self.opacity = 0
    @index = 0
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Get Characters
  #--------------------------------------------------------------------------
  def get_characters
    character_array = case $game_temp.input_type.to_s.downcase
    when 'default',''       then ('0'..'9').to_a
    when 'binary'           then ["0","1"]
    when 'hexa'             then [('0'..'9'),('A'..'F')].collect! {|i| i.to_a}
    when 'upcase_letters'   then [('A'..'Z')," "].collect! {|i| i.to_a}
    when 'downcase_letters' then [('a'..'z')," "].collect! {|i| i.to_a}
    when 'all_letters'      then [('A'..'Z'),('a'..'z')," "].map! {|i| i.to_a}
    when 'all_characters'   then [('A'..'Z'),('a'..'z'),('0'..'9'),
                                  "+","-","*","/","!","#","$","%","&",
                                  "@",".",",","-"," "].collect! {|i| i.to_a}
    # when...
    end
    return (character_array || ['-']).flatten
  end
  #--------------------------------------------------------------------------
  # * Set cursor_width
  #--------------------------------------------------------------------------
  def cursor_width
    unless @cursor_width
      dummy_bitmap = Bitmap.new(32, 32)
      for i in 0...@character_array.size
        letter_size = dummy_bitmap.text_size(@character_array[i]).width + 8
        @cursor_width = [@cursor_width, letter_size].max
      end
      dummy_bitmap.dispose
    end
    @cursor_width
  end
  #--------------------------------------------------------------------------
  # * Get Letter
  #--------------------------------------------------------------------------
  def letter(index)
    return @character_array[@letter_array[index]]
  end
  #--------------------------------------------------------------------------
  # * Increase Letter Array
  #--------------------------------------------------------------------------
  def increase_letter_array(index)
    @letter_array[index] = (@letter_array[index] + 1) % @character_array.size
  end
  #--------------------------------------------------------------------------
  # * Decrease Letter Array
  #--------------------------------------------------------------------------
  def decrease_letter_array(index)
    @letter_array[index] = (@letter_array[index] - 1) % @character_array.size
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    self.cursor_rect.set(@index * @cursor_width, 0, @cursor_width, 32)
  end  
  #--------------------------------------------------------------------------
  # * Get Number
  #--------------------------------------------------------------------------
  def number
    string  = (0...@digits_max).collect {|i| letter(i)}.join
    integer = string.to_i
    @number = sprintf('%0*d',@digits_max,integer) == string ? integer : string
  end
  #--------------------------------------------------------------------------
  # * Set Number
  #     number : new number
  #--------------------------------------------------------------------------
  def number=(number)
    if (array = number.to_s.scan(/./)).size < @digits_max
      array.unshift(@character_array[0]) until array.size == @digits_max 
    end
    @digits_max.times do |i|
      (@character_array.size + 1).times do |j|
        array[i] == @character_array[j] && @letter_array[i] = j
      end
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if Input.repeat?(Input::UP) or Input.repeat?(Input::DOWN)
      $game_system.se_play($data_system.cursor_se)
      increase_letter_array(@index) if Input.repeat?(Input::UP)
      decrease_letter_array(@index) if Input.repeat?(Input::DOWN)
      refresh
    end
    if Input.repeat?(Input::RIGHT) or Input.repeat?(Input::LEFT)
      if @digits_max >= 2
        $game_system.se_play($data_system.cursor_se)
        @index = (@index + 1) % @digits_max if Input.repeat?(Input::RIGHT)
        @index = (@index - 1) % @digits_max if Input.repeat?(Input::LEFT)
      end
    end
    if Input.trigger?(Input::B)
      (@letter_array[@index] = 0) &&  refresh
    end
    update_cursor_rect
  end 
  #--------------------------------------------------------------------------
  # * Set Font
  #--------------------------------------------------------------------------
  def set_font(fname, fsize, fcolor)
    return if fname == nil && fsize == nil && fcolor == nil
    # Calculate cursor width from number width
    dummy_bitmap = Bitmap.new(32, 32)
    dummy_bitmap.font.name = fname
    dummy_bitmap.font.size = fsize
    @cursor_width = dummy_bitmap.text_size('0').width + 8
    dummy_bitmap.dispose
    self.width = @cursor_width * @digits_max + 32
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name  = fname
    self.contents.font.size  = fsize
    self.contents.font.color = check_color(fcolor)
    refresh
    update_cursor_rect
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    #self.contents.font.color = normal_color
    @digits_max.times do |i|
      contents.draw_text(i*@cursor_width,0,@cursor_width,32,letter(i),1)
    end
  end
end

#==============================================================================
# ** AnimationSprite
#------------------------------------------------------------------------------
# Created by ThallionDarkshine 
#  
#==============================================================================
class AnimationSprite < Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(type, x, y, z, rects, src_bitmap)
    super()
    @old_x, @old_y = x, y
    @type = type
    rects.compact!
    rects.delete_if { |rect| rect.width == 0 or rect.height == 0 }
    ry = rects.min { |i, e| i.y <=> e.y }.y
    rx = rects.min { |i, e| i.x <=> e.x }.x
    h = rects.max { |i, e| i.y + i.height <=> e.y + e.height }
    h = h.y + h.height - ry
    w = rects.max { |i, e| i.x + i.width <=> e.x + e.width }
    w = w.x + w.width - rx
    self.x, self.y, self.z = x + rx, y + ry, z
    self.ox, self.oy = w / 2, h / 2
    self.x += ox
    self.y += oy
    self.bitmap = Bitmap.new(w, h)
    self.bitmap.font.name  = src_bitmap.font.name
    self.bitmap.font.size  = src_bitmap.font.size
    self.bitmap.font.color = src_bitmap.font.color
    rects.each { |rect|
      bitmap.blt(rect.x - rx, rect.y - ry, src_bitmap, rect)
      src_bitmap.fill_rect(rect, Color.new(0, 0, 0, 0)) }
    @frames = 0
    @fplus = 1
    case @type
    when 4:
      @shake = [0, 0]
      @shaked = 1
    when 6:
      @frames = -40
    when 7:
      @frames = 2
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update(x, y)
    return if self.disposed?
    if x != @old_x or y != @old_y
      repos(x, y)
    end
    @frames += @fplus
    case @type
    when 1:
      z = 1.0 + @frames * 0.1 / 20
      @fplus = -1 if @frames == 20
      @fplus = 1 if @frames == 0
      self.zoom_x = z
      self.zoom_y = z
    when 2:
      a = @frames * 5.0 / 12
      @fplus = -1 if @frames == 12
      @fplus = 1 if @frames == -12
      self.angle = a
    when 3:
      z = 1.0 - @frames * 0.1 / 20
      @fplus = -1 if @frames == 20
      @fplus = 1 if @frames == 0
      self.zoom_x = z
      self.zoom_y = z
    when 4:
      shake_power = 1
      shake_speed = 10
      delta = (shake_power * shake_speed * @fplus) / 15.0 + rand(3) - 1
      @shake[0] += delta
      if @shake[0] > shake_power
        @fplus = -1
      end
      if @shake[0] < - shake_power
        @fplus = 1
      end
      delta = (shake_power * shake_speed * @shaked) / 15.0 + rand(3) - 1
      @shake[1] += delta
      if @shake[1] > shake_power
        @shaked = -1
      end
      if @shake[1] < - shake_power
        @shaked = 1
      end
      self.ox = self.bitmap.width / 2 + @shake[0]
      self.oy = self.bitmap.height / 2 + @shake[1]
    when 5:
      amnt = 5
      amnt *= Math.sin(Math::PI * @frames / 30.0)
      self.oy = self.bitmap.height / 2 + amnt
    when 6:
      if @frames < 0
        a = 255 + @frames * 255 / 40
        self.color.set(255, 0, 0, a)
        return
      end
      r = g = b = 0
      tmp = (@frames % 360) * 255 / 360
      while tmp < 0
        tmp += 255
      end
      if tmp < 85
        g = tmp * 3
        r = (85 - tmp) * 3
      elsif tmp < 170
        b = (tmp - 85) * 3
        g = (170 - tmp) * 3
      else
        r = (tmp - 170) * 3
        b = (255 - tmp) * 3
      end
      self.color.set(r, g, b)
    when 7:
      amnt = 10
      amnt *= Math.sin(Math::PI * @frames / 30.0).abs
      self.oy = self.bitmap.height / 2 + amnt - 5
    when 8:
      self.opacity = 255 - 170 * @frames / 20
      @fplus = -1 if @frames == 20
      @fplus = 1 if @frames == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Repos
  #--------------------------------------------------------------------------
  def repos(x, y)
    self.x += x - @old_x
    self.y += y - @old_y
    @old_x, @old_y = x, y
  end
end

#==============================================================================
# ** AnimationLetters
#------------------------------------------------------------------------------
#  Created by ThallionDarkshine
#  
#==============================================================================
class AnimationLetters
  #--------------------------------------------------------------------------
  # * Define Method
  #--------------------------------------------------------------------------
  define_method(:dispose) {@sprites.each {|i|[i.bitmap,i].each{|j|j.dispose}}}
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(type, x, y, z, rects, src_bitmap)
    @old_x, @old_y = x, y
    @type = type
    @sprites = []
    @data = []
    tmp_data = get_tmp_data(type, rects.length)
    rects.each { |rect|
      sprite = Sprite.new
      sprite.x, sprite.y, sprite.z = x + rect.x, y + rect.y, z
      sprite.bitmap = Bitmap.new(rect.width, rect.height)
    
      sprite.bitmap.font.name  = src_bitmap.font.name
      sprite.bitmap.font.size  = src_bitmap.font.size
      sprite.bitmap.font.color = src_bitmap.font.color
    
      sprite.bitmap.blt(0, 0, src_bitmap, rect)
      sprite.ox, sprite.oy = rect.width / 2, rect.height / 2
      sprite.x += sprite.ox
      sprite.y += sprite.oy
      src_bitmap.fill_rect(rect, Color.new(0, 0, 0, 0))
      @sprites.push(sprite)
      @data.push(get_data(type, tmp_data)) }
    case @type
    when 4:
      @frames = -40
    else
      @frames = 0
    end
    @fplus = 1
  end
  #--------------------------------------------------------------------------
  # * Get Temporary Data
  #--------------------------------------------------------------------------
  def get_tmp_data(type, length)
    case type
    when 1, 5, 7:
      data = Array.new(length) { |i| i }
      @duration = length * 31
      @no_end = true
    when 2, 6, 8:
      len = (length / 2.0).floor
      data = Array.new(len) { |i| i }
      data = data.concat(data.clone)
      if len % 2 == 1
        data.push(rand(len))
      end
      @duration = len * 31
      @no_end = true
    when 9, 10:
      data = Array.new(length) { |i| i }
    when 11, 12:
      tmp = Array.new(length) { |i| i }
      data = []
      length.times {
        ind = rand(tmp.length)
        data.push(tmp[ind])
        tmp.delete_at(ind)  }
    else
      data = []
    end
    data
  end
  #--------------------------------------------------------------------------
  # * Get Data
  #--------------------------------------------------------------------------
  def get_data(type, tmp_data)
    data = {}
    case type
    when 1, 2, 5, 6, 7, 8:
      tmp = rand(tmp_data.length)
      data[:start] = (tmp_data[tmp] || 0) * 31 + rand(11) - 5
      data[:middle] = data[:start] + 15
      while data[:start] < 0
        data[:start] += @duration
      end
      data[:end] = (data[:middle] + 15) % @duration
      tmp_data.delete_at(tmp)
    when 4:
      data[:hue] = rand(255)
      data[:mod] = rand(5) - 2
      while data[:mod] == 0
        data[:mod] = rand(5) - 2
      end
    when 9, 10, 11, 12:
      data[:end] = false
      len = tmp_data.length
      ind = tmp_data.shift
      len += ind
      data[:offset] = -ind * Math::PI / len
    end
    data
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update(x, y)
    return if @sprites.any? { |i| i.disposed? }
    repos(x, y) if x != @old_x or y != @old_y
    @frames += @fplus
    case @type
    when 1, 2:
      @frames %= @duration
      @sprites.each_with_index { |sprite, i|
        data = @data[i]
        cur_frames = @frames
        start = data[:start]
        middle = data[:middle]
        endf = data[:end]
        while endf < start
          endf += @duration
        end
        while middle < start
          middle += @duration
        end
        while cur_frames < start
          cur_frames += @duration
        end
        while cur_frames > endf
          cur_frames -= @duration
        end
        while (cur_frames - start) > @duration
          cur_frames -= @duration
        end
        while (start - cur_frames) > @duration
          cur_frames += @duration
        end
        if cur_frames.between?(start, middle)
          @no_end = false
          z = 1.0 + (cur_frames - start) * 0.5 / (middle - start)
          sprite.zoom_x = sprite.zoom_y = z
        elsif cur_frames.between?(middle, endf) and !@no_end
          z = 1.0 + (endf - cur_frames) * 0.5 / (endf - middle)
          sprite.zoom_x = sprite.zoom_y = z
        else
          sprite.zoom_x = sprite.zoom_y = 1.0
        end
        mod = rand(5) - 2
        @data[i][:start] += mod
        @data[i][:middle] += mod
        @data[i][:end] += mod }
    when 3:
      a = @frames * 10.0 / 12
      @fplus = -1 if @frames == 30
      @fplus = 1 if @frames == -30
      @sprites.each { |i| i.angle = a }
    when 4:
      if @frames < 0
        a = 255 + @frames * 255 / 40
        @sprites.each_with_index { |sprite, i|
          @data[i][:hue] += @data[i][:mod]
          color = get_color(@data[i][:hue])
          color.alpha = a
          sprite.color = color   }
        return
      end
      @sprites.each_with_index { |sprite, i|
        @data[i][:hue] += @data[i][:mod]
        color = get_color(@data[i][:hue])
        sprite.color = color  }
    when 5, 6:
      @frames %= @duration
      @sprites.each_with_index { |sprite, i|
        data = @data[i]
        cur_frames = @frames
        start = data[:start]
        middle = data[:middle]
        endf = data[:end]
        while endf < start
          endf += @duration
        end
        while middle < start
          middle += @duration
        end
        while cur_frames < start
          cur_frames += @duration
        end
        while cur_frames > endf
          cur_frames -= @duration
        end
        while (cur_frames - start) > @duration
          cur_frames -= @duration
        end
        while (start - cur_frames) > @duration
          cur_frames += @duration
        end
        if cur_frames.between?(start, middle)
          @no_end = false
          sprite.opacity = 255 - (cur_frames - start) * 170 / (middle - start)
        elsif cur_frames.between?(middle, endf) and !@no_end
          sprite.opacity = 255 - (endf - cur_frames) * 170 / (endf - middle)
        else
          sprite.opacity = 255
        end
        mod = rand(5) - 2
        @data[i][:start] += mod
        @data[i][:middle] += mod
        @data[i][:end] += mod  }
    when 7, 8:
      @frames %= @duration
      @sprites.each_with_index { |sprite, i|
        data = @data[i]
        cur_frames = @frames
        start = data[:start]
        middle = data[:middle]
        endf = data[:end]
        while endf < start
          endf += @duration
        end
        while middle < start
          middle += @duration
        end
        while cur_frames < start
          cur_frames += @duration
        end
        while cur_frames > endf
          cur_frames -= @duration
        end
        while (cur_frames - start) > @duration
          cur_frames -= @duration
        end
        while (start - cur_frames) > @duration
          cur_frames += @duration
        end
        if cur_frames.between?(start, middle)
          @no_end = false
          z = 1.0 - (cur_frames - start) * 0.5 / (middle - start)
          sprite.zoom_x = sprite.zoom_y = z
        elsif cur_frames.between?(middle, endf) and !@no_end
          z = 1.0 - (endf - cur_frames) * 0.5 / (endf - middle)
          sprite.zoom_x = sprite.zoom_y = z
        else
          sprite.zoom_x = sprite.zoom_y = 1.0
        end
        mod = rand(5) - 2
        @data[i][:start] += mod
        @data[i][:middle] += mod
        @data[i][:end] += mod   }
    when 9, 11:
      @sprites.each_with_index { |sprite, i|
        data = @data[i]
        mod = 10 * Math.sin(Math::PI * @frames / 45.0 + data[:offset]).abs - 5
        mod2 = 10 * Math.sin(Math::PI * (@frames + 1) / 45.0 + data[:offset]).abs - 5
        if mod > 0 and mod <= 10 * Math.sin(Math::PI * 6 / 30.0).abs - 5 and mod2 > 0
          @data[i][:end] = true
        else
          next unless @data[i][:end]
        end
        sprite.oy = sprite.bitmap.height / 2 + mod  }
    when 10, 12:
      @sprites.each_with_index { |sprite, i|
        data = @data[i]
        mod = 5 * Math.sin(Math::PI * @frames / 30.0 + data[:offset])
        mod2 = 5 * Math.sin(Math::PI * (@frames + 1) / 30.0 + data[:offset])
        #p 10 * Math.sin(Math::PI * 2 * 3 / 30.0) - 5
        #p mod
        if mod > 0 and mod <= 5 * Math.sin(Math::PI * 6 / 30.0) and mod2 > 0
          @data[i][:end] = true
        else
          next unless @data[i][:end]
        end
        sprite.oy = sprite.bitmap.height / 2 + mod  }
    end
  end
  #--------------------------------------------------------------------------
  # * Get Color
  #--------------------------------------------------------------------------
  def get_color(hue)
    r = g = b = 0
    tmp = hue % 255
    while tmp < 0
      tmp += 255
    end
    if tmp < 85
      g = tmp * 3
      r = (85 - tmp) * 3
    elsif tmp < 170
      b = (tmp - 85) * 3
      g = (170 - tmp) * 3
    else
      r = (tmp - 170) * 3
      b = (255 - tmp) * 3
    end
    return Color.new(r, g, b)
  end
  #--------------------------------------------------------------------------
  # * Opacity 
  #--------------------------------------------------------------------------
  def opacity=(v) @sprites.each { |i| i.disposed? || i.opacity = v }  end  
  #--------------------------------------------------------------------------
  # * Repos
  #--------------------------------------------------------------------------
  def repos(x, y)
    @sprites.reject! { |i| i.disposed? }
    @sprites.each { |i| (i.x += x - @old_x)  && (i.y += y - @old_y) }
    @old_x, @old_y = x, y
  end
end

$multiple_message_windows = {}
$multiple_message_windows['ver'] = 1.6