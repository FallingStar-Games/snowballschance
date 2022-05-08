#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :disabled_commands           # List of disabled actor commands
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias acbs_setup_gameactor setup
  def setup(actor_id)
    acbs_setup_gameactor(actor_id)
    @disabled_commands = []
    battler_position_setup
  end
  #--------------------------------------------------------------------------
  # * Decide if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    return super
  end 
  #--------------------------------------------------------------------------
  # * Check if battler is an actor
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    return super
  end
  #--------------------------------------------------------------------------
  # * Decide escaping
  #--------------------------------------------------------------------------
  def escaping?
    return $game_temp.party_escaped
  end
  #--------------------------------------------------------------------------
  # * Type string setting
  #--------------------------------------------------------------------------
  def type_name
    return 'Actor'
  end
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    @base_x = @original_x = @actual_x = @target_x = @initial_x = @hit_x = @damage_x = self.screen_x
    @base_y = @original_y = @actual_y = @target_y = @initial_y = @hit_y = @damage_y = self.screen_y
  end
  #--------------------------------------------------------------------------
  # * Get Target Animation ID for Normal Attacks
  #--------------------------------------------------------------------------
  def animation2_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation2_id : Unarmed_Animation
  end
  #--------------------------------------------------------------------------
  # * Get weapons
  #--------------------------------------------------------------------------
  def weapons
    result = [$data_weapons[@weapon_id]]
    result.delete_if {|x| x == nil }
    return result
  end
  #--------------------------------------------------------------------------
  # * Get armors
  #--------------------------------------------------------------------------
  def armors
    result = []
    result << $data_armors[@armor1_id]
    result << $data_armors[@armor2_id]
    result << $data_armors[@armor3_id]
    result << $data_armors[@armor4_id]
    result.delete_if {|x| x == nil }
    return result
  end
  #--------------------------------------------------------------------------
  # * Get equipments
  #--------------------------------------------------------------------------
  def equips
    return weapons + armors
  end
  #--------------------------------------------------------------------------
  # * Get current weapon
  #--------------------------------------------------------------------------
  def current_weapon
    return weapons.first
  end
  #--------------------------------------------------------------------------
  # * Get final level
  #--------------------------------------------------------------------------
  def final_level
    return $data_actors[@actor_id].final_level
  end
  #--------------------------------------------------------------------------
  # * Change EXP
  #     exp : new EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [exp, 0].max
    level_change
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Change level
  #--------------------------------------------------------------------------
  def level_change
    while @exp >= @exp_list[@level + 1] and @exp_list[@level + 1] > 0
      @level += 1
      for j in $data_classes[@class_id].learnings
        if j.level == @level
          learn_skill(j.skill_id)
        end
      end
    end
    while @exp < @exp_list[@level]
      @level -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get base parameter value
  #     type : parameter tipe
  #--------------------------------------------------------------------------
  def base_parameter(type)
    return $data_actors[@actor_id].parameters[type, @level]
  end  
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    return base_parameter(0)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    return base_parameter(1)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    n = base_parameter(2)
    for item in equips.compact do n += item.str_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Strength
  #--------------------------------------------------------------------------
  def str
    n = base_str + @str_plus
    for i in @states do n *= $data_states[i].str_rate / 100.0 end
    return [[n.to_i, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    n = base_parameter(3)
    for item in equips.compact do n += item.dex_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Dexterity
  #--------------------------------------------------------------------------
  def dex
    n = base_dex + @dex_plus
    for i in @states do n *= $data_states[i].dex_rate / 100.0 end
    return [[n.to_i, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = base_parameter(4)
    for item in equips.compact do n += item.agi_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Agility
  #--------------------------------------------------------------------------
  def agi
    n = base_agi + @agi_plus
    for i in @states do n *= $data_states[i].agi_rate / 100.0 end
    return [[n.to_i, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    n = base_parameter(5)
    for item in equips.compact do n += item.int_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Intelligence
  #--------------------------------------------------------------------------
  def int
    n = base_int + @int_plus
    for i in @states do n *= $data_states[i].int_rate / 100.0 end
    return [[n.to_i, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk
    n = 0
    for item in weapons.compact do n += item.atk end
    n = Unarmed_Attack if weapons.empty?
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    n = 0
    for item in equips.compact do n += item.pdef end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    n = 0
    for item in equips.compact do n += item.mdef end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Basic Evasion Correction
  #--------------------------------------------------------------------------
  def base_eva
    n = 0
    for item in armors.compact do n += item.eva end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Hit
  #--------------------------------------------------------------------------
  def hit
    n = super
    for item in equips.compact do n += item.hit end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  def crt
    n = super
    for item in equips.compact do n += item.crt end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  def dmg
    n = super
    for item in equips.compact do n += item.dmg end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  def rcrt
    n = super
    for item in equips.compact do n += item.rcrt end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  def rdmg
    n = super
    for item in equips.compact do n += item.rdmg end
    return n.to_i
  end  
  #--------------------------------------------------------------------------
  # * Remove secondary equip
  #--------------------------------------------------------------------------
  def remove_left_equip_actor
    equip(1, 0)
  end
  #--------------------------------------------------------------------------
  # * Remove secondary equip by class
  #     class_id : class ID
  #--------------------------------------------------------------------------
  def remove_left_equip_class(class_id)
    equip(1, 0) if class_id == @class_id
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    if self.index != nil
      if Auto_Set_Postions and Battle_Style < 3
        case Battle_Style
        when 0
          return (self.index * - 1) * ((index * 5) - 20) + (Actor_Position_AdjustX + 472)
        when 1
          return (self.index * - 1) *((index * 22) - 32) + (Actor_Position_AdjustX + 424)
        when 2
          wd = 640 / Max_Party
          return ((self.index * wd) + (wd * (Max_Party - $game_party.actors.size) / 2)) + (Actor_Position_AdjustX + (wd / 2))
        end
      else
        return $game_system.battler_positions[self.index][0]
      end
    else
      return Actor_Position_AdjustX
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    if self.index != nil
      if Auto_Set_Postions and Battle_Style < 3
        case Battle_Style
        when 0
          position = (self.index - $game_party.actors.size) * 40 + 
            ($game_party.actors.size * 20) + (Actor_Position_AdjustY + 264) 
          return position
        when 1
          return self.index * (40 - (index * 6)) + (Actor_Position_AdjustY + 260)
        when 2
          return 464 + (Actor_Position_AdjustY) - Battle_Screen_Position[1]
        end
      else
        return $game_system.battler_positions[self.index][1]
      end
    else
      return Actor_Position_AdjustY
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Z-Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  def consume_skill_cost(skill)
    super(skill)
  end 
end