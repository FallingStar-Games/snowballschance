#==============================================================================
# ** Enhanced Squad Movement - Menu Add-On
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.0
#    12-25-2017 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#==============================================================================
#
#  INTRODUCTION:
#  =============
#    This is a sample script  which can show end-users  how to adapt their
#    custom menu systems to work with 'Enhanced Squad Movement.
#
#    Some of the methods in this script required rewrites due to size and
#    where certain 'texts' needed to be placed,  while other methods were
#    easier to alter by way of alias statements.
#
#    Please note that the 'update_target' methods  within both  Scene_Item 
#    and Scene_Skill were aliases.  The only effect added here was to make
#    it impossible for  'abandoned'  party members  from actively using an
#    item or using a skill.  It does NOT...  prevent an item or skill that
#    affects all party members from skipping over abandoned members.
#
#    In order to make  'all-allies'  skills not function  on an abandoned
#    party member,  you would need  to perform an edit to line 183 to 185
#    that normally reads:
#
#            for i in $game_party.actors
#              used |= i.skill_effect(@actor, @skill)
#            end
#
#    The edit to these lines would include a few lines that look at the
#    party members and skip any actor that has the force_wait flag like:
#
#            for i in $game_party.actors
#              idx = $game_party.actors.index(i)
#              if idx != 0
#                next if $game_system.allies[idx].force_wait == true
#              end
#              used |= i.skill_effect(@actor, @skill)
#            end
#
#    A similar variation can be added into the  'update_target'  method in
#    Scene_Item, around line 159-161.
#
#------------------------------------------------------------------------------



module Squad
  
  WAITING_TEXT = "[Unavailable]"    # Text shown in menu for 'waiting' allies
  STATUS_INDEX = 3              # Index position  for Status Menu in main menu
  
end



#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # clear window contents
    self.contents.clear
    # Set the item max value
    @item_max = $game_party.actors.size
    # Cycle through party members
    for i in 0...$game_party.actors.size
      # Refresh each actor
      refresh_actors(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh (actor by index)
  #--------------------------------------------------------------------------
  def refresh_actors(index)
    # Obtain actor
    actor = $game_party.actors[index]
    # Set X/Y Coordinates for drawing contents
    x     = 64
    y     = index * 116
    # Draw actor basics
    draw_actor_graphic(actor, x - 40, y + 80)
    draw_actor_name(actor, x, y)
    draw_actor_class(actor, x + 144, y)
    # The only direct edit... exits with waiting text if ally waiting
    return if refresh_actors_wait?(index,x,y) == true
    draw_actor_level(actor, x, y + 32)
    draw_actor_state(actor, x + 90, y + 32)
    draw_actor_exp(actor, x, y + 64)
    draw_actor_hp(actor, x + 236, y + 32)
    draw_actor_sp(actor, x + 236, y + 64)
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def refresh_actors_wait?(index, x ,y)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # If ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      # Set text to system color and draw Waiting text    
      self.contents.font.color = system_color
      self.contents.draw_text(x, y+32, 120, 32, Squad::WAITING_TEXT)
      # And exit true
      return true
    end
    # Otherwise, exit false
    return false
  end
end



#==============================================================================
# ** Window_Target
#------------------------------------------------------------------------------
#  This window selects a use target for the actor on item and skill screens.
#==============================================================================

class Window_Target < Window_Selectable
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    # Loop through actors
    for i in 0...$game_party.actors.size
      # Set X/Y Coordinates for drawing contents
      x = 4
      y = i * 116
      # Obtain Actor
      actor = $game_party.actors[i]
      # Draw actor basics
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      # The only direct edit... exits with waiting text if ally waiting
      next if refresh_actors_wait?(i,x,y) == true
      draw_actor_level(actor, x + 8, y + 32)
      draw_actor_state(actor, x + 8, y + 64)
      draw_actor_hp(actor, x + 152, y + 32)
      draw_actor_sp(actor, x + 152, y + 64)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def refresh_actors_wait?(index, x ,y)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # If ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      # Set text to system color and draw Waiting text
      self.contents.font.color = system_color
      self.contents.draw_text(x, y+32, 120, 32, Squad::WAITING_TEXT)
      # And exit true
      return true
    end
    # Otherwise, exit false
    return false
  end
end



#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias squad_menu_window_status_refresh refresh
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Perform the original call
    squad_menu_window_status_refresh
    # Exit unless actor is flagged with force_wait flag
    return unless actors_wait?($game_party.actors.index(@actor))
    # Draw Waiting
    self.contents.draw_text(320, 4, 120, 32, Squad::WAITING_TEXT)
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def actors_wait?(index)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # Exit true if ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      return true
    end
    # Otherwise, exit false
    return false
  end
end



#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs menu screen processing.
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_menu_scene_menu_update_target update_status
  #--------------------------------------------------------------------------
  # * Frame Update (when status window is active)
  #--------------------------------------------------------------------------
  def update_status
    # If B button was pressed and isn't the 'status menu'
    if Input.trigger?(Input::C) && @command_window.index != Squad::STATUS_INDEX
      # Play cancel SE
      if actors_wait?(@status_window.index)
        # Play cancel SE
        $game_system.se_play($data_system.buzzer_se)
        # Exit method
        return        
      end
    end
    # Perform the original call
    squad_menu_scene_menu_update_target
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def actors_wait?(index)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # Exit true if ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      return true
    end
    # Otherwise, exit false
    return false
  end
end



#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs item screen processing.
#==============================================================================

class Scene_Item
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_menu_scene_item_update_target update_target
  #--------------------------------------------------------------------------
  # * Frame Update (when target window is active)
  #--------------------------------------------------------------------------
  def update_target
    # If B button was pressed
    if Input.trigger?(Input::C)
      # Play cancel SE
      if actors_wait?(@target_window.index)
        # Play cancel SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
    end
    # Perform the original call
    squad_menu_scene_item_update_target
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def actors_wait?(index)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # Exit true if ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      return true
    end
    # Otherwise, exit false
    return false
  end  
end



#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  This class performs skill screen processing.
#==============================================================================

class Scene_Skill
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------  
  alias squad_menu_scene_skill_update_target update_target
  #--------------------------------------------------------------------------
  # * Frame Update (when target window is active)
  #--------------------------------------------------------------------------
  def update_target
    # If B button was pressed
    if Input.trigger?(Input::C)
      # Play cancel SE
      if actors_wait?(@target_window.index)
        # Play cancel SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
    end
    # Perform the original call
    squad_menu_scene_skill_update_target
  end
  #--------------------------------------------------------------------------
  # * Refresh (determine if actor waiting)
  #--------------------------------------------------------------------------
  def actors_wait?(index)
    # Exit false if not a valid ally
    return false if $game_system.allies[index].nil?
    # Exit true if ally has the wait flag or is on another map
    if $game_system.allies[index].force_wait or
        $game_system.allies[index].map_id != $game_map.map_id
      return true
    end
    # Otherwise, exit false
    return false
  end  
end