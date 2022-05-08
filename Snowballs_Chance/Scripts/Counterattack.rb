#==============================================================================
# Counter Attack
# by Atoa
#==============================================================================
# This script allows actors/enemies to use counter-attack with
# different conditions.
#==============================================================================

module Atoa
  # Don't change or delete these lines.
  Counter_Setting = {'Actor' => {}, 'Enemy' => {}, 'Skill' => {}, 'State' => {},
    'Armor' => {}, 'Weapon' => {}}
  # Don't change or delete these lines.

  # Counter_Setting[Type][ID] = {Activation => Effect,...}

  # Type : Counter-Attack Type
  #     'Actor' for actors
  #     'Enemy' for enemies
  #     'Skill' for skills (the skill has to be learnt)
  #     'State' for effects
  #     'Armor' for armors
  #     'Weapon' for weapons
  
  # Activation = {'type' => type, 'condition' => condition, 'action' => specific action}
  #  Type: Action which will activate the counter
  #   0 = Normal Attack
  #   1 = Attack Skills
  #   2 = Magic Skills
  #   3 = Specific Actions
  #   4 = Any attack or skill
  #
  # Condition: Needed Conditions to counter
  # This can be left out (counter will always be executed)
  # Text String with the condition to be used can be script commands and available
  # methods from Game_Battler Class.
  #
  #	You can add other atrributes using its respective script commands
  #      "user" - user/attacker (the one who is attacking)
  #      "target" - target (the one who is being attacked and will counter)
  #      "skill" - skill
  #      "damage" - damage dealt on the target
  #    Examples:
  #      "damamge.numeric? and damage >= 200" # if damage is a numeric value
	#				      #greater or equal to 200
  #
  #      "damamge.numeric? and damage > 50 * target.maxhp / 100" # if damage is a numeric value
  #                       #greater than  50% target max hp
  #      "damage == Miss_Message" # if damage is not a value but a message error
  #                       #  (when "miss" message shows up)
  #      "rand(100) < 50" # If random value from 0 to 100 is less than 50
  #                       # (50% chance of countering)
  #      "rand(100) < 70 and target.hp < target.maxhp / 2" # If random value from 0 to 100
  #                       # is less than 70 (70% chance of countering) and only
  #                       # if taget has half of its full hp
  #
  #     IMPORTANT: to verifuy if a value is "greater or less" when damage is related,
  #       it's extremely important to use 'damage.numeric?' method to check
  #       if damage is a numberic value. If you use operator like "<" and ">" for verifications
  #       using texts, there will be an error, since damage can be shown as texts.
  #
  #  Specific Action : This value can only be used if "Type" is equal to 3
  #    It has to be a list containing all skill IDs that will make counter
  #    work

  # Effect = [[Type, Target(, [ID], Cost)],...]
  # Effect = {'type' => Type, 'target' => Target, 'id' => [ID], 'cost' => Cost, wait => Wait}
  #  Type : Attack Type
  #    0 = Normal Attack
  #    1 = Skill
  #    2 = Itens
  #  Target: Action target, it can be left out. If left out the target will be
  #   the action default ones
  #    0 = Enemies (one only target actions will always hit the target battler)
  #    1 = Allies (one only target actions will always hit the user)
  #  ID : Numeric value or list containing action/skill IDs available 
  #    only if type is 1 or 2
  #    If more than one value is set, the action will be random among
  #    available actions.
  #  Cost : Action cost, true or false. Only if type is 1 or 2.
  #    If true, the skill will just be executed if the cost can be payed
  #    and it will consume its SP or Item cost.
  #  Wait : Waiting time, true or false, it can be left out.
  #    If true, after attackin, the battler will hold on until counter-attack action ends,
  #    and then returns to its position.

  Counter_Setting['Actor'][1] = {
    {'type' => 0} => {'type' => 0, 'wait' => true}, 
    # Counter any physical attack and target waits until action ends.
    {'type' => 2, 'condition' => 'target.in_danger?'} => {'type' => 2, 'id' => 1, 'cost' => true},
    # Counter against magic using potions if the battler hp is in danger
    {'type' => 4, 'condition' => 'damage.numeric? and damage > 1000'} => {'type' => 1, 'id' => 1, 'cost' => true},
    # Counter any attack that can deal more than 1000 damage using Cure in him/herself
  }
  
  Counter_Setting['Actor'][2] = {
    {'type' => 0} => {'type' => 0, 'wait' => true}, 
    # Always counter any physical attack and target wait until it ends to returno to its position
    {'type' => 2, 'condition' => 'target.in_danger?'} => {'type' => 2, 'id' => 1, 'cost' => true},
    # Counter skills using a potion in him/herself if HP is  in danger
    {'type' => 4, 'condition' => 'damage.numeric? and damage > 1000'} => {'type' => 1, 'id' => 1, 'cost' => true},
    # Counter any attack that deals more than 1000 damage using cure skill in himself/herself
  }
  
  Counter_Setting['Actor'][3] = {
    {'type' => 0} => {'type' => 0, 'wait' => true}, 
    # Always counter any physical attack and target wait until it ends to return to its position
    
    {'type' => 2, 'condition' => 'target.in_danger?'} => {'type' => 2, 'id' => 1, 'cost' => true},
    # Counter skills using a potion in him/herself if HP is in danger
    {'type' => 4, 'condition' => 'damage.numeric? and damage > 1000'} => {'type' => 1, 'id' => 1, 'cost' => true},
    # Counter any attack that deals more than 1000 damage using cure skill in himself/herself
  }
  
  Counter_Setting['Actor'][4] = {
    {'type' => 0} => {'type' => 0, 'wait' => true}, 
    # Always counter any physical attack and target wait until it ends to return to its position
    {'type' => 2, 'condition' => 'target.in_danger?'} => {'type' => 2, 'id' => 1, 'cost' => true},
    # Counter skills using a potion in him/herself if HP is in danger
    {'type' => 4, 'condition' => 'damage.numeric? and damage > 1000'} => {'type' => 1, 'id' => 1, 'cost' => true},
    # Counter any attack that deals more than 1000 damage using cure skill in himself/herself
  }
   
  Counter_Setting['Enemy'][11] = {
    {'type' => 0, 'condition' => 'damage != Miss_Message'} => {'type' => 0, 'wait' => true}, 
    # Counter any pysical attack if damage is dealt and target wait until counter ends
    {'type' => 2, 'condition' => 'target.hp < 50 * target.maxhp / 100'} => {'type' => 1, 'id' => 3, 'cost' => true},
    # Counter against skills using Cura in him/herself if HP is 50%
    {'type' => 4, 'condition' => 'damage.numeric? and damage > 1000'} => {'type' => 1, 'id' => 110, 'cost' => true},
    # Counter against any attack that deals more than 1000 damage using
    # skill "Celcius Attack"
  }
  
