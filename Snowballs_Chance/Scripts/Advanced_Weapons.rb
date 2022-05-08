#==============================================================================
# Advanced Weapons
# By Atoa
#==============================================================================
# This script allows you to create an Advanced Weapon system.
# You can change the status that is the base for weapon damage.
# You can also set the influence of each status.
# Similar to Final Fantasy 12, where some weapons caused damage based on two
# status, or had your damage reduced by MDef.
#==============================================================================

module Atoa

  # Attack Status:
  # Here you set the attacker status that will increase de weapon damage
  # Weapon_Damage_Type = {Weapon_ID => {Status => Mult}}
  #   Weapon_ID = Weapon ID
  #   Status = Status that define the base damage of weapon.
  #   If you create an new status on game actor, you can add it too
  #   Mult = Multiplier of the status, can be decimals.
  
  Weapon_Damage_Type = {
    39 => {'str' => 0.5,'agi' => 0.5},
    40 => {'int'=> 1},
    41 => {'hp'=> 0.1},
    42 => {'level'=> 10}
    }
 
  # Defense Status:
  # Here you set the defender status that will dencrease de weapon damage
  # Weapon_Defense_Type = {Weapon_ID => {Status => Mult}}
  #   Weapon_ID = Weapon ID
  #   Status = Status that define the damage resist status.
  #   If you create an new status on game actor, you can add it too
  #   Mult = Multiplier of the status, can be decimals.
  
  Weapon_Defense_Type = {
    40 => {'mdef'=> 0.5, 'pdef'=> 0.5}
    }
    
  # The 'Status' value can be one of the following:
  #   'maxhp' = Max Hp
  #   'maxsp' = Max Sp
  #   'hp' = Current Hp
  #   'sp' = Current Sp
  #   'level' = Level
  #   'atk'  = Attack
  #   'pdef' = Physical Defense
  #   'mdef' = Magic Defense
  #   'str'  = Strength
  #   'dex'  = Dexterity
  #   'int'  = Intelligence
  #   'agi'  = Agility
  #   'eva'  = Evasion
  #   'hit'  = Hit Rate
  #   'crt'  = Critical Rate (only if using the "Add | New Status")
  #   'dmg'  = Critical Damage (only if using the "Add | New Status")
  #   'rcrt' = Critical Rate Resist (only if using the "Add | New Status")
  #   'rdmg' = Critical Damage Resist (only if using the "Add | New Status")
  #  if you create an new status on Game_Actor class, you can set them too.

  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Advanced Weapons'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Get battler strengh
  #--------------------------------------------------------------------------
  alias battler_strength_advancedweapons battler_strength
  def battler_strength
    if self.actor?
      weapon = self.weapons[0]
      if weapon != nil and Weapon_Damage_Type.include?(action_id(weapon))
        pwr = 0
        for stat in Weapon_Damage_Type[action_id(weapon)]
          pwr += eval("(self.#{stat[0]} * #{stat[1]}).to_i")
        end
        return pwr
      end
    end
    return battler_strength_advancedweapons
  end
  #--------------------------------------------------------------------------
  # * Get battler defense
  #     battler : battler
  #--------------------------------------------------------------------------
  alias battler_defense_advancedweapons battler_defense
  def battler_defense(battler)
    if battler.actor?
      weapon = battler.weapons[0]
      if weapon != nil and Weapon_Defense_Type.include?(action_id(weapon))
        defense = 0
        for stat in Weapon_Defense_Type[action_id(weapon)]
          defense += eval("(self.#{stat[0]} * #{stat[1]}).to_i")
        end
        return defense
      end
    end
    return battler_defense_advancedweapons(battler)
  end
end