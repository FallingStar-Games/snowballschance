#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  This class performs skill screen processing.
#==============================================================================

class Scene_Skill
  #--------------------------------------------------------------------------
  # * Frame Update (if skill window is active)
  #--------------------------------------------------------------------------
  alias acbs_update_skill_scene_skill update_skill
  def update_skill
    if Input.trigger?(Input::C)
      @skill = @skill_window.skill
      if @skill == nil or not @actor.skill_can_use?(@skill.id)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      if @skill.scope >= 3
        @skill_window.active = false
        @target_window.x = (@skill_window.index + 1) % 2 * 304
        @target_window.visible = true
        @target_window.active = true
        if @skill.scope == 4 || @skill.scope == 6
          @target_window.index = -1
        elsif @skill.scope == 7
          @target_window.index = @actor_index - 10 #edit was 10
        else
          @target_window.index = 0
        end
      else
        if @skill.common_event_id > 0
          $game_temp.common_event_id = @skill.common_event_id
          $game_system.se_play(@skill.menu_se)
          @actor.consume_skill_cost(@skill)
          @status_window.refresh
          @skill_window.refresh
          @target_window.refresh
          $scene = Scene_Map.new
          return
        end
      end
      return
    end
    acbs_update_skill_scene_skill
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when target window is active)
  #--------------------------------------------------------------------------
  alias acbs_update_target_scene_skill update_target
  def update_target
    if Input.trigger?(Input::C)
      unless @actor.skill_can_use?(@skill.id)
        return $game_system.se_play($data_system.buzzer_se)
      end
      if @target_window.index == -1
        used = false
        for i in $game_party.actors
          used |= i.skill_effect(@actor, @skill)
        end
      end
      if @target_window.index <= -2
        target = $game_party.actors[@target_window.index + 10]
        used = target.skill_effect(@actor, @skill)
      end
      if @target_window.index >= 0
        target = $game_party.actors[@target_window.index]
        used = target.skill_effect(@actor, @skill)
      end
      if used
        $game_system.se_play(@skill.menu_se)
        @actor.consume_skill_cost(@skill)
        @status_window.refresh
        @skill_window.refresh
        @target_window.refresh
        return $scene = Scene_Gameover.new if $game_party.all_dead?
        if @skill.common_event_id > 0
          $game_temp.common_event_id = @skill.common_event_id
          $scene = Scene_Map.new
          return
        end
      end
      $game_system.se_play($data_system.buzzer_se) unless used
      return
    end
    acbs_update_target_scene_skill
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Battle Call
  #--------------------------------------------------------------------------
  def call_battle
    $game_temp.battle_calling = false
    $game_temp.menu_calling = false
    $game_temp.menu_beep = false
    $game_player.make_encounter_count
    $game_temp.map_bgm = $game_system.playing_bgm
    $game_system.se_play($data_system.battle_start_se)
    $game_system.bgm_play($game_system.battle_bgm)
    $game_player.straighten
    $scene = Scene_Battle.new
  end
end