end
#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Counter Attack'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :counter_action
  attr_accessor :counter_action_set
  attr_accessor :counter_targets
  attr_accessor :counter_cost
  attr_accessor :wait_counter
  attr_accessor :valid_counters
  attr_accessor :counter_waiting
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_counter initialize
  def initialize
    @counter_targets = []
    @valid_counters = []
    initialize_counter
  end
  #--------------------------------------------------------------------------
  # * Applying Normal Attack Effects
  #     attacker : battler
  #--------------------------------------------------------------------------
  alias attack_effect_counter attack_effect
  def attack_effect(attacker)
    effective = attack_effect_counter(attacker)
    if $game_temp.in_battle and attacker != self and not attacker.counter_action_set
      damage = attacker.target_damage[self]
      set_counter_condition(attacker, damage)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  alias skill_effect_counter skill_effect
  def skill_effect(user, skill)
    effective = skill_effect_counter(user, skill)
    if $game_temp.in_battle and user != self and not user.counter_action_set 
      damage = user.target_damage[self]
      set_counter_condition(user, damage, skill)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  alias consume_skill_cost_counter consume_skill_cost
  def consume_skill_cost(skill)
    return if self.counter_action_set and not self.counter_cost
    consume_skill_cost_counter(skill)
  end 
  #--------------------------------------------------------------------------
  # * Set counter condition
  #     user    : user
  #     damage  : damage
  #     skill   : skill
  #--------------------------------------------------------------------------      
  def set_counter_condition(user, damage, skill = nil)
    if self.actor?
      set_counter(user, damage, skill, 'Actor')
      set_counter(user, damage, skill, 'Skill')
      set_counter(user, damage, skill, 'Armor')
      set_counter(user, damage, skill, 'Weapon')
    else
      set_counter(user, damage, skill, 'Enemy')
    end
    set_counter(user, damage, skill, 'State')
    return if @valid_counters.empty?
    self.counter_action = @valid_counters[rand(@valid_counters.size)]
  end
  #--------------------------------------------------------------------------
  # * Set counter
  #     user    : user
  #     damage  : damage
  #     skill   : skill
  #     kind    : kind
  #--------------------------------------------------------------------------      
  def set_counter(user, damage, skill, kind)
    if kind == 'Actor' and Counter_Setting['Actor'][self.id] != nil
      counter = Counter_Setting['Actor'][self.id].dup
      set_counter_values(user, damage, skill, kind, counter)
    end
    if kind == 'Enemy' and Counter_Setting['Enemy'][self.id] != nil
      counter = Counter_Setting['Enemy'][self.id].dup
      set_counter_values(user, damage, skill, kind, counter)
    end
    if kind == 'State'
      for id in self.states
        if Counter_Setting['State'][id] != nil
          counter = Counter_Setting['State'][id]
          set_counter_values(user, damage, skill, kind, counter)
        end
      end
    end
    if kind == 'Skill'
      for id in self.skills
        if Counter_Setting['Skill'][id] != nil
          counter = Counter_Setting['Skill'][id]
          set_counter_values(user, damage, skill, kind, counter)
        end
      end
    end
    if kind == 'Armor'
      for armor in self.armors
        id = armor.id
        if Counter_Setting['Armor'][id] != nil
          counter = Counter_Setting['Armor'][id]
          set_counter_values(user, damage, skill, kind, counter)
        end
      end
    end
    if kind == 'Weapon'
      for weapon in self.weapons
        id = weapon.id
        if Counter_Setting['Weapon'][id] != nil
          counter = Counter_Setting['Weapon'][id]
          set_counter_values(user, damage, skill, kind, counter)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set counter values
  #     user    : user
  #     damage  : damage
  #     skill   : skill
  #     kind    : kind
  #     counter : settings
  #--------------------------------------------------------------------------  
  def set_counter_values(user, damage, skill, kind, counter)
    for condition in counter.keys
      current = counter[condition]
      next if skill.nil? and not [0, 4].include?(condition['type'])
      next if skill != nil and not skill.magic? and not [1, 4].include?(condition['type'])
      next if skill != nil and skill.magic? and not [2, 4].include?(condition['type'])
      next if skill != nil and condition['action'] != nil and not
              condition['action'].include?(skill.id)
      next if condition['condition'] != nil and not eval(get_condition(condition))
      next if current['cost'] and current['type'] == 1 and cant_counter_skill(current['id'])
      next if current['cost'] and current['type'] == 2 and cant_counter_item(current['id'])
      @valid_counters << set_counter_action(current)
    end
  end
  #--------------------------------------------------------------------------
  # * Get condition
  #     condition : current setting
  #--------------------------------------------------------------------------  
  def get_condition(condition)
    current = condition['condition']
    current.gsub!(/target/i) {"self"}
    return current
  end
  #--------------------------------------------------------------------------
  # * Allow skill for counter
  #     current : current setting
  #--------------------------------------------------------------------------  
  def cant_counter_skill(current)
    return (not skill_can_use?(current)) if current.numeric?
    for skill_id in current
      return false if skill_can_use?(skill_id)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Allow item for counter
  #     current : current setting
  #--------------------------------------------------------------------------  
  def cant_counter_item(current)
    return (self.actor? and not $game_party.item_can_use?(current)) if current.numeric?
    for item_id in current
      return false if $game_party.item_can_use?(item_id) or not self.actor?
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Set counter action
  #     current : current setting
  #--------------------------------------------------------------------------  
  def set_counter_action(current)
    if current['type'] == 1 and current['id'].is_a?(Array)
      available_skills = []
      for skill_id in current
        available_skills << skill_id if skill_can_use?(skill_id) or not current['cost']
      end
      action = available_skills[rand(available_skills.size)]
    elsif current['type'] == 2 and current['id'].is_a?(Array)
      available_skills = []
      for item_id in current
        available_skills << skill_id if $game_party.item_can_use?(item_id) or not
                                        current['cost'] or not self.actor?
      end
      action = available_skills[rand(available_skills.size)]
    else
      action = current['id']
    end
    return current.dup
  end
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start battler turn
  #     battler : battler
  #--------------------------------------------------------------------------
  alias battler_turn_counter battler_turn if $atoa_script["Atoa ATB"] or $atoa_script["Atoa CTB"]
  def battler_turn(battler)
    return if battler.counter_action_set
    battler_turn_counter(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_counter step2_part1
  def step2_part1(battler)
    for target in $game_party.actors + $game_troop.enemies
      if target.dead?
        target.counter_action = nil
        target.counter_action_set = false
        target.counter_waiting = nil
        target.wait_counter = false
        target.counter_cost = false
        target.current_action.clear
        target.action_scope = 0
      end
    end
    step2_part1_counter(battler)
    if battler.cast_action != nil and battler.counter_action_set
      battler.current_phase = "Phase 2-1"
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part1_counter step5_part1
  def step5_part1(battler)
    step5_part1_counter(battler)
    if battler.counter_waiting != nil
      battler.counter_waiting.wait_counter = false
      battler.counter_waiting = nil
    end
    for target in $game_party.actors + $game_troop.enemies
      if target.counter_action != nil and target.inputable? and not 
         target.hp0? and not battler.counter_action_set
        set_counter_action(battler, target)
        target.counter_action_set = true
        @action_battlers.unshift(target)
        @action_battlers.uniq!
        if target.returning? and target.moving?
          target.current_phase = 'Phase 2-1'
          target.target_x = target.actual_x
          target.target_y = target.actual_y
        end
      end
      target.counter_action = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part2_counter step5_part2
  def step5_part2(battler)
    return if battler.wait_counter
    step5_part2_counter(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_counter step5_part4
  def step5_part4(battler)
    step5_part4_counter(battler)
    battler.counter_action_set = false
    battler.valid_counters.clear
  end
  #--------------------------------------------------------------------------
  # * Set action cost
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_action_cost_counter set_action_cost if $atoa_script['Atoa CTB']
  def set_action_cost(battler)
    if battler.counter_action_set
      battler.current_cost = 0
      return
    end
    set_action_cost_counter(battler)
  end
  #--------------------------------------------------------------------------
  # * ATB reset
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias reset_atb_counter reset_atb if $atoa_script['Atoa ATB']
  def reset_atb(battler)
    return if battler.counter_action_set
    reset_atb_counter(battler)
  end
  #--------------------------------------------------------------------------
  # * Set item consum
  #     battler : battler
  #--------------------------------------------------------------------------
  alias consum_item_cost_counter consum_item_cost
  def consum_item_cost(battler)
    return if battler.counter_action_set and not battler.counter_cost
    consum_item_cost_counter(battler)
  end
  #--------------------------------------------------------------------------
  # * Set counter action
  #     battler : battler
  #     target  : target
  #--------------------------------------------------------------------------
  def set_counter_action(battler, target)
    action = target.counter_action
    target.counter_info = [target.current_action.kind, target.current_action.basic,
      target.current_action.skill_id, target.current_action.item_id, target.action_scope]
    target.current_action.kind = action["type"]
    target.current_action.basic = 0 if action["type"] == 0
    target.current_action.skill_id = action["id"] if action["type"] == 1
    target.current_action.item_id = action["id"] if action["type"] == 2
    target.counter_cost = action["cost"]
    if action["type"] == 1 or action["type"] == 2
      id = target.current_action.skill_id if action["type"] == 1
      id = target.current_action.item_id if action["type"] == 2
      target.current_skill = $data_skills[id] if action["type"] == 1
      target.current_item = $data_items[id] if action["type"] == 2
    end
    target.current_action.target_index = battler.index
    if action["type"] == 1
      scope = 7
      target.action_scope = scope 
    elsif action["type"] == 0
      scope = oposite_side(battler, target) ? 1 : 3
      target.action_scope = scope 
    end
    if (target.current_skill != nil or target.current_item != nil) and not
       oposite_side(battler, target)
      current_action = target.current_skill if target.current_skill != nil
      current_action = target.current_item if target.current_item != nil
      case current_action.scope
      when 1 then scope = 3
      when 2 then scope = 4
      when 3 then scope = 1
      when 4 then scope = 2
      when 5 then scope = 1
      when 6 then scope = 2
      end
      target.action_scope = scope
    end
    set_target_battlers(target, scope)
    target.action_scope = 0
    if action["wait"]
      battler.wait_counter = true
      target.counter_waiting = battler
      battler.pose_id = @spriteset.battler(battler).set_idle_pose
    end
  end
end