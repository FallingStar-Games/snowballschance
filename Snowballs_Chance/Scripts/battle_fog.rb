#----------------------
# Battle fogs
#----------------------

module Fog_Config
  # the id of the switch that determines whether or not to display the fog in the battle scene
  ENABLED_SWITCH_ID = 52
end

class Spriteset_Battle
  alias tdks_battle_fog_init initialize
  def initialize
    tdks_battle_fog_init
    @fog = Plane.new(@viewport1)
    if $scene.fog!=nil
    @fog.bitmap = $scene.fog
    @fog.ox, @fog.oy, @fog.zoom_x, @fog.zoom_y, @fog.opacity, @fog.blend_type, @fog.tone, @fog.color, @fog_sx, @fog_sy = *$scene.fog_settings
    @fog.z = 1000
    @fog.visible = $game_switches[Fog_Config::ENABLED_SWITCH_ID]
    end
  end
 
  alias tdks_battle_fog_update update
  def update
    tdks_battle_fog_update
    if $scene.fog!=nil
    @fog.ox -= @fog_sx / 8.0 if @fog
    @fog.oy -= @fog_sy / 8.0 if @fog
    end
  end
end

class Spriteset_Map
  attr_reader :fog
end

class Scene_Battle
  attr_reader :fog, :fog_settings
 
  alias tdks_battle_fog_init initialize
  def initialize(*args)
    if $BTEST==false
    tdks_battle_fog_init(*args)
    tmp = $scene.spriteset.fog
    if tmp.bitmap!=nil
    @fog = tmp.bitmap.clone
    @fog_settings = [tmp.ox, tmp.oy, tmp.zoom_x, tmp.zoom_y, tmp.opacity, tmp.blend_type, tmp.tone.clone, tmp.color.clone, $game_map.fog_sx, $game_map.fog_sy]
      end
    end
  end
end

class Scene_Map
  attr_reader :spriteset
end