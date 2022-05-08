#-----------------------------------------
#---                                   ---
#---    Multiple Message Windows       ---
#---- HERETIC REVISION + jiggly edits  ---
#-------     Version 1.6      ------------
#-------                      ------------
#-----------------------------------------
#
# NO LONGER REQUIRES SDK.  It will work fine with or without the SDK now!
#
# *NOTE* - This script should go ABOVE the CATERPILLAR SCRIPT
#
#
#
#==============================================================================
# ** Multiple Message Windows (SDK and Non SDK Bundle!)
#------------------------------------------------------------------------------
# Wachunga
# 1.5
# 2006-11-17
#==============================================================================

=begin
  Full list of options:

  (Note that all are case *insensitive*.)
  
  =============================================================================
   Local (specified in message itself and resets at message end)
  =============================================================================
  - \L = letter-by-letter mode toggle
  - \A = auto-pause mode toggle for ,.?! characters
  - \S[n] = set speed at which text appears in letter-by-letter mode
  - \D[n] = set delay (in frames) before next text appears
  - \.    = adds a short delay (new!)
  - \P[n] = position message over event with id n
            * use n=0 for player
            * in battle, use n=a,b,c,d for actors (e.g. \P[a] for first actor)
              and n=1,...,n for enemies (e.g. \P[1] for first enemy)
              where order is actually the reverse of troop order (in database)
  - \Na[name]       = display message name!!!!
  - \P[Cn] = Tie-In with Caterpillar.  Positions Message over Cat Actor
              in n Position of Caterpillar.  1 for First Cat Actor, etc...
            * example: \P[C2] for 2nd Cat Actor, or 3rd Actor in Caterpillar
            * n excludes Player
  - \P = position message over current event (default for floating messages)
  - \^ = message appears directly over its event
  - \v = message appears directly below its event
  - \< = message appears directly to the left of its event
  - \> = message appears directly to the right of its event
  - \$ = message appears above actor unless facing up, then appears below  
  - \% = message appears behind actor relative to direction
  - \B = bold text
  - \I = italic text
  - \C[#xxxxxx] = change to color specified by hexadecimal (eg. ffffff = white)
  - \C = change color back to default
  - \! = message autoclose
  - \? = wait for user input before continuing
  - \+ = make message appear at same time as preceding one
         * note: must be at the start of message to work
  - \* = displays the next message immediately if available
         * note: next event command must be text, choice, or number input
  - \@ = thought balloon
  - \N[En] = display name of enemy with id n (note the "E")
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
  NEW!!
  - \PIC[n] = display a picture

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
    
    You can disable the "Auto Foot Forward Off" feature by adding \no_ff
    to an Event's Name.  IE: Bill\no_ff
 
  ---- Resets ----
  
  These occur when the player walks away from a Speaking NPC
  
  Put these strings in an Event's Name to use!
           
  \no_ff - If you don't want a specific event to be RESET, you can add
           \no_ff to the Event's Name.  EV041\no_ff and Event will
           not be affected by Foot Forward Reset when Player Walks off screen
           
  \no_mc - No Move Continue - In the event you dont want a specific event to
           continue its Move Route from where it left off when it is moved
           off-screen, put \no_mc in the Event's Name.  I.E. EV12\no_mc    

  These are, of course, in addition to the default options:
  - \V[n]  = display value of variable n
  - \V[Tn] = display value of text variable n
  - \N[n] = display name of actor with id n
  - \C[n] = change color to n
  - \G  = display gold window - Screen Opposite of Player's Position
  - \G+ = display gold window at the Top of the Screen
  - \G- = display gold window at the Bottom of the Screen
  - \\ = show the '\' character
  
  New in 1.6
  
  * \f[face_image] = display faceset image (80x80 picture, broken)
  
  
  - \xy[x,y] = position message at specific x,y coordinates (PLANNED)
  
  ---- Tip: you can set an event's xy coords and then target that event 
  if you really need to use this feature before it's coded
=end

#------------------------------------------------------------------------------
# * SDK Log Script
#------------------------------------------------------------------------------
#SDK.log('Multiple Message Windows', 'Wachunga', 1.5, '2006-11-17')

#------------------------------------------------------------------------------
# * Begin SDK Enabled Check
#------------------------------------------------------------------------------
#if SDK.state('Multiple Message Windows') == true

#==============================================================================
# Settings
#==============================================================================

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
  FILENAME_THOUGHT_WINDOWSKIN = "paperskinx2.png" 
  
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
  THOUGHT_FONT_COLOR = "#000000"
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

  def initialize
    # whether or not messages appear one letter at a time
    @letter_by_letter = true
    # note: can also change within a single message with \L

    # the default speed at which text appears in letter-by-letter mode
    @text_speed = 0
    # note: can also change within a single message with \S[n]
    
    # this is defined as a user setting that can be changed during gameplay
    @text_speed_player = 0
    
    # Heretic's Notes:
    #
    # This is a placeholder for the default user setting in the event that
    # a character needs to speak at a different speed without destroying
    # the users preferences...
    # Call by message.text_speed = message.text_speed_player
    # YOU HAVE TO ENTER A NEWLINE (PRESS ENTER) BEFORE 2ND VARIABLE
    # DUE TO WRAPPING TEXT BUG WITH SCRIPTS IN EVENT SCRIPTS
    # Otherwise you get errors
    
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
    @font_name = $defaultfont
    @font_size = 20
    @font_color = nil
    


    # pause on these characters ,.?!
    # pause for delay number of frames if this is true, toggle with \A in Text
    @auto_comma_pause = true
    # inserts this number of frames to ,!.? characters, nil for off    
    @auto_comma_delay = 5
    # Skip Commas, Exclamation Points, Periods, and Question Marks when Skipped
    @comma_skip_delay = true

    # designers can allow or disallow choices, why not number windows too?
    @allow_cancel_numbers = true
    # speeds up text display a bit so players dont get bored waiting
    @update_text_while_fading = true
    
    # reset foot_forwad stance on auto-close due to Event going off-screen
    @auto_ff_reset = true
    # continues Move Route when NPC is speaking and goes off screen
    @auto_move_continue = true
    
    # exit if distance from speaker is too great
    @dist_exit = false
    # distance player can be before window closes
    @dist_max = 99999
    
    # allow message windows to float off screen instead of flipping
    @allow_offscreen = false
    
    # reposition the message window if the speaker turns
    @reposition_on_turn = true
    
    # if Msg Windows were Reoriented by Player Movement, sticky to that spot
    @sticky = true

    # Sounds While Speaking Related
    @sound = true                       # Enables or Disables Text Sounds  
    @sound_audio = 'coda'          # Audio SE (in DB) to play
    @sound_volume = 80                     # Text Sound Volume
    @sound_pitch = 100                      # Text Sound Pitch
    @sound_pitch_range = 10                # How Much to vary the Pitch
    @sound_vary_pitch = true               # Whether to Vary the Pitch or not
    @sound_frequency = 3                   # Plays a sound this many letters

    # Save these settings - DONT EDIT
    save_sound_settings
  end
  
  attr_accessor :move_during                # Walk around while speaking
  attr_accessor :letter_by_letter           # Display msg letter by letter
  attr_accessor :text_speed                 # How fast text is displayed
  attr_accessor :text_speed_player          # Saves Player Preference
  attr_accessor :skippable                  # Msg can be skipped
  attr_accessor :resize                     # Resizes Message Window
  attr_accessor :floating                   # Messages are Speech Bubbles
  attr_accessor :autocenter                 # Centers Text in Window
  attr_accessor :show_tail                  # Speech Bubble Tail
  attr_accessor :show_pause                 # Shows Icon to press a button
  attr_accessor :location                   # Relative to Speaker Top Bottom etc
  attr_accessor :font_name                  # Name of Font to be used
  attr_accessor :font_size                  # Size of Font
  attr_accessor :font_color                 # Color of Font
  attr_accessor :auto_comma_pause           # Pauses on these characters ?,.!
  attr_accessor :auto_comma_delay           # How many Frames to Delay
  attr_accessor :comma_skip_delay           # Ignore Auto Comma Pause on Skip
  attr_accessor :allow_cancel_numbers       # Allows cancelling Number Input
  attr_accessor :auto_ff_reset              # Foot Forward Animation reset
  attr_accessor :auto_move_continue         # Continues Previous Move Route  
  attr_accessor :update_text_while_fading   # Update Text while Fading In
  attr_accessor :dist_exit                  # Auto Close Window if true
  attr_accessor :dist_max                   # Dist Max Player from Speaker
  attr_accessor :allow_offscreen            # Allows Msg Windows Off Screen
  attr_accessor :reposition_on_turn         # Reposition Windows if Speaker Turn
  attr_accessor :sticky                     # Msgs "Prefer" Sticky Locations
  # Sound Related
  attr_accessor :sound                      # Enables or Disables Text Sounds  
  attr_accessor :sound_audio                # Audio SE (in DB) to play
  attr_accessor :sound_volume               # Text Sound Volume
  attr_accessor :sound_pitch                # Text Sound Pitch
  attr_accessor :sound_pitch_range          # How Much to vary the Pitch
  attr_accessor :sound_vary_pitch           # Whether to Vary the Pitch or not
  attr_accessor :sound_frequency            # Plays a sound this many letters
  #Name box (NEW!!)
  attr_accessor :name_box_skin
  attr_accessor :name_box_x_offset
  attr_accessor :name_box_y_offset 
  attr_accessor :name_box_width
  attr_accessor :name_box_height
  attr_accessor :name_font_size
  attr_accessor :name_box_text_color
  
    #name box stuff
    # go to name_sprite_position insterad, 
    #this is probably obsolete
 @name_box_x_offset = 0       #Choose the X axis offset of the name bos. default= 0
 @name_box_y_offset = -10    #Choose the Y axis offset of the name bos. default= -10
 @name_box_width = 30           #Choose the width of the Name Box. default= 8  
 @name_box_height = 28        #Choose the height of the Name Box. default= 26
 @name_font_type = $defaultfont #Choose the Font Name (Case Sensitive) for Name Box
 @name_font_size = 20            #Choose the deafault Font Size for Name Box text
 #@name_box_text_color= 3        #Choose the Text Color of the Name Box
 @name_box_skin = "mainskin"       #Choose the WindowSkin for the Name Box
 


  # Used for storing the Default Sound Configuration
  def save_sound_settings
    # Allows Saving ONCE
    return if @default_sounds_audio
    # Stores the Default Values
    @default_sound_audio = @sound_audio
    @default_sound_volume = @sound_volume
    @default_sound_pitch = @sound_pitch
    @default_sound_pitch_range = @sound_pitch_range
    @default_sound_vary_pitch = @sound_vary_pitch
    @default_sound_frequency = @sound_frequency
  end

  # Loads the Default Sound Settings
  def load_sound_settings
    # If settings have not been saved
    return if not @default_sound_audio
    
    # Default System Sound Configuration
    @sound_audio = @default_sound_audio
    @sound_volume = @default_sound_volume
    @sound_pitch = @default_sound_pitch
    @sound_pitch_range = @default_sound_pitch_range
    @sound_vary_pitch = @default_sound_vary_pitch
    @sound_frequency = @default_sound_frequency
  end
end

#==============================================================================
# Private constants (don't edit)
#==============================================================================

  # used for message.location
  TOP = 8
  BOTTOM = 2
  LEFT = 4
  RIGHT = 6

#------------------------------------------------------------------------------

class Game_Character
  attr_accessor :move_route              # Character's Move Route  
  attr_accessor :direction               # Used for changing bubble orientation
  attr_accessor :direction_fix           # Character locked facing a direction 
  attr_accessor :walk_anime              # Character steps when moves
  attr_accessor :step_anime              # Character is Stepping
  attr_accessor :erased                  # Erased Flag
  attr_accessor :original_move_speed     # Characters original Move Speed
  attr_accessor :original_move_frequency # Characters original Move Speed
  attr_accessor :no_ff                   # Prevents Auto Foot Forward Off
  attr_accessor :no_mc                   # No 'M'ove Continue
  attr_accessor :dist_kill               # Closes ALL windows if Player X Dist
  
  unless self.method_defined?('heretic_char_mmw_initialize')
    alias heretic_char_mmw_initialize initialize
  end
  
  def initialize
    # Run Original
    heretic_char_mmw_initialize        
    # Add New Properties
    @original_move_speed = 4
    @original_move_frequency = 6    
    @no_ff = nil
    @no_mc = nil
    @dist_kill = nil
    # Game Player - Sticky
    if self.is_a?(Game_Player)
      @sticky = false
    end
  end
end
  
class Game_Event < Game_Character
  unless self.method_defined?('heretic_event_mmw_initialize')
    alias heretic_event_mmw_initialize initialize
  end

  def initialize(map_id, event, *args)  
    heretic_event_mmw_initialize(map_id, event, *args)
    check_no_auto_ff(event)
    check_no_mc(event)
  end

  # These occur when Windows are Auto Closed for going Off Screen
  
  # Check for no Auto Foot Forward Off - In the event of Animation Problems...
  def check_no_auto_ff(event)
    event.name.gsub(/\\no_ff/i) {@no_ff = true}
  end

  # Check for no MC - 'M'ove 'C'ontinue - Restores Original Move Route...
  def check_no_mc(event)
    event.name.gsub(/\\no_mc/i) {@no_mc = true}
  end
end
  
class Window_Message < Window_Selectable
  attr_accessor :choice_window     # Allows Multi Windows with Choice Selection
  
#==============================================================================
# Private constants (don't edit)
#==============================================================================

  # Characters that produce Text Sounds - a to z and 0 thru 9
  CHARACTERS = [('a'..'z'),('0'..'9')].map{|i| i.to_a}.flatten

#------------------------------------------------------------------------------  


  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------

  def initialize(msgindex = 0) 
    super(80, 304, 480, 160)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = false
    self.z = 9000 + msgindex * 5 # permits messages to overlap legibly
    @counter = 2
    #how many frames long is your fire animation
    @fireframes = 3
    @fade_in = false
    @fade_out = false
    @contents_showing = false
    @cursor_width = 0
    self.active = false
    self.index = -1
    @msgindex = msgindex
    @tail = Sprite.new
    @tail.bitmap =
      if @msgindex == 0
        RPG::Cache.windowskin(FILENAME_SPEECH_TAIL)
      else
        # don't use cached version or else all tails
        # are rotated when multiple are visible at once
        Bitmap.new("Graphics/Windowskins/"+FILENAME_SPEECH_TAIL)
      end
    # keep track of orientation of tail bitmap
    if @tail.bitmap.orientation == nil
      @tail.bitmap.orientation = 0
    end
    # make origin the center, not top left corner
    @tail.ox = @tail.bitmap.width / 2
    @tail.oy = @tail.bitmap.height / 2
    # Removed due to Tail Overlap on Secondary Message Bubbles
    @tail.z = 3000
    
    # Increase Z Index
    #@tail.z = self.z + 4
    @tail.visible = false
    if $game_system.message.floating and $game_system.message.resize
      @windowskin = FILENAME_SPEECH_WINDOWSKIN
    else
      # use windowskin specified in database
      @windowskin = $game_system.windowskin_name
    end
    if $game_system.message.floating and $game_system.message.resize
      # if used as speech balloons, use constants
      @font_name = SPEECH_FONT_NAME
      @font_color = check_color(SPEECH_FONT_COLOR)
      @font_size = SPEECH_FONT_SIZE
    else
      # use defaults
      @font_name = Font.default_name
      @font_color = Font.default_color
      @font_size = Font.default_size
    end
    # override defaults if necessary
    if $game_system.message.font_name != nil
      @font_name = $game_system.message.font_name
    end
    if $game_system.message.font_color != nil
      @font_color = check_color($game_system.message.font_color)
    end
    if $game_system.message.font_size != nil
      @font_size = $game_system.message.font_size
    end
    @update_text = true
    @letter_by_letter = $game_system.message.letter_by_letter
    @text_speed = $game_system.message.text_speed
    # id of character for speech balloons
    @float_id = nil
    # location of box relative to speaker
    @location = $game_system.message.location
    # insert a pause for commas, periods and other special characters
    @auto_comma_pause = $game_system.message.auto_comma_pause
    @auto_comma_delay = $game_system.message.auto_comma_delay
    # allows number windows to be cancelled    
    @allow_cancel_numbers = $game_system.message.allow_cancel_numbers
    # allows windows to update text while fading in
    @update_text_while_fading = $game_system.message.update_text_while_fading     
    # resets foot forward animation when off screen
    @auto_ff_reset = $game_system.message.auto_ff_reset
    # resets foot forward animation when off screen
    @auto_move_continue = $game_system.message.auto_move_continue
    # allows a specific window to be flagged if choices are displayed
    @choice_window = nil
    
    # Close a Window if distance from speaker is too great
    @dist_exit = $game_system.message.dist_exit
    # Maximum Distance player can be away from speaker before closing
    @dist_max = $game_system.message.dist_max

    # Sounds While Speaking Related
    @sound = $game_system.message.sound
    @sound_audio = $game_system.message.sound_audio
    @sound_volume = $game_system.message.sound_volume
    @sound_pitch = $game_system.message.sound_pitch
    @sound_pitch_range = $game_system.message.sound_pitch_range
    @sound_vary_pitch = $game_system.message.sound_vary_pitch
    @sound_frequency = $game_system.message.sound_frequency
    @sound_counter = 0
  end
  
  def dispose
    terminate_message
    # have to check all windows before claiming that no window is showing
    if $game_temp.message_text.compact.empty?
      $game_temp.message_window_showing = false
    end

    if @input_number_window != nil
      @input_number_window.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Terminate Message
  #--------------------------------------------------------------------------
  
  def terminate_message
    return if $game_temp.input_in_window == true
    self.active = false
    self.pause = false
    self.index = -1
    self.contents.clear
    # Clear showing flag
    @contents_showing = false

    # Clear variables related to text, choices, and number input
    @tail.visible = false
    # note that these variables are now indexed arrays
    $game_temp.message_text[@msgindex] = nil
    # Call message callback
    if $game_temp.message_proc[@msgindex] != nil
      # make sure no message boxes are displaying
      if $game_temp.message_text.compact.empty?
        $game_temp.message_proc[@msgindex].call
      end
      $game_temp.message_proc[@msgindex] = nil
    end
    self.choice_window = nil
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
  # * Refresh Message Window
  #--------------------------------------------------------------------------
  
  def refresh
    self.contents.clear
    @x = @y = 0 # now instance variables
    @float_id = nil
    @location = $game_system.message.location
    if $game_system.message.floating and $game_system.message.resize
      @windowskin = FILENAME_SPEECH_WINDOWSKIN
    else
      # use windowskin specified in database
      @windowskin = $game_system.windowskin_name
    end
    if $game_system.message.floating and $game_system.message.resize
      # if used as speech balloons, use constants
      @font_name = SPEECH_FONT_NAME
      @font_color = check_color(SPEECH_FONT_COLOR)
      @font_size = SPEECH_FONT_SIZE
    else
      # use default font
      @font_name = Font.default_name
      @font_color = Font.default_color
      @font_size = Font.default_size
    end
    # override font defaults
    if $game_system.message.font_name != nil
      @font_name = $game_system.message.font_name
    end
    if $game_system.message.font_color != nil
      @font_color = check_color($game_system.message.font_color)
    end
    if $game_system.message.font_size != nil
      @font_size = $game_system.message.font_size
    end
    @line_widths = nil
    @wait_for_input = false
    @tail.bitmap =
      if @msgindex == 0
        RPG::Cache.windowskin(FILENAME_SPEECH_TAIL)
      else
        Bitmap.new("Graphics/Windowskins/"+FILENAME_SPEECH_TAIL)
      end
    RPG::Cache.windowskin(FILENAME_SPEECH_TAIL)
    @tail.bitmap.orientation = 0 if @tail.bitmap.orientation == nil
    @text_speed = $game_system.message.text_speed
    @letter_by_letter = $game_system.message.letter_by_letter
    @auto_comma_pause = $game_system.message.auto_comma_pause
    @auto_comma_delay = $game_system.message.auto_comma_delay
    @comma_skip_delay = $game_system.message.comma_skip_delay
    @allow_cancel_numbers = $game_system.message.allow_cancel_numbers
    @auto_ff_reset = $game_system.message.auto_ff_reset
    @auto_move_continue = $game_system.message.auto_move_continue
    @update_text_while_fading = $game_system.message.update_text_while_fading
    @dist_exit = $game_system.message.dist_exit
    @dist_max = $game_system.message.dist_max 
    @dist_max = 1 if @dist_max < 1
    @auto_orient = nil
    @delay = @text_speed
    @player_skip = false
    # Sound Related    
    @sound = $game_system.message.sound
    @sound_volume = $game_system.message.sound_volume
    @sound_pitch = $game_system.message.sound_pitch
    @sound_pitch_range = $game_system.message.sound_pitch_range
    @sound_vary_pitch = $game_system.message.sound_vary_pitch
    @sound_frequency = $game_system.message.sound_frequency
    @sound_counter = 0    
    # End Sound Related
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
        @text.gsub!(/\\[V]\[[T]([0-9]+)\]/i) { $game_system.mmw_text[$1.to_i] }        
        @text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until @text == last_text
      @text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      # Change "\\\\" to "\000" for convenience
      @text.gsub!(/\\\\/) { "\000" }
      @text.gsub!(/\\[Gg][\+]/) { "\023" } # Gold Window at TOP
      @text.gsub!(/\\[Gg][\-]/) { "\024" } # Gold Window at Bottom
      @text.gsub!(/\\[Gg]/) { "\002" }  # Gold Window Auto, based on Player Loc

#=begin      
        #Dubealex's Choose Name Box Text Color (NEW)
   @text.gsub!(/\\[Zz]\[([0-9]+)\]/) do
   $game_system.message.name_box_text_color= $1.to_i #broken
   @text.sub!(/\\[Zz]\[([0-9]+)\]/) { "" }
   end
   #End new command
   
  name_window_set = false
  if (/\\[Nn][Aa]\[(.+?)\]/.match(@text)) != nil
    
    name_window_set = true
    name_text = $1
    @text.sub!(/\\[Nn][Aa]\[(.*?)\]/) { "" }
  end
if (/\\[Nn][Aa][Mm][Ee]\[(.+?)\]/.match(@text)) != nil
  #old style compatibility
    name_window_set = true
    name_text = $1
    @text.sub!(/\\[Nn][Aa][Mm][Ee]\[(.*?)\]/) { "" }
  end
    if name_window_set
    create_name_sprite(name_text) if name_text != ''
    #@name_window_text.z = self.z + 2
  end
#=end

      # display icon of item, weapon, armor or skill
      @text.gsub!(/\\[Ii]\[([IiWwAaSs][0-9]+)\]/) { "\013[#{$1}]" }
      # display name of enemy, item, weapon, armor or skill
      @text.gsub!(/\\[Nn]\[([EeIiWwAaSs])([0-9]+)\]/) do
        case $1.downcase
          when "e"
            entity = $data_enemies[$2.to_i]
          when "i"
            entity = $data_items[$2.to_i]
          when "w"
            entity = $data_weapons[$2.to_i]
          when "a"
            entity = $data_armors[$2.to_i]
          when "s"
            entity = $data_skills[$2.to_i]
        end
        entity != nil ? entity.name : ""
      end
      # display icon and name of item, weapon, armor or skill
      @text.gsub!(/\\[Ii]&[Nn]\[([IiWwAaSs])([0-9]+)\]/) do
        case $1.downcase
          when "e"
            entity = $data_enemies[$2.to_i]
          when "i"
            entity = $data_items[$2.to_i]
          when "w"
            entity = $data_weapons[$2.to_i]
          when "a"
            entity = $data_armors[$2.to_i]
          when "s"
            entity = $data_skills[$2.to_i]
        end
        entity != nil ? "\013[#{$1+$2}] " + entity.name : ""
      end      
      # display name of current map
      @text.gsub!(/\\[Mm][Aa][Pp]/) { $game_map.name }
      # change font color
      @text.gsub!(/\\[Cc]\[([0-9]+|#[0-9A-Fa-f]{6,6})\]/) { "\001[#{$1}]" }
      # return to default color
      @text.gsub!(/\\[Cc]/) { "\001" }
      # toggle letter-by-letter mode
      @text.gsub!(/\\[Ll]/) { "\003" }
      # toggle auto_comma_pause mode
      @text.gsub!(/\\[Aa]/) { "\016" }
      # trigger Foot Forward Animation
      @text.gsub!(/\\[Ff]\+/) { "\020" }
      # trigger Foot Forward Animation Alter Frame
      @text.gsub!(/\\[Ff]\*/) { "\022" }        
      # trigger Reset Foot Forward Animation
      @text.gsub!(/\\[Ff]\-/) { "\021" }        
      # change text speed (for letter-by-letter)
      @text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\004[#{$1}]" }
      # insert delay
      @text.gsub!(/\\[Dd]\[([0-9]+)\]/) { "\005[#{$1}]" }

      # insert delays for commas, periods, questions and exclamations
      @text.gsub!(/, /) { ", \015" }    # Comma with One Space
      @text.gsub!(/!  /) { "!  \015" }  # Exclamation Point with Two Spaces
      @text.gsub!(/\?  /) { "?  \015" } # Question Mark with Two Spaces
      @text.gsub!(/\.  /) { ".  \015" } # Period with Two Spaces
      @text.gsub!(/\\[.]/) { "\015" }    # the \. command
      
      # select an icon (unimplemented!)
      #@text.gsub!(/\\[Ii][Cc]\[]/) { "\025" } 
      
      # show a picture!
      @text.gsub!(/\\[Qq]\[([\w]+)\]/) { "\026[#{$1}]" } 
      #render fire
      @text.gsub!(/\\[Ff][Ii]/) { "\027" }
      
      @text.gsub!(/\\[Ff]\[(.+?)(?:,(\d+))?\]/) { "\028[#{$1}]" }
      #@text.gsub!(/\\[Nn][Aa]\[([0-9]+),([0-9]+)\]/) { "\029[#{$1},#{$2}]" }
      #display name BROKEN, PLEASE USE DUBEALEX VERSION
      #@text.gsub!(/\\[Nn]a\[(.+?)(?:(\d+))?\]/) { "\030[#{$1}]" } 
      #@text.gsub!(/\\[Nn][Aa]\[([\w]+)\]/) { "\030[#{$1}]" } 
      
      # self close message
      @text.gsub!(/\\[!]/) { "\006" }
      # wait for button input
      @text.gsub!(/\\[?]/) { "\007" }
      # bold
      @text.gsub!(/\\[Bb]/) { "\010" }
      # italic
      @text.gsub!(/\\[Ii]/) { "\011" }
      # add msg with \*
      @text.gsub!(/\\[*]/) { "\014" }      
      # thought balloon
      if @text.gsub!(/\\[@]/, "") != nil
        @windowskin = FILENAME_THOUGHT_WINDOWSKIN
        @font_name = THOUGHT_FONT_NAME
        @font_size = THOUGHT_FONT_SIZE
        @font_color = check_color(THOUGHT_FONT_COLOR)
        @tail.bitmap = 
          if @msgindex == 0
            RPG::Cache.windowskin(FILENAME_THOUGHT_TAIL)
          else
            Bitmap.new("Graphics/Windowskins/"+FILENAME_THOUGHT_TAIL)
          end
        @tail.bitmap.orientation = 0 if @tail.bitmap.orientation == nil
      end
      # Get rid of "\+" (multiple messages)
      @text.gsub!(/\\[+]/, "")
      # Get rid of "\*" (multiple messages)
      @text.gsub!(/\\[*]/, "")      
      # Get rid of "\\^", "\\v", "\\<", "\\>" (relative message location)
      if @text.gsub!(/\\\^/, "") != nil
        @location = 8
      elsif @text.gsub!(/\\[Vv]/, "") != nil
        @location = 2
      elsif @text.gsub!(/\\[<]/, "") != nil
        @location = 4
      elsif @text.gsub!(/\\[>]/, "") != nil
        @location = 6
      end
      # Get rid of "\\P" (position window to given character)
      if @text.gsub!(/\\[Pp]\[([0-9]+)\]/, "") != nil
        @float_id = $1.to_i
      elsif @text.gsub!(/\\[Pp]\[([a-zA-Z])\]/, "") != nil and
          $game_temp.in_battle
        @float_id = $1.downcase
        
      # Tie-In with Caterpillar, use \P[Cn] for a Cat Actor or Follower \P[C1]
      elsif @text.gsub!(/\\[Pp]\[[Cc]([0-9]+)\]/, "") != nil and
            !$game_temp.in_battle and
            Interpreter.method_defined?('get_cat_position_id')
            
        # This only works with Heretic's Caterpillar
        #CHANGE THIS
        if $1.to_i == 0
          @float_id = 0 # Player
        elsif $1.to_i > 0 and $1.to_i <= $game_system.caterpillar.actors.size
          # temporary shortuct to keep on one line
          s = $game_system.map_interpreter
          # Returns the Event ID of the Cat Actor in that position          
          @float_id = s.get_cat_position_id($1.to_i - 1)
        end        
        
      elsif @text.gsub!(/\\[Pp]/, "") != nil or
            ($game_system.message.floating and $game_system.message.resize) and
            !$game_temp.in_battle
        # Just assigns the Event ID of the \P[x] Event
        @float_id = $game_system.map_interpreter.event_id
      end
      # Orient to Behind Events Direction with \%
      if @text.gsub!(/\\[%]/, "") != nil and !$game_temp.in_battle and 
         $game_system.message.floating
        # Set Direction of Bubble based on Direction of Character
        d = (@float_id > 0) ?
            $game_map.events[@float_id].direction : $game_player.direction
        # Allows Window to Reorient if the Speaker Turns
        @auto_orient = 1
        # If Sticky is Disabled...
        if !$game_system.message.sticky
          # Unset any possible Stickys
          $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
          # Game Player Sticky
          if @float_id == 0 and not $game_player.sticky
            # Reset Game Player Preferred Location
            $game_player.preferred_loc = nil 
          end
        end
        if @float_id > 0 and $game_map.events[@float_id].preferred_loc and
           $game_map.events[@float_id].allow_flip
          # This just helps to keep the position the same
          @location = $game_map.events[@float_id].preferred_loc
        elsif @float_id == 0 and $game_player.preferred_loc and
              $game_player.allow_flip
          # Set Location to Players Preferred Location.
          @location = $game_player.preferred_loc
        else
          if d == 2
            @location = 8
            if @float_id == 0 and $game_player.sticky
              $game_player.preferred_loc = 8
            elsif @float_id and $game_system.message.sticky and 
               @float_id.is_a?(Numeric) and @float_id > 0
              $game_map.events[@float_id].preferred_loc = 8
            end
          elsif d == 4
            @location = 6
          elsif d == 6
            @location = 4
          elsif d == 8
            @location = 2
            if @float_id == 0 and $game_player.sticky
              $game_player.preferred_loc = 8
            elsif $game_system.message.sticky and 
              @float_id.is_a?(Numeric) and @float_id > 0
              $game_map.events[@float_id].preferred_loc = 2
            end
          else
            @location = 8
          end
        end
      end
      # Orient Above unless facing UP, then Down
      if @text.gsub!(/\\[\$]/, "") != nil and !$game_temp.in_battle and
         $game_system.message.floating
        # This Allows Top / Bottom Flipping if the Speaker Turns
        @auto_orient = 2
        d = (@float_id > 0) ?
            $game_map.events[@float_id].direction : $game_player.direction
        # Check for "Sticky" messages
        if !$game_system.message.sticky
          # Unset any possible Stickys
          $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
          if @float_id == 0 and not $game_player.sticky
            $game_player.preferred_loc = nil 
          end
        end
        # If the message got flipped due to Character Turning, then Prefer
        pl = (@float_id > 0) ? $game_map.events[@float_id].preferred_loc : 
             (@float_id == 0) ? $game_player.preferred_loc : nil
        if ((@float_id > 0 and $game_map.events[@float_id].allow_flip) or
           (@float_id == 0 and $game_player.allow_flip)) and
           (pl == 2 or pl == 8)
           
          # Set Location to the Preferred Location.  Only works if Triggered
          # Other Events are NOT included in this "Stickyness"
          @location = pl
        else
          # Orient by Direction
          case d            
          when 8
            @location = 2
          else
            @location = 8
          end
        end
        # Set Preferred Location for Sticky
        if $game_system.message.sticky
          # Set Sticky for Player
          if @float_id == 0 and $game_player.preferred_loc == nil and
                                $game_player.sticky
            # Set Sticky for Player, expires at end of Event Processing
            $game_player.preferred_loc = @location
          # Set Sticky for Event
          elsif @float_id > 0 and
                $game_map.events[@float_id].preferred_loc == nil
            # Set Sticky for Event, expires at end of Event Processing
            $game_map.events[@float_id].preferred_loc = @location
          end
        end        
      end         
      if $game_system.message.resize or $game_system.message.autocenter
        # calculate length of lines
        text = @text.clone
        temp_bitmap = Bitmap.new(1,1)
        temp_bitmap.font.name = @font_name
        temp_bitmap.font.size = @font_size
        @line_widths = [0,0,0,0]
        for i in 0..3
          line = text.split(/\n/)[3-i]
          if line == nil
            next
          end
          line.gsub!(/[\001-\007](\[[#A-Fa-f0-9]+\])?/, "")          
          line.gsub!(/\013\[[IiWwAaSs][0-9]+\]/, "\013")
          line.chomp.split(//).each do |c|
            
            
            # C for Characters in Size of Message Bubble
            
            case c
              when "\000"
                c = "\\"
              when "\010"
                # bold
                temp_bitmap.font.bold = !temp_bitmap.font.bold
                c = '' # Set character artifacts to a non character
                next
              when "\011"
                # italics
                temp_bitmap.font.italic = !temp_bitmap.font.italic
                c = '' # Set character artifacts to a non character
                next
              when "\013"
                # icon
                @line_widths[3-i] += 24
                next
              when "\014","\015","\016","\020","\021","\022","\023","\024"
                # Featres Heretic added, causes garbage to appear
                next
            end
            @line_widths[3-i] += temp_bitmap.text_size(c).width
          end
          if (3-i) >= $game_temp.choice_start
            # account for indenting
            @line_widths[3-i] += 8 unless $game_system.message.autocenter
          end
        end
        if $game_temp.num_input_variable_id > 0
          # determine cursor_width as in Window_InputNumber
          # (can't get from @input_number_window because it doesn't exist yet)
          cursor_width = temp_bitmap.text_size("0").width + 8
          # use this width to calculate line width (+8 for indent)
          input_number_width = cursor_width*$game_temp.num_input_digits_max
          input_number_width += 8 unless $game_system.message.autocenter
          @line_widths[$game_temp.num_input_start] = input_number_width
        end
        temp_bitmap.dispose
      end
      resize
      reposition if @float_id != nil
      self.contents.font.name = @font_name
      self.contents.font.size = @font_size
      self.contents.font.color = @font_color
      self.windowskin = RPG::Cache.windowskin(@windowskin)
      # autocenter first line if enabled
      # (subsequent lines are done as "\n" is encountered)
      if $game_system.message.autocenter and @text != ""
        @x = (self.width-40)/2 - @line_widths[0]/2
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
    max_y = 4
    @line_widths.each do |line|
      max_y -= 1 if line == 0 and max_y > 1
    end
    if $game_temp.choice_max  > 0
      # account for indenting
      max_x += 8 unless $game_system.message.autocenter
    end
    new_width = max_x + 40
    if @windowskin == FILENAME_THOUGHT_WINDOWSKIN and THOUGHT_WIDTH_MULTIPLE >0
      # force window width to be a multiple of THOUGHT_WIDTH_MULTIPLE
      # so that specialty windowskins (e.g. thought balloon) look right
      if new_width % THOUGHT_WIDTH_MULTIPLE != 0
        new_width += THOUGHT_WIDTH_MULTIPLE-(new_width%THOUGHT_WIDTH_MULTIPLE)
      end
    end
    self.width = new_width
    self.height = max_y * 32 + 32
    self.contents = Bitmap.new(width - 32, height - 32)
    self.x = 320 - (self.width/2) # center
  end
  
  def triggered_id?(event_id)
    return false if not $scene.is_a?(Scene_Map)
    # If the Event Speaking is the one that was Triggered in max_dist_id
    return true if $game_system.map_interpreter.max_dist_id == 
                   $game_system.map_interpreter.event_id
  end

  #--------------------------------------------------------------------------
  # * Reposition Window
  #-------------------------------------------------------------------------- 
  def reposition 
    if $game_temp.in_battle
      if "abcdefghij".include?(@float_id) # must be between a and d
        @float_id = @float_id[0] - 97 # a = 0, b = 1, c = 2, d = 3
        if $scene.spriteset.actor_sprites[@float_id] == nil
          @tail.visible = false
          return 
        end
        sprite = $scene.spriteset.actor_sprites[@float_id]
      else
        @float_id -= 1 # account for, e.g., player entering 1 for index 0
        if $scene.spriteset.enemy_sprites[@float_id] == nil
          @tail.visible = false
          return
        end
        sprite = $scene.spriteset.enemy_sprites[@float_id]
      end
=begin
      if sprite.frame_height != nil #ATOA COMPATIBLE!!!!
        char_height = sprite.frame_height
        char_width = sprite.frame_width
        char_x = sprite.x
        char_y = sprite.y - char_height/2
      else   
=end

      if sprite.height != nil
        char_height = sprite.height
        char_width = sprite.width
        char_x = sprite.x
        char_y = sprite.y - char_height/2
      else

        # This prevents GAME CRASH Enemy doesnt exist
        return
      end
      
    else # not in battle...
      char = (@float_id == 0 ? $game_player : $game_map.events[@float_id])
      if char == nil
        # no such character
        @float_id = nil
        return 
      end
      # close message (and stop event processing) if speaker is off-screen
      # or the window itself is completely off-screen
      if char.screen_x <= 0 or char.screen_x >= 640 or
         char.screen_y <= 0 or char.screen_y > 480 or
         ($game_system.message.move_during and
          not triggered_id?(char.id) and
          @dist_exit and char.allow_flip and  
           @float_id > 0 and not char.within_range?(@dist_max, @float_id)) or
           ($game_system.message.allow_offscreen and !$game_temp.in_battle and
           (self.height - self.y > 480 or self.height + self.y < 0 or
            self.width - self.x > 640 or self.width + self.x < 0)) 
        # Moved Off Screen or out of range so close Window
        terminate_message
        # 115 Breaks Event Processing
        $game_system.map_interpreter.command_115
        # reset foot forward on speak stance
        if @auto_ff_reset and not char.no_ff
          char.foot_forward_off 
        end
        # reset 'M'ove 'C'ontinue
        if @auto_move_continue and not char.no_mc
          char.event_move_continue(@float_id, true) 
        end
        # Instanced for this Msg Window, prevents calling Resets multiple times
        @auto_ff_reset = false
        # Turn off the Triggered Flag
        char.allow_flip = false
        char.preferred_loc = nil
        # Load the Default Sound Settings because Player walked away
        $game_system.message.load_sound_settings
        return
      end
      char_height = RPG::Cache.character(char.character_name,0).height / 4
      char_width = RPG::Cache.character(char.character_name,0).width / 4
      # Patch for Zooming Sprites from Heretic's Rotate and Pendulum Script
      if char.respond_to?(:sprite_zoom_y) and char.sprite_zoom_y
        # Adjust the Position for Sprite Zoom
        char_height *= char.sprite_zoom_y
      end
      # record coords of character's center
      char_x = char.screen_x
      char_y = char.screen_y - char_height/2 -16 #added the minus 16
    end
    params = [char_height, char_width, char_x, char_y]
    # position window and message tail
    vars = new_position(params)
    x = vars[0]
    y = vars[1]
    # check if need to flip because of Speaker Direction
    flip = need_flip?(@float_id, @location, x, y, params)
    # check if any window locations need to be "flipped"
    # because of Window Location
    
    if @location == 4 and
       ((x < 0 and 
       (not $game_system.message.allow_offscreen or $game_temp.in_battle)) or
       flip)
      # if the msg is an Auto Oriented Msg and it needs to be flipped
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 6)
      else       
        # switch to right
        @location = 6
      end
      vars = new_position(params)
      x = vars[0]
      if x + self.width > 640 and 
         (!$game_system.message.allow_offscreen or $game_temp.in_battle)
        # right is no good either...
        if y >= 24 #EDIT was 24
          # switch to top
          @location = 8
          vars = new_position(params)
        else
          # switch to bottom
          @location = 2
          vars = new_position(params)
        end
      end
      if $game_system.message.sticky
        $game_map.events[@float_id].preferred_loc = @location if @float_id > 0
        if @float_id == 0 and [2,8].include?(@location)
          if $game_player.allow_flip and $game_player.sticky
            $game_player.preferred_loc = @location
          else
            $game_player.preferred_loc = nil
          end
        end
      else
        $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
      end
    elsif @location == 6 and
          ((x + self.width > 640 and
          (!$game_system.message.allow_offscreen or $game_temp.in_battle)) or
          flip)
      # if the msg is an Auto Oriented Msg and it needs to be flipped
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 4)
      else          
        # switch to left
        @location = 4
      end
      vars = new_position(params)
      x = vars[0]
      if x < 0 and 
         (!$game_system.message.allow_offscreen or $game_temp.in_battle)
        # left is no good either...
        if y >= 50
          # switch to top
          @location = 8
          vars = new_position(params)
        else
          # switch to bottom
          @location = 2
          vars = new_position(params)
        end
      end
      if $game_system.message.sticky
        $game_map.events[@float_id].preferred_loc = @location if @float_id > 0
        if @float_id == 0 and [2,8].include?(@location)
          if $game_player.allow_flip and $game_player.sticky
            $game_player.preferred_loc = @location
          else
            $game_player.preferred_loc = nil
          end
        end
      else
        $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
      end
    elsif @location == 8 and
          ((y < 0 and 
          (!$game_system.message.allow_offscreen or $game_temp.in_battle)) or
          flip)
      # if the msg is an Auto Oriented Msg and it needs to be flipped
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 2)
      else
        # switch to bottom
        @location = 2
      end
      vars = new_position(params)
      y = vars[1]

      if y + self.height > 480 and
         (!$game_system.message.allow_offscreen or $game_temp.in_battle)
        # bottom is no good either...
        # note: this will probably never occur given only 3 lines of text
        # note: heretic - yeah right.  Wait till I get ahold of your code!
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
      if not $game_temp.in_battle
        if $game_system.message.sticky
          $game_map.events[@float_id].preferred_loc = @location if @float_id > 0
          if @float_id == 0 and [2,8].include?(@location)
            if $game_player.allow_flip and $game_player.sticky
              $game_player.preferred_loc = @location
            else
              $game_player.preferred_loc = nil
            end
          end
        else
          $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
        end
      end
    elsif @location == 2 and 
          ((y + self.height > 480 and
          (!$game_system.message.allow_offscreen or $game_temp.in_battle)) or
          flip)
      # if the msg is an Auto Oriented Msg and it needs to be flipped
      if @auto_orient == 1 and need_flip?(@float_id, @location, x, y)
        @location = put_behind(@float_id, 8)
      else
        # switch to top
        @location = 8
      end
      vars = new_position(params)
      y = vars[1]
      if y < 0 and
         (!$game_system.message.allow_offscreen or $game_temp.in_battle)
        # top is no good either...
        # note: this will probably never occur given only 3 lines of text
        # note: heretic - yeah right.  Wait till I get ahold of your code!        
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
      if not $game_temp.in_battle
        if $game_system.message.sticky
          $game_map.events[@float_id].preferred_loc = @location if @float_id > 0
          if @float_id == 0 and [2,8].include?(@location)
            if $game_player.allow_flip and $game_player.sticky
              $game_player.preferred_loc = @location
            else
              $game_player.preferred_loc = nil
            end
          end
        else
          $game_map.events[@float_id].preferred_loc = nil if @float_id > 0
        end
      end
    end
    x = vars[0]
    y = vars[1]
    tail_x = vars[2]
    tail_y = vars[3]    
    # adjust windows if near edge of screen
    if not $game_system.message.allow_offscreen or $game_temp.in_battle
      if x < 0
        x = 0
      elsif (x + self.width) > 640
        x = 640 - self.width
      end
      if y < 0
        y = 0
      elsif (y + self.height) > 480
        y = 480 - self.height
      elsif $game_temp.in_battle and @location == 2 and (y > (320 - self.height))
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
  end
  
  #--------------------------------------------------------------------------
  # * Need Flip? - Prevent Player from walking under Message Bubbles
  #--------------------------------------------------------------------------
  def need_flip?(event_id, loc, x, y, params = nil)
    return false if !@auto_orient or
                    @fade_out or
                    event_id.nil? or 
                    (event_id != 0 and
                    $game_map.events[event_id].erased) or
                    $game_temp.in_battle or
                    !$game_system.message.reposition_on_turn or
                    !$game_system.message.move_during
    # vars for speaker
    event = (event_id > 0) ? $game_map.events[event_id] : $game_player
    dir = event.direction
    
    # if an argument is passed called params and not allowed offscreen   
    if params and not $game_system.message.allow_offscreen
      case loc
        when 2
          new_loc = 8
        when 4 
          new_loc = 6
        when 6 
          new_loc = 4
        when 8 
          new_loc = 2
      end
      # check what the new coordinates of a repositioned window will be  
      new_vars = new_position(params, new_loc, no_rotate = true)
      new_x = new_vars[0]
      new_y = new_vars[1]
      # return false if not allowed off screen and new position is off screen
      if (new_x < 0 and new_loc == 4) or
         (new_x + self.width > 640) or
         (new_y < 0) or
         (new_y + self.height > 480)
        # if not allowed offscreen and trying to flip offscreen
        return false 
      end
    end

    # default result
    result = false
    result = true if @auto_orient == 2 and
                     event.allow_flip and
                     dir == loc 

    if @auto_orient == 1
      if event_id > 1
        # If Auto Orient Any Direction, try to put preference on top / bottom
        # Top / Bottom Preference was made for readability of Msgs
        # because it is easier to go off screen left and right
        if dir == loc or
           ((dir == 2 or dir == 8) and (loc == 4 or loc == 6))
          result = true
        end
      elsif event_id == 0 and $game_player.allow_flip

        # if Game Player Message is Sticky
        if $game_player.sticky and
           ((dir == 2 and loc != 8) or
           (dir == 8 and loc != 2) or
           (
             (not $game_player.preferred_loc) and
             ((dir == 4 and loc != 6) or (dir == 6 and loc != 4))
            )
           )
          # Return that Message needs to be Flipped
          result = true
        # If Game Player Non Sticky Message not behind Player   
        elsif not $game_player.sticky and
           ((dir == 2 and loc != 8) or
           (dir == 4 and loc != 6) or
           (dir == 6 and loc != 4) or
           (dir == 8 and loc != 2))
          # Return that Message needs to be Flipped
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
  # * Determine New Window Position
  #--------------------------------------------------------------------------  
  def new_position(params, location = @location, no_rotate = nil)
    char_height = params[0]
    char_width = params[1]
    char_x = params[2]
    char_y = params[3]
    if location == 8
      # top
      x = char_x - self.width/2
      y = char_y - char_height/2 - self.height - @tail.bitmap.height/2
      @tail.bitmap.rotation(0) if not no_rotate
      tail_x = x + self.width/2 
      tail_y = y + self.height
    elsif location == 2
      # bottom
      x = char_x - self.width/2
      y = char_y + char_height/2 + @tail.bitmap.height/2
      @tail.bitmap.rotation(180) if not no_rotate
      tail_x = x + self.width/2
      tail_y = y
    elsif location == 4
      # left
      x = char_x - char_width/2 - self.width - @tail.bitmap.width/2
      y = char_y - self.height/2
      @tail.bitmap.rotation(270) if not no_rotate
      tail_x = x + self.width
      tail_y = y + self.height/2
    elsif location == 6
      # right
      x = char_x + char_width/2 + @tail.bitmap.width/2
      y = char_y - self.height/2
      @tail.bitmap.rotation(90) if not no_rotate
      tail_x = x
      tail_y = y + self.height/2
    end
    return [x,y,tail_x,tail_y]
  end
  
  #--------------------------------------------------------------------------
  # * Text Sound
  #--------------------------------------------------------------------------  
  
  def play_text_sound(c)
    sound = "Audio/SE/" + $game_system.message.sound_audio
    volume = @sound_volume
    
    if @sound_vary_pitch and @sound_pitch
      # Prevent Negative Numbers...
      sound_pitch_range = (@sound_pitch_range > @sound_pitch) ?
          @sound_pitch : @sound_pitch_range      
      # If we want to Randomize the Sounds
      if @sound_vary_pitch == "random"
        # Random within the Range
        pitch = rand(sound_pitch_range * 2) + @sound_pitch - sound_pitch_range
      # Vary Sound Pitch to be based on Letter Sounds
      else

        # Note to Self - Reorganize based on actual Letter Sounds, not so Random
        if ['l','m','n','q','u','w','2'].include?(c)
          pitch = @sound_pitch - sound_pitch_range
          #print(sound + "_aa")
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_aa.wav" )
            sound = sound + "_aa"
            #print(sound)
            end
        elsif ['a','f','h','j','k','o','r','x','1','4','7','8'].include?(c)
          pitch = @sound_pitch - sound_pitch_range / 2
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_ee.wav" )
            sound = sound + "_ee"
            end
        elsif ['b','c','d','e','g','p','t','v','z','0','3','6'].to_a.include?(c)
          pitch = @sound_pitch
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_ii.wav" )
            sound = sound + "_ii"
            end
        elsif ['s','7'].to_a.include?(c)
          pitch = @sound_pitch + sound_pitch_range / 2
          if FileTest.exist?( "Audio/SE/" + $game_system.message.sound_audio + "_oo.wav" )
            sound = sound + "_oo"
            end
        elsif ['i','y','5','9'].to_a.include?(c)
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
  # * Update Text
  #--------------------------------------------------------------------------  
  def update_text
    if @text != nil
      # Get 1 text character in c (loop until unable to get text)
      while ((c = @text.slice!(/./m)) != nil)
        # Plays Sounds for each Letter, Numbers and Spaces Excluded
        if @sound and @letter_by_letter and !@player_skip and
           CHARACTERS.include?(c.downcase)
          # Increment for each Letter Sound Played
          @sound_counter += 1
          # Prevents Division by Zero, allows 0 to play a sound every letter
          frequency = (@sound_frequency == 0) ?
                      @sound_counter : @sound_frequency
          # Play Sound for each New Word or if Remainder is 0
          if @sound_counter == 1 or @sound_counter % frequency == 0
            # Play correct sound for each letter
            play_text_sound(c.downcase)
          end
        else
          @sound_counter = 0
        end        
        # If \\
        if c == "\000"
          # Return to original text
          c = "\\"
        end
        # If \C[n] or \C[#xxxxxx] or \C
        if c == "\001"
          # Change text color
          @text.sub!(/\[([0-9]+|#[0-9A-Fa-f]{6,6})\]/, "")
          if $1 != nil
            self.contents.font.color = check_color($1)
          else
            # return to default color
            if $game_system.message.font_color != nil
              color = check_color($game_system.message.font_color)
            elsif $game_system.message.floating and $game_system.message.resize
              color = check_color(SPEECH_FONT_COLOR)
            else
              # use defaults
              color = Font.default_color
            end
            self.contents.font.color = color
          end
          # go to next text
          next
        end
        # If \G+ (Gold Window at the Top)
        if c == "\023"
          # Make gold window
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = 32
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          # Dont take up space in window, next character
          next
        end
        # If \G- (Gold Window at the Bottom)
        if c == "\024"
          # Make gold window
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = 384
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          # Dont take up space in window, next character
          next
        end
        # If \G
        if c == "\002"
          # Make gold window
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = self.y >= 128 ? 32 : 384
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          # go to next text
          next
        end
        # If \L
        if c == "\003"
          # toggle letter-by-letter mode
          @letter_by_letter = !@letter_by_letter
          # go to next text
          next
        end
        # If \S[n]
        if c == "\004"
          @text.sub!(/\[([0-9]+)\]/, "")
          speed = $1.to_i
          if speed >= 0
            @text_speed = speed
            # reset player skip after text speed change
            @player_skip = false            
          end
          return
        end
        # If \D[n]
        if c == "\005"
          @text.sub!(/\[([0-9]+)\]/, "")
          delay = $1.to_i
          if delay >= 0
            @delay += delay
            # reset player skip after delay
            @player_skip = false
          end
          return
        end   
        # If \!
        if c == "\006"
          # close message and return from method
          terminate_message
          return
        end
        # If \?
        if c == "\007"
          @wait_for_input = true
          return
        end
        # If \B or \b
        if c == "\010"
          # bold
          self.contents.font.bold = !self.contents.font.bold
          #return - removed, glitches when letter_by_letter is false
          next
        end
        # If \I or \i
        if c == "\011"
          # italics
          self.contents.font.italic = !self.contents.font.italic
          #return - removed, glitches when letter_by_letter is false
          next
        end
        if c == "\013"
          # display icon of item, weapon, armor or skill
          @text.sub!(/\[([IiWwAaSs])([0-9]+)\]/, "")
          case $1.downcase
            when "i"
              item = $data_items[$2.to_i]
            when "w"
              item = $data_weapons[$2.to_i]
            when "a"
              item = $data_armors[$2.to_i]
            when "s"
              item = $data_skills[$2.to_i]
          end
          if item == nil
            return
          end
          bitmap = RPG::Cache.icon(item.icon_name)
          self.contents.blt(4+@x, 32*@y+4, bitmap, Rect.new(0, 0, 24, 24))
          @x += 24
          #self.contents.draw_text(x + 28, y, 212, 32, item.name)
          return
        end       
        # if \* - Display the next message
        if c == "\014"
          if $scene.is_a?(Scene_Battle)
            # Set Variables in the Battle Interpreter to display Next Window
            $game_system.battle_interpreter.set_multi
          elsif $scene.is_a?(Scene_Map)
            # Set Variables in the Map Interpreter to display Next Window
            $game_system.map_interpreter.set_multi
          end
          return
        end
        # if ", " or ".  " or "!  " or "?  " characters with spaces
        if c == "\015"
          if @auto_comma_pause and @letter_by_letter == true and
             (not @player_skip or (@player_skip and not @comma_skip_delay))
            delay = @text_speed + @auto_comma_delay
            if delay >= 0
              @delay += delay
              # reset player skip after delay
              @player_skip = false
            end
          end
          next
        end
        # if \A (Auto Pause for Commas, Periods, Exclamation and Question Marks)
        if c == "\016"
          # toggle auto comma pause
          @auto_comma_pause = !@auto_comma_pause
          next
        end
        # if \F+ (Foot Forward Animation On)
        if c == "\020" and @float_id
          speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
          speaker.foot_forward_on
          # Dont take up space in window, next character
          next
        end
        # if \F- (Foot Forward Animation Off)  
        if c == "\021" and @float_id
          speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
          speaker.foot_forward_off
          # Dont take up space in window, next character
          next
        end
        # Picture display!!
        if c == "\026" #and @string_id
          @text.sub!(/\[([\w]+)\]/, "")
          bitmap = RPG::Cache.picture($1.to_s)
          rect = Rect.new(0, 0, bitmap.width, bitmap.height)
          contents.blt(4+@x, 32*@y, bitmap, rect)
          #contents.blt(4+@x, 32*@y+4, bitmap, rect)
          @x += bitmap.width + 4
          #@y += bitmap.height
          next
        end
          #fire display \fi
        if c == "\027" 
          bitmap = RPG::Cache.picture("nyoomdf")
          rect = Rect.new(0, 0, bitmap.width/@fireframes, bitmap.height)
          #fire counter
          @counter += 1
          @counter = @counter % @fireframes*4
          rect.x =( @counter / @fireframes) * rect.width
          contents.blt(4+@x, 32*@y, bitmap, rect)
          next
        end   
        #face display
      if c == "\028" #imported new
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
        # if \F* (Foot Forward Animation On "Other" Foot)
        if c == "\022" and @float_id
          speaker = (@float_id > 0) ? $game_map.events[@float_id] : $game_player
          speaker.foot_forward_on(frame = 1)
          # Dont take up space in window, next character
          next
        end  
        
        # If new line text
        if c == "\n"
          # Update cursor width if choice
          if @y >= $game_temp.choice_start
            width = $game_system.message.autocenter ? @line_widths[@y]+8 : @x
            @cursor_width = [@cursor_width, width].max
          end
          # Add 1 to y
          @y += 1
          if $game_system.message.autocenter and @text != ""
            @x = (self.width-40)/2 - @line_widths[@y]/2
          else
            @x = 0
            # Indent if choice
            if @y >= $game_temp.choice_start
              @x = 8
            end
          end
          # go to next text
          next
        end
        # Draw text
        self.contents.draw_text(4 + @x, 32 * @y, 40, 32, c)
        # Add x to drawn text width
        @x += self.contents.text_size( c ).width
        # add text speed to time to display next character
        @delay += @text_speed unless !@letter_by_letter or @player_skip
        return if @letter_by_letter and !@player_skip
      end
    end
    # If choice and window has choices set to be displayed
    if $game_temp.choice_max > 0 and @choice_window
      @item_max = $game_temp.choice_max
      self.active = true
      if $choice_index and $choice_index.is_a?(Integer) and
         $choice_index < $game_temp.choice_max
        self.index = $choice_index
      else
        self.index = 0
      end
    end
    # If number input and this window shows choices and no number window exists
    if $game_temp.num_input_variable_id > 0 and @choice_window and 
       not @input_number_window
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
  # * Reset Window
  #--------------------------------------------------------------------------
  def reset_window
    if $game_temp.in_battle
      self.y = 16
    else
      case $game_system.message_position
      #this is for untargetted positioned windows
      when 0  # up
        self.y = 20
      when 1  # middle
        self.y = 160
      when 2  # down
        self.y = 304
      end
    end
    if $game_system.message_frame == 0
      self.opacity = 255
    else
      self.opacity = 0
    end
    # transparent speech balloons don't look right, so keep opacity at 255
    # self.back_opacity = 160
    @tail.opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update 
    super
    # Terminate ANY Messages if Player too far away, useful for signs
    if $scene.is_a?(Scene_Map)
      if $game_system.map_interpreter.event_id != 0
        e_id = $game_system.map_interpreter.event_id
        ev = $game_map.events[e_id]
        if ev and $game_map.events[e_id].dist_kill
          if not ev.within_range?(ev.dist_kill, e_id) and 
             not $game_player.move_route_forcing and
             $game_system.message.move_during and
             (not ev.move_route_forcing or ev.move_route.repeat)
            # Player moved too far away so kill windows and event processing
            if @input_number_window != nil
              # Dispose of number input window
              @input_number_window.dispose
              @input_number_window = nil  
            end
            # Terminate This Msg - Leave Others so each handles their @float_id
            terminate_message
            # 115 Breaks Event Processing
            $game_system.map_interpreter.command_115
            # If there is someone speaking        
            if @float_id
              # Player
              # Note: No Move Continue because moving away
              # is a Player initiated Action
              if @float_id == 0
                # reset foot forward on speak stance
                if @auto_ff_reset and not $game_player.no_ff
                  # Command to turn Foot Forward Poses Off
                  $game_player.foot_forward_off 
                end
                $game_player.allow_flip = false
                $game_player.preferred_loc = nil
              elsif @float_id > 0
                # reset foot forward on speak stance
                if @auto_ff_reset and not $game_map.events[@float_id].no_ff
                  # Command to turn Foot Forward Poses Off
                  $game_map.events[@float_id].foot_forward_off 
                end
                # reset 'M'ove 'C'ontinue
                if @auto_move_continue and not $game_map.events[@float_id].no_mc
                  # Continue doing what it was doing before
                  event_to_reset = $game_map.events[@float_id]
                  event_to_reset.event_move_continue(@float_id, true, 1) 
                end
                $game_map.events[@float_id].allow_flip = false
                $game_map.events[@float_id].preferred_loc = nil
              end
            end
            # Instanced for this Msg Window, prevents calling Resets multiple times
            @auto_ff_reset = false
            # Turn off the Triggered Flag
            ev.allow_flip = false
            ev.preferred_loc = nil

            if $game_temp.message_text.compact.empty?
              ev.dist_kill = nil
              $game_system.map_interpreter.restore_mmw_vars
              #$game_map.need_refresh = true
              if not $game_map.events[e_id].no_mc
                $game_map.events[e_id].event_move_continue(e_id, true, 1)
                $game_system.map_interpreter.max_dist_id = nil
              end
            end
          # Load the Default Sound Settings because Player walked away
          $game_system.message.load_sound_settings
          end
        end 
      end
    end
    
    # If fade in
    if @fade_in
      self.contents_opacity += 24
      if @input_number_window != nil
        @input_number_window.contents_opacity += 24
      end
      if self.contents_opacity == 255
        @fade_in = false
      end
      # allow text to be updated while window is fading in
      return if not $game_system.message.update_text_while_fading
    end
    # If inputting number
    if @input_number_window != nil
      @input_number_window.update
      # Confirm
      if Keys.trigger?($keyboard["select"])
        #Input.trigger?(Input::C)
        # Allows windows to be closed
        $game_temp.input_in_window = false
        # play sound effect
        $game_system.se_play($data_system.decision_se)
        # Set Variable to identify the Number Window was Cancelled
        $game_system.number_cancelled = false        
        # if variable_id was lost, refer to backup
        if $game_temp.num_input_variable_id == 0
          $game_variables[$game_temp.num_input_variable_id_backup] =
            @input_number_window.number
        else
          $game_variables[$game_temp.num_input_variable_id] =
            @input_number_window.number
        end
        $game_map.need_refresh = true
        # Dispose of number input window
        @input_number_window.dispose
        @input_number_window = nil  
        if $scene.message_window.size > 1
          for msg in $scene.message_window
            msg.terminate_message
          end
        else
          terminate_message
        end
      # Cancel, if allowed
      # *NOTE* - use "number_cancelled?" to checks if Cancel Button was pushed
      elsif Keys.trigger?($keyboard["cancel"]) &&
        #Input.trigger?(Input::B) and 
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
        if $scene.message_window.size > 1
          for msg in $scene.message_window
            msg.terminate_message
          end
        else
          terminate_message
        end
      end
      # prevent terminating windows and destroying variables
      return
    end
    # If message is being displayed
    if @contents_showing
      # Confirm or cancel finishes waiting for input or message
      if Keys.trigger?($keyboard["select"]) || Keys.trigger?($keyboard["cancel"])
        #Input.trigger?(Input::C) or Input.trigger?(Input::B)
        if @wait_for_input
          @wait_for_input = false
          self.pause = false
        elsif $game_system.message.skippable
          @player_skip = true
        end
        # Dont close the window if waiting for choices to be displayed
        if $game_temp.input_in_window and 
           $game_temp.message_text.compact.size > 1 and
           not $input_window_wait
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
      if @update_text and !@wait_for_input
        if @delay == 0
          update_text
        else
          @delay -= 1
        end
        return
      end

      # If choice isn't being displayed, show pause sign
      if !self.pause and ($game_temp.choice_max == 0 or @wait_for_input)
        self.pause = true unless !$game_system.message.show_pause
      end
      # Cancel
      if Keys.trigger?($keyboard["cancel"])
        #Input.trigger?(Input::B)
        if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
          # Allow ALL windows to be closed
          $game_temp.input_in_window = false
          # Play Sound Effect
          $game_system.se_play($data_system.cancel_se)
          # Process the Choice
          $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
          # If multi window cancel choice
          if $scene.message_window.size > 1
            for msg in $scene.message_window
              msg.terminate_message
            end
          else
            terminate_message
          end
        end
        # personal preference: cancel button should also continue
        terminate_message 
      end
      # Confirm
      if Keys.trigger?($keyboard["select"])
        #Input.trigger?(Input::C)
        # Allow ALL windows to be closed
        $game_temp.input_in_window = false
        # if choice is displayed in one of multiple windows        
        if $game_temp.choice_max > 0
          if $scene.message_window.size > 1
            for i in 0...$scene.message_window.size
              if $scene.message_window[i].choice_window
                # return selection position by index of the choice window
                @index = $scene.message_window[i].index
              end
            end
          end          
          $game_system.se_play($data_system.decision_se)
          $game_temp.choice_proc.call(self.index)
        end
        # If Preceeding Window not closed because choice displayed
        if $scene.message_window.size > 1
          choice = false
          for i in 0...$scene.message_window.size
            if $scene.message_window[i].choice_window
              choice = true
              break
            end
          end
          # If window is a choice window and other windows held open
          if choice
            # close all the message windows
            for msg in $scene.message_window
              msg.terminate_message
            end
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
    if @fade_out == false and $game_temp.message_text[@msgindex] != nil
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
      if need_reposition?
        # update message position for character/screen movement        
        reposition 
      end
      if self.opacity == 0 
        self.visible = false
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
    if !$game_temp.in_battle and $game_system.message.floating and
        $game_system.message.resize and @float_id != nil
      if $game_system.message.move_during and @float_id == 0 and
          (($game_player.last_real_x != $game_player.real_x) or
          ($game_player.last_real_y != $game_player.real_y))
          # player with floating message moved
          # (note that relying on moving? leads to "jumpy" message boxes)
          return true
      elsif ($game_map.last_display_y != $game_map.display_y) or
         ($game_map.last_display_x != $game_map.display_x)
        # player movement or scroll event caused the screen to scroll
        return true
      else
        char = $game_map.events[@float_id]
        if char != nil and 
          ((char.last_real_x != char.real_x) or
          (char.last_real_y != char.real_y))
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
    if $game_system.message.show_tail and $game_system.message.floating and
      $game_system.message.resize and $game_system.message_frame == 0 and
      @float_id != nil
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Posotion
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


#new

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
    boxcolor = Color.new(160, 20, 20) #this is what color the box is gonna be
    bitmap = Bitmap.new(name.length*10+20, 32) #sets the box size to big enough
    
    boxcolor.alpha=100
    bitmap.fill_rect(-10, 2, name.length*15, 15, boxcolor )
    boxcolor.alpha=150
    bitmap.fill_rect(-10, 2, name.length*10, 15, boxcolor ) 
    boxcolor.alpha=200
    bitmap.fill_rect(-10, 2, name.length*5, 15, boxcolor ) 
    #draw a box here
    bitmap.font = self.contents.font
    bitmap.font.color = text_color(6) #yellow. it's yellow.
    bitmap.draw_text(2, 0, name.length*10, 32, name)

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
    @name_sprite.y = self.y - 6
    @name_sprite.x = self.x + 8 #find the max width
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
=begin
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    temp = $game_temp.in_battle
    $game_temp.in_battle = $scene.is_a?(Scene_Battle)
    drg128_upd
    $game_temp.in_battle = temp
  end  
=end
  #--------------------------------------------------------------------------
  # * Reposition Window
  #-------------------------------------------------------------------------- 
  def reposition
    drg128_rep
    face_position
    name_sprite_position
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
    f = Bitmap.new(80,80)
    @portrait = Sprite.new
    @portrait.bitmap, @portrait.opacity = d, 0
    @portrait.x, @portrait.y = b[0], b[1]
    @portrait.bitmap.blt(0, 0, e || Bitmap.new(1,1), 
        Rect.new(0,0,@portrait.bitmap.width,a[1]+a[3])) 
    unless  c == ' '    
      f.fill_rect(Rect.new(0,0,80,80),check_color(0)) if c
      f.stretch_blt(f.rect, @portrait.bitmap, Rect.new(*a)) if face[1] != ' '
      f.fill_rect(Rect.new(0,0,80,2),check_color(c))  if c
      f.fill_rect(Rect.new(0,78,80,2),check_color(c)) if c
      f.fill_rect(Rect.new(0,0,2,80),check_color(c))  if c
      f.fill_rect(Rect.new(78,0,2,80),check_color(c)) if c
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

end #new
#------------------------------------------------------------------------------

class Game_Character
  attr_reader   :last_real_x         # last map x-coordinate
  attr_reader   :last_real_y         # last map y-coordinate
  attr_accessor :move_frequency      # allows resetting if interrupted
  attr_accessor :allow_flip          # if event was triggered by player
  attr_accessor :preferred_loc       # triggered after Msg Reposition
  
  alias heretic_game_ch_mmw_initialize initialize
  def initialize
    # Original
    heretic_game_ch_mmw_initialize
    # Used with Flip and Sticky Options...
    @preferred_loc = nil
  end
  
  alias wachunga_game_char_update update
  def update
    @last_real_x = @real_x
    @last_real_y = @real_y
    wachunga_game_char_update
  end
 
  def within_range?(range = 4, id = @event_id)
    e = $game_map.events[id]
    radius = (Math.hypot((e.x - $game_player.x), (e.y - $game_player.y))).abs
    return (range >= radius)
  end
  # If Heretic's Loop Maps is installed
  if Game_Map.method_defined?(:map_loop_passable?)
    #--------------------------------------------------------------------------
    # * Within Range - Game_Character
    #  - Checks Distance between Player and Speaking Character
    #  - Uses Character Distance Method from Loop Maps for determining the 
    #    difference in distance between Player and Event on Looping Maps
    #--------------------------------------------------------------------------  
    def within_range?(range = 4, id = @event_id)
      # Get Distance Difference between Player and Event
      dx, dy = character_distance($game_player)
      radius = Math.hypot(dx,dy).abs
      return (range >= radius)
    end
  end
  
  #----------------------------------------------------------------------------
  # * Allows Animation Change regardless of Direction
  #----------------------------------------------------------------------------

  unless self.method_defined?('foot_forward_on')  
    def foot_forward_on(frame = 0)
      return if @direction_fix or !@walk_anime or @step_anime or 
                $game_temp.in_battle
      if frame == 0
        case @direction
        when 2
          @pattern = 3
        when 4, 6, 8
          @pattern = 1
        else
          @pattern = 0
        end
        @original_pattern = @pattern
      elsif frame == 1
        case @direction
        when 2
          @pattern = 1
          when 4, 6, 8
          @pattern = 3
        else
          @pattern = 0
        end
        @original_pattern = @pattern
      end
    end
  
    def foot_forward_off
      # If called by walking off screen, dont affect a Sign or Stepping Actor
      return if $game_temp.in_battle or @direction_fix or !@walk_anime or @no_ff
      @pattern, @original_pattern = 0, 0
    end
  end
    
  # Call from Event Editor => Scripts 
  # DO NOT call from Set Move Route => Scripts
  def event_move_continue(event_id, valid = false, alt = false)
    # return if Event has a No 'M'ove 'C'ontinue flag
    return if @no_mc
    # Restore Original Move Route if Event went off the screen while talking
    # This may be buggy if multiple event pages are used
    if @ff_original_move_route != nil and valid
      # Release forced move route
      @move_route_forcing = false
      # Restore original values        
      @move_speed = @ff_original_move_speed
      @move_frequency = @ff_original_move_frequency
      @move_route = @ff_original_move_route
      @move_route_index = @ff_original_move_route_index 
      # Release storing variables
      @ff_original_move_index = nil
      @ff_original_move_speed = nil
      @ff_original_move_frequency = nil
      @ff_original_move_route = nil
      @original_move_route = nil
      @original_move_route_index = nil
    elsif @original_move_route != nil and valid and alt
      # Release forced move route
      @move_route_forcing = false      
      @move_route = @original_move_route
      @move_route_index = @original_move_route_index
      @original_move_route = nil
      @original_move_route_index = nil      
    end
  end

  unless self.method_defined?('heretic_mmw_lock')
    alias heretic_mmw_lock lock
    alias heretic_mmw_unlock unlock
  end    
    
  def lock
    # Call Original
    heretic_mmw_lock
    # Store Movement Variables in case player walks away
    @ff_original_move_route_index = @move_route_index
    @ff_original_move_speed = @move_speed
    @ff_original_move_frequency = @move_frequency
    @ff_original_move_route = @move_route
    # Store Variable that Event was Triggered by Player
    @allow_flip = true
  end
    
  def unlock
    # Call Original
    heretic_mmw_unlock
    # Unset Variable that Event was Triggered by Player
    @allow_flip = false
    @preferred_loc = nil
    # Reset Player as well...
    $game_player.allow_flip = false
    $game_player.preferred_loc = nil
    $game_player.sticky = false
    
    # Unset any possible dist kill flags
    if $game_temp.message_text.compact.empty?
      $game_map.events[@id].dist_kill = nil if @id
      $game_system.map_interpreter.max_dist_id = nil
    end

    # Reset Choice Index
    $choice_index = 0    
    
    # Loads the Default Sound Settings at the End of Event Interaction
    $game_system.message.load_sound_settings if $game_system.message.sound
  end
  
end

#------------------------------------------------------------------------------

class Game_Player < Game_Character

  attr_accessor :sticky  # Used for Positioning Msg Bubbles
  
  alias wachunga_mmw_game_player_update update
  def update
   # The conditions are changed so the player can move around while messages
   # are showing (if move_during is true), but not if user is making a
   # choice or inputting a number
   # Note that this check overrides the default one (later in the method)
   # because it is more general
    unless moving? or
      @move_route_forcing or
      ($game_system.map_interpreter.running? and
      !$game_temp.message_window_showing) or
      ($game_temp.message_window_showing and
      !$game_system.message.move_during) or 
      ($game_temp.choice_max > 0 or $game_temp.num_input_digits_max > 0)
      update_player_movement
    end
    wachunga_mmw_game_player_update    
  end
  
end
  
#------------------------------------------------------------------------------

class Game_Temp
  alias wachunga_mmw_game_temp_initialize initialize
  def initialize
    wachunga_mmw_game_temp_initialize
    @message_text = [] 
    @message_proc = [] 
  end
end

#------------------------------------------------------------------------------
  
class Sprite_Battler < RPG::Sprite
  # necessary for positioning messages relative to battlers
  attr_reader :height
  attr_reader :width
end

#------------------------------------------------------------------------------

class Scene_Battle
  # necessary for accessing actor/enemy sprites in battle
  attr_reader :spriteset
end

#------------------------------------------------------------------------------

class Spriteset_Battle
  # necessary for accessing actor/enemy sprites in battle
  attr_reader :actor_sprites
  attr_reader :enemy_sprites
end

#------------------------------------------------------------------------------

class Scene_Map
  attr_accessor :message_window
  # SDK Compatability
  if Module.constants.include?('SDK')  
    def main_draw
      # Make sprite set
      @spriteset = Spriteset_Map.new
      # Make message window
      @message_window = []
      @message_window[0] = Window_Message.new(0)
      # Transition run
      Graphics.transition
    end
  
    alias wachunga_mmw_scene_map_main_dispose main_dispose
    def main_dispose
      wachunga_mmw_scene_map_main_dispose
      for mw in @message_window
        mw.dispose
      end
    end
  
    def update_graphics
      # Update sprite set
      @spriteset.update
      # Update message window
      for mw in @message_window
        mw.update
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Scene_Map - New Message Window Addition
  #--------------------------------------------------------------------------
  def new_message_window(index)
    if @message_window[index] != nil
      # clear message windows at and after this index
      last_index = @message_window.size - 1
      last_index.downto(index) do |i|
        if @message_window[i] != nil
          @message_window[i].dispose
          @message_window[i] = nil
        end
      end
      @message_window.compact!
    end
    new_message = Window_Message.new(index)
    @message_window.push(new_message)
  end

end

#------------------------------------------------------------------------------

class Scene_Battle
  attr_accessor :message_window  

  # If SDK is installed
  if Module.constants.include?('SDK')
    def main_windows
      # Make other windows
      @party_command_window = Window_PartyCommand.new
      @help_window = Window_Help.new
      @help_window.back_opacity = 160
      @help_window.visible = false
      @status_window = Window_BattleStatus.new
      @message_window = [] 
      @message_window[0] = Window_Message.new(0) 
    end
    
    def main_dispose
      # Dispose of windows
      @actor_command_window.dispose
      @party_command_window.dispose
      @help_window.dispose
      @status_window.dispose
      for mw in @message_window
        mw.dispose
      end 
      @skill_window.dispose unless @skill_window == nil
      @item_window.dispose unless @item_window == nil
      @result_window.dispose unless @result_window == nil
      # Dispose of sprite set
      @spriteset.dispose
      $choice_index = 0
    end
  
    def update_objects
      # Update windows
      @help_window.update
      @party_command_window.update
      @actor_command_window.update
      @status_window.update
      for mw in @message_window
        mw.update
      end 
      # Update sprite set
      @spriteset.update
    end
  
  # End SDK / Non SDK Compatability Test
  end
  
  #--------------------------------------------------------------------------
  # * Scene_Battle - New Message Window Addition
  #--------------------------------------------------------------------------
  def new_message_window(index)
    if @message_window[index] != nil
      # clear message windows at and after this index
      last_index = @message_window.size - 1
      last_index.downto(index) do |i|
        if @message_window[i] != nil
          @message_window[i].dispose
          @message_window[i] = nil
        end
      end
      @message_window.compact!
    end
    @message_window.push(Window_Message.new(index))
  end

end

#------------------------------------------------------------------------------

class Game_System
  attr_accessor  :number_cancelled   # Allows detection if a Number Input Cancel
  attr_accessor  :mmw_text           # Holds Strings to show in Msgs \v[Tn]
  attr_reader    :message            # Shortcut, allows message without $game_
  
  alias wachunga_mmw_game_system_init initialize
  def initialize
    wachunga_mmw_game_system_init
    @message = Game_Message.new
    # allows detection if a Number Input was Cancelled
    @number_cancelled = false
    # Holds Strings to show in Msgs
    @mmw_text = []
  end
end

#------------------------------------------------------------------------------

class Interpreter
  attr_reader   :event_id
  attr_reader   :list
  attr_accessor :index
  attr_accessor :max_dist_id
  
  alias wachunga_mmw_interp_setup setup
  def setup(list, event_id)
    wachunga_mmw_interp_setup(list, event_id)
    # index of window for the message
    @msgindex = 0
    # whether multiple messages are displaying
    @multi_message = false
    # Id of Event that is using set_max_dist
    @max_dist_id = nil
  end
  
  def setup_choices(parameters)
    # Set Select Window to Active
    $scene.message_window[@msgindex].active = true
    # Set choice item count to choice_max
    $game_temp.choice_max = parameters[0].size
    # Set choice to message_text
    for text in parameters[0]
      # just add index for array
      $game_temp.message_text[@msgindex] += text + "\n"
    end
    # Set cancel processing
    $game_temp.choice_cancel_type = parameters[1]
    # Set callback
    current_indent = @list[@index].indent
    $game_temp.choice_proc = Proc.new { |n| @branch[current_indent] = n }
  end

  # Not sure if this will be useful, leaving undocumented for now
  def event_move_continue(event_id)
    $game_map.events[event_id].event_move_continue(event_id, true)
  end  
  
  def number_cancelled?
    return $game_system.number_cancelled
  end
  
  def set_multi
    # Setting these two variables causes the Next Message to be displayed.
    @multi_message = true
    @message_waiting = false
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
    # Start Message on Line 1
    line_count = 1
    # Loop
    loop do 
      # If next event command text is on the second line or after
      if @list[@index+1].code == 401
        # Add the second line or after to message_text
        # just adding index
        $game_temp.message_text[@msgindex]+=@list[@index+1].parameters[0]+"\n"
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
            $scene.message_window[@msgindex].choice_window = @msgindex
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
            $scene.message_window[@msgindex].choice_window = @msgindex
            # Advance index
            @index += 1
            # Number input setup
            $game_temp.num_input_start = line_count
            $game_temp.num_input_variable_id = @list[@index].parameters[0]
            $game_temp.num_input_digits_max = @list[@index].parameters[1]
            $game_temp.num_input_variable_id_backup = 
              @list[@index].parameters[0]
          end
        # start multimessage if next line is "Show Text" starting with "\+"
        elsif @list[@index+1].code == 101
          if @list[@index+1].parameters[0][0..1]=="\\+"
            @multi_message = true
            @message_waiting = false
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
    $scene.message_window[@msgindex].choice_window = @msgindex    
    # If text has been set to message_text
    # just adding index
    if $game_temp.message_text[@msgindex] != nil
      # End
      return false
    end
    # Set message end waiting flag and callback
    @message_waiting = true
    # adding more indexes
    $game_temp.message_proc[@msgindex] = Proc.new { @message_waiting = false }
    # Choices setup
    $game_temp.message_text[@msgindex] = ""
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
    # Flag this window as having choices displayed
    $scene.message_window[@msgindex].choice_window = @msgindex    
    # If text has been set to message_text
    # just adding index
    if $game_temp.message_text[@msgindex] != nil
      # End
      return false
    end
    # Set message end waiting flag and callback
    @message_waiting = true
    # adding more indexes
    $game_temp.message_proc[@msgindex] = Proc.new { @message_waiting = false }
    # Number input setup
    $game_temp.message_text[@msgindex] = ""
    $game_temp.num_input_start = 0
    $game_temp.num_input_variable_id = @parameters[0]
    $game_temp.num_input_digits_max = @parameters[1]
    $game_temp.num_input_variable_id_backup = @list[@index].parameters[0]
    # Continue
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  # Fix for RMXP bug: call script boxes that return false hang the game
  # See, e.g., http://rmxp.org/forums/showthread.php?p=106639  
  #--------------------------------------------------------------------------
  def command_355
    # Set first line to script
    script = @list[@index].parameters[0] + "\n"
    # Loop
    loop do
      # If next event command is second line of script or after
      if @list[@index+1].code == 655
        # Add second line or after to script
        script += @list[@index+1].parameters[0] + "\n"
      # If event command is not second line or after
      else
        # Abort loop
        break
      end
      # Advance index
      @index += 1
    end
    # Evaluation
    result = eval(script)
    # If return value is false
    if result == false
      # End
      #return false
    end
    # Continue
    return true
  end
  
  def message
    $game_system.message
  end
  
  def within_range?(range = 4, id = @event_id)
    e = $game_map.events[id]
    radius = (Math.hypot((e.x - $game_player.x), (e.y - $game_player.y))).abs
    return (radius <= range)
  end

  unless self.method_defined?('heretic_mmw_command_209')
    alias heretic_mmw_command_202 command_202
    alias heretic_mmw_command_209 command_209
  end
  
  #--------------------------------------------------------------------------
  # * Set Event Location
  #--------------------------------------------------------------------------
  def command_202
    # Run the Original
    heretic_mmw_command_202
    # Get character
    character = get_character(@parameters[0])
    # If no character exists, Player is still checked...
    if character == nil
      # Continue
      return true
    end
    if @event_id != 0
      $game_map.events[@event_id].allow_flip = false
      $game_map.events[@event_id].preferred_loc = nil
    end
    # Return that the command has run...
    return true
  end
  #--------------------------------------------------------------------------
  # * Set Move Route
  #--------------------------------------------------------------------------
  def command_209
    # Run the Original
    heretic_mmw_command_209
    # Get character
    character = get_character(@parameters[0])
    # If no character exists, Player is still checked...
    if character == nil
      # Continue
      return true
    end
    if @parameters[1]
      # Any Movement Related Commands, Turn Commands and Others are Ignored
      codes = *[1..14]
      # Scripts from Caterpillar that cause Movement in NPC's
      commands = ['move_toward_event','move_away_from_event']
      # Check the List of Move Commands to see if they are Movement Related...
      for command in @parameters[1].list
        if codes.include?(command.code) and @event_id != 0
          $game_map.events[@event_id].allow_flip = false
          $game_map.events[@event_id].preferred_loc = nil          
          # quit iterating
          return true
        elsif command.code == 45
          script = command.parameters[0]
          for string in commands
            found = false
            script.sub(string) {found = true}
            if found and @event_id != 0
              $game_map.events[@event_id].allow_flip = false if found
              $game_map.events[@event_id].preferred_loc = nil if found
              # quit iterating
              return true
            end
          end
        end
      end
    end
  end    

  def set_max_dist(dist, save = true)
    return if not $scene.is_a?(Scene_Map)
    $game_map.events[@event_id].dist_kill = dist if dist.is_a?(Numeric)
    # If Max Distance is 0 and Location is NOT Passable when triggered
    if $game_map.events[@event_id].dist_kill == 0 and
       (!$game_map.passable?($game_map.events[@event_id].x,
                           $game_map.events[@event_id].y,
                           0) or
       ($game_map.events[@event_id].character_name != "" and
       !$game_map.events[@event_id].through))
      # Bump it up to 1 because 0 doesnt work for non passable triggers
      $game_map.events[@event_id].dist_kill = 1
    end
    
    # Prevent closing at a distance for other NPC's that might be speaking...
    @max_dist_id = event_id
    # Save MMW Configuration in case of a Walk Away...
    save_mmw_vars if save
  end
  
  def clear_max_dist
    return if not $scene.is_a?(Scene_Map)
    # Leaves MMW Settings Intact and unsets Variable that causes End Commands
    $game_map.events[@event_id].dist_kill = nil
  end
  
  def save_mmw_vars
    # Window Skin
    @windowskin_name_save = $game_system.windowskin_name
    # MMW Variables
    @mmw_vars_saved = true
    @mmw_letter_by_letter = $game_system.message.letter_by_letter
    @mmw_text_speed = $game_system.message.text_speed
    @mmw_text_speed_player = $game_system.message.text_speed_player
    @mmw_skippable = $game_system.message.skippable
    @mmw_resize = $game_system.message.resize
    @mmw_floating = $game_system.message.floating
    @mmw_autocenter = $game_system.message.autocenter
    @mmw_show_tail = $game_system.message.show_tail
    @mmw_show_pause = $game_system.message.show_pause
    @mmw_move_during = $game_system.message.move_during
    @mmw_location = $game_system.message.location
    @mmw_font_name = $game_system.message.font_name
    @mmw_font_size = $game_system.message.font_size
    @mmw_font_color = $game_system.message.font_color
    @mmw_auto_comma_pause = $game_system.message.auto_comma_pause
    @mmw_auto_comma_delay = $game_system.message.auto_comma_delay
    @mmw_allow_cancel_numbers = $game_system.message.allow_cancel_numbers
    @mmw_update_text_while_fading=$game_system.message.update_text_while_fading
    @mmw_auto_ff_reset = $game_system.message.auto_ff_reset
    @mmw_auto_move_continue = $game_system.message.auto_move_continue
    @mmw_dist_exit = $game_system.message.dist_exit
    @mmw_dist_max = $game_system.message.dist_max
    @mmw_allow_offscreen = $game_system.message.allow_offscreen
    @mmw_reposition_on_turn = $game_system.message.reposition_on_turn 
    @mmw_sticky = $game_system.message.sticky
    # Sound Stuff
    @mmw_sound = $game_system.message.sound
    @mmw_sound_volume = $game_system.message.sound_volume
    @mmw_sound_pitch = $game_system.message.sound_pitch
    @mmw_sound_pitch_range = $game_system.message.sound_pitch_range
    @mmw_sound_vary_pitch = $game_system.message.sound_vary_pitch
    @mmw_sound_frequency = $game_system.message.sound_frequency    
    #namebox stuff
  @mmw_name_box_x_offset = $game_system.message.name_box_x_offset
  @mmw_name_box_y_offset = $game_system.message.name_box_y_offset 
  @mmw_name_box_width = $game_system.message.name_box_width
  @mmw_name_box_height = $game_system.message.name_box_height
  @mmw_name_font_size = $game_system.message.name_font_size
  @mmw_name_box_text_color = $game_system.message.name_box_text_color
  @mmw_name_box_skin = $game_system.message.name_box_skin
  
  end
  
  def restore_mmw_vars
    if @mmw_vars_saved
     # Windowskin - Used with Different Backgrounds on Signs 
     $game_system.windowskin_name = @windowskin_name_save 
     # MMW Variables
     $game_system.message.letter_by_letter = @mmw_letter_by_letter
     $game_system.message.text_speed = @mmw_text_speed
     $game_system.message.text_speed_player = @mmw_text_speed_player
     $game_system.message.skippable = @mmw_skippable
     $game_system.message.resize = @mmw_resize
     $game_system.message.floating = @mmw_floating
     $game_system.message.autocenter = @mmw_autocenter
     $game_system.message.show_tail = @mmw_show_tail
     $game_system.message.show_pause = @mmw_show_pause
     $game_system.message.move_during = @mmw_move_during
     $game_system.message.location = @mmw_location
     $game_system.message.font_name = @mmw_font_name
     $game_system.message.font_size = @mmw_font_size 
     $game_system.message.font_color = @mmw_font_color
     $game_system.message.auto_comma_pause = @mmw_auto_comma_pause
     $game_system.message.auto_comma_delay = @mmw_auto_comma_delay
     $game_system.message.allow_cancel_numbers = @mmw_allow_cancel_numbers
     $game_system.message.update_text_while_fading=@mmw_update_text_while_fading
     $game_system.message.auto_ff_reset = @mmw_auto_ff_reset
     $game_system.message.auto_move_continue = @mmw_auto_move_continue
     $game_system.message.dist_exit = @mmw_dist_exit
     $game_system.message.dist_max = @mmw_dist_max
     $game_system.message.allow_offscreen = @mmw_allow_offscreen
     $game_system.message.reposition_on_turn  = @mmw_reposition_on_turn
     $game_system.message.sticky = @mmw_sticky
     # Sound Stuff
     $game_system.message.sound = @mmw_sound
     $game_system.message.sound_volume = @mmw_sound_volume
     $game_system.message.sound_pitch = @mmw_sound_pitch
     $game_system.message.sound_pitch_range = @mmw_sound_pitch_range
     $game_system.message.sound_vary_pitch=@mmw_sound_vary_pitch
     $game_system.message.sound_frequency = @mmw_sound_frequency
     #namebox stuff
  $game_system.message.name_box_x_offset = @mmw_name_box_x_offset
  $game_system.message.name_box_y_offset = @mmw_name_box_y_offset
  $game_system.message.name_box_width = @mmw_name_box_width
  $game_system.message.name_box_height = @mmw_name_box_height
  $game_system.message.name_font_size = @mmw_name_font_size
  $game_system.message.name_box_text_color = @mmw_name_box_text_color
  $game_system.message.name_box_skin = @mmw_name_box_skin
    end
  end  
end

#------------------------------------------------------------------------------

class Game_Map
  attr_accessor :last_display_x                # last display x-coord * 128
  attr_accessor :last_display_y                # last display y-coord * 128
  
  alias wachunga_mmw_game_map_update update
  def update
    @last_display_x = @display_x
    @last_display_y = @display_y
    wachunga_mmw_game_map_update
  end
  
  # This was removed because it requires the SDK
  
  #def name
  #  return load_data('Data/MapInfos.rxdata')[@map_id].name
  #end
  
  # Removes some of the need for the SDK
  
  # NOTE:  This is also defined in Caterpillar, which doesnt require the SDK
  
  #----------------
  # * Name
  #----------------
  @@map_info = load_data("Data/MapInfos.rxdata") 

  def name(id = @map_id) 
    return @@map_info[id].name 
  end 
  
end

#------------------------------------------------------------------------------

# Note:  I know this is a crappy way to do it, but I cant figure out another
#  way to prevent the loss of data when showing a number input with multiple
#  windows being displayed.  It destroys the data before it can call the data
#  so just creating a backup of that data.  It works, thats all I care.

class Game_Temp
  attr_accessor :num_input_variable_id_backup  # prevents variable loss
  attr_accessor :input_in_window               # prevents window closures
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  unless self.method_defined?('heretic_number_window_backup_initialize')
    alias heretic_number_window_backup_initialize initialize
  end
  
  def initialize
    # Call Original
    heretic_number_window_backup_initialize
    @num_input_variable_id_backup = 0
    @input_in_window = false
  end
end
  
#------------------------------------------------------------------------------

class Bitmap
  
  attr_accessor :orientation

  #--------------------------------------------------------------------------
  # * Rotation Calculation
  #--------------------------------------------------------------------------
  def rotation(target)
    return if not [0, 90, 180, 270].include?(target) # invalid orientation
    if @rotation != target
      degrees = target - @orientation
      if degrees < 0
        degrees += 360
      end
      rotate(degrees)
    end    
  end
  
  #--------------------------------------------------------------------------
  # * Rotate Square (Clockwise)
  #--------------------------------------------------------------------------
  def rotate(degrees = 90)
    # method originally by SephirothSpawn
    # would just use Sprite.angle but its rotation is buggy
    # (see http://www.rmxp.org/forums/showthread.php?t=12044)
    return if not [90, 180, 270].include?(degrees)
    copy = self.clone
    if degrees == 90
      # Passes Through all Pixels on Dummy Bitmap
      for i in 0...self.height
        for j in 0...self.width
          self.set_pixel(width - i - 1, j, copy.get_pixel(j, i))
        end
      end
    elsif degrees == 180
      for i in 0...self.height
        for j in 0...self.width
          self.set_pixel(width - j - 1, height - i - 1, copy.get_pixel(j, i))
        end
      end      
    elsif degrees == 270
      for i in 0...self.height
        for j in 0...self.width
          self.set_pixel(i, height - j - 1, copy.get_pixel(j, i))
        end
      end
    end
    @orientation = (@orientation + degrees) % 360
  end

end

#------------------------------------------------------------------------------

class Window_Base
  
  #--------------------------------------------------------------------------
  # * Check Color
  #     color : color to check
  #--------------------------------------------------------------------------
  def check_color(color)
    if color.is_a?(Color)
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
      color = color.to_i
      if color >= 0 and color <= 7
        return text_color(color)
      end
    end
    return normal_color
  end
  
end

#------------------------------------------------------------------------------

class Window_InputNumber < Window_Base

  def set_font(fname, fsize, fcolor)
    return if fname == nil and fsize == nil and fcolor == nil
    # Calculate cursor width from number width
    dummy_bitmap = Bitmap.new(32, 32)
    dummy_bitmap.font.name = fname
    dummy_bitmap.font.size = fsize
    @cursor_width = dummy_bitmap.text_size("0").width + 8
    dummy_bitmap.dispose
    self.width = @cursor_width * @digits_max + 32
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = fname
    self.contents.font.size = fsize
    self.contents.font.color = check_color(fcolor)
    refresh
    update_cursor_rect
  end

  def refresh
    self.contents.clear
    #self.contents.font.color = normal_color
    s = sprintf("%0*d", @digits_max, @number)
    for i in 0...@digits_max
      self.contents.draw_text(i * @cursor_width + 4, 0, 32, 32, s[i,1])
    end
  end
  
end

#------------------------------------------------------------------------------
# * End SDK Enable Test
#------------------------------------------------------------------------------
#end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Frame Update - Redefinition - Added Aug 31st, 2013
  #
  #   This fixes a Visual Bug where a Windowskin will change on you when
  #   a Non Floating Message Window is Fading Out.  The NEXT Message will
  #   have the newly set Windowskin applied.
  #--------------------------------------------------------------------------
  def update
    super
    # Reset if windowskin was changed
    if $game_system.windowskin_name != @windowskin_name
      # Prevents changing Message Windowskin until Next Message
      if not self.is_a?(Window_Message)
        @windowskin_name = $game_system.windowskin_name
        self.windowskin = RPG::Cache.windowskin(@windowskin_name)
      end
    end
  end
end

# MMW SDK / Non-SDK Patch

# If SDK is not installed
if not Module.constants.include?('SDK')

  # Use this script to disable Multiple Message Windows SDK Requirements
  
  #=============================================================================
  # ** Game_Multi_Message
  #-----------------------------------------------------------------------------
  #  This class handles the actor array. Refer to "$game_actors" for each
  #  instance of this class.
  #=============================================================================
  
  class Game_Multi_Message 
    #--------------------------------------------------------------------------
    # * Data
    #--------------------------------------------------------------------------
    def initialize()  @data = []         end
    def [](id)        @data[id]          end
    def []=(id,val)   @data[id] = val    end
    def update()      @data.each {|s| s.respond_to?(:update) && s.update }   end
    def dispose()     @data.each {|s| s.respond_to?(:dispose) && s.dispose } end
    #--------------------------------------------------------------------------
    # ● Method Missing
    #--------------------------------------------------------------------------
    def method_missing(val,*args,&block)
      return @data.send(val.to_s,*args,&block) if @data.respond_to?(val.to_sym)
      text = "Undefined method #{val} at #{self.inspect}" 
      raise(NoMethodError, text, caller(1))               
    end
  end
  
#=========================================
# ▼ Class Window_Frame Begins
#=========================================
class Window_Frame < Window_Base

def initialize(x, y, width, height)
super(x, y, width, height)
self.windowskin = RPG::Cache.windowskin($game_system.message.name_box_skin)
self.contents = nil
end
#--------------------------------------------------------------------------

def dispose
super
end
end
  
  #=============================================================================
  # ** Scene_Map
  #-----------------------------------------------------------------------------
  #  This class performs map screen processing.
  #=============================================================================
  class Scene_Map
    #--------------------------------------------------------------------------
    # ● Alias Listing
    #--------------------------------------------------------------------------
    $@ || alias_method(:mmw_sdk_patch_update, :update)
    #--------------------------------------------------------------------------
    # ● Main Dispose
    #--------------------------------------------------------------------------
    method_defined?(:main_dispose) or define_method(:main_dispose) {0} 
    #--------------------------------------------------------------------------
    # ● Frame Update
    #--------------------------------------------------------------------------
    def update(*args)
      unless @message_window.is_a?(Game_Multi_Message)
        @message_window.respond_to?(:dispose) && @message_window.dispose 
        @message_window = Game_Multi_Message.new
        @message_window[0] = Window_Message.new(0)
      end
      mmw_sdk_patch_update(*args)
    end
  end
  
  #=============================================================================
  # ** Scene_Battle 
  #-----------------------------------------------------------------------------
  #  This class performs battle screen processing.
  #=============================================================================
  class Scene_Battle
    #--------------------------------------------------------------------------
    # ● Alias Listing
    #--------------------------------------------------------------------------
    $@ || alias_method(:mmw_sdk_patch_update, :update)
    #--------------------------------------------------------------------------
    # ● Frame Update
    #--------------------------------------------------------------------------
    def update(*args)
      unless @message_window.is_a?(Game_Multi_Message)
        @message_window.respond_to?(:dispose) && @message_window.dispose 
        @message_window = Game_Multi_Message.new
        @message_window[0] = Window_Message.new(0)
      end
      mmw_sdk_patch_update(*args)
    end
  end

#=========================================
# ▼ Class Air_Text Begins 
#=========================================
class Air_Text < Window_Base

def initialize(x, y, designate_text, color=0)
 
super(x-16, y-16, 32 + designate_text.size * 12, 56)
self.opacity      = 0
self.back_opacity = 0
self.contents = Bitmap.new(self.width - 32, self.height - 32)
w = self.contents.width
h = self.contents.height
self.contents.font.name = $defaultfonttype
self.contents.font.size = $defaultfontsize
#self.contents.font.color = text_color(3)#color
self.contents.draw_text(0, 0, w, h, designate_text)
end

#--------------------------------------------------------------------------

def dispose
self.contents.clear
super
end
end 
  #=============================================================================
  # ** Game_Player
  #-----------------------------------------------------------------------------
  #  This class handles the player. Its functions include event starting
  #  determinants and map scrolling. Refer to "$game_player" for the one
  #  instance of this class.
  #=============================================================================
  class Game_Player
    #--------------------------------------------------------------------------
    # * Player Movement Update
    #--------------------------------------------------------------------------
    unless method_defined?(:update_player_movement)
      def update_player_movement
      
        if Keys.press?($keyboard["down"])
         move_down
      elsif Keys.press?($keyboard["left"])
         move_left
      elsif Keys.press?($keyboard["right"])
         move_right
      elsif Keys.press?($keyboard["up"])
         move_up
      end
=begin
        case Input.dir4
        when 2 then move_down
        when 4 then move_left
        when 6 then move_right
        when 8 then move_up
        end
=end
      end
    end
  end

end # End SDK Not Installed