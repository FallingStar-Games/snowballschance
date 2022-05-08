#==============================================================================
# Consume Items Actions
# By Atoa
#==============================================================================
# This script allows you to create skills and weapons that consume itens
# when used
# 
# That way you can make bows that needs arrows or something like that
#
# There are two types of consume:
# 1 - Consum items from the inventory
#   On this type, it's necessary to have all items set on the amount needed,
#   and all needed items are used up.
#   Useful to create skills that needs an combination of ingredients to be cast.
# 2 - Consum equiped items
#   On this type, you need to be equiped with one of the items configurated.
#   Only the equiped item are consumed.
#   An good way to maker bows that consum arrows, that way you can make
#   arrows with different propieties.
#==============================================================================
  
module Atoa
  
  # Do not remove or change these lines
  Weapon_Need_Items = {}
  Skill_Need_Items = {}
  Weapon_Need_Equiped = {}
  Skill_Need_Equiped = {}
  # Do not remove or change these lines
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CONSUM ITEM FROM IVENTORY
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # The weapons and skills configurated here needs all the items listed
  # to be used. All items needed are consumed on the ammount defined.

  #  Weapon_Need_Items[Weapon ID] = [[Type, ID consum, Ammount]]
  #    Weapon ID = Id of the weapon that need the items
  #    Type = Type of the item consumed. must be equal:
  #      'i' = for items
  #      'a' = for armors
  #      'w' = for weapons
  # You can anda as many items you want to be consumed.
  #  E.g.: Weapon_Need_Items[25] = [['i', 25, 2],['i', 17, 1],['a', 13, 1]]
  Weapon_Need_Items[17] = [['i', 34, 1]]
  Weapon_Need_Items[18] = [['i', 34, 1]]
  Weapon_Need_Items[19] = [['i', 34, 1]]
  Weapon_Need_Items[20] = [['i', 34, 1]]
  
  #  Skill_Need_Items[Skill ID] = [[Type, ID consum, Ammount]]
  #    Skill ID = Id of the skill that need the items
  #    Type = Type of the item consumed. must be equal:
  #      'i' = for items
  #      'a' = for armors
  #      'w' = for weapons
  # You can anda as many items you want to be consumed.
  #  E.g.: Skill_Need_Items[25] = [['i', 25, 2],['i', 17, 1],['a', 13, 1]]
  Skill_Need_Items[73] = [['i', 34, 1]]
  Skill_Need_Items[74] = [['i', 34, 1]]
  Skill_Need_Items[75] = [['i', 34, 1]]
  Skill_Need_Items[76] = [['i', 34, 1]]
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CONSUM EQUIPED ITEMS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # The weapons and skills configurated here needs that one of the listed items
  # equiped to be used. Only the equiped item are consumed, even if you have
  # the other listed items on you inventory.

  #  Weapon_Need_Equiped[Weapon ID] = [[Type, ID consum, Ammount]]
  #    Weapon ID = Id of the weapon that need the items
  #    Type = Type of the item consumed. must be equal:
  #      'a' = for armors
  #      'w' = for weapons
  #    (remember that items can't be equiped, only armors and weapons)
  # You can add as many items you want, that way you can set differents "ammos"
  # to the same weapon
  #  E.g.: Weapon_Need_Equiped[25] = [['a',41, 1],['a',42, 1]]
  Weapon_Need_Equiped[21] = [['a',41, 1],['a',42, 1]]
  Weapon_Need_Equiped[22] = [['a',41, 1],['a',42, 1]]
  Weapon_Need_Equiped[23] = [['a',41, 1],['a',42, 1]]
  Weapon_Need_Equiped[24] = [['a',41, 1],['a',42, 1]]
  
  #  Skill_Need_Equiped[Weapon ID] = [[Type, ID consum, Ammount]]
  #    Skill ID = Id of the skill that need the items
  #    Type = Type of the item consumed. must be equal:
  #      'a' = for armors
  #      'w' = for weapons
  #    (remember that items can't be equiped, only armors and weapons)
  # You can add as many items you want, that way you can set differents "ammos"
  # to the same skill
  #  E.g.: Skill_Need_Equiped[25] = [['a',41, 1],['a',42, 1]]
  Skill_Need_Equiped[77] = [['a',41, 3],['a',42, 3]]
  Skill_Need_Equiped[78] = [['a',41, 1],['a',42, 1]]
  Skill_Need_Equiped[79] = [['a',41, 1],['a',42, 1]]
  Skill_Need_Equiped[80] = [['a',41, 5],['a',42, 5]]
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Action Consum Item'] = true

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  alias skill_can_use_itemskill skill_can_use?
  def skill_can_use?(skill_id)
    if Skill_Need_Items.include?(skill_id) or Skill_Need_Equiped.include?(skill_id)
      return false unless check_item_needed('Skill', skill_id)
    end
    return skill_can_use_itemskill(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Check needed items
  #     type : action type
  #     id   : action ID
  #--------------------------------------------------------------------------
  def check_item_needed(type, id)
    action = eval(type + '_Need_Items.dup')
    equipment = eval(type + '_Need_Equiped.dup')
    if action.include?(id)
      for need in action[id]
        next if need[0] == 'i' and $game_party.item_number(need[1]) >= need[2]
        next if need[0] == 'a' and $game_party.armor_number(need[1]) >= need[2]
        next if need[0] == 'w' and $game_party.weapon_number(need[1]) >= need[2]
        return false
      end
    end
    if equipment.include?(id)
      for need in equipment[id]
        equipments = armors.dup if need[0] == 'a'
        equipments = weapons.dup if need[0] == 'w'
        for equip in equipments
          if action_id(equip) == need[1] and (need[0] == 'a' and 
             $game_party.armor_number(need[1]) >= [need[2] - 1, 0].max) or
             (need[0] == 'w' and $game_party.weapon_number(need[1]) >= [need[2] - 1, 0].max)
            return true 
          end
        end
      end
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Consume skill cost
  #     skill : skill
  #--------------------------------------------------------------------------
  alias consume_skill_cost_itemskill consume_skill_cost
  def consume_skill_cost(skill)
    if Skill_Need_Items.include?(skill.id) or Skill_Need_Equiped.include?(skill.id)
      consume_item('Skill', skill.id)
    end
    consume_skill_cost_itemskill(skill)
  end
  #--------------------------------------------------------------------------
  # * Consume items
  #     type : action type
  #     id   : action ID
  #--------------------------------------------------------------------------
  def consume_item(type, id)
    action = eval(type + '_Need_Items.dup')
    equipment = eval(type + '_Need_Equiped.dup')
    if action.include?(id)
      for need in action[id]
        $game_party.lose_item(need[1], need[2]) if need[0] == 'i' 
        $game_party.lose_armor(need[1], need[2]) if need[0] == 'a' 
        $game_party.lose_weapon(need[1], need[2]) if need[0] == 'w' 
      end
    end
    if equipment.include?(id)
      if $atoa_script['Atoa Multi Slot']
        for need in equipment[id]
          equipments = armors.dup if need[0] == 'a'
          equipments = weapons.dup if need[0] == 'w'
          for i in 0...equips.size
            if action_id(equip[i]) == need[1]
              equip(i, 0)
              $game_party.lose_armor(need[1], need[2]) if need[0] == 'a'
              $game_party.lose_weapon(need[1], need[2]) if need[0] == 'w'
              equip(i, equip[i].id)
            end
          end
        end
      else
        for need in equipment[id]
          equipments = armors.dup if need[0] == 'a'
          equipments = weapons.dup if need[0] == 'w'
          for equip in equipments
            if equip.type_name == 'Weapon'
              type = 0
            else
              type = 1 if equip.id == @armor1_id
              type = 2 if equip.id == @armor2_id
              type = 3 if equip.id == @armor3_id
              type = 4 if equip.id == @armor4_id
            end
            if action_id(equip) == need[1]
              equip(type, 0)
              $game_party.lose_armor(need[1], need[2]) if need[0] == 'a'
              $game_party.lose_weapon(need[1], need[2]) if need[0] == 'w'
              equip(type, equip.id)
            end
          end
        end
      end
    end
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_itemskill phase3_setup_command_window
  def phase3_setup_command_window
    weapon = @active_battler.weapons[0]
    if weapon != nil and (Weapon_Need_Items.include?(action_id(weapon)) or
       Weapon_Need_Equiped.include?(action_id(weapon)))
      unless @active_battler.check_item_needed('Weapon', action_id(weapon)) 
        @active_battler.disabled_commands << $data_system.words.attack
        @active_battler.disabled_commands.uniq!
      else
        @active_battler.disabled_commands.delete($data_system.words.attack)
      end
    end
    phase3_setup_command_window_itemskill
  end
  #--------------------------------------------------------------------------
  # * Confirm Attack Selection
  #--------------------------------------------------------------------------
  alias confirm_attack_select_itemskill confirm_attack_select
  def confirm_attack_select
    weapon = @active_battler.weapons[0]
    if weapon != nil and (Weapon_Need_Items.include?(action_id(weapon)) or
       Weapon_Need_Equiped.include?(action_id(weapon)))
      unless @active_battler.check_item_needed('Weapon', action_id(weapon)) 
        $game_system.se_play($data_system.buzzer_se)
        return 
      end
    end
    confirm_attack_select_itemskill
  end
  #--------------------------------------------------------------------------
  # * Make Basic Action Result
  #     battler : battler
  #--------------------------------------------------------------------------
  alias make_basic_action_result_itemskill make_basic_action_result
  def make_basic_action_result(battler)
    if battler.current_action.basic == 0 and battler.actor?
      weapon = battler.weapons[0]
      if weapon != nil and (Weapon_Need_Items.include?(action_id(weapon)) or
         Weapon_Need_Equiped.include?(action_id(weapon)))
        battler.consume_item('Weapon', action_id(weapon))
      end
    end
    make_basic_action_result_itemskill(battler)
  end
end