#==============================================================================
# ¡ Sprite_Shadow (Sprite_Ombre )
# Based on Genzai Kawakami's shadows, dynamisme&features by Rataime, 
# extra features Boushy
#==============================================================================
# Type "s" in a comment on the event's page to be the light source
#
# Type "o" in a comment for an event to cast a shadow
#==============================================================================
CATERPILLAR_COMPATIBLE = false
SQUAD_MOVE_COMPATIBLE = true

class Game_Party
 attr_reader :characters
end

class Sprite_Shadow < RPG::Sprite

 attr_accessor :character

 def initialize(viewport, character = nil,source = nil,anglemin=0,anglemax=0,distancemax=0)
  super(viewport)
  @anglemin=anglemin.to_f
  @anglemax=anglemax.to_f
  @distancemax=distancemax.to_f
  @character = character
  @source = source
  update
 end

 def update
  super
 
  if @tile_id != @character.tile_id or
      @character_name != @character.character_name or
      @character_hue != @character.character_hue
    @tile_id = @character.tile_id
    @character_name = @character.character_name
    @character_hue = @character.character_hue
    if @tile_id >= 384
      self.bitmap = RPG::Cache.tile($game_map.tileset_name,
        @tile_id, @character.character_hue)
      self.src_rect.set(0, 0, 32, 32)
      self.ox = 16
      self.oy = 32
    else
      self.bitmap = RPG::Cache.character(@character.character_name,
        @character.character_hue)
      @cw = bitmap.width / 4
      @ch = bitmap.height / 4
      self.ox = @cw / 2
      self.oy = @ch
    end
  end
  self.visible = (not @character.transparent)
  if @tile_id == 0
    sx = @character.pattern * @cw
    sy = (@character.direction - 2) / 2 * @ch
    if self.angle>90 or angle<-90
      if @character.direction== 6
              sy = ( 4- 2) / 2 * @ch
      end
      if @character.direction== 4
              sy = ( 6- 2) / 2 * @ch
      end
      if @character.direction== 2
              sy = ( 8- 2) / 2 * @ch
      end
      if @character.direction== 8
              sy = ( 2- 2) / 2 * @ch
      end
    end
    self.src_rect.set(sx, sy, @cw, @ch)
  end
  self.x = @character.screen_x
  self.y = @character.screen_y-5
  self.z = @character.screen_z(@ch)-1
  self.opacity = @character.opacity
  self.blend_type = @character.blend_type
  self.bush_depth = @character.bush_depth
  if @character.animation_id != 0
    animation = $data_animations[@character.animation_id]
    animation(animation, true)
    @character.animation_id = 0
  end
  @deltax=@source.x-self.x
  @deltay= @source.y-self.y
  self.angle = 57.3*Math.atan2(@deltax, @deltay )
  @angle_trigo=self.angle+90
  if @angle_trigo<0
    @angle_trigo=360+@angle_trigo
  end
  self.color = Color.new(0, 0, 0)
  @distance = ((@deltax ** 2) + (@deltay ** 2))
  if$game_map.shadows==-1
    self.opacity = 0
  else
    self.opacity = 1200000/(@distance+8000) 
  end
  @distance = @distance ** 0.5
  if @distancemax !=0 and @distance>=@distancemax
    self.opacity=0
  end
  if @anglemin !=0 or @anglemax !=0
      if (@angle_trigo<@anglemin or @angle_trigo>@anglemax) and @anglemin<@anglemax
        self.opacity=0
      end
      if (@angle_trigo<@anglemin and @angle_trigo>@anglemax) and @anglemin>@anglemax
        self.opacity=0
      end   
  end
 end
end

#===================================================
# ¥ CLASS Sprite_Character edit
#===================================================

class Sprite_Character < RPG::Sprite
 alias shadow_initialize initialize
 
 def initialize(viewport, character = nil)
  @character = character
  super(viewport)
  @ombrelist=[]
  if (character.is_a?(Game_Event) and character.list!=nil and character.list[0].code == 108 and character.list[0].parameters == ["s"])
    if (character.list[1]!=nil and character.list[1].code == 108)
      @anglemin=character.list[1].parameters[0]
    end
    if (character.list[2]!=nil and character.list[2].code == 108)
      @anglemax=character.list[2].parameters[0]
    end
    if (character.list[3]!=nil and character.list[3].code == 108)
      @distancemax=character.list[3].parameters[0]
    end
    for i in $game_map.events.keys.sort
    if ($game_map.events[i].is_a?(Game_Event) and $game_map.events[i].list!=nil and $game_map.events[i].list[0].code == 108 and $game_map.events[i].list[0].parameters == ["o"])
      @ombrelist[i+1] = Sprite_Shadow.new(viewport, $game_map.events[i],self,@anglemin,@anglemax,@distancemax)
    end
    end
    @ombrelist[1] = Sprite_Shadow.new(viewport, $game_player,self,@anglemin,@anglemax,@distancemax)
#===================================================
# œ Compatibility with fukuyama's caterpillar script
#===================================================
if CATERPILLAR_COMPATIBLE and $game_party.characters!=nil

 for member in $game_party.characters
  @ombrelist.push(Sprite_Shadow.new(viewport, member,self,@anglemin,@anglemax,@distancemax))
 end

end
      if SQUAD_MOVE_COMPATIBLE and $game_system.allies.values != nil
        for member in $game_system.allies.values
          #for i in 0...$game_temp.shadow_spriteset.shadows.size
            #@ombrelist.push(Sprite_Shadow.new(@viewport0, member, i))
          #end
            @ombrelist.push(Sprite_Shadow.new(viewport, member,self,@anglemin,@anglemax,@distancemax))
        end
      end
#===================================================
# œ End of the compatibility
#===================================================
  end
  shadow_initialize(viewport, @character)
 end
 
 alias shadow_update update
 
 def update
  shadow_update
  if @ombrelist!=[]
    for i in 1..@ombrelist.size
      if @ombrelist[i]!=nil
        @ombrelist[i].update
      end
    end
  end
 end
 
end

#===================================================
# ¥ CLASS Scene_Save edit
#===================================================
class Scene_Save < Scene_File
 
 alias shadows_write_save_data write_save_data
 
 def write_save_data(file)
  $game_map.shadows = nil
  shadows_write_save_data(file)
 end
end

#===================================================
# ¥ CLASS Game_Map edit
#===================================================
class Game_Map
 attr_accessor :shadows
end