#==============================================================================
# Status Limit
# By Atoa
#==============================================================================
# This scripts allows to set new limits for actors status
#==============================================================================

module Atoa
  # Do not remove this line
  Max_Level = {}
  # Do not remove this line

  # Default level limit
  Max_Level_Default = 99
  
  # Individual level limit
  # Max_Level[ID] = X
  #  ID = Actor ID
  #  X = Max level
  Max_Level[1] = 99
  Max_Level[2] = 99
  Max_Level[3] = 99
  Max_Level[4] = 99
  
  # Actor status limit
  Actor_Max_Hp  = 9999
  Actor_Max_Sp  = 9999
  Actor_Max_Str = 999
  Actor_Max_Dex = 999
  Actor_Max_Agi = 999
  Actor_Max_Int = 999
  Actor_Max_Atk = 999
  Actor_Max_PDef = 999
  Actor_Max_MDef = 999
    
  # Base status Multiplier
  # These values change the base status of the character
  # Can be decimals(E.g.: 2.7)
  Actor_Mult_Hp  = 1
  Actor_Mult_Sp  = 1
  Actor_Mult_Str = 1
  Actor_Mult_Dex = 1
  Actor_Mult_Agi = 1
  Actor_Mult_Int = 1
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Status Limit'] = true

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get final level
  #--------------------------------------------------------------------------
  def final_level
    return Max_Level[@actor_id] != nil ? Max_Level[@actor_id] : Max_Level_Default
  end  
  #--------------------------------------------------------------------------
  # * Calculate EXP
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..(final_level + 1)
      if i > final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change Level
  #     level : new level
  #--------------------------------------------------------------------------
  def level=(level)
    level = [[level, final_level].min, 1].max
    self.exp = @exp_list[level]
  end
  #--------------------------------------------------------------------------
  # * Get base parameter value
  #     type : parameter tipe
  #--------------------------------------------------------------------------
  alias base_parameter_statuslimit base_parameter
  def base_parameter(type)
    if @level >= 100
      base = ("(param[99] - param[98]) * (level - 99) + ([level * ((param[99] - param[98]) - (param[2] - param[1])) / 100, 0].max).to_i").dup
      base.gsub!(/level/i) {"@level"}
      base.gsub!(/param\[(\d+)\]/i) {"$data_actors[@actor_id].parameters[type, #{$1.to_i}]"}
      return $data_actors[@actor_id].parameters[type, 99] + eval(base)
    else
      return base_parameter_statuslimit(type)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    n = base_parameter(0)
    n *= Actor_Mult_Hp
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxhp
    n = base_maxhp + @maxhp_plus
    for i in @states do n *= $data_states[i].maxhp_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Hp].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum SP
  #--------------------------------------------------------------------------
  def base_maxsp
    n = base_parameter(1)
    n *= Actor_Mult_Sp
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Maximum SP
  #--------------------------------------------------------------------------
  def maxsp
    n = base_maxsp + @maxsp_plus
    for i in @states do n *= $data_states[i].maxsp_rate / 100.0 end
    return [[n.to_i, 0].max, Actor_Max_Sp].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Strength
  #--------------------------------------------------------------------------
  def base_str
    n = base_parameter(2)
    n *= Actor_Mult_Str
    for item in equips.compact do n += item.str_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Strength
  #--------------------------------------------------------------------------
  def str
    n = base_str + @str_plus
    for i in @states do n *= $data_states[i].str_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Str].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Dexterity
  #--------------------------------------------------------------------------
  def base_dex
    n = base_parameter(3)
    n *= Actor_Mult_Dex
    for item in equips.compact do n += item.dex_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Dexterity
  #--------------------------------------------------------------------------
  def dex
    n = base_dex + @dex_plus
    for i in @states do n *= $data_states[i].dex_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = base_parameter(4)
    n *= Actor_Mult_Agi
    for item in equips.compact do n += item.agi_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Agility
  #--------------------------------------------------------------------------
  def agi
    n = base_agi + @agi_plus
    for i in @states do n *= $data_states[i].agi_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Intelligence
  #--------------------------------------------------------------------------
  def base_int
    n = base_parameter(5)
    n *= Actor_Mult_Int
    for item in equips.compact do n += item.int_plus end
    return n.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Intelligence
  #--------------------------------------------------------------------------
  def int
    n = base_int + @int_plus
    for i in @states do n *= $data_states[i].int_rate / 100.0 end
    return [[n.to_i, 1].max, Actor_Max_Int].min
  end
  
  #--------------------------------------------------------------------------
  # * Set Maximum HP
  #     maxhp : new maximum HP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -Actor_Max_Hp].max, Actor_Max_Hp].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # * Set Maximum SP
  #     maxsp : new maximum SP
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -Actor_Max_Sp].max, Actor_Max_Sp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Set Strength (STR)
  #     str : new Strength (STR)
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -Actor_Max_Str].max, Actor_Max_Str].min
  end
  #--------------------------------------------------------------------------
  # * Set Dexterity (DEX)
  #     dex : new Dexterity (DEX)
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -Actor_Max_Dex].max, Actor_Max_Dex].min
  end
  #--------------------------------------------------------------------------
  # * Set Agility (AGI)
  #     agi : new Agility (AGI)
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -Actor_Max_Agi].max, Actor_Max_Agi].min
  end
  #--------------------------------------------------------------------------
  # * Set Intelligence (INT)
  #     int : new Intelligence (INT)
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -Actor_Max_Int].max, Actor_Max_Int].min
  end

  #--------------------------------------------------------------------------
  # * Get Basic Attack Power
  #--------------------------------------------------------------------------
  def base_atk
    n = 0
    for item in weapons.compact do n += item.atk end
    unarmed = Unarmed_Attack 
    n = unarmed if weapons.empty?
    return [[n.to_i, 0].max, Actor_Max_Atk].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Physical Defense
  #--------------------------------------------------------------------------
  def base_pdef
    n = 0
    for item in equips.compact do n += item.pdef end
    return [[n.to_i, 0].max, Actor_Max_PDef].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Magic Defense
  #--------------------------------------------------------------------------
  def base_mdef
    n = 0
    for item in equips.compact do n += item.mdef end
    return [[n.to_i, 0].max, Actor_Max_MDef].min
  end
end