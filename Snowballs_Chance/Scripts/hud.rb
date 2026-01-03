#========================================================
# ** Game_Actor
# Script by MeisMe
# Graphics added by Peaches
#------------------------------------------------------------------------------
# This class handles the actor. It's used within the Game_Actors class
# ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================
class Game_Actor
#--------------------------------------------------------------------------
# * Get the current EXP
#--------------------------------------------------------------------------
def now_exp
return @exp - @exp_list[@level]
end
#--------------------------------------------------------------------------
# * Get the next level's EXP
#--------------------------------------------------------------------------
def next_exp
return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
end
end

#==============================================================================
# ** Window_HUD
#------------------------------------------------------------------------------
# This class is used to display HP, SP and Gold on the map.
#==============================================================================
class Window_HUD < Window_Base
#--------------------------------------------------------------------------
# * Object Initialization
#--------------------------------------------------------------------------
def initialize
super(-16, 400, 680, 150)
self.contents = Bitmap.new(width-32, height-32)
self.opacity = 0
self.z= 9999
self.contents.font.size = $defaultfontsize
self.contents.font.name = $defaultfonttype
@actors = []
@old_hp = []
@old_sp = []
@old_exp = []
@old_level = []

  for i in 0...$game_party.actors.size
  @actors.push($game_party.actors[i])
  @old_hp.push(@actors[i].hp)
  @old_sp.push(@actors[i].sp)
  @old_exp.push(@actors[i].now_exp)
  @old_level.push(@actors[i].level)
  end
@old_gold = $game_party.gold

if $game_switches[16]==true and $game_switches[12]==false 
  self.visible=true
else #new
  self.visible=false
  #erase everything
end 

refresh
end
#--------------------------------------------------------------------------
# * Refresh
#--------------------------------------------------------------------------
def refresh

self.contents.clear
self.contents.font.color = normal_color
bitmap = RPG::Cache.picture("hudback")
self.contents.blt(0, 0, bitmap, Rect.new(0, 0, 640, 108))
x = 1#32
  for i in 0...[5,@actors.size].min #[4,@actors.size].min
    y = 6
    draw_actor_name(@actors[i], x+58, -4) 
    draw_actor_hp(@actors[i], x, 15,width = 144) #144
    draw_actor_sp(@actors[i], x, 35, width = 144)
    if @actors.size == 5
    x += 124
  else
    x += 150
    end
  end
#anything else you want to draw

end
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
def update
super

if $game_switches[16]==true and $game_switches[12]==false 
  self.visible=true
else #new
  self.visible=false
  #erase everything
end 

  if @actors.size != $game_party.actors.size #if actor amount has changed
  @actors = []

    for i in 0...$game_party.actors.size #update the actor count
    @actors.push($game_party.actors[i])
    end
  refresh #then start drawing
  return
  end
  for i in 0...[5,@actors.size].min
    if @old_hp[i] != @actors[i].hp or
    @old_sp[i] != @actors[i].sp or
    @old_exp[i] != @actors[i].now_exp or
    @old_level[i] != @actors[i].level or
    @old_gold != $game_party.gold
    refresh
    @old_hp[i] = @actors[i].hp
    @old_sp[i] = @actors[i].sp
    @old_exp[i] = @actors[i].now_exp
    @old_level[i] = @actors[i].level
    @old_gold = $game_party.gold
    end
  end
end

end
#========================================================
# ** Scene_Map
#------------------------------------------------------------------------------
# This class performs map screen processing.
#==============================================================================
class Scene_Map
#--------------------------------------------------------------------------
# * Object Aliasing
#--------------------------------------------------------------------------
alias hud_scene_map_main main
alias hud_scene_map_update update
#--------------------------------------------------------------------------
# * Object Initialization
#--------------------------------------------------------------------------
def main
@HUD = Window_HUD.new
hud_scene_map_main
@HUD.dispose
end
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
def update
@HUD.update
hud_scene_map_update
end
end