#---------------------------
# Item activates skill (Atoa cbs compatible version)
# By: Game_Guy
# Converted over by shinyjiggly
#---------------------------

module GGSI
  def self.item_skill(id)
    case id
    #when item_id then return skill_id
    # pretty much
    # when item then return skill it casts
    
    when 4 then return 11 # heal-y food uses conditional heal
      
    end
    return nil
  end
end
class Game_Battler
  alias gg_link_skill_item_eff_lat item_effect
  def item_effect(item, user = nil)
    s = GGSI.item_skill(item.id)
    return gg_link_skill_item_eff_lat(item) if s == nil || user == nil
    return skill_effect(user, $data_skills[s])
  end
end
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Make Item Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_item_action_result(battler)
    battler.current_item = $data_items[battler.current_action.item_id]
    return unless $game_party.item_can_use?(battler.current_item.id)
    if battler.actor? and battler.current_item.consumable and not 
       battler.multi_action_running
      consum_item_cost(battler)
    end
    battler.multi_action_running = battler.action_done = true
    @status_window.refresh if status_need_refresh
    battler.animation_1 = battler.current_item.animation1_id
    battler.animation_2 = battler.current_item.animation2_id
    @common_event_id = battler.current_item.common_event_id
    index = battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    for target in battler.target_battlers
      target.item_effect(battler.current_item, battler)
    end
  end
end