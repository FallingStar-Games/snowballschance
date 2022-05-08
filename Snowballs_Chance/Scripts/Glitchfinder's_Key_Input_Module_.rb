 #≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
# ** Glitchfinder's Key Input Module              [RPG Maker XP] [RPG Maker VX]
#    Version 1.00
#------------------------------------------------------------------------------
#  This script helps scripters to use the full range of keys on any keyboard,
#  without being limited by the default Input Module.
#==============================================================================
# * Version History
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   Version 1.00 ------------------------------------------------- (2010-03-18)
#     - Initial version
#     - Author: Glitchfinder
#==============================================================================
# * Instructions
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Place this script above Main, and below the default scripts. (I realize this
#  is obvious to most, but some people don't get it.)
#
#  This module is automatically updated by the default Input module, which
#  means that the only time you need to call the update method is in a scene
#  that does not update the default Input module.
#
#  This module does not break the functionality of the default Input module.
#
#  If you wish to read keys from a gamepad, you must still use the default
#  input module to do so.
#
#  To use this module, simply use one of the four methods (press?(key),
#  trigger?(key), repeat?(key), or release?(key)), where key is the index of
#  the key you want to check. Key may also be used as Keys::KEYNAME. For a list
#  of acceptable key names, look below the header.
#==============================================================================
# * Method List
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Keys.update
#    Updates keyboard input. Calls to this method are not necessary unless the
#    default Input module is not being updated.
#
#  Keys.press?(key)
#    Determines whether the button determined by key is currently being
#    pressed. If the button is being pressed, returns true. If not, returns
#    false.
#
#  Keys.trigger?(key)
#    Determines whether the button determined by key is being pressed again.
#    "Pressed again" is seen as time having passed between the button being not
#    pressed and being pressed. If the button is being pressed, returns true.
#    If not, returns false.
#
#  Keys.repeat?(key)
#    Determines whether the button determined by key is being pressed again.
#    Unlike trigger?(), this takes into account the repeat input of a button
#    being held down continuously. If the button is being pressed, returns
#    true. If not, returns false.
#
#  Keys.release?(key)
#    Determines whether the button determined by key has just been released. If
#    the button has been released, returns true. If not, returns false.
#==============================================================================
# *Glitchfinder's Advice
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  This script is meant for people with a medium or advanced level of scripting
#  knowledge and ability, or for those using scripts that require this module.
#==============================================================================
# * Contact
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  Glitchfinder, the author of this script, may be contacted through his
#  website, found at http://www.glitchkey.com
#
#  You may also find Glitchfinder at http://www.hbgames.org
#==============================================================================
# * Usage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  This script may be used with the following terms and conditions:
#
#    1. This script is free to use in any noncommercial project. If you wish to
#       use this script in a commercial (paid) project, please contact
#       Glitchfinder at his website.
#    2. This script may only be hosted at the following domains:
#         http://www.glitchkey.com
#         http://www.hbgames.org
#    3. If you wish to host this script elsewhere, please contact Glitchfinder.
#    4. If you wish to translate this script, please contact Glitchfinder. He
#       will need the web address that you plan to host the script at, as well
#       as the language this script is being translated to.
#    5. This header must remain intact at all times.
#    6. Glitchfinder remains the sole owner of this code. He may modify or
#       revoke this license at any time, for any reason.
#    7. Any code derived from code within this script is owned by Glitchfinder,
#       and you must have his permission to publish, host, or distribute his
#       code.
#    8. This license applies to all code derived from the code within this
#       script.
#    9. If you use this script within your project, you must include visible
#       credit to Glitchfinder, within reason.
#≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

#==============================================================================
# ** Keys
#------------------------------------------------------------------------------
#  This module performs key input processing
#==============================================================================

module Keys
  #--------------------------------------------------------------------------
  # * Miscellaneous Keys
  #--------------------------------------------------------------------------
  CANCEL              = 0x03 # Control-Break Processing
  BACKSPACE           = 0x08 # Backspace Key
  TAB                 = 0x09 # Tab Key
  CLEAR               = 0x0C # Clear Key
  RETURN              = 0x0D # Enter Key
  SHIFT               = 0x10 # Shift Key
  CONTROL             = 0x11 # Ctrl Key
  MENU                = 0x12 # Alt Key
  PAUSE               = 0x13 # Pause Key
  ESCAPE              = 0x1B # Esc Key
  CONVERT             = 0x1C # IME Convert Key
  NONCONVERT          = 0x1D # IME Nonconvert Key
  ACCEPT              = 0x1E # IME Accept Key
  SPACE               = 0x20 # Space Bar Key (Space, usually blank)
  PRIOR               = 0x21 # Page Up Key
  NEXT                = 0x22 # Page Down Key
  ENDS                = 0x23 # End Key
  HOME                = 0x24 # Home Key
  LEFT                = 0x25 # Left Arrow Key
  UP                  = 0x26 # Up Arrow Key
  RIGHT               = 0x27 # Right Arrow Key
  DOWN                = 0x28 # Down Arrow Key
  SELECT              = 0x29 # Select Key
  PRINT               = 0x2A # Print Key
  EXECUTE             = 0x2B # Execute Key
  SNAPSHOT            = 0x2C # Print Screen Key
  DELETE              = 0x2E # Delete Key
  HELP                = 0x2F # Help Key
  LSHIFT              = 0xA0 # Left Shift Key
  RSHIFT              = 0xA1 # Right Shift Key
  LCONTROL            = 0xA2 # Left Control Key (Ctrl)
  RCONTROL            = 0xA3 # Right Control Key (Ctrl)
  LMENU               = 0xA4 # Left Menu Key (Alt)
  RMENU               = 0xA5 # Right Menu Key (Alt)
  PACKET              = 0xE7 # Used to Pass Unicode Characters as Keystrokes
  #--------------------------------------------------------------------------
  # * Number Keys
  #--------------------------------------------------------------------------
  N0                  = 0x30 # 0 Key
  N1                  = 0x31 # 1 Key
  N2                  = 0x32 # 2 Key
  N3                  = 0x33 # 3 Key
  N4                  = 0x34 # 4 Key
  N5                  = 0x35 # 5 Key
  N6                  = 0x36 # 6 Key
  N7                  = 0x37 # 7 Key
  N8                  = 0x38 # 8 Key
  N9                  = 0x39 # 9 Key
  #--------------------------------------------------------------------------
  # * Letter Keys
  #--------------------------------------------------------------------------
  A                   = 0x41 # A Key
  B                   = 0x42 # B Key
  C                   = 0x43 # C Key
  D                   = 0x44 # D Key
  E                   = 0x45 # E Key
  F                   = 0x46 # F Key
  G                   = 0x47 # G Key
  H                   = 0x48 # H Key
  I                   = 0x49 # I Key
  J                   = 0x4A # J Key
  K                   = 0x4B # K Key
  L                   = 0x4C # L Key
  M                   = 0x4D # M Key
  N                   = 0x4E # N Key
  O                   = 0x4F # O Key
  P                   = 0x50 # P Key
  Q                   = 0x51 # Q Key
  R                   = 0x52 # R Key
  S                   = 0x53 # S Key
  T                   = 0x54 # T Key
  U                   = 0x55 # U Key
  V                   = 0x56 # V Key
  W                   = 0x57 # W Key
  X                   = 0x58 # X Key
  Y                   = 0x59 # Y Key
  Z                   = 0x5A # Z Key
  #--------------------------------------------------------------------------
  # * Windows Keys
  #--------------------------------------------------------------------------
  LWIN                = 0x5B # Left Windows Key (Natural keyboard)
  RWIN                = 0x5C # Right Windows Key (Natural Keyboard)
  APPS                = 0x5D # Applications Key (Natural keyboard)
  SLEEP               = 0x5F # Computer Sleep Key
  BROWSER_BACK        = 0xA6 # Browser Back Key
  BROWSER_FORWARD     = 0xA7 # Browser Forward Key
  BROWSER_REFRESH     = 0xA8 # Browser Refresh Key
  BROWSER_STOP        = 0xA9 # Browser Stop Key
  BROWSER_SEARCH      = 0xAA # Browser Search Key
  BROWSER_FAVORITES   = 0xAB # Browser Favorites Key
  BROWSER_HOME        = 0xAC # Browser Start and Home Key
  VOLUME_MUTE         = 0xAD # Volume Mute Key
  VOLUME_DOWN         = 0xAE # Volume Down Key
  VOLUME_UP           = 0xAF # Volume Up Key
  MEDIA_NEXT_TRACK    = 0xB0 # Next Track Key
  MEDIA_PREV_TRACK    = 0xB1 # Previous Track Key
  MEDIA_STOP          = 0xB2 # Stop Media Key
  MEDIA_PLAY_PAUSE    = 0xB3 # Play/Pause Media Key
  LAUNCH_MAIL         = 0xB4 # Start Mail Key
  LAUNCH_MEDIA_SELECT = 0xB5 # Select Media Key
  LAUNCH_APP1         = 0xB6 # Start Application 1 Key
  LAUNCH_APP2         = 0xB7 # Start Application 2 Key
  PROCESSKEY          = 0xE5 # IME Process Key
  ATTN                = 0xF6 # Attn Key
  CRSEL               = 0xF7 # CrSel Key
  EXSEL               = 0xF8 # ExSel Key
  EREOF               = 0xF9 # Erase EOF Key
  PLAY                = 0xFA # Play Key
  ZOOM                = 0xFB # Zoom Key
  PA1                 = 0xFD # PA1 Key
  #--------------------------------------------------------------------------
  # * Number Pad Keys
  #--------------------------------------------------------------------------
  NUMPAD0             = 0x60 # Numeric Keypad 0 Key
  NUMPAD1             = 0x61 # Numeric Keypad 1 Key
  NUMPAD2             = 0x62 # Numeric Keypad 2 Key
  NUMPAD3             = 0x63 # Numeric Keypad 3 Key
  NUMPAD4             = 0x64 # Numeric Keypad 4 Key
  NUMPAD5             = 0x65 # Numeric Keypad 5 Key
  NUMPAD6             = 0x66 # Numeric Keypad 6 Key
  NUMPAD7             = 0x67 # Numeric Keypad 7 Key
  NUMPAD8             = 0x68 # Numeric Keypad 8 Key
  NUMPAD9             = 0x69 # Numeric Keypad 9 Key
  MULTIPLY            = 0x6A # Multiply Key (*)
  ADD                 = 0x6B # Add Key (+)
  SEPARATOR           = 0x6C # Separator Key
  SUBTRACT            = 0x6D # Subtract Key (-)
  DECIMAL             = 0x6E # Decimal Key (.)
  DIVIDE              = 0x6F # Divide Key (/)
  #--------------------------------------------------------------------------
  # * Function Keys
  #--------------------------------------------------------------------------
  F1                  = 0x70 # F1 Key
  F2                  = 0x71 # F2 Key
  F3                  = 0x72 # F3 Key
  F4                  = 0x73 # F4 Key
  F5                  = 0x74 # F5 Key
  F6                  = 0x75 # F6 Key
  F7                  = 0x76 # F7 Key
  F8                  = 0x77 # F8 Key
  F9                  = 0x78 # F9 Key
  F10                 = 0x79 # F10 Key
  F11                 = 0x7A # F11 Key
  F12                 = 0x7B # F12 Key
  F13                 = 0x7C # F13 Key
  F14                 = 0x7D # F14 Key
  F15                 = 0x7E # F15 Key
  F16                 = 0x7F # F16 Key
  F17                 = 0x80 # F17 Key
  F18                 = 0x81 # F18 Key
  F19                 = 0x82 # F19 Key
  F20                 = 0x83 # F20 Key
  F21                 = 0x84 # F21 Key
  F22                 = 0x85 # F22 Key
  F23                 = 0x86 # F23 Key
  F24                 = 0x87 # F24 Key
  #--------------------------------------------------------------------------
  # * Toggle Keys
  #--------------------------------------------------------------------------
  CAPITAL             = 0x14 # Caps Lock Key
  KANA                = 0x15 # IME Kana Mode Key
  HANGUL              = 0x15 # IME Hangul Mode Key
  JUNJA               = 0x17 # IME Junja Mode Key
  FINAL               = 0x18 # IME Final Mode Key
  HANJA               = 0x19 # IME Hanja Mode Key
  KANJI               = 0x19 # IME Kanji Mode Key
  MODECHANGE          = 0x1F # IME Mode Change Request Key
  INSERT              = 0x2D # Insert Key
  NUMLOCK             = 0x90 # Num Lock Key
  SCROLL              = 0x91 # Scroll Lock Key
  #--------------------------------------------------------------------------
  # * OEM Keys (Vary by keyboard)
  #--------------------------------------------------------------------------
  OEM_1               = 0xBA # Misc Characters (; : in USA 101/102 Keyboards)
  OEM_PLUS            = 0xBB # + = Key
  OEM_COMMA           = 0xBC # , < Key
  OEM_MINUS           = 0xBD # - _ Key
  OEM_PERIOD          = 0xBE # . > Key
  OEM_2               = 0xBF # Misc Characters (/ ? in USA 101/102 Keyboards)
  OEM_3               = 0xC0 # Misc Characters (` ~ in USA 101/102 Keyboards)
  OEM_4               = 0xDB # Misc Characters ([ { in USA 101/102 Keyboards)
  OEM_5               = 0xDC # Misc Characters (\ | in USA 101/102 Keyboards)
  OEM_6               = 0xDD # Misc Characters (] } in USA 101/102 Keyboards)
  OEM_7               = 0xDE # Misc Characters (' " in USA 101/102 Keyboards)
  OEM_8               = 0xDF # Misc Characters (Varies by Keyboard)
  OEM_9               = 0xE1 # OEM Specific
  OEM_10              = 0x92 # OEM Specific
  OEM_11              = 0x93 # OEM Specific
  OEM_12              = 0x94 # OEM Specific
  OEM_13              = 0x95 # OEM Specific
  OEM_14              = 0x96 # OEM Specific
  OEM_15              = 0xE3 # OEM Specific
  OEM_16              = 0xE4 # OEM Specific
  OEM_17              = 0xE6 # OEM Specific
  OEM_18              = 0xE9 # OEM Specific
  OEM_19              = 0xEA # OEM Specific
  OEM_20              = 0xEB # OEM Specific
  OEM_21              = 0xEC # OEM Specific
  OEM_22              = 0xED # OEM Specific
  OEM_23              = 0xEE # OEM Specific
  OEM_24              = 0xEF # OEM Specific
  OEM_25              = 0xF1 # OEM Specific
  OEM_26              = 0xF2 # OEM Specific
  OEM_27              = 0xF3 # OEM Specific
  OEM_28              = 0xF4 # OEM Specific
  OEM_29              = 0xF5 # OEM Specific
  OEM_102             = 0xE2 # Angle Bracket or Backslash on RT-102 Keyboards
  OEM_CLEAR           = 0xFE # Clear Key
  #--------------------------------------------------------------------------
  # * Declare Module Variables
  #--------------------------------------------------------------------------
  # Create string for unpacking input
  @unpack_string = 'b'*256
  # Generate blank input arrays
  @last_array = '0'*256
  @press = Array.new(256, false)
  @trigger = Array.new(256, false)
  @repeat = Array.new(256, false)
  @release = Array.new(256, false)
  # Generate blank counter array
  @repeat_counter = Array.new(256, 0)
  # Declare keyboard API
  @getKeyboardState = Win32API.new('user32', 'GetKeyboardState', ['P'], 'V')
  @getAsyncKeyState = Win32API.new('user32', 'GetAsyncKeyState', 'i', 'i')
  # Call current keyboard state
  @getKeyboardState.call(@last_array)
  # Set previous keyboard state
  @last_array = @last_array.unpack(@unpack_string)
  # Cycle through keys
  for i in 0...@last_array.size
    # Set pressed key state
    @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def self.update
    # Clear input arrays
    @trigger = Array.new(256, false)
    @repeat = Array.new(256, false)
    @release = Array.new(256, false)
    # create blank input array
    array = '0'*256
    # Call current keyboard state
    @getKeyboardState.call(array)
    # Unpack key array
    array = array.unpack(@unpack_string)
    # Cycle through all keys
    for i in 0...array.size
      # If the current key state does not match the previous state
      if array[i] != @last_array[i]
        # Set current key state
        @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
        # If the repeat counter is at 0
        if @repeat_counter[i] <= 0 && @press[i]
          # Set the key to repeat
          @repeat[i] = true
          # Set the repeat counter to 15 frames
          @repeat_counter[i] = 15
        end
        # If the key is not being pressed
        if !@press[i]
          # Set the key to released
          @release[i] = true
        # If the key is being pressed
        else
          # Set the key to triggered
          @trigger[i] = true
        end
      # If the key state is the same
      else
        # If the key is set to pressed
        if @press[i] == true
          # Set the current key state
          @press[i] = @getAsyncKeyState.call(i) == 0 ? false : true
          # Set the key to released if it is no longer being pressed
          @release[i] = true if !@press[i]
        end
        # If the repeat counter is greater than 0 and the key is pressed
        if @repeat_counter[i] > 0 && @press[i] == true
          # Cycle the repeat counter down one frame
          @repeat_counter[i] -= 1
        # If the repeat counter is 0 or less and the key is pressed
        elsif @repeat_counter[i] <= 0 && @press[i] == true
          # Set the key to repeat
          @repeat[i] = true
          # Set the repeat counter to 15 frames
          @repeat_counter[i] = 3
        # If the repeat counter does not equal 0
        elsif @repeat_counter[i] != 0
          # Set the repeat counter to 0
          @repeat_counter[i] = 0
        end
      end
    end
    # Set the previous keyboard state
    @last_array = array
  end
  #--------------------------------------------------------------------------
  # * Get Key Pressed State
  #     key : key index
  #--------------------------------------------------------------------------
  def self.press?(key)
    # Return key pressed state
    return @press[key]
  end
  #--------------------------------------------------------------------------
  # * Get Key Triggered State
  #     key : key index
  #--------------------------------------------------------------------------
  def self.trigger?(key)
    # Return key triggered state
    return @trigger[key]
  end
  #--------------------------------------------------------------------------
  # * Get Key Repeated State
  #     key : key index
  #--------------------------------------------------------------------------
  def self.repeat?(key)
    # Return key repeated state
    return @repeat[key]
  end
  #--------------------------------------------------------------------------
  # * Get Key Released State
  #     key : key index
  #--------------------------------------------------------------------------
  def self.release?(key)
    # Return key released state
    return @release[key]
  end
end

#==============================================================================
# ** Input
#------------------------------------------------------------------------------
#  This module performs key input processing
#==============================================================================

module Input
  # Add class data
  class << self
    #------------------------------------------------------------------------
    # * Alias Methods
    #------------------------------------------------------------------------
    alias glitch_input_keys_update update
    #------------------------------------------------------------------------
    # * Frame Update
    #------------------------------------------------------------------------
    def update
      # Call original method
      glitch_input_keys_update
      # Update Keys module
      Keys.update
    end
  end
end 