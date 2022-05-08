=begin
#==============================================================================
# Equipment Auto States
# By Atoa
#==============================================================================
# This script allows you to create effects that stay always active if the
# actor is equiped with an equipment that gives that effect.
#==============================================================================

module Atoa
  # Do not remove this line
  Auto_Status = {'Weapon' => {}, 'Armor' => {}}
  # Do not remove this line

  # Auto_Status = Permite adicionar mais de um efeito sempre ativo para armas e armaduras
  # Auto_Status[Action_Type][Action_ID ]=> [Status,...] 
  #   Action_Type = 'Weapon' para Armas, 'Armor' para Armaduras
  #   Action_ID = ID da Arma ou Armadura
  #   Status = ID dos status permanentes.
  #
  Auto_Status['Weapon'][34] = [3,4,5,21]
  
  Auto_Status['Armor'][34] = [22,23]
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Auto States'] = true

#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
# Class that manage weapons
#==============================================================================

class RPG::Weapon
  #--------------------------------------------------------------------------
  # * Set auto states IDs
  #--------------------------------------------------------------------------
  def multi_auto_state_id
    st = Auto_Status['Weapon']
    return (st != nil and st[@id] != nil) ? st[@id] : []
  end
end

#==============================================================================
# ** RPG::Armor
#------------------------------------------------------------------------------
# Class that manage armors
#==============================================================================

class RPG::Armor
  #--------------------------------------------------------------------------
  # * Set auto states IDs
  #--------------------------------------------------------------------------
  def multi_auto_state_id
    st = Auto_Status['Armor']
    return (st != nil and st[@id] != nil) ? st[@id] : []
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_autostates setup
  def setup(actor_id)
    setup_autostates(actor_id)
    for equip in equips 
      update_multi_auto_state(nil, equip)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Auto State
  #     old_equip : unequipped armor
  #     new_equip : equipped armor
  #--------------------------------------------------------------------------
  def update_multi_auto_state(old_equip, new_equip)
    if old_equip != nil
      for state in old_equip.multi_auto_state_id
        remove_state(state, true)
      end
    end
    if new_equip != nil and not self.dead?
      for state in new_equip.multi_auto_state_id
        add_state(state, true)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id         : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  alias equip_autostates equip
  def equip(equip_type, id)
    type_id = $atoa_script['Atoa Multi Slot'] ?  @equip_kind[equip_type] : equip_type
    if type_id == 0 or ($atoa_script['Atoa Two Hands'] and type_id == 1 and two_swords_style)
      if id == 0 or $game_party.weapon_number(id) > 0
        if $atoa_script['Atoa Multi Slot'] 
          update_multi_auto_state($data_weapons[@equip_id[equip_type]], $data_weapons[id])
        else
          update_multi_auto_state($data_weapons[@weapon_id], $data_weapons[id])
        end
      end
    else
      if id == 0 or $game_party.armor_number(id) > 0
        if $atoa_script['Atoa Multi Slot'] 
          update_multi_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
        else
          update_multi_auto_state($data_armors[eval("@armor#{type_id}_id")], $data_armors[id])
        end
      end
    end
    equip_autostates(equip_type, id)
  end
end
=end