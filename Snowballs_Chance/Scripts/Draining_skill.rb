#==============================================================================
# Skill Drain
# By Atoa
#==============================================================================
# This script allow to create skills and equips that adds the effect 'drain'
# of HP and SP.
# That way attacks and skills can absorb part of the damage caused
#==============================================================================
=begin
module Atoa
  # Do not remove this line
  Drain_Action = {'Skill' => {}, 'Weapon' => {}, 'Item' => {}}
  # Do not remove this line
  
  # Drain_Action[action_type][id] = {drain_type => [success, rate, anim_id, pop, show_excedent],...}
  # action_type = action type
  #   action_type = 'Skill' for skills, 'Weapon' for weapons, 'Item' for items
  # id = ID of the skill/weapon/item
  # drain_type = drain type
  #   'hp' for HP drain, 'sp' for SP drain
  # success = absorb success rate
  # rate = % of damage converted in HP/SP
  # anim_id = ID of the animation shown when absorb HP/SP, leave nil or 0 for
  #   no animation
  # 
  
  Drain_Action['Skill'][63] = {'hp' => [100, 50, nil, true, false], 'sp' =>[100, 50, 18, true, false]}
  #Drain_Action['Weapon'][43] = {'hp' => [50, 50, nil, true, true]}
  
  #Drain_Action['Skill'][5] = {'hp' => [100, -33, 10, true, false]} #moved over to other 
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Drain'] = true

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# This class manages the battle players.
# This class identifies Allies or Heroes as (Game_Actor) and
# the Enemies like (Game_Enemy).
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # Public Variables
  #--------------------------------------------------------------------------
  attr_accessor :base_absorb
  #--------------------------------------------------------------------------
  # Initialize the object
  #--------------------------------------------------------------------------
  alias initialize_drain initialize
  def initialize
    initialize_drain
    @base_absorb = 0
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# This class processes the Battle screen
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # Update of phase 4 of the character (part 2)
  #     battler : Battler ativo
  #--------------------------------------------------------------------------
alias step4_part2_drain step4_part2
  def step4_part2(battler)
    step4_part2_drain(battler)
    set_drain_damage(battler)
  end
  #--------------------------------------------------------------------------
  # Update of phase 4 of the character (part 3)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step4_part3_drain step4_part3
  def step4_part3(battler)
    step4_part3_drain(battler)
    action = battler.now_action
    if action != nil and Drain_Action[action.type_name] != nil and
       Drain_Action[action.type_name].include?(action_id(action))
      absorb_damage(battler, battler.base_absorb, Drain_Action[action.type_name][action_id(action)].dup)
    end
  end
  #--------------------------------------------------------------------------
  # Define Drain Damage
  #     battler : Active battler
  #--------------------------------------------------------------------------
  def set_drain_damage(battler)
    battler.base_absorb = 0
    for target in battler.target_battlers
      battler.base_absorb += target.damage if target.damage.numeric?
    end
  end
  #--------------------------------------------------------------------------
  # Absorb damage
  #     battler : active battler
  #     absorb  : absorb value
  #     action  : action
  #--------------------------------------------------------------------------
  def absorb_damage(battler, absorb, action)
    for type in action.keys
      if type == 'hp' and (action[type][0] >= rand(100))
        base_absorb = ((absorb * action[type][1]) / 100).to_i 
        
        #base absorb is [absorb] times (action type) divided by 100
        
        if base_absorb > 0
          difference = battler.maxhp - battler.hp 
          #the difference between the max health and the current health
          base_absorb = [base_absorb, difference].min
          
          #if the absorb is a positive number, 
          #make it either the health difference, or just the straight number
          #that was determined earlier.
          #this is to avoid overhealing I assume
          
        elsif base_absorb < 0 
          base_absorb = [base_absorb, - battler.hp].max
          #if it's a negative number, either give it the negative amount, 
          #or make it 
        end
        if base_absorb != 0 
          #if the absorb amount is larger than zero
          battler.damage = - base_absorb
          #remove the absorb amount from the damage
          
          #battler.hp -= battler.damage
          #remove the damage from the hp
          battler.animation_id = action[type][2].nil? ? 0 : action[type][2]
          battler.damage_pop = action[type][3]
          #then make the 
          wait(3) if battler.damage != 0
        end
      end
      if type == 'sp' and (action[type][0] >= rand(100))
        base_absorb = ((absorb * action[type][1]) / 100).to_i
        if base_absorb > 0
          difference = battler.maxsp - battler.sp
          base_absorb = [base_absorb, difference].min
        elsif base_absorb < 0 
          base_absorb = [base_absorb, - battler.sp].max
        end
        if base_absorb != 0
          battler.damage = - base_absorb
          battler.sp -= battler.damage
          battler.animation_id = action[type][2].nil? ? 0 : action[type][2]
          battler.damage_pop = action[type][3]
          battler.sp_damage = action[type][3]
          wait(3) if battler.damage != 0
        end
      end
    end
  end
end
=end