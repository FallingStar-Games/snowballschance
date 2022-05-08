#--------------------------
# Overlay Bars BROKEN
# By lavendersiren
# with help from Marrend
#---------------------------
# Allows you to toggle the hp and sp on screen!
# (intended to be used with HP/SP/EXP but can work 
# without it if you just want the numbers)
#--------------------------
=begin
class Overlay_Bars < Scene_Map

def initialize
  show_bars = false
  end
  
def toggle_bars
  if Input.trigger?(:X)
  show_bars = !show_bars
  end
end
  
def refresh
    if Input.trigger?(:X)
      toggle_bars
    end

    if show_bars == true
      for i in 0...$game_party.actors.size
        self.contents.clear
        x = 64
        y = i * 116
        actor = $game_party.actors[i]
        draw_actor_hp(actor, x + 180, y + 25)
        draw_actor_sp(actor, x + 180, y + 46)
      end
    end
  end
end
=end