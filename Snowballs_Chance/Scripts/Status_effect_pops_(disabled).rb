=begin
#==============================================================================
# ** ATOA Status Effect Pops
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.1
#    1-10-2016 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#
#==============================================================================
#  
#  INTRODUCTION:
#
#  This script creates a new damage pop option for the ATOA ACBS system, now
#  drawing status effect/ailment names along when a character is so effected
#  while in battle.
#
#  Like the original system, graphics for status damage pops are kept within
#  the Graphics\Digits folder. Otherwise, it will draw damage pops using the
#  more traditional draw_text method.
#
#  NOTE: Mix match of graphically rendered and text drawn damage pops is not
#        visually recommended.  Both handle positioning differently.
#
#  This script is an add-on for Atoa's ACBS.
#
#------------------------------------------------------------------------------
#
#  INSTALLATION:
#
#  Paste below Atoa's ACBS system.
#
#  The configurations are explained below.
#
#------------------------------------------------------------------------------
#
#  CONFIGURATION:
#
#  These are going to be quickly explained.  There's not a lot really TO
#  explain about them.
#
#  Basic values:
#
#  * Dmg_State_Max
#    This sets the maximum number of damage pops that will show at one time.
#    I do not recommend going above 3 as it may appear crowded.
#
#  * Dmg_State_X_Adjust
#    Like the Atoa ACBS system, there is an extra X-Position adjustment value
#    you can use.  A setting of 0 should keep it horizontally aligned with all
#    other damage pops of the same style.
#
#  * Dmg_State_Y_Adjust
#    This determines the vertical position of your damage pops, either above
#    or below the ones normally generated.  Negative values are above the
#    default pops while positive will be positioned below.  
#
#  * Dmg_State_Height
#    This sets how much vertical space is between each status damage pop.
#
#  * Dmg_Default_Text
#    This is used when a status damage pop is being generated and no custom
#    status effect name (below) is defined.  If this value is set to true, then
#    it will use the default name in the database.  If set to false, then it
#    will not render the status damage pop.
#
#  * Dmg_State_Skip
#    This allows you to define what status ailments are not to be shown, even
#    if the game is set to permit default status effect names (above).  Just
#    set the IDs of the states in the array.
#
#
#  Extended values:
#
#  * Dmg_State_Pops
#    This is a hash array where you set the name for each status effect to
#    show.  If a graphic of the same name is in the Graphics\Digits folder,
#    it will render that graphic as the damage pop.  Otherwise, it will show
#    this name using default text methods.  If a state pop is being generated
#    and no name is in this hash array, it will either show the default name
#    stored in the database or just 'not' show the pop, depending upon the
#    value set by the Dmg_Default_Text value (above).
#
#  * Dmg_State_Color
#    When a status damage pop is rendered, it is of a custom color.  This
#    array sets the default color in the [red, green, blue] format.  It can
#    be overwritten by individual color settings described below.
#
#  * Dmg_State_Colors
#    This is a hash array where you set the color for each status effect to
#    show.  If no color is defined for a given state, it will use the default
#    color above.
#
#  * Dmg_State_Dur
#    When a status damage pop is rendered, it is to stay on the screen for
#    a set period of time in frames.  This is where you set the number of
#    frames (default = 40).
#
#  * Dmg_State_Durs
#    This is a hash array where you allow some status effect pops to show
#    longer or to vanish quicker than others.  If no value is listed, it will
#    use the default duration as set by the Dmg_State_Dur value above.
#
#
#==============================================================================
#
#  TERMS AND CONDITIONS:
#
#  Free for use, even in commercial games.   And as this script was requested
#  by Noctis, you have to give both of us credit for this script.
#
#==============================================================================

