 #==============================================================================
#????8-Direction Characterset Edit?ver. 1.01???
#??Script by ParaDog
#??http://2d6.parasite.jp/
#------------------------------------------------------------------------------
# Additional 'diagonal' movement is now possible by pushing combinations of the
# vertical and horizontal controls (up & left, etc) simultaneously.
#
# Additional charsets for the 8-directional movement are to be stored within
# the "Graphics/Characters" folder, just like the regular charactersets.
#
# Name the new diagonal movement charactersets the same as the regular ones,
# but with a new '_quarter' extension. As such, you would name the very first
# characterset: 001-Fighter01_quarter.
#------------------------------------------------------------------------------
# Additional notes:
# This system can be used with the 'Dash Characterset Edit' system, but please
# place this script 'BELOW' the fore-mentioned Dash script for it to work.
#
# As you can combine the two scripts (Dash and 8-Directional), you can also use
# charactersets that show diagonal running action, also stored within the same
# "Graphics/Characters" folder.
#
# Naming the new graphics would require the inclusion of both '_dash' and the
# '_quarter' extensions as shown here: 001-Fighter01_dash_quarter.
#==============================================================================

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
# This class handles the player. Its functions include event starting
# determinants and map scrolling. Refer to "$game_player" for the one
# instance of this class.
#==============================================================================

class Game_Player < Game_Character
#--------------------------------------------------------------------------
# * Frame update
#--------------------------------------------------------------------------
alias update_para_quarter update
def update
update_para_quarter
unless moving? or $game_system.map_interpreter.running? or
@move_route_forcing or $game_temp.message_window_showing
# If the direction button is pushed, move the player in that direction
  if Keys.press?($keyboard["down"])
		 if Keys.press?($keyboard["left"])
		 move_lower_left
		 elsif Keys.press?($keyboard["right"])
		 move_lower_right
		 else
		 move_down
		 end
	   elsif Keys.press?($keyboard["up"])
		 if Keys.press?($keyboard["left"])
		 move_upper_left
		 elsif Keys.press?($keyboard["right"])
		 move_upper_right
		 else
		 move_up
		 end
      elsif Keys.press?($keyboard["left"])
         move_left
      elsif Keys.press?($keyboard["right"])
         move_right
    end    
=begin
case Input.dir8
when 1 # Move Lower Left
move_lower_left
when 3 # Move Lower Right
move_lower_right
when 7 # Move Upper Left
move_upper_left
when 9 # Move Upper Right
move_upper_right
end
=end
end
end
end

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
# This sprite is used to display the character.It observes the Game_Character
# class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Character < RPG::Sprite
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
alias update_para_quarter update
def update
update_para_quarter
if @tile_id == 0
if (@character.direction - 2) % 2 == 1
# Checking the presence of the diagonal charset
if quarter_graphic_exist?(@character)
# Set the diagonal charset
if character.dash_on and dash_quarter_graphic_exist?(@character)
@character_name = @character.character_name + "_dash_quarter"
else
@character_name = @character.character_name + "_quarter"
end
self.bitmap = RPG::Cache.character(@character_name,
@character.character_hue)
# Acquire direction
case @character.direction
when 1
n = 0
when 3
n = 2
when 7
n = 1
when 9
n = 3
end
else
@character.direction = @character.sub_direction
# When the diagonal charset does not exist, direction
n = (@character.direction - 2) / 2
end
# Set original transfer rectangle
sx = @character.pattern * @cw
sy = n * @ch
self.src_rect.set(sx, sy, @cw, @ch)
else
self.bitmap = RPG::Cache.character(@character.character_name,
@character.character_hue)
# Set original transfer rectangle
sx = @character.pattern * @cw
sy = (@character.direction - 2) / 2 * @ch
self.src_rect.set(sx, sy, @cw, @ch)
end
end
end
#--------------------------------------------------------------------------
# * Diagonal Charset?
#--------------------------------------------------------------------------
def quarter_graphic_exist?(character)
# Reading check
begin
RPG::Cache.character(character.character_name.to_s + "_quarter", character.character_hue)
rescue
return false
end
return true
end
#--------------------------------------------------------------------------
# * Dashing Diagonal Charset?
#--------------------------------------------------------------------------
def dash_quarter_graphic_exist?(character)
# Reading check
begin
RPG::Cache.character(character.character_name.to_s + "_dash_quarter", character.character_hue)
rescue
return false
end
return true
end
end

#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
# This class deals with characters. It's used as a superclass for the
# Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
#--------------------------------------------------------------------------
# * Public Instance Variables
#--------------------------------------------------------------------------
attr_accessor :direction # direction
attr_accessor :sub_direction # sub_direction
#--------------------------------------------------------------------------
# * Move Lower Left
#--------------------------------------------------------------------------
def move_lower_left
# If no direction fix
unless @direction_fix
@sub_direction = @direction
@direction = 1
# Face left if facing right, and face down if facing up
@sub_direction = (@sub_direction == 6 ? 4 : @sub_direction == 8 ? 2 : @sub_direction)
end
# When a down to left or a left to down course is passable
if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
(passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
# Update coordinates
@x -= 1
@y += 1
# Increase steps
increase_steps
end
end
#--------------------------------------------------------------------------
# * Move Lower Right
#--------------------------------------------------------------------------
def move_lower_right
# If no direction fix
unless @direction_fix
@sub_direction = @direction
@direction = 3
# Face right if facing left, and face down if facing up
@sub_direction = (@sub_direction == 4 ? 6 : @sub_direction == 8 ? 2 : @sub_direction)
end
# When a down to right or a right to down course is passable
if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
(passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
# Update coordinates
@x += 1
@y += 1
# Increase steps
increase_steps
end
end
#--------------------------------------------------------------------------
# * Move Upper Left
#--------------------------------------------------------------------------
def move_upper_left
# If no direction fix
unless @direction_fix
@sub_direction = @direction
@direction = 7
# Face left if facing right, and face up if facing down
@sub_direction = (@sub_direction == 6 ? 4 : @sub_direction == 2 ? 8 : @sub_direction)
end
# When an up to left or a left to up course is passable
if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
(passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
# Update coordinates
@x -= 1
@y -= 1
# Increase steps
increase_steps
end
end
#--------------------------------------------------------------------------
# * Move Upper Right
#--------------------------------------------------------------------------
def move_upper_right
# If no direction fix
unless @direction_fix
@sub_direction = @direction
@direction = 9
# Face right if facing left, and face up if facing down
@sub_direction = (@sub_direction == 4 ? 6 : @sub_direction == 2 ? 8 : @sub_direction)
end
# When an up to right or a right to up course is passable
if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
(passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
# Update coordinates
@x += 1
@y -= 1
# Increase steps
increase_steps
end
end
#--------------------------------------------------------------------------
# * Dash
#--------------------------------------------------------------------------
def dash_on
if @dash_on != nil
return @dash_on
else
return false
end
end
end
