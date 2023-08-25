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
    super(0, 64, 640, 192) #(0, 64, 272, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    
    case (@actor.name)
      when "Frie"
      @friend = 33
      @bio = "A glacia you met on the trail."
      @bio2 = "She has a rather cold disposition..."
      when "Vern"
      @friend = 34
      @bio = "A rather contemplative kind of guy."
      @bio2 = "Apparently this is his first hike."
      when "Topaz"
      @friend = 35
      @bio = "A very theatrical personality."
      @bio2 = "They're your first client."
      when "Coda"
      @friend = 36
      @bio = "That's you! Rather childish but "
      @bio2 = "actually the oldest one here."
      when "Ranger"
      @friend = 66
      @bio = "Found perserved in magical amber."
      @bio2 = "How long can she endure?"
    else
      @friend = 66
      @bio = "A guest to the party."
      @bio2 = "For how long though?"
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
    draw_actor_hp(@actor, 32, 102)
    draw_actor_sp(@actor, 32, 132)
    self.contents.font.color = system_color
    self.contents.draw_text(316, 80+16, width-32, 32, "Friendship value:")
    self.contents.font.color = normal_color
    self.contents.draw_text(370, 110+16, width, 32, $game_variables[@friend].to_s)
    #190
    
    self.contents.draw_text(250, 0, width-32, 32, @bio)
    self.contents.draw_text(250, 32, width-32, 32, @bio2)



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