module Atoa
  #----------------------------------------------------------------------------
  Dmg_State_Pops    = {}        # Do Not Touch
  Dmg_State_Colors  = {}        # Do Not Touch
  Dmg_State_Durs    = {}        # Do Not Touch
  #----------------------------------------------------------------------------

  # State Pop Values
  # ---------------------------------------------------------------------------
  # Basis values to set that control the system.
  #
    Dmg_State_Max       = 3     # Max # of State pops (Recommend no more than 3)
    Dmg_State_X_Adjust  = 0     # X position adjustment for State Pops
    Dmg_State_Y_Adjust  = -48   # Y position adjustment for State Pops
    Dmg_State_Height    = 16    # Vertical Space between State Pops
    Dmg_Default_Text    = true  # If true and no damage pop defuned, use default
    Dmg_State_Skip      = [4,5] # Array of states NOT to show pops
    
    
  # State Pop Names
  # ---------------------------------------------------------------------------
  # Renames the damage pops or acts as filenames for graphic pops to show.
  # If a filename, assumes graphic is in the Graphics\Digits folder.
  #
    Dmg_State_Pops[2] = "Slammed!"     # Changes stunned state name to Slammed
    Dmg_State_Pops[3] = "POISON"    # Changes venom state name to Poisoned
    Dmg_State_Pops[18] = "Bleeding" 

  # State Pop Colors
  # ---------------------------------------------------------------------------
  # Used only with damage pops drawn with the more traditional draw_text
  # method, this sets the color of rendered text.  Not used with graphic
  # image pops.
  #
    Dmg_State_Color     = [128,0,128] # Default color set to dark purple
    # -------------------------------------------------------------------------
    Dmg_State_Colors[2] = [255,0,0]   # Red color for Slammed/Stun state
    Dmg_State_Colors[3] = [0,255,0]   # Green color for Poisoned/Venom state
    Dmg_State_Colors[9] = [255,128,0] # Orange color for Weaken state
    Dmg_State_Colors[18] = [255,0,0]  # Red color for Bleeding state
    
  # State Pop Colors
  # ---------------------------------------------------------------------------
  # Used only with damage pops drawn with the more traditional draw_text
  # method, this sets the color of rendered text.  Not used with graphic
  # image pops.
  #
    Dmg_State_Dur       = 40          # Default state effect duration
    # -------------------------------------------------------------------------
    Dmg_State_Durs[2]   = 80          # 2 second duration for stuns
    Dmg_State_Durs[3]   = 60          # 1 1/2 seconds for venom
    
end



#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa StatePops'] = true



#==============================================================================
# ** RPG::Sprite
#------------------------------------------------------------------------------
# Class that manages Sprites exhibition
#==============================================================================

