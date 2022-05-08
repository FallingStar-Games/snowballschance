#-------------------------
#  Faces on menu
#  mostly by Klaudius 84
#  (unknown face handler added by shinyjiggly)
#-----------------------
class Window_MenuStatus < Window_Selectable
def refresh


    self.contents.clear

    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
    x = 64
    y = i * 116
    actor = $game_party.actors[i]
    draw_actor_facegraphic(actor, x - 65, y + 52)
    draw_actor_name(actor, x + 60, y + 8)
    draw_actor_class(actor, x + 60, y + 30)
    draw_actor_state(actor, x + 245, y + 8 )
    draw_actor_hp(actor, x + 190, y + 25)
    draw_actor_sp(actor, x + 190, y + 46)
        #draw_actor_level(actor, x + 60, y + 22)
    #draw_actor_exp(actor, x + 60, y + 51)
    end
  end
  end
  


class Window_Base < Window
def draw_actor_facegraphic(actor, x, y)
  
  if FileTest.exist?("Graphics/Pictures/"+ actor.name + "_face.png")
    bitmap = RPG::Cache.picture(actor.name + "_face")
  else
    bitmap = RPG::Cache.picture("default_face")
  end
    cw = bitmap.width
    ch = bitmap.height
    src_rect = Rect.new(0, 0, cw, ch)
    self.contents.blt(x, y - ch / 2, bitmap, src_rect)
    end
  end
  