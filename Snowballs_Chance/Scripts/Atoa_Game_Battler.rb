#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :now_action            # battler current action
  attr_accessor :pose_id               # pose ID
  attr_accessor :direction             # battler direction
  attr_accessor :state_animation_id    # current state animation ID
  attr_accessor :base_x                # battler base X position
  attr_accessor :base_y                # battler base Y position
  attr_accessor :original_x            # battler original X position
  attr_accessor :original_y            # battler original Y position
  attr_accessor :actual_x              # battler real X position
  attr_accessor :actual_y              # battler real Y position
  attr_accessor :target_x              # battler target X position
  attr_accessor :target_y              # battler target Y position
  attr_accessor :initial_x             # battler initial X position
  attr_accessor :initial_y             # battler initial Y position
  attr_accessor :hit_x                 # battler real damage X position
  attr_accessor :hit_y                 # battler real damage Y position
  attr_accessor :damage_x              # battler target damage X position
  attr_accessor :damage_y              # battler target damage Y position
  attr_accessor :wait_time             # battler wait time
  attr_accessor :pose_wait             # pose wait time
  attr_accessor :move_speed            # battler movement speed
  attr_accessor :jump_speed            # battler jump speed
  attr_accessor :jumping               # battler jumping
  attr_accessor :action_scope          # battler action scope
  attr_accessor :animation_1           # battler animation 1
  attr_accessor :animation_2           # battler animation 2
  attr_accessor :animation_pos         # battler animation position
  attr_accessor :animation_mirror      # invert animation
  attr_accessor :slip_phase            # slip damage phase
  attr_accessor :damage_count          # damage pop duration
  attr_accessor :old_scope             # old scope value
  attr_accessor :dmgwait               # damage pop wait time
  attr_accessor :heavy_fall            # battler heavy fall effect
  attr_accessor :shaking               # battler shake effect
  attr_accessor :bouncing              # battler launch effect
  attr_accessor :current_phase         # battler current phase
  attr_accessor :current_skill         # selected skill
  attr_accessor :current_item          # selected item
  attr_accessor :mirage_color          # mirage effect color
  attr_accessor :old_name              # memorized battler name
  attr_accessor :old_maxhp             # memorized battler max hp
  attr_accessor :old_maxsp             # memorized battler max sp
  attr_accessor :old_hp                # memorized battler current hp
  attr_accessor :old_sp                # memorized battler current sp
  attr_accessor :old_level             # memorized battler level
  attr_accessor :old_states            # memorized battler states
  attr_accessor :battler_one_target    # Battler single target
  attr_accessor :sp_damage             # sp damage flag
  attr_accessor :invisible             # invisible flag
  attr_accessor :idle_pose             # idle pose flag
  attr_accessor :move_pose             # movement pose flag
  attr_accessor :damaged               # damage pose flag
  attr_accessor :evaded                # wait pose flag
  attr_accessor :defense_pose          # defense pose flag
  attr_accessor :mirage                # mirage effect flag
  attr_accessor :freeze                # freeze battler flag
  attr_accessor :lifting               # lifiting battler flag (target)
  attr_accessor :lifted                # lifited battler flag (target)
  attr_accessor :rising                # lifiting battler flag (user)
  attr_accessor :rised                 # lifited battler flag (user)
  attr_accessor :smashing              # launch impact flag
  attr_accessor :invisible_action      # invisible action flag
  attr_accessor :critical_hit          # critical hit flag
  attr_accessor :action_done           # action done flag
  attr_accessor :steal_action          # steal action flag
  attr_accessor :multi_action_running  # multiple action running flag
  attr_accessor :hit_animation         # hit animation flag
  attr_accessor :pose_animation        # pose animation flag
  attr_accessor :movement              # movement flag
  attr_accessor :step_foward           # step foward flag
  attr_accessor :action_all            # all target action flag
  attr_accessor :action_center         # movement center flag
  attr_accessor :teleport_to_target    # teleport to target flag
  attr_accessor :attack_lock           # enemy attack lock list
  attr_accessor :current_states        # current states list
  attr_accessor :state_to_add          # states to add list
  attr_accessor :state_to_remove       # states to remove list
  attr_accessor :target_battlers       # battler targets list
  attr_accessor :random_targets        # random targets list
  attr_accessor :weapons               # battler weapons lists
  attr_accessor :pose_sequence         # pose sequence list
  attr_accessor :action_target         # action targets list
  attr_accessor :target_damage         # damage dealt list
  attr_accessor :pose_delay            # pose delay list
  attr_accessor :pop_delay             # damage pop delay list
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_gamebattler initialize
  def initialize
    acbs_initialize_gamebattler
    @pose_id = 0
    @direction = 0
    @state_animation_id = 0
    @wait_time = 0
    @pose_wait = 0
    @move_speed = 0
    @jump_speed = 0
    @jumping = 0
    @shaking = 0
    @bouncing = 0
    @dmgwait = 0
    @heavy_fall = 0
    @action_scope = 0
    @animation_1 = 0
    @animation_2 = 0
    @slip_phase = 0
    @damage_count = 0
    @old_scope = 0
    @sp_damage = false
    @invisible = false
    @idle_pose = false
    @move_pose = false
    @mirage = false
    @freeze = false
    @lifting = false
    @lifted = false
    @rising = false
    @rised = false
    @smashing = false
    @critical_hit = false
    @action_done = false
    @steal_action = false
    @sp_damage = false
    @multi_action_running = false
    @hit_animation = false
    @pose_animation = false
    @movement = false
    @invisible_action = false
    @animation_mirror = false
    @current_states = []
    @state_to_add = []
    @state_to_remove = []
    @target_battlers = []
    @weapons = []
    @pose_sequence = []
    @action_target = []
    @random_targets = []
    @attack_lock = []
    @target_damage = {}
    @pose_delay = {}
    @pop_delay = {}
  end
  #--------------------------------------------------------------------------
  # * Set battler pose
  #     pose : pose ID
  #--------------------------------------------------------------------------
  def set_pose(pose)
    @idle_pose = false
    @move_pose = false
    @pose_id = pose
  end
  #--------------------------------------------------------------------------
  # * Check battler movement
  #--------------------------------------------------------------------------
  def moving?
    return (@target_x != @actual_x or @target_y != @actual_y)
  end
  #--------------------------------------------------------------------------
  # * Check if action is an attack
  #--------------------------------------------------------------------------
  def attack?
    return (@current_action.kind == 0 and @current_action.basic == 0)
  end
  #--------------------------------------------------------------------------
  # * Check if action is an skill
  #--------------------------------------------------------------------------
  def skill_use?
    return @current_action.kind == 1
  end
  #--------------------------------------------------------------------------
  # * Check if action is an item
  #--------------------------------------------------------------------------
  def item_use?
    return @current_action.kind == 2
  end
  #--------------------------------------------------------------------------
  # * Check if action will be skiped
  #--------------------------------------------------------------------------
  def skip?
    return (@current_action.kind == 0 and @current_action.basic > 0)
  end
  #--------------------------------------------------------------------------
  # * Check if object is an weapon
  #--------------------------------------------------------------------------
  def weapon?
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if object is an skill
  #--------------------------------------------------------------------------
  def skill?
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if object is an item
  #--------------------------------------------------------------------------
  def item?
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if object is an armor
  #--------------------------------------------------------------------------
  def armor?
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if object is an battler
  #--------------------------------------------------------------------------
  def battler?
    return true
  end
  #--------------------------------------------------------------------------
  # * Magic verification flag
  #--------------------------------------------------------------------------
  def magic?
    return false
  end
  #--------------------------------------------------------------------------
  # * Object scope
  #--------------------------------------------------------------------------
  def scope
    return 1
  end
  #--------------------------------------------------------------------------
  # * Check if battler is active
  #--------------------------------------------------------------------------
  def active?
    phases = ['Phase 2-1', 'Phase 3-1', 'Phase 3-2', 'Phase 3-3', 'Phase 4-1']
    return (phases.include?(@current_phase) and not self.dead?)
  end
  #--------------------------------------------------------------------------
  # * Check if battler is on action phase
  #--------------------------------------------------------------------------
  def action?
    phases = ['Phase 4-1', 'Phase 4-2', 'Phase 4-3', 'Phase 4-4', 'Phase 5-1']
    return (phases.include?(@current_phase) and not self.dead?)
  end
  #--------------------------------------------------------------------------
  # * Check if action is on return phase
  #--------------------------------------------------------------------------
  def returning?
    phases = ['Phase 5-1', 'Phase 5-2', 'Phase 5-3', 'Phase 5-4']
    return phases.include?(@current_phase)
  end
  #--------------------------------------------------------------------------
  # * Decide Danger
  #--------------------------------------------------------------------------
  def in_danger?
    return @hp <= ((self.maxhp * Danger_Value)/ 100)
  end
  #--------------------------------------------------------------------------
  # * Decide escaping
  #--------------------------------------------------------------------------
  def escaping?
    return false
  end
  #--------------------------------------------------------------------------
  # * Decide Incapacitation
  #--------------------------------------------------------------------------
  def dead?
    return (@hp <= 0 and not @immortal)
  end
  #--------------------------------------------------------------------------
  # * Decide HP 0
  #--------------------------------------------------------------------------
  def hp0?
    return (not @hidden and @hp <= 0)
  end
  #--------------------------------------------------------------------------
  # * Decide Confusion
  #--------------------------------------------------------------------------
  def confused?
    return (self.restriction == 2 or self.restriction == 3)
  end
  #--------------------------------------------------------------------------
  # * Decide Silence
  #    skill_id : skill ID
  #--------------------------------------------------------------------------
  def silenced?(skill_id)
    return ($data_skills[skill_id].atk_f == 0 and self.restriction == 1)
  end
  #--------------------------------------------------------------------------
  # * Set new base X position
  #     n : new value
  #--------------------------------------------------------------------------
  def base_x=(n)
    @base_x = [[n, 16].max, (Battle_Screen_Dimension[0] - 16)].min
  end
  #--------------------------------------------------------------------------
  # * Set new base Y position
  #     n : new value
  #--------------------------------------------------------------------------
  def base_y=(n)
    @base_y = [[n, 16].max, (Battle_Screen_Dimension[1] - 16)].min
  end
  #--------------------------------------------------------------------------
  # * Set new original X position
  #     n : new value
  #--------------------------------------------------------------------------
  def original_x=(n)
    @original_x = [[n, 16].max, (Battle_Screen_Dimension[0] - 16)].min
  end
  #--------------------------------------------------------------------------
  # * Set new original Y position
  #     n : new value
  #--------------------------------------------------------------------------
  def original_y=(n)
    @original_y = [[n, 16].max, (Battle_Screen_Dimension[1] - 16)].min
  end
  #--------------------------------------------------------------------------
  # * Return to original position
  #--------------------------------------------------------------------------
  def retunt_to_original_position
    @original_x = self.screen_x
    @original_y = self.screen_y
  end
  #--------------------------------------------------------------------------
  # * Update state animation
  #--------------------------------------------------------------------------
  def state_animation_update
    return 0 if @states.empty?
    for state in @states
      @current_states << state unless @current_states.include?(state)
    end
    for state in @current_states
      if $data_states[state].animation_id == 0 or not @states.include?(state)
        @current_states.delete(state)
      end
    end
    return 0 if @current_states.empty?
    current_state = @current_states.shift
    @current_states << current_state
    return $data_states[current_state].animation_id
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  def crt
    return Base_Critical_Rate
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  def dmg
    return Base_Critical_Damage
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  def rcrt
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  def rdmg
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get weapon attack
  #--------------------------------------------------------------------------
  def weapon_attack
    return self.atk
  end
  #--------------------------------------------------------------------------
  # * Get battler strengh
  #--------------------------------------------------------------------------
  def battler_strength
    return self.str
  end
  #--------------------------------------------------------------------------
  # * Get weapon crital rate
  #--------------------------------------------------------------------------
  def weapon_critical
    return self.crt
  end
  #--------------------------------------------------------------------------
  # * Get weapon crital damage
  #--------------------------------------------------------------------------
  def weapon_critical_damage
    return self.dmg
  end
  #--------------------------------------------------------------------------
  # * Get battler defense
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_defense(battler)
    return self.pdef
  end
  #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #     attacker : battler
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    self.sp_damage = false
    hit_result = set_attack_hit_result(attacker)
    if hit_result
      set_sp_damage(attacker, attacker.actor? ? attacker.weapons[0] : nil)
      set_attack_damage_value(attacker)
      if attacker.target_damage[self] > 0
        attacker.target_damage[self] /= 2 if self.guarding?
        set_critical_damage(attacker, attacker.weapon_critical_damage) if self.critical
        apply_variance(attacker.weapon_variance, attacker)
      end
      set_attack_state_change(attacker)
    else
      attacker.target_damage[self] = Miss_Message
      self.critical = false
    end
    set_attack_damage(attacker)
    return true
  end
  #--------------------------------------------------------------------------
  # * Set final attack damage
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_damage(attacker)
    set_damage(attacker, attacker.actor? ? attacker.weapons[0] : nil)
  end
  #--------------------------------------------------------------------------
  # * Set attack success
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_hit_result(attacker)
    return ((rand(100) < attacker.hit) and set_attack_hit_value(attacker))
  end
  #--------------------------------------------------------------------------
  # * Set attack damage
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_damage_value(attacker)
    atk_pow = set_attack_power(attacker)
    str_pow = set_strenght_power(attacker)
    attacker.target_damage[self] = [atk_pow * str_pow / 20, 0].max
    attacker.target_damage[self] *= elements_correct(attacker.element_set)
    attacker.target_damage[self] /= 100
  end
  #--------------------------------------------------------------------------
  # * Set attack power
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_power(attacker)
    case Damage_Algorithm_Type
    when 0
      atk_pow = attacker.weapon_attack - (battler_defense(attacker) / 2)
    when 1
      atk_pow = attacker.weapon_attack - ((attacker.weapon_attack * battler_defense(attacker)) / 1000)
    when 2, 4
      atk_pow = 20
    when 3
      atk_pow = (10 + attacker.weapon_attack) - (battler_defense(attacker) / 2)
    end
    return atk_pow
  end
  #--------------------------------------------------------------------------
  # * Set strenght power
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_strenght_power(attacker)
    case Damage_Algorithm_Type
    when 0, 1
      str_pow = 20 + attacker.battler_strength
    when 2
      str_pow = [(attacker.battler_strength * 4) - (self.dex * 2) , 0].max
    when 3
      str_pow = [(20 + attacker.battler_strength) - (self.dex / 2) , 0].max
    when 4
      value = Custom_Attack_Algorithm.dup
      value.gsub!(/{atk}/i) {"attacker.weapon_attack"}
      value.gsub!(/{str}/i) {"attacker.battler_strength"}
      value.gsub!(/{def}/i) {"battler_defense(attacker)"}
      str_pow = eval(value)
    end
    return str_pow
  end
  #--------------------------------------------------------------------------
  # * Set attack hit value
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_hit_value(attacker)
    atk_hit = Damage_Algorithm_Type > 1 ? attacker.agi : attacker.dex
    eva = 8 * self.agi / atk_hit + self.eva
    hit = (self.cant_evade? or self.hp <= 0) ? 100 : 100 - eva
    return (rand(100) < hit)
  end
  #--------------------------------------------------------------------------
  # * Set attack critical hit
  #     target : target
  #     rate   : rate
  #--------------------------------------------------------------------------
  def set_attack_critical(target, rate)
    atk_crt = Damage_Algorithm_Type > 1 ? self.agi : self.dex
    res_crt = rate - target.rcrt
    critical = self.critical_hit = rand(100) < [res_crt, 0].max * atk_crt / target.agi
    target.critical = critical
    self.critical_hit |= critical
    return self.critical_hit
  end
  #--------------------------------------------------------------------------
  # * Set critical damage
  #     attacker : battler
  #     rate     : rate
  #--------------------------------------------------------------------------
  def set_critical_damage(attacker, rate)
    dmg_crt = rate - self.rdmg
    attacker.target_damage[self] += (attacker.target_damage[self] * [dmg_crt, 1].max) / 100
  end
  #--------------------------------------------------------------------------
  # * Attack state change
  #     attacker : battler
  #--------------------------------------------------------------------------
  def set_attack_state_change(attacker)
    remove_states_shock
    @state_changed = false
    states_plus(attacker.plus_state_set)
    states_minus(attacker.minus_state_set)
  end
  #--------------------------------------------------------------------------
  # * Get weapon variance
  #     attacker : battler
  #--------------------------------------------------------------------------
  def weapon_variance
    weapons = self.actor? ? self.weapons[0] : nil
    ext = check_extension(weapons, 'DMGVARIANCE/')
    return ext.nil? ? Base_Variance : ext.to_i
  end
  #--------------------------------------------------------------------------
  # * Apply damage variance
  #     variance : variance
  #     user     : user
  #--------------------------------------------------------------------------
  def apply_variance(variance, user)
    amp = [user.target_damage[self].abs * variance / 100, 1].max
    user.target_damage[self] += rand(amp + 1) + rand(amp + 1) - amp
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_damage(user, action = nil)
    user.target_damage[self] = '' if check_include(action, "NODAMAGE")
  end
  #--------------------------------------------------------------------------
  # * Set SP damage
  #     battler : battler
  #     action  : action
  #--------------------------------------------------------------------------
  def set_sp_damage(battler, action)
    self.sp_damage = check_include(action, 'SPDAMAGE')
  end
  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    self.sp_damage = false
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= skill.common_event_id > 0
    hit_result = set_skill_hit_result(user, skill)
    if hit_result
      effective |= set_skill_result(user, skill, effective)
    else
      user.target_damage[self] = Miss_Message
      self.critical = false
    end
    set_damage(user, skill) if $game_temp.in_battle
    user.target_damage[self] = nil unless $game_temp.in_battle
    return effective
  end
  #--------------------------------------------------------------------------
  # * Set skill result
  #     user      : user
  #     skill     : skill
  #     effective : effective skill
  #--------------------------------------------------------------------------
  def set_skill_result(user, skill, effective)
    set_sp_damage(user, skill)
    set_skill_damage_value(user, skill)
    if user.target_damage[self].abs > 0
      user.target_damage[self] /= 2 if self.guarding?
      if self.critical
        if check_include(skill, 'CRITICALDAMAGE')
          ext = check_extension(skill, 'CRITICALDAMAGE/')
          rate = ext.nil? ? Base_Critical_Damage : Base_Critical_Damage + ext.to_i
        elsif check_include(skill, 'CRITICALWEAPONDAMAGE')
          ext = checkextension(skill, 'CRITICALWEAPONDAMAGE/')
          rate = user.weapon_critical_damage
          rate +=  ext.to_i unless ext.nil?
        end
        set_critical_damage(user, rate) 
      end
      apply_variance(skill.variance, user) 
      apply_variance(user.weapon_variance, user) if check_include(skill, 'WEAPONVARIANCE')
    end
    effective |= set_skill_state_change(user, skill, effective)
    if effective and not $game_temp.in_battle
      set_damage(user, skill)
      apply_damage(user.target_damage[self], self.sp_damage)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Set skill success
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_hit_result(user, skill)
    return (set_skill_hit(user, skill) and set_skill_hit_value(user, skill))
  end
  #--------------------------------------------------------------------------
  # * Set skill hit
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_hit(user, skill)
    skill_hit = skill.magic? ? skill.hit : (skill.hit * user.hit / 100.0)
    return (rand(100) < skill_hit)
  end
  #--------------------------------------------------------------------------
  # * Set skill hit value
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_hit_value(user, skill)
    return true unless $game_temp.in_battle
    atk_hit = Damage_Algorithm_Type > 1 ? user.agi : user.dex
    eva = 8 * self.agi / atk_hit + self.eva
    hit = (self.cant_evade? or self.hp <= 0) ? 100 : (100 - (eva * skill.eva_f / 100.0)) 
    return (rand(100) < hit)
  end
  #--------------------------------------------------------------------------
  # * Set skill damage
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_damage_value(user, skill)
    power = set_skill_power(user, skill)
    rate = set_skill_rate(user, skill)
    rate = [rate, 0].max
    user.target_damage[self] = power * rate / 20.0
    user.target_damage[self] *= elements_correct(skill.element_set)
    user.target_damage[self] /= 100
    user.target_damage[self] = user.target_damage[self].to_i
  end
  #--------------------------------------------------------------------------
  # * Set skill power
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_power(user, skill)
    case Damage_Algorithm_Type
    when 0,3
      power = skill.power + ((user.weapon_attack * skill.atk_f) / 100.0)
      if skill.power > 0
        power -= ((battler_defense(user) * skill.pdef_f) / 200.0)
        power -= ((self.mdef * skill.mdef_f) / 200.0)
      end
    when 1
      power = skill.power + ((user.weapon_attack * skill.atk_f) / 100.0)
      power -= (power * (battler_defense(user) * skill.pdef_f)) / 100000.0
      power -= (power * (self.mdef * skill.mdef_f)) / 100000.0
    when 2
      user_str = (user.str * 4 * skill.str_f / 100.0)
      user_int = (user.int * 2 * skill.int_f / 100.0)
      if skill.power > 0
        power = skill.power + user_str + user_int
      else
        power = skill.power - user_str - user_int
      end
      power -= ((self.dex * 2 * skill.pdef_f) / 100.0)
      power -= ((self.int * 1 * skill.mdef_f) / 100.0)
    when 4
      value = Custom_Skill_Algorithm.dup
      value.gsub!(/{atk}/i) {"user.weapon_attack"}
      value.gsub!(/{str}/i) {"user.battler_strength"}
      value.gsub!(/{def}/i) {"battler_defense(user)"}
      power = eval(value)
    end
    power = [power, 0].max if skill.power > 0
    return power
  end
  #--------------------------------------------------------------------------
  # * Set skill multiplier
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_skill_rate(user, skill)
    case Damage_Algorithm_Type
    when 0,1,2,4
      rate = 20
    when 3
      rate = 40
      rate -= (self.dex / 2 * skill.pdef_f / 200.0)
      rate -= ((self.dex + self.int)/ 4 * skill.mdef_f / 200.0)
    end
    unless Damage_Algorithm_Type == 4
      rate += (user.battler_strength * skill.str_f / 100.0)
      rate += (user.dex * skill.dex_f / 100.0)
      rate += (user.agi * skill.agi_f / 100.0)
      rate += (user.int * skill.int_f / 100.0)
    end
    return rate.to_i
  end
  #--------------------------------------------------------------------------
  # * Set skill state change
  #     user      : user
  #     skill     : skill
  #     effective : effective skill
  #--------------------------------------------------------------------------
  def set_skill_state_change(user, skill, effective)
    user.target_damage[self] = '' if skill.power == 0
    if skill.power != 0 and not skill.magic?
      remove_states_shock
      effective = true
    end
    damage = user.target_damage[self]
    if damage.numeric?
      effective |= self.hp != [[self.hp - damage, 0].max, self.maxhp].min
      effective |= self.sp != [[self.sp - damage, 0].max, self.maxsp].min if self.sp_damage
    end
    @state_changed = false
    effective |= states_plus(skill.plus_state_set)
    effective |= states_minus(skill.minus_state_set)
    user.target_damage[self] = (@state_changed ? '' : Miss_Message) if skill.power == 0
    return effective
  end
  #--------------------------------------------------------------------------
  # * Application of Item Effects
  #     item : item
  #     user : user
  #--------------------------------------------------------------------------
  def item_effect(item, user = self)
    self.critical = self.sp_damage = false
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1)
      return false
    end
    effective = false
    effective |= item.common_event_id > 0
    if (rand(100) < item.hit)
      effective |= make_item_damage_value(item, user, effective)
      effective |= set_item_state_change(item, user, effective)
    else
      user.target_damage[self] = Miss_Message
    end
    set_damage(user, item) if $game_temp.in_battle
    user.target_damage[self] = nil unless $game_temp.in_battle
    return effective
  end
  #--------------------------------------------------------------------------
  # * Set item damage
  #     item      : Item
  #     user      : Usuário
  #     effective : Item efetivo
  #--------------------------------------------------------------------------
  def make_item_damage_value(item, user, effective)
    recover_hp = [maxhp * item.recover_hp_rate / 100, maxhp].min + item.recover_hp
    recover_sp = [maxsp * item.recover_sp_rate / 100, maxsp].min + item.recover_sp
    if recover_hp < 0
      recover_hp += self.pdef * item.pdef_f / 20
      recover_hp += self.mdef * item.mdef_f / 20
      recover_hp = [recover_hp, 0].min
    end
    if recover_sp < 0
      recover_sp += self.pdef * item.pdef_f / 20
      recover_sp += self.mdef * item.mdef_f / 20
      recover_sp = [recover_sp, 0].min
    end
    recover_hp *= elements_correct(item.element_set)
    recover_hp /= 100
    recover_sp *= elements_correct(item.element_set)
    recover_sp /= 100
    recover_hp += apply_item_variance(item, recover_hp.abs) if item.variance > 0 and recover_hp.abs > 0
    recover_sp += apply_item_variance(item, recover_sp.abs) if item.variance > 0 and recover_sp.abs > 0
    if (item.recover_sp_rate > 0 or item.recover_sp > 0) and
       (item.recover_hp_rate == 0 and item.recover_hp == 0)
      self.sp_damage = true
    end
    recover_hp = [[recover_hp, -9999].max, 9999].min
    recover_sp = [[recover_sp, -9999].max, 9999].min
    damage = -recover_hp 
    damage = -recover_sp if self.sp_damage
    user.target_damage[self] = damage
    effective |= self.hp != [[self.hp + recover_hp, 0].max, self.maxhp].min
    effective |= self.sp != [[self.sp + recover_sp, 0].max, self.maxsp].min
    effective |= (damage.numeric? and damage != 0 and $game_temp.in_battle)
    self.sp += recover_sp if recover_sp > 0 and not self.sp_damage
    return effective
  end
  #--------------------------------------------------------------------------
  # * Apply item variance
  #     recover : Valor de Recuperação
  #--------------------------------------------------------------------------
  def apply_item_variance(item, recover)
    amp = [recover * item.variance / 100, 1].max
    return rand(amp+1) + rand(amp+1) - amp
  end
  #--------------------------------------------------------------------------
  # * Set item state change
  #     item      : Item
  #     user      : Usuário
  #     effective : Item efetivo
  #--------------------------------------------------------------------------
  def set_item_state_change(item, user, effective)
    @state_changed = false
    effective |= states_plus(item.plus_state_set)
    effective |= states_minus(item.minus_state_set)
    if item.parameter_type > 0 and item.parameter_points != 0
      case item.parameter_type
      when 1
        @maxhp_plus += item.parameter_points
      when 2
        @maxsp_plus += item.parameter_points
      when 3
        @str_plus += item.parameter_points
      when 4
        @dex_plus += item.parameter_points
      when 5
        @agi_plus += item.parameter_points
      when 6
        @int_plus += item.parameter_points
      end
      effective = true
    end
    if item.recover_hp_rate == 0 and item.recover_hp == 0 and 
       item.recover_sp_rate == 0 and item.recover_sp == 0
      user.target_damage[self] = ''
      if item.parameter_type == 0 or item.parameter_points == 0
        user.target_damage[self] = Miss_Message unless @state_changed
      end
    end
    apply_damage(user.target_damage[self], self.sp_damage) if effective and not $game_temp.in_battle
    return effective
  end
  #--------------------------------------------------------------------------
  # * Apply damage
  #     damage    : damage
  #     sp_damage : sp damage flag
  #--------------------------------------------------------------------------
  def apply_damage(damage, sp_damage = false)
    if self.dead? and @state_to_remove.include?(1)
      remove_state(1)
      self.hp = damage.abs if damage.numeric?
    else
      if self.sp_damage
        self.sp -= damage if damage.numeric?
      else
        self.hp -= damage if damage.numeric?
      end
    end
    for i in @state_to_add
      add_state(i)
    end
    for i in @state_to_remove
      remove_state(i)
    end
    @state_to_remove.clear
    @state_to_add.clear
  end
  #--------------------------------------------------------------------------
  # * State Change (+) Application
  #     plus_state_set  : State Change (+)
  #--------------------------------------------------------------------------
  def states_plus(plus_state_set)
    effective = false
    for i in plus_state_set
      unless self.state_guard?(i)
        effective |= self.state_full?(i) == false
        if $data_states[i].nonresistance
          @state_changed = true
          @state_to_add << i
        elsif self.state_full?(i) == false
          check_add_state(i)
        end
      end
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Check state to be added
  #    index : index
  #--------------------------------------------------------------------------
  def check_add_state(index)
    if rand(100) < [0,100,80,60,40,20,0][self.state_ranks[index]]
      @state_changed = true
      @state_to_add << index
    end
  end
  #--------------------------------------------------------------------------
  # * Apply State Change (-)
  #     minus_state_set : state change (-)
  #--------------------------------------------------------------------------
  def states_minus(minus_state_set)
    effective = false
    for i in minus_state_set
      effective |= self.state?(i)
      @state_changed = true
      @state_to_remove << i
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    skill = $data_skills[skill_id]
    return if skill.nil?
    if check_include(skill, 'CONSUMEHP')
      return false if calc_sp_cost(skill) > self.hp
    else
      return false if calc_sp_cost(skill) > self.sp
    end
    return false if dead?
    return false if silenced?(skill_id)
    occasion = skill.occasion
    return (occasion == 0 or occasion == 1) if $game_temp.in_battle
    return (occasion == 0 or occasion == 2) if !$game_temp.in_battle
  end
  #--------------------------------------------------------------------------
  # * Get skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  def calc_sp_cost(skill)
    cost = skill.sp_cost
    if check_include(skill, 'COSTMAX')
      return self.maxhp * cost / 100 if check_include(skill, 'CONSUMEHP')
      return self.maxsp * cost / 100
    elsif check_include(skill, 'COSTNOW')
      return self.hp * cost / 100 if check_include(skill, 'CONSUMEHP')
      return self.sp * cost / 100
    end
    return cost
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  def consume_skill_cost(skill)
    return if skill.nil?
    cost = calc_sp_cost(skill)
    self.hp -= cost if check_include(skill, 'CONSUMEHP')
    self.sp -= cost if not check_include(skill, 'CONSUMEHP')
  end 
  #--------------------------------------------------------------------------
  # * Set lock by enemy attack
  #--------------------------------------------------------------------------
  def attack_locked?
    for battler in $game_party.actors + $game_troop.enemies
      return true if battler.attack_lock.include?(self)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Set movement target position
  #--------------------------------------------------------------------------
  def set_move_target_postion
    @battler_one_target = nil
    if @movement and @step_foward
      action_step_foward
    elsif @movement and @action_all and not @action_center
      action_target_all
    elsif @movement and @action_center
      action_target_center
    elsif @movement and not @step_foward and not 
       @action_center and not @action_all
      action_one_target
    else
      @target_x = @actual_x
      @target_y = @actual_y
    end
  end
  #--------------------------------------------------------------------------
  # * Set step foward action
  #--------------------------------------------------------------------------
  def action_step_foward
    dir = @direction
    @target_x = @actual_x + (dir == 4 ? -64 : dir == 6 ? 64 : 0)
    @target_y = @actual_y + (dir == 8 ? -64 : dir == 2 ? 64 : 0)
    if Battle_Style == 1
      @target_x = @actual_x + (dir == 8 ? -64 : dir == 2 ? 64 : 0)
      @target_y = @actual_y + (dir == 4 ? -64 : dir == 6 ? 64 : 0)
    end
    loop do
      break if not_on_same_place
    end    
  end
  #--------------------------------------------------------------------------
  # * Set tatget all action
  #--------------------------------------------------------------------------
  def action_target_all
    pos = action_movement_start
    dir = @direction
    x = (dir == 2 ? pos[1] : dir == 4 ? 128 + pos[0] : dir == 6 ? - 128 - pos[0] : pos[1])
    y = (dir == 2 ? - 128 - pos[0] : dir == 4 ? pos[1] : dir == 6 ? pos[1] : 128 + pos[0])
    targets = actor? ? $game_troop.avarage_position : $game_party.avarage_position
    @target_x = targets[0] + x
    @target_y = targets[1] + y
    loop do
      break if not_on_same_place
    end
  end
  #--------------------------------------------------------------------------
  # * Set target center action
  #--------------------------------------------------------------------------
  def action_target_center
    @target_x = Battle_Screen_Dimension[0] / 2
    @target_y = Battle_Screen_Dimension[1] / 2
  end
  #--------------------------------------------------------------------------
  # * Set move to target
  #--------------------------------------------------------------------------
  def action_one_target
    @target_battlers.flatten!
    target = @target_battlers[0]
    return if target.nil?
    pos = action_movement_start
    dir = @direction
    @target_x = target.actual_x + (dir == 2 ? pos[1] : dir == 4 ? 32 + pos[0] : dir == 6 ? - 32 - pos[0] : pos[1])
    @target_y = target.actual_y + (dir == 2 ? - 32 - pos[0] : dir == 4 ? pos[1] : dir == 6 ? pos[1] : 32 + pos[0])
    @battler_one_target = target
    loop do
      break if not_on_same_place
    end
  end
  #--------------------------------------------------------------------------
  # * Check if not in same position
  #--------------------------------------------------------------------------
  def not_on_same_place
    for target in $game_party.actors + $game_troop.enemies
      next if target == self
      if (target.actual_x == @target_x and target.actual_y == @target_y) or
         (target.target_x == @target_x and target.target_y == @target_y)
        case Battle_Style 
        when 0, 2
          @target_y = @target_y + (self.index % 2 == 0 ? 16 : -16)
        when 1
          @target_x = @target_x + (self.index % 2 == 0 ? 16 : -16)
          @target_y = @target_y + (self.index % 2 == 0 ? 16 : -16)
        when 3
          case @direction
          when 2, 8
            @target_x = @target_x + (self.index % 2 == 0 ? 16 : -16)
          when 4, 6
            @target_y = @target_y + (self.index % 2 == 0 ? 16 : -16)
          end
        end
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Get action movement start position
  #--------------------------------------------------------------------------
  def action_movement_start
    position = action_postions
    return position.nil?  ? [0,0] : [position[0],position[1]]
  end
  #--------------------------------------------------------------------------
  # * Get movement position
  #--------------------------------------------------------------------------
  def action_postions
    action = @now_action.nil? ? self : @now_action
    ext = check_extension(action, 'MOVEPOSITION/')
    return nil if ext.nil?
    ext.slice!('MOVEPOSITION/')
    ext = ext.split(',')
    move = [ext[0].to_i,ext[1].to_i,ext[2].to_i,ext[3].to_i,ext[4].to_i]
    return move.nil? ? nil : move.dup
  end
  #--------------------------------------------------------------------------
  # * Set action movement end
  #--------------------------------------------------------------------------
  def action_movement_end
    pos = action_postions
    target = @target_battlers[0]
    return if pos.nil? or target.nil?
    dir = @direction
    @target_x = @actual_x + (dir == 2 ? pos[3] : dir == 4 ? - pos[2] : dir == 6 ? pos[2] : pos[3])
    @target_y = @actual_y + (dir == 2 ? pos[2] : dir == 4 ? pos[3] : dir == 6 ? pos[3] : - pos[2])
    @move_speed = pos[4]
  end
end