class RPG::Sprite < ::Sprite
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias status_pops_damage damage
  #--------------------------------------------------------------------------
  # * Set Damage Pop
  #     value     : Damage value
  #     critical  : Critical flag
  #     sp_damage : SP Damage flag
  #--------------------------------------------------------------------------
  def damage(value, critical, sp_damage = nil)
    # Create temporary damage state array
    temp_dmg_states = []
    # Push new damage states into array
    temp_dmg_states += @battler.state_to_add unless @battler.state_to_add == []
    # Perform the original call
    status_pops_damage(value, critical, sp_damage)
    return if temp_dmg_states == []
    # Take only up to the max number of states to show
    temp_dmg_states = temp_dmg_states[0,Atoa::Dmg_State_Max]
    # Reverse order if drawing above normal damage pop
    temp_dmg_states.reverse if Dmg_State_Y_Adjust < 0
    # Cycle through temporary damage state array
    for i in 0..temp_dmg_states.size-1
      # Get state ID from list
      state_id = temp_dmg_states[i]
      # Skip if the state is a no-show state (no pop)
      next if Atoa::Dmg_State_Skip.include?(state_id)
      # Get height position)
      state_ht = (i * Atoa::Dmg_State_Height) + Dmg_State_Y_Adjust
      # Determine if a valid graphic exists or if text
      test_pop = false
      begin
        testbitmap = RPG::Cache.digits(Atoa::Dmg_State_Pops[state_id])
      rescue
        test_pop = true
      end      
      # Branch if text pop or graphic
      if test_pop == true
        damage_state_pop_texts(i, state_id, state_ht)
      else
        damage_state_pop_graphics(i, state_id, state_ht)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set State Damage Pop from Graphic
  #     i         : counter index of state in state pops applied
  #     state_id  : actual status ailment ID in database
  #     state_ht  : height position to be drawn in respect to pop
  #--------------------------------------------------------------------------
  def damage_state_pop_graphics(i, state_id, state_ht)
    # Determine last sprite drawn among all damage pops
    newpopsize = @_damage_sprites.size
    # Get duration for individual state
    state_dur = Atoa::Dmg_State_Dur
    if Atoa::Dmg_State_Durs.has_key?(state_id)
      state_dur = Atoa::Dmg_State_Durs[state_id]
    end
    # Grab the actual image from the folder
    bitmap    = RPG::Cache.digits(Atoa::Dmg_State_Pops[state_id])
    # Set sprite number, delay and x/y position
    j         = newpopsize + i
    dmg_delay = Multi_Pop ? i : 1
    x         = Dmg_State_X_Adjust
    y         = state_ht - self.oy / 3
    # Draw the state damage sprite
    damage_state_sprite_drawing(bitmap, state_dur, dmg_delay, j, x, y)
  end
  #--------------------------------------------------------------------------
  # * Set State Damage Pop from Text
  #     i         : counter index of state in state pops applied
  #     state_id  : actual status ailment ID in database
  #     state_ht  : height position to be drawn in respect to pop
  #--------------------------------------------------------------------------
  def damage_state_pop_texts(i, state_id, state_ht)
    # Determine last sprite drawn among all damage pops
    newpopsize = @_damage_sprites.size
    # Get duration for individual state
    state_dur = Atoa::Dmg_State_Dur
    if Atoa::Dmg_State_Durs.has_key?(state_id)
      state_dur = Atoa::Dmg_State_Durs[state_id]
    end
    # Get damage pop string from state ID
    damage_string = Atoa::Dmg_State_Pops[state_id]
    # Either use the default name or exit if no replacement string
    if damage_string.nil?
      if Atoa::Dmg_Default_Text == true
        damage_string = $data_states[state_id].name
      else
        return
      end
    end
    # Get the color for the status damage pop
    state_color = Atoa::Dmg_State_Color
    if Atoa::Dmg_State_Colors.has_key?(state_id)
      state_color = Atoa::Dmg_State_Colors[state_id]
    end
    # Set the color
    pop_damage_color = [state_color[0], state_color[1], state_color[2]]
    # Cycle through individual letters in text
    for k in 0...damage_string.size
      # Obtain letter
      letter = damage_string[k..k]
      # Create new bitmap for letter and draw
      bitmap = Bitmap.new(160, 48)
      bitmap.font.name = Damage_Font
      bitmap.font.size = Dmg_Font_Size
      # Set black font outline and draw outline
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1,160, 36, letter, 1)
      bitmap.draw_text(+1, 12-1,160, 36, letter, 1)
      bitmap.draw_text(-1, 12+1,160, 36, letter, 1)
      bitmap.draw_text(+1, 12+1,160, 36, letter, 1)
      # Set pop color and draw text
      bitmap.font.color.set(*pop_damage_color)
      bitmap.draw_text(0, 12,160, 36, letter, 1)
      # Set sprite number, delay and x/y position
      j         = newpopsize + k
      dmg_delay = Multi_Pop ? i : 1
      x         = Dmg_State_X_Adjust + 32 + k * Dmg_Space - (damage_string.size * 8)
      y         = state_ht - self.oy / 3
      # Draw the state damage sprite
      damage_state_sprite_drawing(bitmap, state_dur, dmg_delay, j, x, y)
    end
  end
  #--------------------------------------------------------------------------
  # * Set State Damage Pop from Text
  #     bitmap    : bitmap passed into drawn sprite
  #     state_dur : amount of delay adjusted for individual state
  #     delay     : amount of delay adjusted for characters in pop
  #     count     : counter for individual sprite drawn (increases for each)
  #     x         : x-position of damage pop sprite being adjusted
  #     y         : y-position of damage pop sprite being adjusted
  #--------------------------------------------------------------------------
  def damage_state_sprite_drawing(bitmap, state_dur, delay, count, x, y)
    dmg_delay = Multi_Pop ? i : 1
    dmg_adjust = Damage_Sprite ? 32 : 96
    @_damage_sprites[count] = ::Sprite.new(self.viewport)
    @_damage_sprites[count].bitmap  = bitmap
    @_damage_sprites[count].ox      = dmg_adjust
    @_damage_sprites[count].oy      = 20
    @_damage_sprites[count].x = self.x + Dmg_X_Adjust + x
    @_damage_sprites[count].y = self.y + Dmg_Y_Adjust + y
    @_damage_sprites[count].z = state_dur + 3000 + dmg_delay * 2
    @_damage_sprites[count].opacity = 0          
  end
end
=end