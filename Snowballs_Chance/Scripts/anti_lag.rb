#======================================
# Anti Event Lag Script
#======================================
#  By: Near Fantastica
#   Date: 12.06.05
#   Version: 4
#======================================

# Heretic Revision August 21st, 2012

#    -----  HERETIC NOTES -----
    
# THIS SCRIPT HAS BEEN MODIFIED!

# The original version of the script did increase framerates at the cost
# of flat out making some things not work at all.

# This revision of the original script should fix those issues.  

# #1 Fixed an issue where Events that used Multiple Event Pages 
# (which require conditions) were never refreshed, as the call to
# change those events was ommitted entirely, apparently by accident.

# #2 Fixed Events moving Off Screen to not update.  Any time Set Move Route
# is called, the moved Event will now Update correctly.  Useful for Cutscenes
# where an NPC walks to On Screen from Off Screen.

# #3 If you use an "Autonomous Movement", and want an Event or NPC to be
# updated regardless if they are on the screen or not, you'll need to 
# add \al_update to that Event's Name.  The Naming Parameter was used
# to allow functionality to be maintained across any number of Event Pages.

# #4 This script only updates Events or NPC's around that are close enough
# to the Player that they require being updated.  For Large Sprites, this
# can cause some issues.  I adjusted the distance so that Large Sprites 
# won't cause glitches by partially staying on the screen when they aren't
# supposed to be there.

# --- Notes for Compatability ---

# This script makes changes to update in both Spriteset_Map and Game_Map classes
# There isnt a whole heck of a lot of script to run the optimizations, so if
# you have ANY other script that makes changes to update in either of those
# classes, place those scripts BELOW this one.  
#
# Other Scripts that FULLY REDEFINE def update will break this script.
#
# If another script does fully redefine def update, you can probably try
# combine the two scripts.  I've commented out the spots of code that need
# to be there for anti-lag to work.

# NAMING OPTIONS

# - \al_update

# For Example:  "EV031\al_update" can move around anywhere on the Map and will
#  be updated regardless of where it is at on the Map!
#  (\al_ is just an abbreviation for "Anti Lag", which hopefully is unique!)

#  Events with \al_update in their name will ALWAYS be Updated

# I also changed "Set Move Route" to automatically add a @lag_include Flag
#  to the Event so that the Event will ALWAYS be able to move.  This will
#  most likely happen for Cutscenes where an Event needs to be able to
#  move around regardless of its Range from Player on the Map.  Once you
#  leave a Map and return, this will reset and the Event or NPC will only
#  update if it is On Screen, or at least close to the Screen


module Update_Range
  # Note: Module for both the Game_Map and Spriteset_Map classes
  
  #--------------------------------------------------------------------------
  #  In Range - Determines whether or not an Event should be Updated
  #--------------------------------------------------------------------------
  def in_range?(object)
    # Using 256 here will speed things up a tad, but may cause Large Sprites
    # that go offscreen to glitch and stay on screen when they actually aren't
	  display_x = $game_map.display_x - 512 # 256
	  display_y = $game_map.display_y - 512 # 256
	  display_width = $game_map.display_x + 2916 #2820
	  display_height = $game_map.display_y + 2570 #2180
    # If too far off screen
	  if object.real_x <= display_x or
       object.real_x >= display_width or
       object.real_y <= display_y or
       object.real_y >= display_height
      # Invalid
      return false
    end
    # Valid
	  return true
  end  
end
  

#======================================
# Game_Map
#======================================

class Game_Map
  # Makes In-Range Definiton available in the Game_Map class
  include Update_Range

  #--------------------------------------------------------------------------
  #  Update - Updates Events in a Game Map - FULL REDEFINITION
  #--------------------------------------------------------------------------  
  def update
    # Refresh map if necessary
    if $game_map.need_refresh
      # Refresh the Game Map - CRITICAL for changing Event Pages
      refresh
    end
    # If scrolling    
	  if @scroll_rest > 0
	    distance = 2 ** @scroll_speed
	    case @scroll_direction
	      when 2
		      scroll_down(distance)
	      when 4 
		      scroll_left(distance)
	      when 6  
		      scroll_right(distance)
	      when 8  
		      scroll_up(distance)
	    end
  	  @scroll_rest -= distance
    end

    
    
    # This is the Event Anti Lag Code
	  for event in @events.values
      # If Event is In Range, Auto, Parallel, Set Move Route, or Cat Actor
	    if event.trigger == 3 or event.trigger == 4 or event.lag_include or
         in_range?(event) 
        # Update the Event
		    event.update
        # If you have other code to run, allow this part to run first, then
        # run other parts of scripts here inside of the conditional branch.
	    end
	  end
    # End Event Anti Lag Code
    
    
    
	  for common_event in @common_events.values
	    common_event.update
	  end
	  @fog_ox -= @fog_sx / 8.0
	  @fog_oy -= @fog_sy / 8.0
	  if @fog_tone_duration >= 1
	    d = @fog_tone_duration
	    target = @fog_tone_target
	    @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d
	    @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d
	    @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d
	    @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d
	    @fog_tone_duration -= 1
	  end
	  if @fog_opacity_duration >= 1
	    d = @fog_opacity_duration
	    @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
	    @fog_opacity_duration -= 1
	  end
  end
