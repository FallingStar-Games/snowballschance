#==============================================================================
# HP Sacrifice
# By LockeZ
#==============================================================================
# This script allows you to create skills, weapons and items that cost HP
# when used.
#==============================================================================
=begin
module Atoa
  # Do not remove this line
  HP_Sacrifice_Action = {'Skill' => {}, 'Weapon' => {}, 'Item' => {}}
  # Do not remove this line
  
  # HP_Sacrifice_Action[action_type][id] = [chance, formula, amount, anim_id, pop, can_kill]
  # action_type = action type
  #   action_type = 'Skill' for skills, 'Weapon' for weapons, 'Item' for items
  # id = ID of the skill/weapon/item
  # 
  # chance = chance of damaging self
  # formula = How the amount lost is calculated.  Must be 'integer' or 'percent'.
  # amount = Amount of HP lost, based on formula.  If formula is set to integer,
  #   this is the actual amount lost.  If it's set to percent, this is the
  #   percent of max HP that is lost.
  # anim_id = ID of the animation shown when absorb HP/SP, leave nil or 0 for
  #   no animation
  # pop = true or false, whether the sacrificed amount pops up as visible damage
  # can_kill = true or false, if false the skill will not reduce you below 1 HP
  
  # Rad Arts
  HP_Sacrifice_Action['Skill'][5] = [100, 'percent', 33, 10, true, true]  #lethal strike
  HP_Sacrifice_Action['Skill'][54] = [100, 'percent', 25, 10, true, true] #shasho
  
  #HP_Sacrifice_Action['Skill'][6] = [100, 'percent', 100, nil, false, true]  #Black Payment
  #HP_Sacrifice_Action['Skill'][34] = [100, 'percent', 10, nil, true, false] #Blotted Life
  
  # Enemy Skill
  #HP_Sacrifice_Action['Skill'][436] = [100, 'percent', 100, nil, false, true] #Kamikaze
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['LockeZ HP Sacrifice'] = true


#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Update battler phase 4 (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part3_hp_sacrifice step4_part3
  def step4_part3(battler)
    step4_part3_hp_sacrifice(battler)
    action = battler.now_action
    if action != nil and HP_Sacrifice_Action[action.type_name] != nil and
       HP_Sacrifice_Action[action.type_name].include?(action_id(action))
      sacrifice_hp(battler, HP_Sacrifice_Action[action.type_name][action_id(action)].dup)
    end
  end
  #--------------------------------------------------------------------------
  # Sacrifice HP
  #     battler : active battler
  #     action  : action
  #--------------------------------------------------------------------------
  def sacrifice_hp(battler, action)
    if action[0] >= rand(100)
      if action[1] == 'integer'
        hp_sacrificed = action[2].to_i
      elsif action[1] == 'percent'
        hp_sacrificed = (battler.maxhp * action[2] / 100).to_i
      end
      if action[5] == false
        hp_sacrificed = [battler.hp - 1, hp_sacrificed].min
      end
      if hp_sacrificed != 0
        battler.damage = hp_sacrificed
        battler.animation_id = action[3].nil? ? 0 : action[3]
        battler.damage_pop = action[4]
        battler.hp -= hp_sacrificed
        wait(3) if battler.damage != 0
        if battler.dead?
          battler.damage_pop = true
          step4_part4(battler)
          step5_part1(battler)
          step5_part2(battler)
          step5_part3(battler)
          step5_part4(battler)
        end
      end
    end
  end
end
=end