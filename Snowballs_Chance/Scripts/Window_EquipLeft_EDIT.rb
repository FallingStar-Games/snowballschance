#==============================================================================
# ** Window_EquipLeft Edited
#------------------------------------------------------------------------------
#  since we aren't using stats here, let's just show everything else
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 64, 272, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    
    case (@actor.name)
      when "Frie"
      @friend = 33
      when "Vern"
      @friend = 34
      when "Topaz"
      @friend = 35
      when "Coda"
      @friend = 36
    else
      @friend = 1
    end
    
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_facegraphic(@actor, 0, 48)
    draw_actor_name(@actor, 92, 0)
    draw_actor_class(@actor, 92, 25)
    draw_actor_state(@actor, 92, 50)
    draw_actor_hp(@actor, 16, 102)
    draw_actor_sp(@actor, 16, 132)
    self.contents.draw_text(190, 110, width, 32, $game_variables[@friend].to_s) 
    self.contents.draw_text(90, 80, width-32, 32, "Friendship value")
    end
  #--------------------------------------------------------------------------
  # * Set parameters after changing equipment
  #     new_atk  : attack power after changing equipment
  #     new_pdef : physical defense after changing equipment
  #     new_mdef : magic defense after changing equipment
  #--------------------------------------------------------------------------
  def set_new_parameters(new_atk, new_pdef, new_mdef)
    if @new_atk != new_atk or @new_pdef != new_pdef or @new_mdef != new_mdef
      @new_atk = new_atk
      @new_pdef = new_pdef
      @new_mdef = new_mdef
      refresh
    end
  end
end
