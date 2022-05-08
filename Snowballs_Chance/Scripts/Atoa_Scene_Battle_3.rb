#==============================================================================
# ** Scene_Battle (part 3)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias acbs_phase3_setup_command_window_scenebattle phase3_setup_command_window
  def phase3_setup_command_window
    @update_skills_commands = Window_Skill.new(@active_battler)
    @update_skills_commands.refresh
    @update_skills_commands.update
    @update_skills_commands.dispose
    acbs_phase3_setup_command_window_scenebattle
    @actor_command_window.back_opacity = Base_Opacity
    command_window_position
    @actor_command_window.z = 4500
    @active_battler_window.refresh(@active_battler)
    set_name_window_position
    disable_commands
  end
  #--------------------------------------------------------------------------
  # * Disable Commands
  #--------------------------------------------------------------------------
  def disable_commands
    for i in 0...@actor_command_window.commands.size
      command = @actor_command_window.commands[i]
      if @active_battler.disabled_commands.include?(command)
        @actor_command_window.disable_item(i)
      else
        @actor_command_window.enable_item(i)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Actor Command Window Position Setup
  #--------------------------------------------------------------------------
  def command_window_position
    adjust = Command_Window_Position_Adjust.dup
    case Command_Window_Position
    when 0
      @actor_command_window.x = @active_battler.base_x - 64 + adjust[0]
      @actor_command_window.y = @active_battler.base_y - 256 + adjust[1]
    when 1
      @actor_command_window.x = @active_battler.base_x + 32 + adjust[0]
      @actor_command_window.y = @active_battler.base_y - 128 + adjust[1]
    when 2
      @actor_command_window.x = @active_battler.base_x - 192 + adjust[0]
      @actor_command_window.y = @active_battler.base_y - 104 + adjust[1]
    when 3
      @actor_command_window.x = Command_Window_Custom_Position[0]
      @actor_command_window.y = Command_Window_Custom_Position[1]
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Name Window Setup
  #--------------------------------------------------------------------------
  def set_name_window_position
    case Name_Window_Position
    when 0
      @active_battler_window.x = @actor_command_window.x
      @active_battler_window.y = @actor_command_window.y - @active_battler_window.height
    when 1
      @active_battler_window.x = @actor_command_window.x
      @active_battler_window.y = @actor_command_window.y + @actor_command_window.height
    when 2
      @active_battler_window.x = @actor_command_window.x - @actor_command_window.width
      @active_battler_window.y = @actor_command_window.y
    when 3
      @active_battler_window.x = @actor_command_window.x + @actor_command_window.width
      @active_battler_window.y = @actor_command_window.y
    when 4
      @active_battler_window.x = @actor_command_window.x + Name_Window_Custom_Position[0]
      @active_battler_window.y = @actor_command_window.y + Name_Window_Custom_Position[1]
      @active_battler_window.z = 7000
      end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_scenebattle update_phase3
  def update_phase3
    update_target_switch
    update_action_scope
    if @enemy_arrow_all != nil
      return update_phase3_select_all_enemies
    elsif @actor_arrow_all != nil
      return update_phase3_select_all_actors
    elsif @battler_arrow_all != nil
      return update_phase3_select_all_battlers
    elsif @self_arrow != nil
      return update_phase3_select_self
    end
    acbs_update_phase3_scenebattle
  end
  #--------------------------------------------------------------------------
  # * Target Switch Update
  #--------------------------------------------------------------------------
  def update_target_switch
    if (Input.trigger?(Input::L) or Input.trigger?(Input::R)) and
       check_include(battler_action(@active_battler), "TARGETSWITCH")
      action = battler_action(@active_battler)
      $game_system.se_play($data_system.cursor_se)
      if @actor_arrow != nil
        end_actor_select
        start_enemy_select
      elsif @enemy_arrow != nil and action.scope == 5
        end_enemy_select
        start_actor_select
      elsif @enemy_arrow != nil and not action.scope == 5
        end_enemy_select
        start_actor_select
      elsif @actor_arrow_all != nil
        end_select_all_actors
        start_select_all_enemies
      elsif @enemy_arrow_all != nil
        end_select_all_enemies
        start_select_all_actors
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Action Scope Update
  #--------------------------------------------------------------------------
  def update_action_scope
    action = battler_action(@active_battler)
    if @enemy_arrow != nil
      @active_battler.action_scope = 1
    elsif @actor_arrow != nil and action.scope == 5
      @active_battler.action_scope = 5
    elsif @actor_arrow != nil and not action.scope == 5
      @active_battler.action_scope = 3
    elsif @actor_arrow_all != nil and action.scope == 6
      @active_battler.action_scope = 6
    elsif @actor_arrow_all != nil and not action.scope == 6
      @active_battler.action_scope = 4
    elsif @enemy_arrow_all != nil
      @active_battler.action_scope = 2
    elsif @self_arrow != nil
      @active_battler.action_scope = 7
    end
  end
  #--------------------------------------------------------------------------
  # * Set Current Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def now_action(battler)
    return if battler.nil?
    battler.now_action = nil
    if battler.attack?
      battler.now_action = battler.weapons[0]
    elsif battler.skill_use?
      battler.now_action = $data_skills[battler.current_action.skill_id]
    elsif battler.item_use?
      battler.now_action = $data_items[battler.current_action.item_id]
    end
  end
  #--------------------------------------------------------------------------
  # * Get current action ID
  #     battler : battler
  #--------------------------------------------------------------------------
  def now_id(battler)
    return battler.now_action.nil? ? 0 : battler.now_action.id
  end
  #--------------------------------------------------------------------------
  # * Get Battler Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_action(battler)
    now_action(battler)
    return battler.now_action.nil? ? battler : battler.now_action
  end
  #--------------------------------------------------------------------------
  # * Start Enemy Selection
  #--------------------------------------------------------------------------
  def start_enemy_select
    now_action(@active_battler)
    @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport4)
    @enemy_arrow.help_window = @help_window
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  def start_actor_select
    now_action(@active_battler)
    @actor_arrow = Arrow_Actor.new(@spriteset.viewport4)
    @actor_arrow.index = @actor_index
    @actor_arrow.help_window = @help_window
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @actor_arrow.input_right if check_include(battler_action(@active_battler), "EXCLUDEUSER")
  end
  #--------------------------------------------------------------------------
  # * Start All Enemies Selection
  #--------------------------------------------------------------------------
  def start_select_all_enemies
    now_action(@active_battler)
    @enemy_arrow_all = Arrow_Enemy_All.new(@spriteset.viewport4)
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Start All Actors Selection
  #--------------------------------------------------------------------------
  def start_select_all_actors
    now_action(@active_battler)
    @actor_arrow_all = Arrow_Actor_All.new(@spriteset.viewport4)
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Start All Battlers Selection
  #--------------------------------------------------------------------------
  def start_select_all_battlers
    now_action(@active_battler)
    @battler_arrow_all = Arrow_Battler_All.new(@spriteset.viewport4)
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Start Self Selection
  #--------------------------------------------------------------------------
  def start_select_self
    now_action(@active_battler)
    @self_arrow = Arrow_Self.new(@spriteset.viewport4)
    @self_arrow.index = @active_battler.index
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : actor selection)
  #--------------------------------------------------------------------------
  alias acbs_update_phase3_actor_select_scenebattle update_phase3_actor_select
  def update_phase3_actor_select
    acbs_update_phase3_actor_select_scenebattle
    if @active_battler != nil and @actor_arrow != nil and 
       @actor_arrow.index == @active_battler.index and
       check_include(battler_action(@active_battler), "EXCLUDEUSER") 
      @actor_arrow.input_update_target
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all enemies selection)
  #--------------------------------------------------------------------------
  def update_phase3_select_all_enemies
    @enemy_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_enemies
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      end_skill_select if @skill_window != nil
      end_item_select if @item_window != nil
      end_select_all_enemies
      phase3_next_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all actors selection)
  #--------------------------------------------------------------------------
  def update_phase3_select_all_actors
    @actor_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_actors
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      end_skill_select if @skill_window != nil
      end_item_select if @item_window != nil
      end_select_all_actors
      phase3_next_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all battlers selection)
  #--------------------------------------------------------------------------
  def update_phase3_select_all_battlers
    @battler_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_all_battlers
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      end_skill_select if @skill_window != nil
      end_item_select if @item_window != nil
      end_select_all_battlers
      phase3_next_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : self selection)
  #--------------------------------------------------------------------------
  def update_phase3_select_self
    @self_arrow.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_select_self
      return
    end
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      end_skill_select if @skill_window != nil
      end_item_select if @item_window != nil
      end_select_self
      phase3_next_actor
      return
    end
  end
  #--------------------------------------------------------------------------
  # * End Actor Selection
  #--------------------------------------------------------------------------
  alias acbs_end_actor_select_scenebattle end_actor_select
  def end_actor_select
    acbs_end_actor_select_scenebattle
    if @actor_command_window.index == 0
      @actor_command_window.active = true
      @actor_command_window.visible = true
      @help_window.visible = false
    end
  end  
  #--------------------------------------------------------------------------
  # * End All Enemies Selection
  #--------------------------------------------------------------------------
  def end_select_all_enemies
    @enemy_arrow_all.dispose_multi_arrow
    @enemy_arrow_all = nil
    if @actor_command_window.index == 0
      @actor_command_window.active = true
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * End All Actors Selection
  #--------------------------------------------------------------------------
  def end_select_all_actors
    @actor_arrow_all.dispose_multi_arrow
    @actor_arrow_all = nil
    if @actor_command_window.index == 0
      @actor_command_window.active = true
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * End All Battlers Selection
  #--------------------------------------------------------------------------
  def end_select_all_battlers
    @battler_arrow_all.dispose_multi_arrow
    @battler_arrow_all = nil
    if @actor_command_window.index == 0
      @actor_command_window.active = true
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * End Self Selection
  #--------------------------------------------------------------------------
  def end_select_self
    @self_arrow.dispose
    @self_arrow = nil
    if @actor_command_window.index == 0
      @actor_command_window.active = true
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  def update_phase3_basic_command
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      phase3_prior_actor
      return
    end
    if Input.trigger?(Input::C)
      command = @actor_command_window.commands[@actor_command_window.index]
      if @active_battler.disabled_commands.include?(command)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      case command 
      when $data_system.words.attack
        confirm_attack_select
        return
      when $data_system.words.item
        confirm_item_select
        return
      when $data_system.words.skill
        confirm_skill_select
        return
      when $data_system.words.guard 
        confirm_guard_select
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Attack Selection
  #--------------------------------------------------------------------------
  def confirm_attack_select
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.kind = 0
    @active_battler.current_action.basic = 0
    @actor_command_window.active = false
    @actor_command_window.visible = false
    ext = check_extension(battler_action(@active_battler), "TARGET/")
    ext.slice!("TARGET/") unless ext.nil?
    if ext == "ALLBATTLERS"
      $game_system.se_play($data_system.decision_se)
      start_select_all_battlers
      return
    elsif ext == "ALLENEMIES" or check_include(battler_action(@active_battler), "RANDOM")
      $game_system.se_play($data_system.decision_se)
      start_select_all_enemies
      return
    elsif ext == "ALLALLIES" and check_include(battler_action(@active_battler), "RANDOM")
      $game_system.se_play($data_system.decision_se)
      start_select_all_actors
      return
    end
    start_enemy_select
  end
  #--------------------------------------------------------------------------
  # * Confirm Item Selection
  #--------------------------------------------------------------------------
  def confirm_item_select
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.kind = 2
    start_item_select
  end
  #--------------------------------------------------------------------------
  # * Confirm Skill Selection
  #--------------------------------------------------------------------------
  def confirm_skill_select
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.kind = 1
    start_skill_select
  end
  #--------------------------------------------------------------------------
  # * Confirm Defend Selection
  #--------------------------------------------------------------------------
  def confirm_guard_select
    $game_system.se_play($data_system.decision_se)
    @active_battler.current_action.kind = 0
    @active_battler.current_action.basic = 1
    phase3_next_actor
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : skill selection)
  #--------------------------------------------------------------------------
  def update_phase3_skill_select
    @skill_window.visible = true
    @skill_window.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_skill_select
      return
    end
    if Input.trigger?(Input::C)
      confirm_action_select(@skill_window.skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : item selection)
  #--------------------------------------------------------------------------
  def update_phase3_item_select
    @item_window.visible = true
    @item_window.update
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      end_item_select
      return
    end
    if Input.trigger?(Input::C)
      confirm_action_select(@item_window.item)
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Action Selection
  #     action : current action
  #--------------------------------------------------------------------------
  def confirm_action_select(action)
    if action.nil? or ((action.skill? and not @active_battler.skill_can_use?(action.id)) or
      (action.item? and not $game_party.item_can_use?(action.id)))
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    $game_system.se_play($data_system.decision_se)
    if @item_window != nil
      @active_battler.current_action.item_id = action.id
      @active_battler.current_item = action
      @item_window.visible = false
    elsif @skill_window != nil
      @active_battler.current_action.skill_id = action.id 
      @active_battler.current_skill = action
      @skill_window.visible = false
    end
    $game_system.se_play($data_system.decision_se)
    ext = check_extension(action, "TARGET/")
    ext.slice!("TARGET/") unless ext.nil?
    if ext == "ALLBATTLERS"
      start_select_all_battlers
      return
    elsif ext == "ALLENEMIES" or action.scope == 2 or (action.scope == 1 and 
       check_include(action, "RANDOM"))
      start_select_all_enemies
      return
    elsif ext == "ALLALLIES" or action.scope == 4 or (action.scope == 3 and 
       check_include(action, "RANDOM"))
      start_select_all_actors
      return
    end
    if action.scope == 7
      start_select_self
    elsif action.scope == 1
      start_enemy_select
    elsif action.scope == 3 or action.scope == 5
      start_actor_select
    else
      end_skill_select if action.skill?
      end_item_select if action.item?
      phase3_next_actor
    end
  end
end