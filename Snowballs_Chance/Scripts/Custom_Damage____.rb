#==============================================================================
# Custom Damage
# By Atoa
#==============================================================================
# This script allows to create custom damage formulas for actors, enemies
# weapons and skills
#==============================================================================

module Atoa
  # Do not remove these lines
  Actor_Custom_Formula = {}
  Enemy_Custom_Formula = {}
  Weapon_Custom_Formula = {}
  Skill_Custom_Formula = {}
  Item_Custom_Formula = {} #NEW
  # Do not remove these lines
  
  #=============================================================================
  # Formula settings
  #=============================================================================
  # The formula must be an String (text)
  # All scripts commands and methos available for the Game_Battler class
  # can be used within the string
  # 
  # Use the following values to set the attacjer attack and target defense:
  # {atk} - Weapon attack of attacker
  # {str} - Strength of attacker
  # {def} - Physical defense of Target
  # 
  # Other status can be added using theis respective commands and methods.
  # To set an battler os kill, use the following commands:
  # "user" for user/attacker
  # "target" for the target
  # "skill" for skill
    
  # Formulas for actors
  # Actor_Custom_Formula[ID] = "Formula"
  
  # Damage formula for actor ID 3
  # Similar to the original formula. Replacing Strenght with Dexterity
  # (User Attack - Target Defense / 2) * (20 + User Dexterity) / 20
  #Actor_Custom_Formula[3] = "[{atk} - {def} / 2, 0].max * (20 + user.dex) / 20"
  
  # Formulas for enemies
  # Enemy_Custom_Formula[ID] = "Formula"
  
  # Formulas for weapons
  # Obs.: Weapon formulas have priority above actors formulas
  # Weapon_Custom_Formula[ID] = "Formula"
  
  
  # Speacial_Status = New Status for Weapons or Armors and
  # Speacial_Status[Action_Type] = { Action_ID => {Status => Value}} 
  #   equip_kind = kind of the equipment
  #     'Weapon' for weapons, 'Armor' for armors
  #   Action_ID = Weapon ID or Armor ID
  #   Status = Status Changed, can be equal:
  #     'hit' = Hit Rate: Hit Rate Modifier
  #     'crt' = Critical Rate: Changes the chance of causing critical hits.
  #     'dmg' = Critical Damage: Changes the damage dealt by critical hits.
  #     'rcrt' = Critical Rate Resist: Changes the chance of reciving citical hits
  #     'rdmg' = Critical Damage Resist: Changes the damage recived by critical hits.
  

  
  Weapon_Custom_Formula[1] = "({atk}/2 + rand({atk}+1)*1.5).round*{str} - {def}" #gunaxe
  Weapon_Custom_Formula[2] = "({atk} + rand({atk}+1)/8)*{str} - {def}" #sword
  Weapon_Custom_Formula[3] = "({str} + (rand({str}+1) / 4)) - {def}" #fist
  Weapon_Custom_Formula[4] = "({atk} + rand({atk}+1)/8)*user.dex - {atk} - {def}/2" #rapier
  Weapon_Custom_Formula[5] = "rand({atk}) * (({str}*2+1)-{def})" #testing
  Weapon_Custom_Formula[6] = "({atk} + rand({atk}+1) / 4) * ({str} + user.dex) / 2 - {def}" #single knife
  Weapon_Custom_Formula[7] = "[rand({atk}+1),{atk}/2].max * [(({str}+{atk})-({def})),1].max" #random axe
  Weapon_Custom_Formula[8] = "({str} + (rand({str}+1) / 4)) - {def}" #antlers
  Weapon_Custom_Formula[9] = "({atk} + rand({atk}+1))" #gun
  Weapon_Custom_Formula[10] = "({atk} + rand({atk}+1))" #gun
  Weapon_Custom_Formula[11] = "({atk} + rand({atk}+1)/8) * ({str} + user.int) / 2 - {def}" #staff
  Weapon_Custom_Formula[12] = "({atk} / 2 + rand({atk}+1)) * [(({str}+{atk})-({def})),1].max" #mace
  Weapon_Custom_Formula[13] = "({ATK}*2 + rand({ATK}+1)/8)*{STR} - {DEF}*2" #whip
  Weapon_Custom_Formula[14] = "({ATK}*2 + rand({ATK}+1)/8)*{STR} - {DEF}*2" #claws
  
  Weapon_Custom_Formula[15] = "#{Weapon_Custom_Formula[6]}" #double knives
  
  Weapon_Custom_Formula[16] = "({str} + (rand({str}+1) / 4)) - {def} + 3"  #LADLE
  
  Weapon_Custom_Formula[69] = "69" #nice
  
  # Formulas for skill
  # Obs.: Skill formulas don't consider the formulas of weapon, actors and enemies
  #   unless you add them directly creating condtions for that
  # Skill_Custom_Formula[ID] = "Formula"
  
  # This example deal fixed 1000 damage
  # (it's needed to set the variation on database to Zero)
  Skill_Custom_Formula[22] = "1000"
  Skill_Custom_Formula[3] = "({atk} + rand({atk}+1))" #assault
  Skill_Custom_Formula[4] = "({atk} + rand({atk}))/3"
  Skill_Custom_Formula[5] = "((({atk}/2 + rand({atk}+1)*1.5)*{str})*2 - {def})" #gunaxe x2
  Skill_Custom_Formula[8] = "#{Skill_Custom_Formula[5]}" #inaccurate gunaxe
  Skill_Custom_Formula[54] = "(26+rand(26+1)/8)*user.int" #shasho

  # This example the power of the attack depends on the number of potions
  # ($game_party.item_number(1) = number of potions)
  # (Number of Potions * 3 - Target Mdef / 2) * (20 + User Int) / 20
  Skill_Custom_Formula[160] = "[($game_party.item_number(1) * 3 - target.mdef / 2), 0].max * (user.int + 20) / 20"
  
  # This is an example to show that even after an break line and the text changing
  # color, the string still valid.
  # On this example, the skill damage is equal level², since enemies don't have level
  # an condition to check if the user is an actor is added. For enemies the
  # damage is equal (Strength / 10)².
  Skill_Custom_Formula[161] = "
    if user.actor?
      [user.level ** 2, 0].max
    else
      [(user.str / 10) ** 2, 0].max
    end" 

  Skill_Custom_Formula[11] = "
    if user.actor?  
    #if it's used on an actor, 
      if target.id == 12  #check the actor index
        -500
      else
        -100
      end
    else   #if not, it's just 300
      -300
      
    end" 
  
  # One example to show how other formulas can be added.
  Skill_Custom_Formula[162] = "#{Actor_Custom_Formula[3]} * 5"
  
  
  #NEW!!
  #Item_Custom_Formula[1] = ""
  #NOTE: GET DIFFERENT STUFF TO WORK DIFFERENTLY DEPENDING ON WHO IS TARGETED!!
  
  #=============================================================================
  # IMPORTANT
  #=============================================================================
  # - The power of the skill on the database must be different from Zero.
  #   If it's Zero, the skill will *ALWAYS* miss.
  # - The variance value set on the database still working normally.
  # - Other skill values from database will be used only if add to the formula
  # - You CAN skip lines inside the string (like the skill 161 example)
  #   the text value don't change it's color, showing that it's an string,
  #   but the value STILL AN STRING.
  # - If on the game, an script erro happens, and the script don't point to
  #   any line, showing the first line of the script editor.
  #   the error is on the string formula. so DON'T COMPLAIN THAT IT'S A BUG.
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Custom Damage'] = true

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Set attack power
  #     attacker : battler
  #--------------------------------------------------------------------------
  alias set_attack_power_customdamage set_attack_power
  def set_attack_power(attacker)
    if attacker.actor?
      weapon = attacker.current_weapon
      if weapon != nil and Weapon_Custom_Formula.include?(weapon.id)
        return set_custom_formula(attacker, Weapon_Custom_Formula[attacker.current_weapon.id].dup)
      elsif Actor_Custom_Formula.include?(attacker.id)
        return set_custom_formula(attacker, Actor_Custom_Formula[attacker.id].dup)
      end
    else
      if Enemy_Custom_Formula.include?(self.id)
        return set_custom_formula(attacker, Enemy_Custom_Formula[self.id].dup)
      end
    end
    return set_attack_power_customdamage(attacker)
  end
  #--------------------------------------------------------------------------
  # * Set strenght power
  #     attacker : battler
  #--------------------------------------------------------------------------
  alias set_strenght_power_customdamage set_strenght_power
  def set_strenght_power(attacker)
    if attacker.actor?
      weapon = attacker.current_weapon
      return 20 if weapon != nil and Weapon_Custom_Formula.include?(weapon.id)
      return 20 if Actor_Custom_Formula.include?(attacker.id)
    else
      return 20 if Enemy_Custom_Formula.include?(self.id)
    end
    return set_strenght_power_customdamage(attacker)
  end  
  #--------------------------------------------------------------------------
  # * Set skill power
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  alias set_skill_power_customdamage set_skill_power
  def set_skill_power(user, skill)
    if Skill_Custom_Formula.include?(skill.id)
      return set_custom_formula(user, Skill_Custom_Formula[skill.id], skill)
    end
    return set_skill_power_customdamage(user, skill)
  end
  #--------------------------------------------------------------------------
  # * Set skill multiplier
  #     user  : user
  #     skill : skill
  #--------------------------------------------------------------------------
  alias set_skill_rate_customdamage set_skill_rate
  def set_skill_rate(user, skill)
    if Skill_Custom_Formula.include?(skill.id)
      return 20
    end
    return set_skill_rate_customdamage(user, skill)
  end
  #--------------------------------------------------------------------------
  # * Set custom formula
  #     user  : user
  #     value : forumla
  #     skill : skill
  #--------------------------------------------------------------------------
  def set_custom_formula(user, value, skill = nil)
    value.gsub!(/attacker/i) {"user"}
    value.gsub!(/target/i) {"self"}
    value.gsub!(/{atk}/i) {"user.weapon_attack"}
    value.gsub!(/{str}/i) {"user.battler_strength"}
    value.gsub!(/{def}/i) {"battler_defense(user)"}
    return eval(value)
  end
end