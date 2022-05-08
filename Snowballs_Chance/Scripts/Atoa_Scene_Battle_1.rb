#==============================================================================
# ** Scene_Battle (part 1)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    start
    create_viewport
    perform_transition
    update_battle
    terminate
  end
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    @immortals = []
    @active_battlers = []
    @action_battlers = []
    @wait_all = 0
    @escape_ratio = Escape_Base_Rate
    @intro_battlercry_battler = nil
    @victory_battlercry_battler = nil
    @last_active_enemy = nil
    @last_active_actor = $game_party.actors[0]
    set_old_info
    setup_temp_info
    $game_system.battle_interpreter.setup(nil, 0)
    setup_enemy_troop
    set_immortals
  end
  #--------------------------------------------------------------------------
  # * Create Display Viewport
  #--------------------------------------------------------------------------
  def create_viewport 
    @spriteset = Spriteset_Battle.new
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.item
    s4 = $data_system.words.guard
    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])  
    @actor_command_window.y = 160
    @actor_command_window.back_opacity = 160
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @party_command_window = Window_PartyCommand.new
    @help_window = Window_Help.new
    @help_window.back_opacity = 160
    @help_window.visible = false
    @active_battler_window = Window_NameCommand.new(@active_battler, 240, 64)
    @active_battler_window.visible = false
    @status_window = Window_BattleStatus.new
    @status_window.visible = $game_temp.hide_windows ? false : true
    @message_window = Window_Message.new
    @wait_count = 0
  end
  #--------------------------------------------------------------------------
  # * Execute Transition
  #--------------------------------------------------------------------------
  def perform_transition
    @action_plane = Plane.new(@spriteset.viewport2)
    @action_plane_settings = []
    @action_plane_delete = false
    for battler in $game_troop.enemies + $game_party.actors
      @spriteset.battler(battler).default_battler_direction
    end
    @spriteset.update
    set_intro_battlecry
    show_transition
    wait(15) unless Show_Graphics_Transition
    set_intro
    start_phase1
  end
  #--------------------------------------------------------------------------
  # * Main Update
  #--------------------------------------------------------------------------
  def update_battle
    loop do
      update
      break if $scene != self
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @misc_updates = false
    update_interpreter
    update_graphics
    update_transitions
    misc_updates
    update_phases unless @misc_updates
    update_battlers_phase unless @wait_all > 0
    update_slip_phase
    @wait_all = [@wait_all - 1, 0].max
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    for battler in $game_party.actors 
      battler.state_animation_id = 0
    end
    Graphics.freeze
    $game_map.refresh
    @actor_command_window.dispose if @actor_command_window != nil
    @party_command_window.dispose if @party_command_window != nil
    @help_window.dispose if @help_window != nil
    @status_window.dispose if @status_window != nil
    @message_window.dispose if @message_window != nil
    @active_battler_window.dispose if @active_battler_window != nil
    @skill_window.dispose if @skill_window != nil
    @item_window.dispose if @item_window != nil
    @result_window.dispose if @result_window != nil
    @spriteset.dispose if @spriteset != nil
    @action_plane.dispose if @action_image != nil
    Graphics.transition if $scene.is_a?(Scene_Title)
    Graphics.freeze if $scene.is_a?(Scene_Title)
    $scene = nil if $BTEST and not $scene.is_a?(Scene_Gameover)
  end
  #--------------------------------------------------------------------------
  # * Set temporaty info
  #--------------------------------------------------------------------------
  def setup_temp_info
    $game_temp.in_battle = true
    $game_temp.battle_start = true
    $game_temp.battle_end = false
    $game_temp.battle_victory = false
    $game_temp.battle_escape = false
    $game_temp.battle_abort = false
    $game_temp.battle_main_phase = false
    $game_temp.party_escaped = false
    $game_temp.battle_turn = 0
    $game_temp.battle_event_flags.clear
    $game_temp.battleback_name = $game_map.battleback_name
    $game_temp.forcing_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Set enemy troop
  #--------------------------------------------------------------------------
  def setup_enemy_troop
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
  end
  #--------------------------------------------------------------------------
  # * Set immortal enemies
  #--------------------------------------------------------------------------
  def set_immortals
    @true_immortals = []
    for enemy in $game_troop.enemies
      @true_immortals << enemy if enemy.immortal
    end
    for battler in $game_party.actors + $game_troop.enemies
      battler.immortal = false
    end
  end
  #--------------------------------------------------------------------------
  # * Set intro battlecry
  #--------------------------------------------------------------------------
  def set_intro_battlecry
    battle_cry_set_actor = []
    battle_cry_set_enemy = []
    for battler in $game_party.actors
      next unless check_bc_basic(battler, "INTRO") and not battler.dead? 
      battle_cry_set_actor << battler
    end
    for battler in $game_troop.enemies
      next unless check_bc_basic(battler, "INTRO") and not battler.dead? 
      battle_cry_set_enemy << battler
    end
    unless battle_cry_set_actor.empty? or $game_temp.no_actor_intro_bc
      @intro_battlercry_battler = battle_cry_set_actor[rand(battle_cry_set_actor.size)]
    end
    unless battle_cry_set_enemy.empty? or $game_temp.no_enemy_intro_bc or @intro_battlercry_battler.nil?
      @intro_battlercry_battler = battle_cry_set_enemy[rand(battle_cry_set_enemy.size)]
    end
  end
  #--------------------------------------------------------------------------
  # * Show transition
  #--------------------------------------------------------------------------
  def show_transition
    if $data_system.battle_transition == ""
      Graphics.transition(Transition_Speed)
    else
      Graphics.transition(Transition_Speed, "Graphics/Transitions/" + $data_system.battle_transition)
    end
  end
  #--------------------------------------------------------------------------  
  # * Set intro animation
  #--------------------------------------------------------------------------  
  def set_intro
    if $game_temp.skip_intro
      $game_temp.battle_start = false
    else
      intro_anime
    end
    $game_temp.skip_intro = false
  end
  #--------------------------------------------------------------------------
  # * Update battle interpreter
  #--------------------------------------------------------------------------
  def update_interpreter
    if $game_system.battle_interpreter.running?
      $game_system.battle_interpreter.update
      if $game_temp.forcing_battler == nil
        unless $game_system.battle_interpreter.running?
          setup_battle_event unless judge
        end
        if @phase != 5 and status_need_refresh and not $game_temp.message_window_showing
          @status_window.refresh
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  def update_graphics
    @active_battler_window.visible = (Battle_Name_Window and @actor_command_window.visible)
    @active_battler_window.opacity = @actor_command_window.opacity
    status_window_update
    update_basic
    $game_temp.battle_abort = true if $game_system.timer_working and $game_system.timer == 0
    @help_window.update
    @party_command_window.update
    @actor_command_window.update
    update_action_plane
    update_immortals
  end
  #--------------------------------------------------------------------------
  # * Update Transition
  #--------------------------------------------------------------------------
  def update_transitions
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" + $game_temp.transition_name)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Misc Updates
  #--------------------------------------------------------------------------
  def misc_updates
    @misc_updates = true
    return if $game_temp.message_window_showing
    return update_gameover if $game_temp.gameover
    return $scene = Scene_Title.new if $game_temp.to_title
    if $game_temp.battle_abort
      battle_end(3)
      play_map_bmg
      return
    end
    return @wait_count -= 1 if @wait_count > 0
    return if $game_temp.forcing_battler == nil and $game_system.battle_interpreter.running?
    @misc_updates = false
  end
  #--------------------------------------------------------------------------
  # * Battlers phase update
  #--------------------------------------------------------------------------
  def update_battlers_phase
    for battler in $game_troop.enemies + $game_party.actors
      next if battler.exist? or battler.restriction < 4
      @active_battlers.delete(battler)
      @action_battlers.delete(battler)
    end
    for battler in @action_battlers
      @action_battlers.delete(battler) if battler.actor? and not $game_party.actors.include?(battler)
      @action_battlers.delete(battler) if not battler.actor? and not $game_troop.enemies.include?(battler)
    end
    for battler in @active_battlers
      update_current_phase(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Slip damage phase update
  #--------------------------------------------------------------------------
  def update_slip_phase
    slip_battlers = []
    for battler in $game_troop.enemies + $game_party.actors
      slip_battlers << battler if battler.slip_phase > 0
    end
    slip_damage_pop(slip_battlers)
  end  
  #--------------------------------------------------------------------------
  # * Apply splip damage effect
  #     battlers : targets
  #--------------------------------------------------------------------------
  def slip_damage_pop(battlers)
    return if battlers.empty?
    slip_1 = Slip_Pop_State["Slip_1"].nil? ? nil : Slip_Pop_State["Slip_1"]
    slip_2 = Slip_Pop_State["Slip_2"].nil? ? nil : Slip_Pop_State["Slip_2"]
    for battler in battlers
      next unless battler.exist?
      case battler.slip_phase
      when 4
        slip_damage_calc(battler, slip_1, "hp")
      when 3
        slip_damage_calc(battler, slip_1, "sp")
      when 2
        slip_damage_calc(battler, slip_2, "hp")
      when 1
        slip_damage_calc(battler, slip_2, "sp")
      end
      battler.slip_phase -= 1
    end
    @status_window.refresh if status_need_refresh
    update_graphics
    @damage_pop_show = false
    for battler in battlers
      battler.damage = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Set slip damage value
  #   battler : battler
  #   slip    : damage parameter
  #   type    : damage type (hp pr sp)
  #--------------------------------------------------------------------------
  def slip_damage_calc(battler, slip, type)
    damage = 0
    damage_pop = false
    damage_mirror(battler)
    for id in battler.states
      if slip != nil and slip[id] != nil and slip[id][0] == type
        value = type == "hp" ? battler.maxhp : battler.maxsp
        base_damage = slip[id][1] + value * slip[id][2] / 100
        damage += base_damage + (base_damage * (rand(5) - rand(5)) / 100)
        if damage >= battler.hp and slip[id][4] == false and type == "hp"
          damage = battler.hp - 1
        end
        battler.sp_damage = type == "hp" ? false : true
        damage_pop |= slip[id][3]
      end
    end
    battler.hp -= damage if type == "hp"
    battler.sp -= damage if type == "sp"
    battler.damage = damage
    battler.damage_pop = damage_pop
    @damage_pop_show = damage_pop
  end
  #--------------------------------------------------------------------------
  # * Basic Update Processing
  #--------------------------------------------------------------------------
  def update_basic
    super
  end
  #--------------------------------------------------------------------------
  # * Wait time
  #     duration : wait duration in frames
  #--------------------------------------------------------------------------
  def wait(duration)
    super(duration)
  end
  #--------------------------------------------------------------------------
  # * Status window update 
  # to do: make only the active actor's one visible
  # (need to figure out how to check active actor, currently it effects all)
  #--------------------------------------------------------------------------
  def status_window_update
    @status_window.visible = true
    if Status_Window_Hide
      @status_window.visible = false if @skill_window != nil and @skill_window.visible
      @status_window.visible = false if @item_window != nil and @item_window.visible
    end
    @status_window.visible = false if $game_temp.hide_windows
    @status_window.visible = false if $game_temp.status_hide
    @status_window.update
  end
  #--------------------------------------------------------------------------
  # * Process intro animation
  #--------------------------------------------------------------------------
  def intro_anime
    battle_cry_basic(@intro_battlercry_battler, "INTRO") if @intro_battlercry_battler != nil
    wait(Intro_Time)
    $game_temp.battle_start = false
  end
  #--------------------------------------------------------------------------
  # * Action plane update
  #--------------------------------------------------------------------------
  def update_action_plane
    if not @action_plane_settings.empty? and not @action_plane_delete
      @action_plane.opacity = [@action_plane.opacity + 10, @action_plane_settings[0]].min
      @action_plane.ox += @action_plane_settings[1]
      @action_plane.oy += @action_plane_settings[2]
    elsif not @action_plane_settings.empty? and @action_plane_delete
      @action_plane.opacity = [@action_plane.opacity - 10, 0].max
      @action_plane.ox += @action_plane_settings[1]
      @action_plane.oy += @action_plane_settings[2]
      if @action_plane.opacity == 0
        @action_plane_settings.clear
        @action_plane_delete = false
        @action_plane.bitmap.dispose
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Show help window
  #     text    : window text
  #     battler : battler that called the hekp window
  #     time    : exhibition duration
  #     align   : alignment
  #--------------------------------------------------------------------------
  def pop_help(text, battler = nil, time = 25, align = 1)
    @help_window.visible = false
    @help_window.set_text(text, align, battler)
    @wait_all = time + battle_speed * 2
  end
  #--------------------------------------------------------------------------
  # * Show help window with pause
  #     text    : window text
  #     battler : battler that called the hekp window
  #     time    : exhibition duration
  #     align   : alignment
  #--------------------------------------------------------------------------
  def pop_wait_help(text, battler = nil, time = 40, align = 1)
    @help_window.visible = false
    @help_window.set_text(text, align, battler)
    wait(40)
    @help_window.visible = false
    wait(2)
  end
  #--------------------------------------------------------------------------
  # * Check if status window needs refresh
  #--------------------------------------------------------------------------
  def status_need_refresh
    result = false
    for actor in $game_party.actors
      result |= actor.hp != actor.old_hp 
      result |= actor.sp != actor.old_sp
      result |= actor.maxhp != actor.old_maxhp
      result |= actor.maxhp != actor.old_maxhp
      result |= actor.level != actor.old_level
      result |= actor.name != actor.old_name
      result |= actor.states != actor.old_states
      break if result
    end
    set_old_info
    return result
  end
  #--------------------------------------------------------------------------
  # * Set old stats value
  #--------------------------------------------------------------------------
  def set_old_info
    for actor in $game_party.actors
      actor.old_hp = actor.hp
      actor.old_sp = actor.sp
      actor.old_maxhp = actor.maxhp
      actor.old_maxsp = actor.maxsp
      actor.old_level = actor.level
      actor.old_name = actor.name.dup
      actor.old_states = actor.states.dup
    end
  end
  #--------------------------------------------------------------------------
  # * Update Game Over
  #--------------------------------------------------------------------------
  def update_gameover
    set_enemy_victory_pose
    $scene = Scene_Gameover.new
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:escape 2:lose 3:abort)
  #--------------------------------------------------------------------------
  alias acbs_battle_end_scenebattle battle_end
  def battle_end(result)
    if result == 1
      set_escape_anim
    elsif result == 2
      set_enemy_victory_pose
    end
    acbs_battle_end_scenebattle(result)
    Audio.me_stop
  end
  #--------------------------------------------------------------------------
  # * Set enemy victory poser
  #--------------------------------------------------------------------------
  def set_enemy_victory_pose
    wait(20)
    for battler in $game_troop.enemies
      if ext = check_include(battler, "VICTORYPOSE") and battler.exist?
        pose = set_pose_id(battler, "Victory") 
        next if pose.nil?
        battler.idle_pose = false
        battler.pose_id = pose
      end
    end
    set_enemy_victory_battlecry
    battle_cry_basic(@victory_battlercry_enemy, "VICTORY") if @victory_battlercry_enemy != nil
    wait(Victory_Time)
  end
  #--------------------------------------------------------------------------
  # * Set Victory battlecry for enemies
  #--------------------------------------------------------------------------
  def set_enemy_victory_battlecry
    @victory_battlercry_enemy = nil
    battle_cry_set = []
    for battler in $game_troop.enemies
      if check_bc_basic(battler, "VICTORY") and not battler.dead?
        battle_cry_set << battler
      end
    end
    unless battle_cry_set.empty? or $game_temp.no_enemy_victory_bc
      @victory_battlercry_enemy = rand(battle_cry_set.size)
    end 
    if @last_active_enemy != nil and not @last_active_enemy.dead? and not
       $game_temp.no_enemy_victory_bc and battle_cry_set.include?(@last_active_enemy)
      @victory_battlercry_enemy = @last_active_enemy
    end
  end
  #--------------------------------------------------------------------------
  # * Set escape animation
  #--------------------------------------------------------------------------
  def set_escape_anim
    @help_window.visible = false
    @party_command_window.visible = false
    battle_cry_set = []
    $game_temp.party_escaped = true
    for battler in $game_party.actors
      battle_cry_set << battler if check_bc_basic(battler, "ESCAPE") and not battler.dead?
      if Escape_Move and not (battler.dead? or battler.restriction == 4)
        dir = battler.direction
        battler.target_x = battler.actual_x + (dir == 4 ? 300 : dir == 6 ? -300 : 0)
        battler.target_y = battler.actual_y + (dir == 2 ? 300 : dir == 8 ? -300 : 0)
        battler.set_pose(Escape_Pose)
      end
    end
    unless battle_cry_set.empty?
      battle_cry_basic(battle_cry_set[rand(battle_cry_set.size)], "ESCAPE")
    end
    wait(30)
  end
  #--------------------------------------------------------------------------
  # * Change to map music
  #--------------------------------------------------------------------------
  def play_map_bmg
    $game_system.bgm_play($game_temp.map_bgm)
  end
  #--------------------------------------------------------------------------
  # * Update immortal battlers
  #--------------------------------------------------------------------------
  def update_immortals
    for target in $game_troop.enemies + $game_party.actors
      if @true_immortals.include?(target) or (is_active_target(target) and not
         target.states.include?(1))
        target.immortal = true
      else
        target.immortal = false
        target.add_state(1) if target.hp0?
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phases
  #--------------------------------------------------------------------------
  def update_phases
    case @phase
    when 1
      update_phase1
    when 2
      update_phase2
    when 3
      update_phase3
    when 4
      update_phase4
    when 5
      update_phase5
    end
  end
end