end

#======================================
# Spriteset_Map
#======================================

class Spriteset_Map
  # Make Range Definiton available in the Sprite_Map class
  include Update_Range
  
  #--------------------------------------------------------------------------
  # * Frame Update - Full Redefinition
  #--------------------------------------------------------------------------
  def update
  	if @panorama_name != $game_map.panorama_name or
	     @panorama_hue != $game_map.panorama_hue
      # Set the Values
	    @panorama_name = $game_map.panorama_name
	    @panorama_hue = $game_map.panorama_hue
	    if @panorama.bitmap != nil
		    @panorama.bitmap.dispose
		    @panorama.bitmap = nil
	    end
	    if @panorama_name != ""
		    @panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
	    end
	    Graphics.frame_reset
	  end
	  if @fog_name != $game_map.fog_name or @fog_hue != $game_map.fog_hue
	    @fog_name = $game_map.fog_name
	    @fog_hue = $game_map.fog_hue
	    if @fog.bitmap != nil
		    @fog.bitmap.dispose
		    @fog.bitmap = nil
	    end
	    if @fog_name != ""
		    @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
	    end
	    Graphics.frame_reset
	  end
	  @tilemap.ox = $game_map.display_x / 4
	  @tilemap.oy = $game_map.display_y / 4
	  @tilemap.update
	  @panorama.ox = $game_map.display_x / 8
	  @panorama.oy = $game_map.display_y / 8
	  @fog.zoom_x = $game_map.fog_zoom / 100.0
	  @fog.zoom_y = $game_map.fog_zoom / 100.0
	  @fog.opacity = $game_map.fog_opacity
	  @fog.blend_type = $game_map.fog_blend_type
	  @fog.ox = $game_map.display_x / 4 + $game_map.fog_ox
	  @fog.oy = $game_map.display_y / 4 + $game_map.fog_oy
	  @fog.tone = $game_map.fog_tone
    
    
    
    # This is the Sprite Anti Lag Code
	  for sprite in @character_sprites
	    if sprite.character.is_a?(Game_Event)
      # If Event is Auto, Parallel, Set to Always Update (/al_update) or In Range
  		  if sprite.character.trigger == 3 or sprite.character.trigger == 4 or
           sprite.character.lag_include or
           in_range?(sprite.character) 
          # Update the Sprite
	  	    sprite.update
          # If you have other code to run, allow this part to run first, then
          # run other parts of scripts here inside of the conditional branch.          
	  	  end
      # Not an Event, thus, Player, so always update the Players Sprite
	    else
        # Update the Sprite
		    sprite.update
	    end
	  end
    # End Sprite Anti Lag Code
    
    
    
  	@weather.type = $game_screen.weather_type
	  @weather.max = $game_screen.weather_max
	  @weather.ox = $game_map.display_x / 4
    @weather.oy = $game_map.display_y / 4
	  @weather.update
	  for sprite in @picture_sprites
	    sprite.update
	  end
	  @timer_sprite.update
	  @viewport1.tone = $game_screen.tone
	  @viewport1.ox = $game_screen.shake
	  @viewport3.color = $game_screen.flash_color
	  @viewport1.update
	  @viewport3.update
  end
end

class Interpreter
  #--------------------------------------------------------------------------
  # * Set Move Route Alias
  #--------------------------------------------------------------------------
  
  # Check for Method Existence
  unless self.method_defined?('anti_lag_command_209')
    # Create an Alias
    alias anti_lag_command_209 command_209
  end
  
  #--------------------------------------------------------------------------
  # * Set Move Route
  #--------------------------------------------------------------------------

  # This forces Events that are being applied a Set Move Route to ALWAYS
  #  be updated.  Prevents Events that are set to Move On Screen from
  #  being able to Move.  They cant move without being updated first.
  
  def command_209
    # Run the Original
    anti_lag_command_209
    # Get character
    character = get_character(@parameters[0])
    # If no character exists
    if character == nil or character.is_a?(Game_Player)
      # Continue
      return true
    end
    # Set @lag_include Flag
    character.lag_include = true
  end
end

class Game_Event < Game_Character
  attr_accessor :lag_include  # Always Updates
  
  # Check for Method Existence
  unless self.method_defined?('anti_lag_initialize')
    # Create an Alias
    alias anti_lag_initialize initialize
  end
  
  #----------------------------------------------------------------------------
  #  * Initialize the Map
  #----------------------------------------------------------------------------
  
  def initialize(map_id, event, *args)
    # Run the Original
    anti_lag_initialize(map_id, event, *args)
    # Check for Events with \al_update
    check_name_tags(event)    
  end
  
  #----------------------------------------------------------------------------
  #  * Check Each Event for Special Name Tags: \al_update, \off_map
  #----------------------------------------------------------------------------
  
  def check_name_tags(event)
    # Check each Event's Name to see if it has \al_update
    event.name.gsub(/\\al_update/i) {@lag_include = true}
  end 

end

