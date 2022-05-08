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

  
  Version History: (Heretic)
  1.56 - Sunday, April 19th, 2015
  - Fixed a minor issue with Sticky
  - Fixed an issue with \b and \i causing delays when Letter by Letter is off
  - Fixed a bug with set_max_dist causing List Termination when an NPC
    moved away from the Player.
  - Fixed a bug where \$ and \% caused a Crash in Non Floating Windows
  - Added code for compatability with Sprite Zooming and Floating for
    both Heretic's Vehicles and Heretic's Rotate, Zoom, and Pendulums
  - Added code for compatability with Heretic's Loop Maps
  - Added "comma_skip_delay" so players can speed through dialogue
  - Added "save = true / false" Option for MMW Settings in set_max_dist(N)
  - Added "clear_max_dist" Option for NPCs and Signs with Cutscenes
  
    ---  SET MAX DIST and CLEAR MAX DIST  ---
    
    Players tend to get BORED with Dialogue Heavy NPCs, and the easiest way to
    prevent Players from quitting the game is to allow them to WALK AWAY from
    an NPC while they are talking.  When the Human Player gets trapped into any
    very long dialogue from RANDOM NPCs, that is when they get BORED the most
    and you run the risk of them quitting your game as a result.  Important
    NPC Character Dialogue is one thing, but for Towns Folk and Signs and
    other places you've written OPTIONAL DIALOGUE, the best thing to do is
    to allow the Player to WALK AWAY.  Initially, this will cause you some
    issues if you need to change MMW Settings for the course of that NPC
    or Event Dialogue, such as Fonts or Floating or Speed.  What happens
    is once those MMW Settings are changed, they are used on the Next Event
    that is executed by the Player.  Thus, set_max_dist(N) was implemented
    to allow the Player to WALK AWAY and not cause any changes to what you
    want as your "Normal MMW Settings" on the Next Event.
    
    The command 'set_max_dist(N, save = true[default] / false)' is most useful
    on Events where you change a MMW Setting during Event Execution so if the
    Player walks away, your MMW Settings are automatically restored.  This 
    helps to simplify your NPCs and Signs so you don't have to configure all
    your MMW Settings for each and every event, only the ones you want to
    change during the execution of that event.  The trouble is by setting 
    a Maximum Distance (in Tiles), with an NPC that takes control of the
    Player and moves them to more than the Maximum Distance you specify, the
    Event will Exit Event Execution.  Thus, you can CLEAR the Maximum Distance
    on an Event by running a script 'clear_max_dist' which will not affect
    any Saved MMW Settings, but will allow you to move the Player or Event
    to any distance from each other.  If you need to do this, also use
    the feature 'message.move_during = false' while doing whatever you do
    at a Distance from the Event.
    
    Example NPC or Sign where Player moves away from Event:
    
    @>set_max_dist(2)
    @>\$Let me show you something!
    @>(Change MMW Setting, stored by set_max_dist(2))
    @>clear_max_dist                # No MMW changes, but now NO Max Distance!
    @>message.move_during = false
    @>(Move Player away from NPC / Sign / Event)
    @>(More Text, but at a distance greater than your Max Dist) # Cant Walk Away
    @>(Other move commands)
    @>(Move back to Sign)
    @>message.move_during = true     # (Allow walking away again)
    @>set_max_dist(2, save = false)  # (Doesnt change the stored MMW Settings)
    @>(More Text)                    # Here, Player can walk away again!
    
    When Events dont change any of the MMW Settings at all, then set_max_dist(N)
    is still useful because while Messages are displayed, Touch Events do
    not Trigger at all.  Thus, calling set_max_dist(N) helps to make sure that
    the Touch Events still trigger properly.
    
    
    
    Example Typical NPC:
    
    (NPC has a Move Route to move at Random)
    
    set_max_dist(2)
    @>Set Move Route: Turn Toward Player (Repeat)
    @>\$\F+Hi there!  This is some text.\F-
    @>\$\F+This is more text.\F-
    @>\$\F+Even more text where the player gets bored and walks away.\F-
    @>Set Move Route: Turn Toward Player (No Repeat)
    
    Player moves away more than Two Tiles from NPC and Dialogue Window closes.
    
    
    
    Example Typical Sign (MMW Settings are changed)
    
    (Event does not move and has Direction Fix set to ON)
    
    set_max_dist(1)
    @>\P[0]The \bSign\b says:
    @>Script: message.floating = false
              message.letter_by_letter = false
    @>(Sign Text)
    @>Script: message.floating = true
              message.letter_by_letter = true
              
    Here, the MMW Settings are changed.  Change them back at the end of the
    list of Event Commands.  If the Player WALKS AWAY from the sign, the
    stored MMW Settings are recalled and helps save you a TON of work because
    the next Event will use the recalled MMW Settings.  As a result, you don't
    have to set message.floating = true on EVERY Event.  Just change the stuff
    you need to change for that part of the NPC or Event Dialogue.
    
    
    When using REPOSITION ON TURN, you need to have several things:
    - First, save your MMW Settings and set Max Dist with "set_max_dist(N)"
    - Next, your "N" or Distance must be higher than 1
    - Turn the Event toward the Player and turn on Repeat
    - Run your Dialogue
    - Clear the Repeating Move Route on the Event with another Set Move Route
    
    If you don't want the NPC to "pay attention" to the Player, you can 
    simply use an "N" value of 1 so as soon as the Player steps even
    adjacently, the Message Bubble will close.  I like using a value of 2
    because it implies the NPC is "paying attention" to the actions
    of the Player.  Repeating Move Routes will also RESET if the Player
    walks away, but be sure to use a Non Repeating Move Route as the LAST
    of the List of Event Commands, otherwise, the Event will "get stuck"
    always paying attention to the Player.
  
    
    
  1.55
  - Removed SDK Dependancy
  - Script will work either WITH or WITHOUT the SDK now automatically
    * NOTE: Different methods are defined and replaced depending on whether
            or not the SDK is installed or not.
  
  1.54
  - Added Option for Variable Text with \v[Tn]
    $game_system.mmw_text[0] = "Hello World!"
    In the "Show Text..." box, put in \v[T0] to display Hello World!
    
  - Added Player Sticky
  
    This means that Event and Player Message Stickyness are now independant.
    When the player moves around, I tried to reposition the Message Bubble to
    maximize player visibility by placing the Message Bubble out of where I
    think they are intending to go.  For example, when the player presses
    Right, the Players Character faces to the Right, so in order to make sure
    the Player can see where they are trying to go, the Message Bubble is
    repositioned to the left of the Players Character.
    
    Repositioning can cause some issues with making some Messages off screen
    and unable to be read.  In order to work around this, Sticky was added to
    favor the Top and Bottom positions.  A Sticky Message can start anywhere,
    but once it is moved, it will try to stick to the Top or the Bottom because
    position on the Left and Right causes some long messages to go offscreen
    and become unreadable.
    
    That is what Sticky means.
    
    - $game_player.sticky is set to FALSE by Default, and will RESET to FALSE
    at the end of Event Execution.
    
  - Added Windowskin as a Saved Variable.  That way if you walk away from
    a sign that has a different Windowskin, that Windowskin will also be
    reset when you walk away from a sign before the Event complets its list
    of commands to execute.
    
  - Fixed a Visual Bug where a Non Floating Message Window would change
    the Windowskin while fading out.  Redefined Window_Base update to
    fix this bug.
    
  - Changed set_max_dist to allow a Zero Distance.  This is useful for
    Passable Events.
    
  - Fixed some Visual Glitches caused by other features I added becoming
    read in characters in version 1.04 of the engine.  1.02 seems to 
    work just fine and caused me to miss these.
    
  - Fixed a bug with set_max_dist(N).  Cutscenes where the Player is moved
    around by Event Commands would cause Event to stop executing.  Changed
    to require move_during to be True and $game_player.move_route_forcing
    to be False for Message Windows to automatically close.  So if you
    set message.move_during = false, a Cutscene is assumed and Windows
    will not be closed.
    
  1.53 (Heretic)
  
  - Added SOUNDS while text is printing out.  Think Banjo Kazooie
  
    What you NEED to know:  When an Event has finished its commands, or if
    you walk away from it, your Sound Settings will RESET.  This is intentional.
    It was implemented to save you work.  Although it is quite possible to do,
    the way a non scripter would end up trying to do this would be tremendous.
    Thus, I did it for you.
    
    There are several things you should know about SOUNDS.
    
    #1 - Sound does NOT play for every single character.  It plays a sound every
    several characters.  Im not psychic, so I dont know what sound you will
    be using, if any at all.  Because of this, the duration of that sound might
    be different than some of the samples I've included.  As a result, you may
    decide that it sounds better to play your sound every character or every 5
    characters.  Thus, it is totally optional.  The option is called
    message.sound_frequency
    
    #2 - It only plays sounds for Letters and Numbers, so non alphanumeric 
    characters do not play sounds.  This includes spaces, and special characters
    used for any of the message script options.  This is just something that I
    thought you should be aware of.
    
    #3 - The Audio File you use needs to be imported into Sound Effects, under
    Materialbase -> Audio/SE (its the one at the very bottom of the list).
    I ran into a couple of files that caused both the editor and the game to 
    crash when I tried to play them, so you may need to convert problematic
    audio files to a different format.
    
    Several of the files I've imported I got from FlashKit.com.  Not all of
    these files were compatible.  Other than that, it does have a good selection
    of royalty free sound files.
    
    http://www.flashkit.com/soundfx/
    
    I considered setting up sound properties for each event and NPC, but decided
    to pass on that because it caused more problems than it appeared to solve.
    Also being considered are options to change the sound properties from within
    the text itself.  The same way as you can make characters bold, delay, or
    other features already built into the script.  If there is interest, I will
    put them in, but for now, once a window starts to display its text, there
    arent any options to change it until the next message window is displayed.
    
    -----  SOUND OPTIONS  -----
    
    These can be changed at any time with scripts.
    
    message.sound = true / false             # Enables or Disables Text Sounds  
    message.sound_audio = '001-System01'     # Audio SE (in DB) to play
    message.sound_volume = 80                # Text Sound Volume
    message.sound_pitch = 80                 # Text Sound Pitch
    message.sound_pitch_range = 20           # How Much to vary the Pitch
    message.sound_vary_pitch = true          # Whether to Vary the Pitch or not
    message.sound_frequency = 2              # Plays a sound this many letters
    
    
  1.52 (Heretic)
  
  - Added ability to "Auto Close" Non Floating Messages based on proximity
    to the triggered event.  You'll have to set a script for Every Event
    you want this to occur on.
    "set_max_dist(n)" where n the Distance in Steps.  One is Minimum.
    
    Notes:  set_max_dist will SAVE all of your MMW settings, and in the
    event that the event execution is terminated early, it will restore
    these settings you originally had.  This is done automatically in
    order to prevent you from having to do unnecessary work.  I find
    it was most useful for Signs where you might set message.floating = false
    which would have resulted in you needing to put in floating = true
    for every other event.  It just saves you work.  SO if you do want
    to have a more permanent adjustment to your MMW settings, call them
    BEFORE you call "set_max_dist(n)"
    
    If you expect the event to play out in its entirety, consider
    using message.move_during = false.  This is intended to allow the event
    to NOT COMPLETE all the entries in an event by allowing the player to
    walk away and close the window.
    
  - Added the ability to "flip" a Message Bubble (non floating) on NPC Turn.
  
    This was done to allow the player to see where they are going.  When
    the player moves around, they need to be able to see where they are
    going, and a Message Bubble can sometimes get in their way.  I also
    set it up so that once an NPC is moved (not turned), this feature
    turns itself off because it assumes a Cutscene.
    
    This requires several things to work.
    #1:  reposition_on_turn is enabled (message.reposition_on_turn = true)
    #2:  NPC is set to turn_toward_player(repeat)
    #3:  NPC has NOT been moved (there are ways around this)
    #4:  Message Window is Auto Oriented using \$ or \%
    
    If you feel like re-enabling this feature after an NPC has been
    moved, you can use a Move Route Script @allow_flip = true for
    that NPC.
    
  - Added the Auto Flipping Message Windows to be "Sticky"
  
    What this means is that when a Message Window is repositioned, the
    next window will appear in the same location as the previous window.
    
    Change it with message.sticky = true / false
    
  1.51b
  
  - Added \G+ and \G- to allow Gold Window to be at the Top or Bottom
    of the screen.  \G can still be used.  It just positions opposite
    of where the player is at.  Just a bit more control over the
    position of the Gold Window.
  
  1.51a
  
  - By Request, added the \F* option to put the "Other Foot Forward"
  
  1.51 
  
  - Added \* option to display next message at ANY time  
  
  - Added \$ and \$ options to Auto Orient Message Bubbles relative to 
    the direction the Speaker is facing.
    
  - Added "Foot Forward" commands available with \F+ and \F-
  
  - Added automatic features to reset a Speaking NPC to its original Stance
    and make it Continue its Move Route.  
  
  *NOTE* - The links provided in the comments may be out of date.

  This custom message system adds numerous features on top of the default
  message system, the most notable being the ability to have multiple message
  windows open at once. The included features are mostly themed around turning
  messages into speech (and thought) balloons, but default-style messages are
  of course still possible.

  Note:
  This version of the script uses the SDK, available from:
  http://www.rmxp.org/forums/showthread.php?t=1802
  
  FEATURES
  
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
    * \IC[] = display icon with that name
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
  - \A = auto-pause mode toggle for ,.?! characters
  - \S[n] = set speed at which text appears in letter-by-letter mode
  - \D[n] = set delay (in frames) before next text appears
  - \.    = adds a short delay
  - \P[n] = position message over event with id n
            * use n=0 for player
            * in battle, use n=a,b,c,d for actors (e.g. \P[a] for first actor)
              and n=1,...,n for enemies (e.g. \P[1] for first enemy)
              where order is actually the reverse of troop order (in database)
  - \P[Cn] = Tie-In with Caterpillar.  Positions Message over Cat Actor
              in n Position of Caterpillar.  1 for First Cat Actor, etc...
            * example: \P[C2] for 2nd Cat Actor, or 3rd Actor in Caterpillar
            * n excludes Player
  - \P = position message over current event (default for floating messages)
  - \xy[x,y] = position message at specific x,y coordinates (PLANNED)
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
  - \. = adds a delay (New!!)
  
  New in 1.5x
  
  * \f[face_image] = display faceset image
                   image must be placed in folder pictures and the size
                   is 80x80
  * \Na[name]       = display message name!!!!
  
  =============================================================================
   Global (specified below or by Call Script and persist until changed)
  =============================================================================
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
  - message.comma_skip_delay = true/false
    * allows skipping delays inserted by commans when Player skips to end of msg
  - message.auto_comma_delay = n
    * changes how long to wait after a pausable character
  - message.auto_ff_reset = true/false
    * resets a Foot Forward stance if a message wnidow is closed for off-screen
    * set to false if it causes animation problems, or, dont use Foot Forward
      on a specific NPC or Event
  - message.auto_move_continue = true/false
    * when moving an event off screen while speaking, resets previous move route
  - message.dist_exit = true/false
    * close messages if the player walks too far away
  - message.dist_max = n
    * the distance away from the player before windows close
  - message.reposition_on_turn = true / false
    * Repeat Turn Toward Player NPC's Reorient Message Windows if they Turn
  - message.sticky
    * If Message was Repositioned, next message will go to that Location
    
  Auto Repositioning Message Windows
  - Cannot be Player
  - NPC MUST have some form of Repeating Turn, usually toward Player
  - NPC MUST NOT MOVE.  Turning is Fine, but cant MOVE
  
  - set_max_dist(n)
    * Useful for allowing player to walk away from signs
    * Saves your MMW Config in case of a Walk-Away Closure
    * call from Event Editor => Scripts
  
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
    * set size of text  (default 18), overriding all defaults
  - message.font_color = color
    * set color of text, overriding all defaults
    * you can use same 0-7 as for \C[n] or "#xxxxxx" for hexadecimal
    
  Set Move Route:
  - foot_forward_on (frame)
    * Optional Parameter - frame
    * foot_forward_on(0) is default, treated as just foot_forward_on
    * foot_forward_on(1) puts the "Other" Foot Forward
  - foot_forward_off

  Note that the default thought and shout balloon windowskins don't
  stretch to four lines very well (unfortunately).
    
  Thanks:
  XRXS code for self-close and wait for input
  Slipknot for a convenient approach to altering settings in-game
  SephirothSpawn for bitmap rotate method
  
=end