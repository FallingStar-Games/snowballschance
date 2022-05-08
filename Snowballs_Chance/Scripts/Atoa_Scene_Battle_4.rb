#==============================================================================
# ** Scene_Battle (part 4)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start Main Phase
  #--------------------------------------------------------------------------
  alias acbs_start_phase4_scenebattle start_phase4
  def start_phase4
    acbs_start_phase4_scenebattle
    slip_damage_all if Slip_Damage_Pop_Time == 3 
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase)
  #--------------------------------------------------------------------------
  def update_phase4
    return unless allow_next_action
    return if judge
    if @action_battlers.size == 0 and @active_battlers.size == 0
      turn_ending
      start_phase2
      return
    end
    if $game_temp.forcing_battler == nil
      setup_battle_event
      return if $game_system.battle_interpreter.running?
    end
    if $game_temp.forcing_battler != nil
      @action_battlers.delete($game_temp.forcing_battler)
      @action_battlers.unshift($game_temp.forcing_battler)
    end
    battler = @action_battlers.shift
    return if battler.nil? or battler.index.nil? or @active_battlers.include?(battler)
    @active_battlers << battler
    battler.animation_1 = battler.animation_2 = @common_event_id = 0
    battler.slip_phase = 4 if Slip_Damage_Pop_Time == 0
    battler.remove_states_auto
    battler.current_phase = "Phase 2-1"
    @status_window.refresh if status_need_refresh
  end 
  #--------------------------------------------------------------------------
  # * Check allow next action
  #--------------------------------------------------------------------------
  def allow_next_action
    return false if cant_if_same
    return false if cant_if_damaged_or_invisible
    return false if cant_target_invisible
    return true if @active_battlers.empty? 
    return false if cant_if_enemy_target and not Allow_Enemy_Target
    return false if cant_target_active and not Allow_Active_Target
    return false if cant_target_moving? and not Allow_Moving_Target
    return true if next_before_return? and Next_Before_Return
    return true if allow_same_targets? and Allow_Same_Target
    return true if allow_diff_targets? and Allow_Diff_Targets
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if next battler already active
  #--------------------------------------------------------------------------
  def cant_if_same
    return false if @action_battlers.empty?
    return true if @active_battlers.include?(@action_battlers.first)
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if next battler is target of a enemy
  #--------------------------------------------------------------------------
  def cant_if_enemy_target
    return false if @action_battlers.empty?
    return false if @active_battlers.empty?
    for battler in @active_battlers
      target = @action_battlers.first
      return true if oposite_side(battler, target) and battler.target_battlers.include?(target)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if battler invisible or damaged
  #--------------------------------------------------------------------------
  def cant_if_damaged_or_invisible
    return false if @action_battlers.empty?
    return true if @action_battlers.first.damaged
    return true if @action_battlers.first.invisible
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if target active
  #--------------------------------------------------------------------------
  def cant_target_active
    return false if @action_battlers.empty?
    return false if @action_battlers.first.target_battlers.empty?
    set_targets(@action_battlers.first)
    for target in @action_battlers.first.target_battlers
      return true if @active_battlers.include?(target)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if target invisible
  #--------------------------------------------------------------------------
  def cant_target_invisible
    return false if @action_battlers.empty?
    return false if @action_battlers.first.target_battlers.empty?
    set_targets(@action_battlers.first)
    for target in @action_battlers.first.target_battlers
      return true if target.invisible
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Allow action before battler end it's return move
  #--------------------------------------------------------------------------
  def next_before_return?
    return false if @active_battlers.empty?
    return false if @active_battlers.last.nil?
    return true if ["Phase 5-2", "Phase 5-3", "Phase 5-4"].include?(@active_battlers.last.current_phase)
    return false
  end
  #--------------------------------------------------------------------------
  # * Allow action if battlers targets are the same
  #--------------------------------------------------------------------------
  def allow_same_targets?
    return false if @active_battlers.empty? or @action_battlers.first.nil?
    set_targets(@action_battlers.first)
    return false if @active_battlers.last.target_battlers.empty?
    return false if @action_battlers.first.target_battlers.empty?
    return false if diff_tagets?
    return true
  end
  #--------------------------------------------------------------------------
  # * Check if targets are different
  #--------------------------------------------------------------------------
  def diff_tagets?
    return false if @action_battlers.first.target_battlers.empty?
    for battler in @active_battlers
      next if battler.target_battlers.empty?
      for target in battler.target_battlers
        return false if @action_battlers.first.target_battlers.include?(target)
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Allow action if battlers targets are different
  #--------------------------------------------------------------------------
  def allow_diff_targets?
    return false if @active_battlers.last.nil? or @action_battlers.first.nil?
    set_targets(@action_battlers.first)
    return false if @active_battlers.last.target_battlers.empty?
    return false if @action_battlers.first.target_battlers.empty?
    return false if same_tagets?
    return true
  end
  #--------------------------------------------------------------------------
  # * Check if targets are the same
  #--------------------------------------------------------------------------
  def same_tagets?
    for battler in @active_battlers
      next if battler.target_battlers.empty?
      for target in battler.target_battlers
        return true if @action_battlers.first.target_battlers.include?(target)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Don't allow action if target are in movement
  #--------------------------------------------------------------------------
  def cant_target_moving?
    return false if @action_battlers.empty?
    return false if @action_battlers.first.target_battlers.empty?
    for target in @action_battlers.first.target_battlers
      return true if target.moving?
    end
    return false
  end  
  #--------------------------------------------------------------------------
  # * Check if target are moving
  #--------------------------------------------------------------------------
  def is_active_target(target)
    for battler in @active_battlers
      return true if battler.target_battlers.include?(target)
      return true if battler.random_targets.include?(target)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if battlers are not on the same team
  #     battler_1 : first battler
  #     battler_2 : second battler
  #--------------------------------------------------------------------------
  def oposite_side(battler_1, battler_2)
    return true if battler_1.is_a?(Game_Actor) and battler_2.is_a?(Game_Enemy)
    return true if battler_2.is_a?(Game_Actor) and battler_1.is_a?(Game_Enemy)
    return false
  end
  #--------------------------------------------------------------------------
  # * Turn Ending
  #--------------------------------------------------------------------------
  def turn_ending
    update_turn_ending
  end
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  def update_turn_ending
    slip_damage_all if Slip_Damage_Pop_Time == 2
    for battler in $game_party.actors
      battler.action_scope = 0
    end
    for battler in $game_troop.enemies + $game_party.actors
      @spriteset.battler(battler).default_battler_direction
    end
  end
  #--------------------------------------------------------------------------
  # * Apply slip damage on all battlers
  #--------------------------------------------------------------------------
  def slip_damage_all
    for battler in $game_party.actors + $game_troop.enemies
      battler.slip_phase = 4 unless battler.dead?
    end
  end
  #--------------------------------------------------------------------------
  # * Make Action Orders
  #--------------------------------------------------------------------------
  alias acbs_make_action_orders_scenebattle make_action_orders
  def make_action_orders
    acbs_make_action_orders_scenebattle
    for battler in @action_battlers
      now_action(battler)
      if check_include(battler_action(battler), "FAST")
        @action_battlers.delete(battler)
        @action_battlers.unshift(battler)
      elsif check_include(battler_action(battler), "SLOW")
        @action_battlers.delete(battler)
        @action_battlers << battler
      end
      if battler.now_action.nil? and battler.current_action.basic == 1
        @action_battlers.delete(battler)
        @action_battlers.unshift(battler)
      end
    end
    @action_battlers.uniq!
  end
  #--------------------------------------------------------------------------
  # * Checks for updating battler current phase
  #     battler : active battler
  #--------------------------------------------------------------------------
  def update_current_phase(battler)
    return @active_battlers.delete(battler) if battler.current_phase == ""
    battler.pose_wait = [battler.pose_wait - 1, 0].max
    battler.wait_time = [battler.wait_time - 1, 0].max if not_in_battle(battler)
    return if battler_waiting(battler) or (battler.invisible and not battler.invisible_action)
    update_battler_phases(battler)
  end
  #--------------------------------------------------------------------------
  # * Battler phases update
  #     battler : active battler
  #--------------------------------------------------------------------------
  def update_battler_phases(battler)
    phase = battler.current_phase
    step2_part1(battler) if phase == "Phase 2-1" and not battler_waiting(battler)
    step3_part1(battler) if phase == "Phase 3-1" and not battler_waiting(battler)
    step3_part2(battler) if phase == "Phase 3-2" and not battler_waiting(battler)
    step3_part3(battler) if phase == "Phase 3-3" and not battler_waiting(battler)
    step4_part1(battler) if phase == "Phase 4-1" and not battler_waiting(battler)
    step4_part2(battler) if phase == "Phase 4-2" and not battler_waiting(battler)
    step4_part3(battler) if phase == "Phase 4-3" and not battler_waiting(battler)
    step4_part4(battler) if phase == "Phase 4-4" and not battler_waiting(battler)
    step5_part1(battler) if phase == "Phase 5-1" and not battler_waiting(battler)
    step5_part2(battler) if phase == "Phase 5-2" and not battler_waiting(battler)
    step5_part3(battler) if phase == "Phase 5-3" and not battler_waiting(battler)
    step5_part4(battler) if phase == "Phase 5-4" and not battler_waiting(battler)
  end
  #--------------------------------------------------------------------------
  # * Check if battler is waiting
  #     battler : active battler
  #--------------------------------------------------------------------------
  def battler_waiting(battler)
    return (battler.wait_time > 0 or ((battler.moving? or battler.move_pose) and not
            battler.action?))
  end
  #--------------------------------------------------------------------------
  # * Check if battler is on the battle
  #     battler : active battler
  #--------------------------------------------------------------------------
  def not_in_battle(battler)
    if battler.actor?
      return !$game_party.actors.include?(battler)
    else
      return !$game_troop.enemies.include?(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step2_part1(battler)
    battler.critical_hit = false
    battler.idle_pose = false
    battler.action_done = false
    battler.steal_action = false
    battler.sp_damage = false
    battler.multi_action_running = false
    now_action(battler)
    unless battler.current_action.forcing
      if battler.restriction == 2 or battler.restriction == 3
        battler.current_action.kind = 0
        battler.current_action.basic = 0
      end
      if battler.restriction == 4
        $game_temp.forcing_battler = nil
        battler.current_phase = "Phase 5-1"
        return
      end
    end
    battler.target_battlers = []
    @target_battlers = []
    if battler.skip?
      make_basic_action_result(battler)
    elsif battler.skill_use?
      battler.current_skill = $data_skills[battler.current_action.skill_id]
    elsif battler.item_use?
      battler.current_item = $data_items[battler.current_action.item_id]
    end
    set_targets(battler)
    set_movement(battler)
    battler.current_phase = "Phase 3-1"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step3_part1(battler)
    if cant_use_action(battler)
      battler.current_phase = "Phase 5-1"
      battler.action_scope = 0
      return
    end
    action_start_anime(battler)
    battler.current_phase = "Phase 3-2"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step3_part2(battler)
    now_action(battler)
    set_hit_number(battler)
    set_action_plane(battler)
    battler_effect_update(battler)
    battler.current_phase = "Phase 3-3"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step3_part3(battler)
    set_battler_lock(battler)
    battler.current_phase = "Phase 4-1"
    action_anime(battler) if battler.pose_animation
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step4_part1(battler)
    make_results(battler)
    throw_object(battler, battler_action(battler))
    battler.current_phase = "Phase 4-2"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step4_part2(battler)
    if battler.hit_animation 
      wait_base = battler.animation_2 == 0 ? 0 : [$data_animations[battler.animation_2].frame_max, 1].max
    else 
      wait_base = battle_speed
    end
    set_action_anim(battler, wait_base)
    set_hurt_anim(battler, wait_base)
    set_damage_pop(battler)
    @status_window.refresh if status_need_refresh
    return unless all_throw_end(battler) and anim_delay_end(battler) and pose_delay_end(battler)
    wait_time = check_wait_time(wait_base, battler, "TIMEAFTERANIM/")
    battler.wait_time = battler.skip? ? 0 : wait_time.to_i
    reset_animations(battler)
    battler.hit_animation = check_include(battler_action(battler), "HITSANIMATION")
    battler.pose_animation = false
    battler.animation_2 = 0
    battler.current_phase = "Phase 4-3"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step4_part3(battler)
    return unless all_throw_end(battler)
    @status_window.refresh if status_need_refresh
    steal_action_result(battler) unless battler.steal_action
    battler.mirage = false
    battler.critical_hit = false
    reset_random(battler)
    battler.current_phase = "Phase 4-4"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step4_part4(battler)
    if battler.current_action.hit_times > 0
      move = check_include(battler_action(battler), "MOVEINCOMBO")
      battler_effect_update(battler, false, true, move)
      battler.current_phase = "Phase 3-3"
      return
    end
    return unless @spriteset.battler(battler).jump_count == 0 or battler.lifted
    if battler.current_action.hit_times <= 0
      check_action_hit_times(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step5_part1(battler)
    battler.attack_lock.clear
    battler.wait_time = battle_speed if battler.action_done and not battler.skip?
    @action_plane_delete = true unless @action_plane_settings.empty?
    reset_target_position(battler)
    battler.target_battlers.clear
    battler.random_targets.clear
    battler.critical_hit = false
    reset_animations(battler)
    @help_window.visible = false if @help_window.battler == battler or @help_window.battler.nil?
    $game_temp.forcing_battler = nil
    if @common_event_id > 0
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    battler.current_phase = "Phase 5-2"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step5_part2(battler)
    if check_include(battler_action(battler), "MOVETYPE/NOMOVE")
      battler.wait_time = battler.skip? ? 0 : battle_speed * 2
    end
    update_move_return_init(battler)
    battler.current_phase = "Phase 5-3"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step5_part3(battler)
    if battler.invisible_action = true
      for member in $game_party.actors + $game_troop.enemies
        member.invisible = false
      end
    end
    battler.invisible = false
    battler.invisible_action = false
    battler.slip_phase = 4 if Slip_Damage_Pop_Time == 1
    battler.current_phase = "Phase 5-4"
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  def step5_part4(battler)
    battler.current_phase = ""
    @active_battlers.delete(battler)
    for battler in $game_troop.enemies + $game_party.actors
      @spriteset.battler(battler).default_battler_direction
    end
    @last_active_enemy = battler unless battler.actor? and not battler.dead?
    @last_active_actor = battler if battler.actor? and not battler.dead?
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Set attack lock
  #     battler : active battler
  #--------------------------------------------------------------------------
  def set_battler_lock(battler)  
    for target in battler.target_battlers
      battler.attack_lock << target unless target == battler
    end
  end
  #--------------------------------------------------------------------------
  # * Update Battler effects
  #     battler : active battler
  #--------------------------------------------------------------------------
  def battler_effect_update(battler, check = true, hits = true, move = true)
    check_action_hits(battler) if check
    battler_hits_update(battler) if hits
    battler_movement_update(battler) if move
    battler.teleport_to_target = check_include(battler_action(battler), "TELEPORTTOTARGET")
    battler.random_targets.clear if check_include(battler_action(battler), "CLEARRANDOM")
  end
  #--------------------------------------------------------------------------
  # * Check action hits
  #     battler : active battler
  #--------------------------------------------------------------------------
  def check_action_hits(battler)
    set_invisible_battler(battler)
    set_action_plane(battler)
    battler.current_action.combo_times -= 1
    battler.hit_animation = true
    battler.pose_animation = true
  end
  #--------------------------------------------------------------------------
  # * Update battler hit number
  #     battler : active battler
  #--------------------------------------------------------------------------
  def battler_hits_update(battler)
    battler.current_action.hit_times -= 1
    if battler.target_battlers.empty?
      battler.current_action.hit_times = 0 
      check_action_hit_times(battler)
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Update Battler movement
  #     battler : active battler
  #--------------------------------------------------------------------------
  def battler_movement_update(battler)
    if battler.hit_animation and not 
       (battler.now_action.nil? and not battler.attack?)
      set_move_postion(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler hit times
  #     battler : active battler
  #--------------------------------------------------------------------------
  def check_action_hit_times(battler)
    if battler.target_battlers.empty?
      battler.current_action.combo_times = 0
      check_action_sequence(battler)
      return
    end
    battler.current_action.hit_times = action_hits(battler)
    if battler.current_action.combo_times <= 0
      check_action_sequence(battler)
    else
      battler_effect_update(battler, true, false, false)
    end
  end
  #--------------------------------------------------------------------------
  # * Check action sequence
  #     battler : active battler
  #--------------------------------------------------------------------------
  def check_action_sequence(battler)
    if battler.current_action.action_sequence.empty? or battler.target_battlers.empty?
      battler.current_action.action_sequence.clear
      battler.current_phase = "Phase 5-1"
      battler.action_scope = 0
    else
      set_sequence(battler)
      if battler.invisible_action = true
        for member in $game_party.actors + $game_troop.enemies
          member.invisible = false
        end
      end
      move = check_include(battler_action(battler), "MOVEINCOMBO")
      battler_effect_update(battler, true, true, move)
      battler.current_phase = "Phase 3-3"
    end
  end
  #--------------------------------------------------------------------------
  # * Get pose ID
  #     battler : battler
  #     pose    : pose name
  #--------------------------------------------------------------------------
  def set_pose_id(battler, pose)
    battler_name = battler.battler_name
    if Pose_Sprite[battler_name] != nil and Pose_Sprite[battler_name][pose] != nil
      return Pose_Sprite[battler_name][pose]
    end
    return eval("#{pose}_Pose")
  end
  #--------------------------------------------------------------------------
  # * Set battler targets
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_targets(battler)
    now_action(battler)
    unless battler.skip?
      if update_target_battlers(battler) and battler.now_action.nil?
        set_target_battlers(battler)
        battler.old_scope = 1
      elsif battler.now_action != nil and (update_target_battlers(battler) or
         check_include(battler_action(battler), "RANDOM") or
         battler.old_scope != battler_action(battler).scope or 
         battler.old_scope != battler.action_scope)
        scope = battler.action_scope == 0 ? battler.now_action.scope : battler.action_scope
        battler.old_scope = scope
        set_target_battlers(battler, scope)
      end
    end
    battler.target_battlers.compact!
  end
  #--------------------------------------------------------------------------
  # * Update battler targets
  #     battler : battler
  #--------------------------------------------------------------------------
  def update_target_battlers(battler)
    return true if battler.target_battlers.empty?
    for target in battler.target_battlers
      if battler.now_action.nil? or battler.now_action.scope != 5
        return true if target.dead? or target.invisible or not_in_battle(target)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set target for action
  #     battler : battler
  #     scope   : action scope
  #--------------------------------------------------------------------------
  def set_target_battlers(battler, scope = 1)
    @target_battlers = []
    if battler.now_action.nil?
      set_no_action_target(battler) 
      return
    end
    set_action_targets(battler, scope)
    set_extension_targets(battler, scope)
    @target_battlers.flatten!
    @target_battlers.uniq!
    add_random_battlers(battler) if check_include(battler_action(battler), "RANDOM")
    if battler.current_action.target_index == -1 and @target_battlers[0] != nil
      battler.current_action.target_index = @target_battlers[0].index 
    end
    battler.target_battlers = @target_battlers
  end
  #--------------------------------------------------------------------------
  # * Set targets for physical attacks
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_no_action_target(battler)
    if battler.is_a?(Game_Enemy)
      if battler.restriction == 3
        target = $game_troop.random_target_enemy
      elsif battler.restriction == 2
        target = $game_party.random_target_actor
      else
        index = battler.current_action.target_index
        target = $game_party.smooth_target_actor(index)
      end
    else
      if battler.restriction == 3
        target = $game_party.random_target_actor
      elsif battler.restriction == 2
        target = $game_troop.random_target_enemy
      else
        index = battler.current_action.target_index
        target = $game_troop.smooth_target_enemy(index)
      end
    end
    battler.target_battlers = [target]
  end
  #--------------------------------------------------------------------------
  # * Set targets for action without extensions
  #     battler : battler
  #     scope   : action scope
  #--------------------------------------------------------------------------
  def set_action_targets(battler, scope)
    party = battler.actor? ? $game_party.actors : $game_troop.enemies
    enemies = battler.actor? ? $game_troop.enemies : $game_party.actors
    case scope
    when 1
      index = battler.current_action.target_index
      target = battler.actor? ? $game_troop.smooth_target_enemy(index) : 
                                $game_party.smooth_target_actor(index)
      @target_battlers << target
    when 2
      add_target_battlers(enemies)
    when 3
      index = battler.current_action.target_index
      target = battler.actor? ? $game_party.smooth_target_actor(index) : 
                                $game_troop.smooth_target_enemy(index)
      @target_battlers << target
    when 4
      add_target_battlers(party)
    when 5
      index = battler.current_action.target_index
      @target_battlers << party[index] if party[index] != nil
    when 6
      add_target_battlers(party)
    when 7
      @target_battlers << battler
    end
  end
  #--------------------------------------------------------------------------
  # * Set targets for action with extensions
  #     battler : battler
  #     scope   : scope
  #--------------------------------------------------------------------------
  def set_extension_targets(battler, scope)
    action = battler_action(battler)
    ext = check_extension(action, "TARGET/")
    ext.slice!("TARGET/") unless ext.nil?
    if ext == "ALLENEMIES"
      @target_battlers.clear
      battlers = battler.actor? ? $game_troop.enemies : $game_party.actors
      for target in battlers 
        @target_battlers << target if target.exist? 
      end
    elsif ext == "ALLBATTLERS"
      @target_battlers.clear
      add_target_battlers($game_troop.enemies + $game_party.actors)
    elsif battler.restriction == 2 or ((action.scope < 3 or ext == "ALLENEMIES") and
       check_include(action, "RANDOM"))
      @target_battlers.clear
      add_target_battlers(battler.actor? ? $game_troop.enemies : $game_party.actors)
      random_targets = @target_battlers.dup
      @target_battlers = [random_targets[rand(random_targets.size)]]
    elsif battler.restriction == 3 or ((action.scope > 2 or ext == "ALLALLIES") and 
       check_include(action, "RANDOM"))
      @target_battlers.clear
      add_target_battlers(battler.actor? ? $game_party.actors : $game_troop.enemies )
      random_targets = @target_battlers.dup
      @target_battlers = [random_targets[rand(random_targets.size)]]
    elsif ext == "ALLBATTLERS" and check_include(action, "RANDOM")
      @target_battlers.clear
      add_target_battlers($game_troop.enemies + $game_party.actors)
      random_targets = @target_battlers.dup
      @target_battlers = [random_targets[rand(random_targets.size)]]
    end
    if check_include(action, "INCLUDEUSER") and not 
       @target_battlers.include?(battler)
      @target_battlers << battler 
    elsif check_include(action, "EXCLUDEUSER")
      @target_battlers.delete(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Add battlers to target list
  #     battlers : Alvos
  #--------------------------------------------------------------------------
  def add_target_battlers(battlers)
    for target in battlers
      @target_battlers << target if target.exist?
    end
  end
  #--------------------------------------------------------------------------
  # * Add battlers to random target list
  #     battler : battler
  #--------------------------------------------------------------------------
  def add_random_battlers(battler)
    for target in @target_battlers
      battler.random_targets << target
    end
    battler.random_targets.uniq!
  end
  #--------------------------------------------------------------------------
  # * Set movement values
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_movement(battler)
    reset_battler_movement(battler)
    battler.movement = battler_can_move(battler)
    battler.action_all = check_action_all(battler_action(battler))
    set_action_movement(battler)
    set_locked_movement(battler)
  end
  #--------------------------------------------------------------------------
  # * Clear movement flags
  #     battler : battler
  #--------------------------------------------------------------------------
  def reset_battler_movement(battler)
    battler.movement = battler.step_foward = battler.action_all = false
    battler.action_all = false
  end
  #--------------------------------------------------------------------------
  # * Check movement permissions
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_can_move(battler)
    return false if not Move_to_Attack
    return false if battler.restriction > 3
    return false if battler.skip?
    return false if check_include(battler, "LOCKMOVE/NOMOVE")
    return false if check_include(battler_action(battler), "MOVETYPE/NOMOVE")
    return false if battler_action(battler).magic? and not 
      (check_include(battler_action(battler), "MOVETYPE/STEPFOWARD") or
      check_include(battler_action(battler), "MOVETYPE/MOVETOTARGET") or
      check_include(battler_action(battler), "MOVETYPE/SCREENCENTER"))
    return true
  end
  #--------------------------------------------------------------------------
  # * Set movement type
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_movement(battler)
    ext = check_extension(battler_action(battler), "MOVETYPE/")
    ext.slice!("MOVETYPE/") unless ext.nil?
    battler.movement = true if ext == "MOVETOTARGET"
    battler.step_foward = true if ext == "STEPFOWARD"
    battler.action_center = true if ext == "SCREENCENTER"
    if battler.actor? and battler.now_action.is_a?(RPG::Skill) and not
       battler.now_action.magic? and battler.weapons[0] != nil and not
       check_include(battler.now_action, "IGNOREWEAPONMOVE")
      ext = check_extension(battler.weapons[0], "MOVETYPE/")
      ext.slice!("MOVETYPE/") unless ext.nil?
      battler.movement = true if ext == "MOVETOTARGET"
      battler.step_foward = true if ext == "STEPFOWARD"
      battler.action_center = true if ext == "SCREENCENTER"
    end
  end
  #--------------------------------------------------------------------------
  # * Set fixed movement type
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_locked_movement(battler)
    ext = check_extension(battler, "LOCKMOVE/")
    unless ext.nil?
      ext.slice!("LOCKMOVE/")
      battler.movement = (ext != "NOMOVE" and not battler.skip?)
      battler.action_center = false
      battler.step_foward = ext == "STEPFOWARD"
    end
  end
  #--------------------------------------------------------------------------
  # * Check actions that targets multiple battlers
  #     battler : battler
  #--------------------------------------------------------------------------
  def check_action_all(action)
    return true if check_include(action, "TARGET/ALLBATTLERS")
    return true if check_include(action, "TARGET/ALLENEMIES")
    return true if check_include(action, "TARGET/ALLALLIES")
    return true if not action.is_a?(Game_Battler) and action.scope == 2
    return true if not action.is_a?(Game_Battler) and action.scope == 4
    return true if not action.is_a?(Game_Battler) and action.scope == 6
    return false
  end
  #--------------------------------------------------------------------------
  # * Check permission for using action
  #     battler : battler
  #--------------------------------------------------------------------------
  def cant_use_action(battler)
    now_action(battler)
    if battler.now_action.is_a?(RPG::Skill) and not battler.skill_can_use?(battler.now_action.id)
      unless battler.current_action.forcing
        $game_temp.forcing_battler = nil
        return true
      end
    end
    if battler.now_action.is_a?(RPG::Item) and not 
       $game_party.item_can_use?(battler.now_action.id)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Action Start Animation
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_start_anime(battler)
    battler.animation_1 = 0
    now_action(battler)
    return if battler.now_action.nil? and not battler.attack?
    if battler.attack? 
      battler.animation_1 = battler.animation1_id
    elsif battler.skill_use? or battler.item_use?
      set_action_start_anim(battler)
    end
    if battler.now_action.is_a?(RPG::Skill)
      battle_cry_advanced(battler, "SKILLCAST", now_id(battler))
    end
    set_mirage(battler, "CAST")
    if battler.animation_1 == 0
      battler.wait_time = 0
    else
      battler.animation_id = battler.animation_1
      battler.animation_hit = true
      battler.wait_time = $data_animations[battler.animation_1].frame_max * 2
    end
    battler.mirage = false
  end
  #--------------------------------------------------------------------------
  # * Action Animation
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_anime(battler)
    battler.pose_wait = 0
    battler.move_pose = false
    battler.idle_pose = false
    @spriteset.battler(battler).move_pose = false
    @spriteset.battler(battler).action_battler_direction unless battler.step_foward or battler.action_all
    return if battler.dead? or battler.skip? or check_include(battler_action(battler), "NOANIMATION")
    now_action(battler)
    set_basic_action_pose(battler)
    set_extension_pose(battler)
    battler.action_movement_end
    set_jump_action(battler)
    set_lift_action(battler)
    set_fall_action(battler)
    set_mirage(battler, "ACTION")
    set_action_battle_cry(battler)
    return if @action_pose_id.nil? or @action_pose_id == 0
    battler.pose_id = @spriteset.battler(battler).set_idle_pose
    @spriteset.battler(battler).update_pose
    battler.pose_id = @action_pose_id
    pose_wait = @spriteset.battler(battler).battler_pose(battler.pose_id)
    return if pose_wait.nil?
    battler_pose_wait = check_wait_time(pose_wait[0] * pose_wait[1] / 2, battler, "TIMEBEFOREANIM/")
    battler.pose_wait = battler_pose_wait
    battler.wait_time = battler_pose_wait
  end
  #--------------------------------------------------------------------------
  # * Set basica action pose
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_basic_action_pose(battler)
    critical = set_critical(battler)
    case battler.now_action
    when nil, RPG::Weapon
      @basic_pose = set_attack_pose(battler, critical)
    when RPG::Skill
      @basic_pose = set_skill_pose(battler, battler.now_action.magic?, critical)
    when RPG::Item
      @basic_pose = set_pose_id(battler, "Item")
    end
  end
  #--------------------------------------------------------------------------
  # * Set critical attack
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_critical(battler)
    critical = false
    if battler.now_action.is_a?(RPG::Weapon) or 
       (battler.now_action.nil? and battler.attack?)
      for target in battler.target_battlers
        critical |= battler.set_attack_critical(target, battler.weapon_critical)
      end
    elsif battler.now_action.is_a?(RPG::Skill) and 
       check_include(battler.now_action, "CRITICAL")
      for target in battler.target_battlers
        ext = ext = check_extension(battler.now_action, "CRITICAL/")
        rate = ext.nil? ? 0 : ext.to_i
        critical |= battler.set_attack_critical(target, rate)
      end
    elsif battler.now_action.is_a?(RPG::Skill) and 
       check_include(battler.now_action, "WEAPONCRITICAL")
      for target in battler.target_battlers
        ext = ext = check_extension(battler.now_action, "WEAPONCRITICAL/")
        rate = ext.nil? ? battler.crt : battler.weapon_critical + ext.to_i
        critical |= battler.set_attack_critical(target, rate)
      end
    end
    return critical
  end
  #--------------------------------------------------------------------------
  # * Set physical attack pose
  #     battler  : battler
  #     critical : critical hit flag
  #--------------------------------------------------------------------------
  def set_attack_pose(battler, critical)
    basic = set_pose_id(battler, critical ? "Critical" : "Attack")
    basic = basic.nil? ? set_pose_id(battler, "Attack") : basic
    return basic
  end
  #--------------------------------------------------------------------------
  # * Set skill pose
  #     battler  : battler
  #     magic    : magic skill flag
  #     critical : critical hit flag
  #--------------------------------------------------------------------------
  def set_skill_pose(battler, magic, critical)
    basic = set_pose_id(battler, magic ? "Magic" : (critical and 
                        Critical_Skill_Pose != nil) ? "Critical_Skill" : "Skill")
    basic = basic.nil? ? set_pose_id(battler, "Magic") : basic
    return basic
  end
  #--------------------------------------------------------------------------
  # * Check Wait Time
  #     wait_base : base wait time
  #     battler   : battler
  #     time      : tempo de espera
  #--------------------------------------------------------------------------
  def check_wait_time(wait_base, battler, time)
    case battler.now_action
    when nil
      ext = check_extension(battler, time)
      unless ext.nil?
        ext.slice!(time)
        value = ext.to_i
        return value.nil? ? 0 : value.to_i
      end
    when RPG::Skill, RPG::Weapon, RPG::Item
      ext = check_extension(battler.now_action, time)
      unless ext.nil?
        ext.slice!(time)
        value = ext.to_i
        return value.nil? ? 0 : value.to_i
      end
    end
    return wait_base.to_i
  end
  #--------------------------------------------------------------------------
  # * Set pose by extension
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_extension_pose(battler)
    ext = check_extension(battler_action(battler), "ANIME/")
    unless ext.nil?
      ext.slice!("ANIME/")
      random_pose = eval("[#{ext}]")
      custom_pose = random_pose[rand(random_pose.size)]
    end
    return @action_pose_id = 0 if custom_pose == 0
    pose_dont_exist = custom_pose.nil? ? true : @spriteset.battler(battler).battler_pose(custom_pose).nil?
    @action_pose_id =  pose_dont_exist ? @basic_pose : custom_pose
  end
  #--------------------------------------------------------------------------
  # * Set jump action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_jump_action(battler)
    ext = check_extension(battler_action(battler), "JUMP/")
    unless ext.nil?
      ext.slice!("JUMP/")
      battler.jumping = ext.to_i
      @spriteset.battler(battler).jump_action_init
      ext2 = check_extension(battler_action(battler), "JUMPSPEED/")
      battler.jump_speed = ext.to_i unless ext2.nil?
    end
  end
  #--------------------------------------------------------------------------
  # * Set lift action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_lift_action(battler)
    ext = check_extension(battler_action(battler), "LIFT/")
    unless ext.nil?
      ext.slice!("LIFT/")
      battler.lifting = true
      battler.jumping = ext.to_i
      @spriteset.battler(battler).jump_action_init
    end
  end
  #--------------------------------------------------------------------------
  # * Set fall action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_fall_action(battler)
    if check_include(battler_action(battler), "FALL")
      battler.lifting = false
      battler.lifted = false
    end
    ext = check_extension(battler_action(battler), "HEAVYFALL/")
    unless ext.nil?
      ext.slice!("HEAVYFALL/")
      battler.heavy_fall = ext.to_i
    end
  end
  #--------------------------------------------------------------------------
  # * Set action Sound Effect
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_battle_cry(battler)
    case battler.now_action
    when nil, RPG::Weapon
      battle_cry_advanced(battler, "WEAPON", now_id(battler))
    when RPG::Skill
      battle_cry_advanced(battler, "SKILLUSE", now_id(battler))
    when RPG::Item
      battle_cry_advanced(battler, "ITEM", now_id(battler))
    end
  end
  #--------------------------------------------------------------------------
  # * Set action start animation
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_start_anim(battler)
    if battler.skill_use?
      action = $data_skills[battler.current_action.skill_id]
      pose = set_pose_id(battler, action.magic? ? "Magic_Cast" : "Physical_Cast")
    elsif battler.item_use?
      action = $data_items[battler.current_action.item_id]
      pose = set_pose_id(battler, "Item_Cast")
    end
    ext = check_extension(action, "CAST/")
    unless ext.nil?
      ext.slice!("CAST/")
      random_pose = eval("[#{ext}]")
      pose = random_pose[rand(random_pose.size)]
    end
    battler.pose_id = pose if pose != nil
    battler.animation_1 = action.animation1_id
    set_action_help(action, battler)
  end
  #--------------------------------------------------------------------------
  # * Set action help message
  #     action  : action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_help(action, battler = nil)
    return if action.nil? or (not action.is_a?(String) and check_include(action, "HELPHIDE"))
    if action.is_a?(String)
      @help_window.set_text(action, 1, battler)
    elsif action.is_a?(RPG::Item) or action.is_a?(RPG::Skill) 
      @help_window.set_text(action.name, 1, battler)
    end
    @help_window.visible = false if (not action.is_a?(String) and check_include(action, "HELPDELETE"))
  end
  #--------------------------------------------------------------------------
  # * Set hit number
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_hit_number(battler)
    battler.current_action.hit_times = action_hits(battler)
    battler.current_action.combo_times = action_combo(battler)
    battler.current_action.action_sequence = action_sequences(battler, battler_action(battler))
  end
  #--------------------------------------------------------------------------
  # * Set invisibility for battlers
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_invisible_battler(battler)
    ext = check_extension(battler_action(battler), "HIDE/")
    return if ext.nil?
    battler.invisible_action = true
    battler.wait_time = 12
    ext.slice!("HIDE/")
    case ext
    when "BATTLER"
      battler.invisible = true
    when "PARTY","ENEMIES"
      party = battler.actor? ? $game_party.actors : $game_troop.enemies if ext == "PARTY"
      party = battler.actor? ? $game_troop.enemies : $game_party.actors if ext == "ENEMIES"
      for member in party
        member.invisible = true
      end
    when "OTHERS","ACTIVE","ALL"
      party = $game_party.actors + $game_troop.enemies
      for member in party
        member.invisible = true if ext == "OTHERS" and member != battler 
        member.invisible = true if ext == "ACTIVE" and not (member == battler or battler.target_battlers.include?(member))
        member.invisible = true if ext == "ALL"
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set background image for action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_plane(battler)
    ext = check_extension(battler_action(battler), "ACTIONPLANE/")
    if ext.nil?
      @action_plane_delete = true unless @action_plane_settings.empty?
      return 
    end
    return unless @action_plane_settings.empty?
    @action_plane_delete = false
    battler.wait_time = 12
    ext.slice!("ACTIONPLANE/")
    ext = ext.split(",") 
    @action_plane_settings[0] = ext[2].to_i
    @action_plane_settings[1] = ext[3].nil? ? 0 : ext[3].to_i
    @action_plane_settings[2] = ext[4].nil? ? 0 : ext[4].to_i
    @action_plane.bitmap = RPG::Cache.picture(ext[1])
    @action_plane.z = ext[0] == "ABOVE" ? 640 : - 100
    @action_plane.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Set move position
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_move_postion(battler)
    set_movement(battler)
    set_targets(battler)
    set_move_init(battler)
  end
  #--------------------------------------------------------------------------
  # * Set movement init
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_move_init(battler)
    battler_sprite = @spriteset.battler(battler)
    battler_sprite.default_battler_direction
    battler.set_move_target_postion
    battler.move_pose = true if battler.moving?
    battler_sprite.action_battler_direction if battler.moving? and not battler.step_foward
    set_mirage(battler, "ADVANCE")
  end
  #--------------------------------------------------------------------------
  # * Set mirage effect
  #     battler : battler
  #     type    : mirage type
  #--------------------------------------------------------------------------
  def set_mirage(battler, type)
    ext = check_extension(battler_action(battler), "MIRAGE#{type}/")
    return if ext.nil?
    ext.slice!("MIRAGE#{type}/")
    ext = eval("[#{ext}]")
    battler.mirage = true 
    battler.mirage_color = ext.compact
  end
  #--------------------------------------------------------------------------
  # * Get action hit number
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_hits(battler)
    ext = check_extension(battler_action(battler), "HITS/")
    return 1 if ext.nil?
    ext.slice!("HITS/")
    ext = ext.split("-")
    hit1 = eval(ext[0])
    hit2 = ext[1].nil? ? hit1 : eval(ext[1])
    hits = [[rand(hit2 + 1 - hit1) + hit1, hit1].max, hit2].min    
    return hits.to_i
  end
  #--------------------------------------------------------------------------
  # * Get action attack number
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_combo(battler)
    ext = check_extension(battler_action(battler), "COMBO/")
    return 1 if ext.nil?
    ext.slice!("COMBO/")
    ext = ext.split("-")
    hit1 = eval(ext[0])
    hit2 = ext[1].nil? ? hit1 : eval(ext[1])
    hits = [[rand(hit2 + 1 - hit1) + hit1, hit1].max, hit2].min    
    return hits.to_i
  end
  #--------------------------------------------------------------------------
  # * Get action sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  def action_sequences(battler, action)
    ext = check_extension(action, "SEQUENCE/")
    return [] if ext.nil?
    ext.slice!("SEQUENCE/")
    ext = ext.split(",")
    sequence = []
    for i in 0...ext.size
      sequence << ext[i].to_i
    end
    return sequence
  end
  #--------------------------------------------------------------------------
  # * Make Result of Actions
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_results(battler)
    if battler.attack?
      make_basic_action_result(battler)
    elsif battler.skill_use?
      make_skill_action_result(battler)
    elsif battler.item_use?
      make_item_action_result(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Make Basic Action Result
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_basic_action_result(battler)
    if battler.current_action.basic == 0
      set_attack_action(battler)
      return
    elsif battler.current_action.basic == 1
      set_guard_action(battler)
      return
    elsif battler.is_a?(Game_Enemy) and battler.current_action.basic == 2
      set_escape_action(battler)
      return
    elsif battler.current_action.basic == 3
      set_action_none(battler)
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Set Attack Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_attack_action(battler)
    battler.animation_1 = battler.animation1_id
    battler.animation_2 = battler.animation2_id
    for target in battler.target_battlers
      target.attack_effect(battler)
    end
    battler.action_done = true
  end
  #--------------------------------------------------------------------------
  # * Set Defense Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_guard_action(battler)
    battler.movement = battler.step_foward = false
    text = Guard_Message.dup
    text.gsub!(/{battler_name}/i) {"#{battler.name}"}
    @help_window.set_text(text, 1, battler)
    battler.idle_pose = true
    battler.defense_pose = true
    battler.action_done = true
    battle_cry_basic(battler, "DEFENSE")
    @wait_all = 10 + battle_speed * 2
  end
  #--------------------------------------------------------------------------
  # * Set Escape Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_escape_action(battler)
    battler.movement = battler.step_foward = false
    text = Escape_Message.dup
    text.gsub!(/{battler_name}/i) {"#{battler.name}"}
    @help_window.set_text(text, 1, battler)
    battler.escape
    battler.action_done = true
    battle_cry_basic(battler, "ESCAPE")
    @wait_all = 10 + battle_speed * 2
  end
  #--------------------------------------------------------------------------
  # * Set Skip Action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_none(battler)
    battler.movement = battler.step_foward = false
    $game_temp.forcing_battler = nil
    battler.action_done = true
  end
  #--------------------------------------------------------------------------
  # * Make Skill Action Results
  #     battler : battler
  #--------------------------------------------------------------------------
  def make_skill_action_result(battler)
    battler.current_skill = $data_skills[battler.current_action.skill_id]
    unless battler.current_action.forcing or battler.multi_action_running
      unless battler.skill_can_use?(battler.current_skill.id)
        $game_temp.forcing_battler = nil
        return
      end
    end
    unless battler.multi_action_running
      battler.consume_skill_cost(battler.current_skill)
    end
    battler.multi_action_running = battler.action_done = true
    @status_window.refresh if status_need_refresh
    battler.current_skill = battler.now_action if battler.current_skill.nil?
    battler.animation_1 = battler.current_skill.animation1_id #uhhhh
    battler.animation_2 = battler.current_skill.animation2_id
    battler.animation_2 = battler.animation2_id if battler.animation_2 == 0
    @common_event_id = battler.current_skill.common_event_id
    for target in battler.target_battlers
      target.skill_effect(battler, battler.current_skill)
    end
  end
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
  #--------------------------------------------------------------------------
  # * Set item consum
  #     battler : battler
  #--------------------------------------------------------------------------
  def consum_item_cost(battler)
    $game_party.lose_item(battler.current_item.id, 1) 
  end
  #--------------------------------------------------------------------------
  # * Throw start animation
  #     battler : battler
  #     action  : action
  #--------------------------------------------------------------------------
  def throw_object(battler, action)
    for target in battler.target_battlers
      ext = set_throw_action(battler, action, "START")
      next if ext.nil? or @spriteset.battler(target).throwing?(battler)
      battler_sprite = @spriteset.battler(target)
      active_sprite = @spriteset.battler(battler)
      battler_sprite.set_throw_object(ext, active_sprite, battler)
      $game_system.se_play(RPG::AudioFile.new(ext[0], 100, 100)) if ext[0] != "nil"
    end
  end
  #--------------------------------------------------------------------------
  # * Throw return start animation
  #     battler : battler
  #     action  : action
  #--------------------------------------------------------------------------
  def throw_return(battler, target, action)
    ext = set_throw_action(battler, action, "END")
    return if ext.nil?
    battler_sprite = @spriteset.battler(target)
    active_sprite = @spriteset.battler(battler)
    battler_sprite.set_throw_return(ext, active_sprite, battler)
    $game_system.se_play(RPG::AudioFile.new(ext[0], 100, 100)) if ext[0] != "nil"
  end
  #--------------------------------------------------------------------------
  # * Set throw action
  #     battler : battler
  #     action  : action
  #     type    : throw type
  #--------------------------------------------------------------------------
  def set_throw_action(battler, action, type)
    if battler.actor? and not check_include(action, "THROWWEAPONIGNORE") and
       action != nil and not action.magic? and not action.is_a?(RPG::Item)
      for weapon in battler.weapons
        ext = check_extension(weapon, type + "THROWWEAPON/")
        next if ext.nil?
        ext.slice!(type + "THROWWEAPON/")
        ext = ext.split(",") 
        for i in 1...ext.size
          ext[i] = eval(ext[i]) if ext[i] != nil
        end
        return ext
      end
    end
    ext = check_extension(action, type + "THROW/")
    return nil if ext.nil?
    ext.slice!(type + "THROW/") 
    ext = ext.split(",") 
    for i in 1...ext.size
      ext[i] = eval(ext[i]) if ext[i] != nil
    end
    return ext
  end
  #--------------------------------------------------------------------------
  # * Check all throw end
  #     battler : battler
  #--------------------------------------------------------------------------
  def all_throw_end(battler)
    for target in battler.target_battlers
      next unless @spriteset.battler(target).throwing?(battler)
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Set Battle Animation
  #     battler   : battler
  #     wait_base : base wait time
  #--------------------------------------------------------------------------
  def set_action_anim(battler, wait_base)
    for target in battler.target_battlers
      if battler.pose_delay[target].nil? and not @spriteset.battler(target).throwing?(battler)
        anim_target = (battler.now_action != nil and battler.now_action.scope == 7) ? battler : target
        set_target_animation(battler, anim_target)
        wait_time = check_wait_time(wait_base / 2, battler, "IMPACTDELAY/")
        battler.pose_delay[target] = wait_time
      end
    end
  end  
  #--------------------------------------------------------------------------
  # * Set Damage Pose
  #     battler   : battler
  #     wait_base : base wait time
  #--------------------------------------------------------------------------
  def set_hurt_anim(battler, wait_base)
    for target in battler.target_battlers
      next if battler.pose_delay[target].nil?
      battler.pose_delay[target] = [battler.pose_delay[target] - 1, 0].max
      if battler.target_damage[target] != nil and battler.pop_delay[target].nil? and
         battler.pose_delay[target] == 0
        wait_time = check_wait_time(wait_base / 2, battler, "DAMAGEDELAY/")
        battler.pop_delay[target] = wait_time
        damage = battler.target_damage[target]
        target.damaged = ((damage.numeric? and damage > 0) and not no_damage(battler, target))
        target.evaded = damage == Miss_Message
        set_damage_move(battler, target) unless target.evaded
        dmg_time = check_wait_time(20, battler, "DMGANIMTIME/")
        target.damage_count = dmg_time
        set_damage_battle_cry(target)
        throw_return(battler, target, battler_action(battler))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Damage Pop
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_damage_pop(battler)
    for target in battler.target_battlers
      next if battler.pop_delay[target].nil?
      battler.pop_delay[target] = [battler.pop_delay[target] - 1, 0].max
      if battler.target_damage[target] != nil and battler.pop_delay[target] == 0
        damage_mirror(target)
        set_target_damage(battler, target)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set target damage
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def set_target_damage(battler, target)
    target.damage = battler.target_damage[target]
    target.damage = "" if no_damage(battler, target)
    target.damage_pop = true
    battler.target_damage.delete(target)
  end
  #--------------------------------------------------------------------------
  # * Set damage pop inversion
  #     target : target
  #--------------------------------------------------------------------------
  def damage_mirror(target)
    return if target.nil?
    @spriteset.battler(target).dmg_mirror = target.direction == 6 ? true : false
  end
  #--------------------------------------------------------------------------
  # * Set battle animation on target
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def set_target_animation(battler, target)
    return if check_include(battler_action(battler), "NOANIMATION")
    action = battler_action(battler)
    set_custom_anim_direction(battler, target, action)
    set_mirror_animation(battler, target, action)
    target.animation_pos = avarage_position(battler.target_battlers) if check_include(action, "ANIMCENTERTARGET")
    target.animation_hit = (target.damage != Miss_Message)
  end
  #--------------------------------------------------------------------------
  # * Set animation based on current position and direction
  #     battler : battler
  #     target  : target
  #     action  : current action
  #--------------------------------------------------------------------------
  def set_custom_anim_direction(battler, target, action)
    ext = nil
    if check_include(action, "ANIMDIRECTIONTARGET")
      ext = check_extension(action, "ANIMDIRECTIONTARGET/")
      ext.slice!("ANIMDIRECTIONTARGET/")
    elsif check_include(action, "ANIMDIRECTIONCASTER")
      ext = check_extension(action, "ANIMDIRECTIONCASTER/")
      ext.slice!("ANIMDIRECTIONCASTER/")
    elsif check_include(action, "ANIMDIRECTIONPOSITION")
      ext = check_extension(action, "ANIMDIRECTIONPOSITION/")
      ext.slice!("ANIMDIRECTIONPOSITION/")
    end
    if ext.nil?
      target.animation_id = battler.hit_animation ? battler.animation_2 : 0
    else
      ext = ext.split(",")
      dir = check_include(action, "ANIMDIRECTIONPOSITION") ? relative_direction(target) :
            check_include(action, "ANIMDIRECTIONTARGET") ? target.direction : battler.direction
      anim_id = dir == 2 ? eval(ext[0]) : dir == 4 ? eval(ext[1]) : 
                dir == 6 ? eval(ext[2]) : eval(ext[3])
      anim_id = anim_id.nil? ? 0 : anim_id
      target.animation_id = battler.hit_animation ? anim_id : 0
    end
  end
  #--------------------------------------------------------------------------
  # * Set battle animation inversion
  #     battler : battler
  #     target  : target
  #     action  : current action
  #--------------------------------------------------------------------------
  def set_mirror_animation(battler, target, action)
    ext = nil
    if check_include(action, "ANIMMIRRORTARGET")
      ext = check_extension(action, "ANIMMIRRORTARGET/")
      ext.slice!("ANIMMIRRORTARGET/")
    elsif check_include(action, "ANIMMIRRORCASTER")
      ext = check_extension(action, "ANIMMIRRORCASTER/")
      ext.slice!("ANIMMIRRORCASTER/")
    end
    unless ext.nil?
      ext = ext.split(",")
      dir = check_include(action, "ANIMMIRRORTARGET") ? target.direction : battler.direction
      target.animation_mirror = dir == 2 ? eval(ext[0]) : dir == 4 ? eval(ext[1]) :
                                dir == 6 ? eval(ext[2]) : eval(ext[3])
    end
  end
  #--------------------------------------------------------------------------
  # * Get battlers avarage position
  #     battlers : battlers group
  #--------------------------------------------------------------------------
  def avarage_position(battlers)
    x = 0
    y = 0
    for target in battlers
      x += target.actual_x
      y += target.actual_y
    end
    x /= [battlers.size, 1].max
    y /= [battlers.size, 1].max
    return [x, y]
  end
  #--------------------------------------------------------------------------
  # * Target relative postion
  #     target : target
  #--------------------------------------------------------------------------
  def relative_direction(target)
    relative_x = (@spriteset.battleback_width / 2) - target.actual_x
    relative_y = (@spriteset.battleback_height / 2) - target.actual_y
    if relative_y.abs > relative_x.abs and Battle_Style > 1
      return (relative_y < 0 ? 8 : 2)
    else
      return (relative_x < 0 ? 4 : 6)
    end
  end
  #--------------------------------------------------------------------------
  # * Sound effect for reciving attacks
  #     target : target
  #--------------------------------------------------------------------------
  def set_damage_battle_cry(target)
    if target.evaded
      battle_cry_basic(target, "EVADE")
    elsif target.damaged
      battle_cry_basic(target, "DAMAGE")
    end
  end
  #--------------------------------------------------------------------------
  # * Check no damage
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def no_damage(battler, target)
    return (battler.now_action.is_a?(RPG::Skill) and ((target.damage == Miss_Message and 
        check_include(battler.now_action, "STEAL")) or 
        check_include(battler.now_action, "NODAMAGE")))
  end
  #--------------------------------------------------------------------------
  # * Check delay on animation exhibition
  #     battler : battler
  #--------------------------------------------------------------------------
  def anim_delay_end(battler)
    for target in battler.target_battlers
      return false if battler.pop_delay[target] != nil and battler.pop_delay[target] > 0
      return false if battler.pose_delay[target] != nil and battler.pose_delay[target] > 0
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Check pose delay end
  #     battler : battler
  #--------------------------------------------------------------------------
  def pose_delay_end(battler)
    return battler.pose_wait <= 0
  end
  #--------------------------------------------------------------------------
  # * Clear animations information
  #     battler : battler
  #--------------------------------------------------------------------------
  def reset_animations(battler)
    for target in $game_troop.enemies + $game_party.actors
      battler.pop_delay.delete(target)
      battler.pose_delay.delete(target)
      battler.target_damage.delete(target)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Damage Movement
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def set_damage_move(battler, target)
    now_action(battler)
    action = battler_action(battler)
    set_relase(battler, target, action)
    set_impact(battler, target, action)
    set_bounce(battler, target, action)
    set_rise(battler, target, action)
    set_smash(battler, target, action)
    set_shake(battler, target, action)
    set_freeze(battler, target, action)
    set_dmgwait(battler, target, action)
  end
  #--------------------------------------------------------------------------
  # * Set damage relase
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_relase(battler, target, action)
    return unless check_include(action, "DMGRELASE")
    target.dmgwait = 0
    target.freeze = false
    target.rising = false
    target.rised = false
  end 
  #--------------------------------------------------------------------------
  # * Set damage impact
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_impact(battler, target, action)
    ext = check_extension(action, "DMGIMPACT/")
    return if ext.nil?
    ext.slice!("DMGIMPACT/")
    ext = eval("[#{ext}]")
    hit_x = target.hit_x - battler.actual_x
    hit_y = target.hit_y - battler.actual_y
    dist_x = (hit_x < 0 ? -ext[1] : hit_x > 0 ? ext[1] : 0) + (ext[2] != nil ? ext[2] : 0) 
    dist_y = (hit_y < 0 ? -ext[1] : hit_y > 0 ? ext[1] : 0) + (ext[3] != nil ? ext[3] : 0)
    divisor = (Math.sqrt((dist_x ** 2) + (dist_y ** 2)) / ext[1]).to_f
    return if divisor == 0
    case ext[0]
    when 0
      target.damage_x = target.hit_x + (dist_x / divisor).to_i
      target.damage_y = target.hit_y + (dist_y / divisor).to_i
    when 1
      target.damage_x = target.hit_x + (dist_x / divisor).to_i if [4,6].include?(battler.direction)
      target.damage_y = target.hit_y + (dist_y / divisor).to_i if [2,8].include?(battler.direction)
    when 2
      target.damage_x = target.hit_x - (dist_x / divisor).to_i if [4,6].include?(battler.direction)
      target.damage_y = target.hit_y - (dist_y / divisor).to_i if [2,8].include?(battler.direction)
    end
  end
  #--------------------------------------------------------------------------
  # * Set damage bounce
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_bounce(battler, target, action)
    ext = check_extension(action, "DMGBOUNCE/")
    return if ext.nil?
    ext.slice!("DMGBOUNCE/")
    target.bouncing = ext.to_i
    @spriteset.battler(target).bounce_init
  end
  #--------------------------------------------------------------------------
  # * Set damage smash
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_smash(battler, target, action)
    return unless check_include(action, "DMGSMASH")
    target.smashing = true
    target.rising = false
    target.rised = false
    target.damage_y = target.actual_y
  end 
  #--------------------------------------------------------------------------
  # * Set damage shake
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_shake(battler, target, action)
    ext = check_extension(action, "DMGSHAKE/")
    return if ext.nil?
    ext.slice!("DMGSHAKE/")
    target.shaking = ext.to_i
  end
  #--------------------------------------------------------------------------
  # * Set damage rise
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_rise(battler, target, action)
    ext = check_extension(action, "DMGRISE/")
    return if ext.nil?
    ext.slice!("DMGRISE/")
    target.rising = true
    target.bouncing = ext.to_i
    @spriteset.battler(target).bounce_init
  end
  #--------------------------------------------------------------------------
  # * Set damage freeze
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_freeze(battler, target, action)
    return unless check_include(action, "DMGFREEZE")
    target.freeze = true
  end
  #--------------------------------------------------------------------------
  # * Set damage wait
  #     battler : battler
  #     target  : target
  #     action  : action
  #--------------------------------------------------------------------------
  def set_dmgwait(battler, target, action)
    ext = check_extension(action, "DMGWAIT/")
    return if ext.nil?
    ext.slice!("DMGWAIT/")
    target.dmgwait = ext.to_i
  end
  #--------------------------------------------------------------------------
  # * Set steal action
  #     battler : battler
  #--------------------------------------------------------------------------
  def steal_action_result(battler)
    battler.steal_action = true
    now_action(battler)
    ext = check_extension(battler.now_action, "STEAL/")
    if battler.now_action.is_a?(RPG::Skill) and ext != nil
      for target in battler.target_battlers
        unless target.actor?
          stole_item = target.stole_item_set(battler,  ext)
          case stole_item
          when nil
            text = No_Item
          when false
            text = Steal_Fail
          when Numeric
            $game_party.gain_gold(stole_item)
            text = Steal_Gold.dup
            text.gsub!(/{gold}/i) {"#{stole_item}"}
            text.gsub!(/{unit}/i) {"#{$data_system.words.gold}"}          
          else
            case stole_item
            when RPG::Item
              $game_party.gain_item(stole_item.id, 1)
            when RPG::Weapon
              $game_party.gain_weapon(stole_item.id, 1)
            when RPG::Armor
              $game_party.gain_armor(stole_item.id, 1)
            end
            text = Steal_Item.dup
            text.gsub!(/{item}/i) {"#{stole_item.name}"}
          end
          pop_help(text, battler)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Clear random targets valoe
  #     battler : battler
  #--------------------------------------------------------------------------
  def reset_random(battler)
    if check_include(battler_action(battler), "RANDOM")
      battler.target_battlers.clear
      set_targets(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Clear tartget position values
  #     battler : battler
  #--------------------------------------------------------------------------
  def reset_target_position(battler)
    battler.wait_time = 16 if battler.lifted
    for target in battler.target_battlers + [battler]
      target.freeze = false
      target.rising = false
      target.rised = false
      target.lifted = false
      target.lifting = false
      target.heavy_fall = 0
      target.dmgwait = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Update movement return
  #     battler : battler
  #--------------------------------------------------------------------------
  def update_move_return_init(battler)
    if battler.exist? and not battler.guarding?
      battler.target_x = battler.base_x
      battler.target_y = battler.base_y
    end
    @spriteset.battler(battler).default_battler_direction unless @spriteset.battler(battler).nil?
    set_mirage(battler, "RETURN")
    battler.move_pose = true if battler.moving?
  end
  #--------------------------------------------------------------------------
  # * Set skills sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_sequence(battler)
    next_skill = battler.current_action.action_sequence.shift
    return if next_skill.nil?
    battler.current_action.skill_id = next_skill
    battler.current_action.kind = 1
    battler.current_skill = $data_skills[battler.current_action.skill_id]
    battler.current_action.action_sequence.unshift(action_sequences(battler, battler.current_skill))
    battler.current_action.action_sequence.flatten!
    battler.action_scope = battler.current_skill.scope
    battler.movement = check_include(battler.current_skill, "MOVETYPE/NOMOVE")
    battler.action_all = check_action_all(battler.current_skill)
    battler.current_action.hit_times = action_hits(battler)
    battler.current_action.combo_times = action_combo(battler)
    set_action_help(battler.current_skill, battler)
    @help_window.visible = false if check_include(battler.current_skill, "HELPDELETE")
  end
  #--------------------------------------------------------------------------
  # * Set custom battler move
  #     battler : battler
  #     pos_x   : movement position X
  #     pos_y   : movement position Y
  #--------------------------------------------------------------------------
  def battler_custom_move(battler, pos_x, pos_y)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    battler.target_x = pos_x
    battler.target_y = pos_y
    battler.move_pose = true
    battler_face_direction(battler)
  end
  #--------------------------------------------------------------------------
  # * Set custom battler base position
  #     battler : battler
  #     pos_x   : movement position X
  #     pos_y   : movement position Y
  #--------------------------------------------------------------------------
  def battler_custom_base_position(battler, pos_x, pos_y)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    battler.original_x = pos_x
    battler.original_y = pos_y
    #edited
  end
  #--------------------------------------------------------------------------
  # * Change battler pose, at end return to idle anim
  #     battler : battler
  #     pose    : pose ID
  #--------------------------------------------------------------------------
  def battler_custom_pose_once(battler, pose)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    @spriteset.battler(battler).action_battler_direction
    battler.pose_id = pose
    battler.pose_sequence = [pose , 1]
  end
  #--------------------------------------------------------------------------
  # * Change battler pose, at end do not return to idle anim
  #     battler : battler
  #     pose    : pose ID
  #--------------------------------------------------------------------------
  def battler_custom_pose_wait(battler, pose)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    @spriteset.battler(battler).action_battler_direction
    battler.pose_id = pose
    battler.pose_sequence = [pose , 0]
  end
  #--------------------------------------------------------------------------
  # * Battler pose sequence, at end return to idle anim
  #     battler : battler
  #     poses   : pose ID list
  #--------------------------------------------------------------------------
  def battler_pose_sequence_once(battler, poses)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    @spriteset.battler(battler).action_battler_direction
    battler.pose_id = poses.first
    battler.pose_sequence = poses + [1]
  end
  #--------------------------------------------------------------------------
  # * Battler pose sequence, at end do not return to idle anim
  #     battler : battler
  #     poses   : pose ID list
  #--------------------------------------------------------------------------
  def battler_pose_sequence_wait(battler, poses)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    @spriteset.battler(battler).action_battler_direction
    battler.pose_id = poses.first
    battler.pose_sequence = poses + [0]
  end
  #--------------------------------------------------------------------------
  # * Reset battler position
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_reset_position(battler)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    battler.target_x = battler.base_x
    battler.target_y = battler.base_y
    battler.move_pose = true
    battler_face_direction(battler)
  end
  #--------------------------------------------------------------------------
  # * Reset battler pose
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_reset_pose(battler)
    return if battler.nil?
    return if battler.actor? and not $game_party.actors.include?(battler)
    return if !battler.actor? and not $game_troop.enemies.include?(battler)
    @spriteset.battler(battler).action_battler_direction
    battler.pose_sequence.clear
  end  
end