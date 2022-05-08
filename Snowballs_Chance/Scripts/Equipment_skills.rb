#==============================================================================
# Equipment with skills
# By Atoa
#==============================================================================
# This script allows you to set equipments that adds skills to actors when
# equiped. You can also ser an required level to the skills to be avaliable
# and set some skills to never be avaliable for an actor.
#==============================================================================

module Atoa
  # Do not remove or change these lines
  Equip_Skills = {'Weapon' => {}, 'Armor' => {}}
  Skill_Restriction = {}
  # Do not remove or change these lines

  # Equip_Skills[Equip_Type] = {Equip_ID => {Min_Level => Skill_ID}}
  #  Equip_Type = 'Weapon' for weapons, 'Armor' for armor
  #  Equips_ID = ID of the equipment
  #  Min_Level = minimum level required for learning the skill
  #  Skill_ID = id of the skill learned
  
  #Equip_Skills['Armor'][40] = {1 => 1, 15 => 2, 30 => 3}
  
  Equip_Skills['Weapon'][1] = {1 => 4, 1 => 5} 
  #gunblitz and lethal strike
  
  # Set the skills that the actor won't learn with equipments.
  # Skill_Restriction[Actor_ID] = [Skill_IDs]
  
  Skill_Restriction[3] = [4, 5] 
  #cleaver doesn't learn gunblitz and lethal strike
  
  #Skill_Restriction[1] = [1, 2, 3]
  
  #=============================================================================

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Equiment Skill'] = true

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
  alias setup_equiskill setup
  def setup(actor_id)
    @equipment_skills = []
    setup_equiskill(actor_id)
    gain_equip_skills
  end
  #--------------------------------------------------------------------------
  # * Change level
  #--------------------------------------------------------------------------
  alias level_change_equiskill level_change
  def level_change
    lose_equip_skills
    level_change_equiskill
    gain_equip_skills
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id         : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  alias equip_equiskill equip
  def equip(equip_type, id)
    equip_equiskill(equip_type, id)
    gain_equip_skills
  end
  #-------------------------------------------------------------------------- 
  # * Gain Equiment Skills
  #-------------------------------------------------------------------------- 
  def gain_equip_skills
    lose_equip_skills
    for eqp in equips
      next if eqp.nil?
      if Equip_Skills[eqp.type_name] != nil and
         Equip_Skills[eqp.type_name][action_id(eqp)] != nil
        skills = Equip_Skills[eqp.type_name][action_id(eqp)].dup
        for skill in skills.keys
          next if Skill_Restriction[@actor_id] != nil and
                  Skill_Restriction[@actor_id].include?(skills[skill])
          get_new_equip_skill(skills[skill]) if skill <= @level
        end
      end
    end
  end
  #-------------------------------------------------------------------------- 
  # * Lose Equiment Skills
  #-------------------------------------------------------------------------- 
  def lose_equip_skills
    for skill_id in @equipment_skills
      self.forget_skill(skill_id)
    end
    @equipment_skills.clear
  end
  #-------------------------------------------------------------------------- 
  # * Lear New Equiment Skills
  #     skill_id : skill ID
  #-------------------------------------------------------------------------- 
  def get_new_equip_skill(skill_id)
    unless self.skill_learn?(skill_id) or @equipment_skills.include?(skill_id)
      @equipment_skills << skill_id
      self.learn_skill(skill_id)
    end
  end
end