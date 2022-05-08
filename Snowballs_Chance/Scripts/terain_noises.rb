#===============================================================================
# Terrain Step Sound
# Version 1.2
# Author game_guy
#-------------------------------------------------------------------------------
# Intro:
# Create nice aesthetics with terrain noise. As you walk across grass or sand,
# let it play a beautiful noise to add to the atmosphere and realism of the
# game.
#
# Features:
# Specific Sound for Each Terrain
# Specific Sounds for Each Tileset
# Specify Volume and Pitch
# Specify an array of sounds for each terrain, allowing random sounds for each step
#
# Instructions:
# Setup the config below, its pretty self explanatory, more instructions
# with config.
#
# You can now change the sound rate in game using a script call.
# $game_map.rate = X
# X = sound rate (the lower the value, the more frequent the sounds)
#
# Credits:
# game_guy ~ For creating it
# Tuggernuts ~ For requesting it a long time ago
# Sase ~ For also requeseting it
#===============================================================================
module TSS
  # In Frames Recommended 5-10
  Wait = 10
  # Ignore the next 2 lines
  Terrains = []
  Tilesets = []
  #===========================================================================
  # Enter in sounds for each terrain tag
  # Goes from 0-8. Set as nil to disable that terrain or delete the line.
  # Each terrain must now be an array. This allows you to define multiple
  # sound effects for each terrain.
  #===========================================================================
  #Terrains[0] = ['001-System01', '002-System02', '003-System03']
  #Terrains[1] = ['fs_wood_hard1'] #water
  #Terrains[2] = ['shwee'] #ice

  #===========================================================================
  # If you would like to specifiy a volume and pitch, simply set the
  # terrain as an array.
  # Terrains[7] = [["sound", volume, pitch]]
  # Just set it as a string if you would like the volume to be at 100 and
  # pitch at 0.
  # This also applies for tilesets below.
  # You can also define multiple sound effects with pitch and volume.
  #===========================================================================
  #Terrains[7] = [["sound", 80, 10], "sound2", ["sound3", 50, 0]]
  #Terrains[4] = ["crush", 50, 50] #puddle TOO LOUD
  
  #===========================================================================
  # With tilesets, you can set specific sounds for each tileset so you don't
  # have the same sounds. Add a new line and put
  # Tilesets[tileset id] = []
  # Then for each terrain put
  # Tilesets[tileset id][terrain id] = ["sound file", "sound file2", etc...]
  # If a sound doesn't exist for a tileset, it will play a default sound,
  # if a default doesn't exist, no sound at all.
  #===========================================================================
  #Tilesets[2] = []
  #Tilesets[2][0] = ["Sound"]
  #Tilesets[2][1] = [["sound", 75, 50]]
end
class Game_Map
 
  attr_accessor :rate
 
  alias gg_init_terrain_sounds_map_lat initialize
  def initialize
    @rate = TSS::Wait
    return gg_init_terrain_sounds_map_lat
  end
 
  def terrain_sound
    if TSS::Tilesets[@map.tileset_id] != nil
      sounds = TSS::Tilesets[@map.tileset_id][$game_player.terrain_tag]
    else
      sounds = TSS::Terrains[$game_player.terrain_tag]
    end
    return nil if sounds == nil || !sounds.is_a?(Array) || sounds.size < 1
    sound = sounds[rand(sounds.size)]
    if sound.is_a?(Array)
      return [sound[0], sound[1], sound[2]]
    else
      return [sound, 100, 0]
    end
  end
 
end

class Game_Player < Game_Character
 
  def update_move
    @timer = $game_map.rate if @timer == nil
    @timer -= 1
    if @timer < 1
      terrain = $game_map.terrain_sound
      if terrain != nil
        vol = terrain[1]
        pit = terrain[2]
        son = terrain[0]
        Audio.se_play('Audio/SE/' + son, vol, pit)
      end
      @timer = $game_map.rate
    end
    super
  end
 
end