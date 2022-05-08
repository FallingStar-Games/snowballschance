#==============================================================================
# Two Hands
# By Atoa
#
# IMPORTANT NOTE!!!! THIS SCRIPT DOES NOT WORK WITH CUSTOM DAMAGE!!
# THIS SCRIPT IS DISABLED UNTIL FURTHER DEVELOPMENTS!!!
#
#==============================================================================
# This script allows to create an system where the actor can equip 
# two handed weapons or two weapons, also create weapons for the right hand
# only and for the left hand only
#==============================================================================
=begin
module Atoa
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # DUAL WIELDING SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set wich actors or classes can use two weapons
  
  # Second Attack Pose ID
  Second_Attack_Pose = 7
  
  # Attack power rate for normal attacks when using more than one weapon
  Dual_Attack_Power = 100
  
  # Attack power rate for skills when using more than one weapon
  Dual_Skill_Power = 100
  
  # ID of the skills that will have extra hits when using two weapons
  Dual_Hit_Skill = [57,58,59,60]
  
  # Actors that uses two weapons, add here their ids
  Two_Swords_Actors = [1,8]

  # Classes that uses two weapons, add here their ids
  Two_Swords_Classes = []
  
  # You can add or remove the dual wielding feature with script calls.
  # 
  # $game_party.two_swords_actors_add(Actor ID)
  #  to add the dual wielding to an actor.
  #
  # $game_party.two_swords_actors_remove(Actor ID)
  #  to remove the dual wielding from an actor.
  #
  # $game_party.two_swords_classes_add(Class ID)
  #  to add the dual wielding to an class.
  #
  # $game_party.two_swords_classes_remove(Class ID)
  #  to remove the dual wielding from an class.
  #
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # RIGHT HAND AND LEFT HAND EQUIP SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set wich hand the equip can be used
  # Just add their ids bellow
  
  # Two Handed weapons
  Two_Hands_Weapons = [10]
  
  # Right Hand only Weapons
  Right_Hand_Weapons = []
  
  # Left Hand only Weapons
  Left_Hand_Weapons = [9]
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Two Hands'] = true

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
# Class that manage skills
#==============================================================================

class RPG::Skill
  #--------------------------------------------------------------------------
  # * Get double hit skill flag
  #--------------------------------------------------------------------------
  def double_hit?
    return Dual_Hit_Skill.include?(@id)
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :two_swords_actors
  attr_accessor :two_swords_classes
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_twohands initialize
  def initialize
    initialize_twohands
    @two_swords_actors = Two_Swords_Actors.dup
    @two_swords_classes = Two_Swords_Classes.dup
  end
  #--------------------------------------------------------------------------
  # * Add two sword style for actor
  #--------------------------------------------------------------------------
  def two_swords_actors_add(id)
    actor = $game_actors[id]
    actor.remove_left_equip_actor
    @two_swords_actors << id
    @two_swords_actors.compact!
  end
  #--------------------------------------------------------------------------
  # * Remove two sword style for actor
  #--------------------------------------------------------------------------
  def two_swords_actors_remove(id)
    actor = $game_actors[id]
    actor.remove_left_equip_actor
    @two_swords_actors.delete(id)
    @two_swords_actors.compact!
  end
  #--------------------------------------------------------------------------
  # * Add two sword style for class
  #--------------------------------------------------------------------------
  def two_swords_classes_add(id)
    for actor in @actors
      actor.remove_left_equip_class(id)
    end
    @two_swords_classes << id
    @two_swords_classes.compact!
  end
  #--------------------------------------------------------------------------
  # * Remove two sword style for class
  #--------------------------------------------------------------------------
  def two_swords_classes_remove(id)
    for actor in @actors
      actor.remove_left_equip_class(id)
    end
    @two_swords_classes.delete(id)
    @two_swords_classes.compact!
  end
end

#==============================================================================
# ** Game_Battler (part 1)
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :multi_attack
  attr_accessor :selected_weapon
  attr_accessor :attack_count

  #--------------------------------------------------------------------------
  # * Set final attack damage
  #     attacker : battler
  #--------------------------------------------------------------------------
  alias set_attack_damage_twohands set_attack_damage
  def set_attack_damage(attacker)
    if self.multi_attack and self.now_action.is_a?(RPG::Weapon)
      set_damage(attacker, self.current_weapon)
    else
      set_attack_damage_twohands(attacker)
    end
  end
  #--------------------------------------------------------------------------
  # * Get weapon attack
  #--------------------------------------------------------------------------
  alias weapon_attack_twohands weapon_attack
  def weapon_attack
    if self.multi_attack and (self.now_action.is_a?(RPG::Weapon) or 
       (self.now_action.is_a?(RPG::Skill) and self.now_action.double_hit? and
       self.current_weapon.is_a?(RPG::Weapon)))
      return ((self.current_weapon.atk * Dual_Attack_Power) /100)
    elsif self.multi_attack and self.now_action.is_a?(RPG::Skill)
      return ((self.atk * Dual_Attack_Power) / 100)
    else
      return weapon_attack_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Get battler strengh
  #--------------------------------------------------------------------------
  alias battler_strength_twohands battler_strength
  def battler_strength
    if $atoa_script['Atoa Advanced Weapons'] and self.multi_attack and 
       (self.now_action.is_a?(RPG::Weapon) or (self.now_action.is_a?(RPG::Skill) and 
       self.now_action.double_hit? and self.current_weapon.is_a?(RPG::Weapon)))
      weapon = self.current_weapon
      if weapon != nil and Weapon_Damage_Type.include?(action_id(weapon))
        pwr = 0
        for stat in Weapon_Damage_Type[action_id(weapon)]
          pwr += eval("(self.#{stat[0]} * #{stat[1]}).to_i")
        end
        return pwr
      end
    end
    return battler_strength_twohands
  end
  #--------------------------------------------------------------------------
  # * Get weapon variance
  #--------------------------------------------------------------------------
  alias weapon_variance_twohands weapon_variance
  def weapon_variance
    if self.multi_attack and (self.now_action.is_a?(RPG::Weapon) or 
       (self.now_action.is_a?(RPG::Skill) and self.now_action.double_hit? and
       self.current_weapon.is_a?(RPG::Weapon)))
      weapon = self.current_weapon
      ext = check_extension(weapon, 'DMGVARIANCE/')
      return ext.nil? ? Base_Variance : ext.to_i
    else
      return weapon_variance_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Get weapon crital rate
  #--------------------------------------------------------------------------
  alias weapon_critical_twohands weapon_critical
  def weapon_critical
    if self.multi_attack and (self.now_action.is_a?(RPG::Weapon) or 
       (self.now_action.is_a?(RPG::Skill) and self.now_action.double_hit? and
       self.current_weapon.is_a?(RPG::Weapon)))
      n = self.current_weapon.crt
      for item in armors.compact do n += item.crt end
      return n
    else
       return weapon_critical_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Get weapon crital damage
  #--------------------------------------------------------------------------
  alias weapon_critical_damage_twohands weapon_critical_damage
  def weapon_critical_damage
    if self.multi_attack and (self.now_action.is_a?(RPG::Weapon) or 
       (self.now_action.is_a?(RPG::Skill) and self.now_action.double_hit? and
       self.current_weapon.is_a?(RPG::Weapon)))
      n = self.current_weapon.dmg
      for item in armors.compact do n += item.dmg end
      return n
    else
       return weapon_critical_damage_twohands 
       #edit, was weapon_critical_twohands_damage
    end
  end
  #--------------------------------------------------------------------------
  # * Set SP damage
  #     battler : battler
  #     action : Ação
  #--------------------------------------------------------------------------
  alias set_sp_damage_twohands set_sp_damage
  def set_sp_damage(battler, action)
    if battler.multi_attack and (battler.now_action.is_a?(RPG::Weapon) or 
       (battler.now_action.is_a?(RPG::Skill) and battler.now_action.double_hit? and
       battler.current_weapon.is_a?(RPG::Weapon)))
      self.sp_damage = check_include(battler.current_weapon, 'SPDAMAGE')
    else
      set_sp_damage_twohands(battler, action)
    end
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :two_swords_style
  #--------------------------------------------------------------------------
  # * Two sword style flag
  #--------------------------------------------------------------------------
  def two_swords_style
    return true if $game_party.two_swords_actors.include?(@actor_id)
    return true if $game_party.two_swords_classes.include?(@class_id)
    return false
  end
  #--------------------------------------------------------------------------
  # * Get weapons
  #--------------------------------------------------------------------------
  alias weapons_twohands weapons
  def weapons
    if two_swords_style and not $atoa_script['Atoa Multi Slot']
      result = [$data_weapons[@weapon_id], $data_weapons[@armor1_id]]
      result .delete_if {|x| x == nil }
      return result 
    else
      return weapons_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Get armors
  #--------------------------------------------------------------------------
  alias armors_twohands armors
  def armors
    if two_swords_style and not $atoa_script['Atoa Multi Slot']
      result  = [$data_armors[@armor2_id], $data_armors[@armor3_id], $data_armors[@armor4_id]]
      result.delete_if {|x| x == nil }
      return result 
    else
      return armors_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Get current weapon
  #--------------------------------------------------------------------------
  alias current_weapon_twohands current_weapon
  def current_weapon
    if @selected_weapon != nil
      return @selected_weapon
    esle
      return current_weapon_twohands
    end
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id         : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  alias equip_twohands equip
  def equip(equip_type, id)
    if equip_type == 1 and two_swords_style and not $atoa_script['Atoa Multi Slot']
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_weapon(id, 1)
        return
      end
    end
    equip_twohands(equip_type, id)
  end
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_twohands refresh
  def refresh
    unless $atoa_script['Atoa Multi Slot']
      self.contents.clear
      draw_actor_graphic(@actor, 40, 112)
      draw_actor_name(@actor, 4, 0)
      draw_actor_class(@actor, 4 + 144, 0)
      draw_actor_level(@actor, 96, 32)
      draw_actor_state(@actor, 96, 64)
      draw_actor_hp(@actor, 96, 112, 172)
      draw_actor_sp(@actor, 96, 144, 172)
      status_size = Object.const_defined?(:Extra_Status) ? Extra_Status.size : 0 
      for i in 0..2
        draw_actor_parameter(@actor, 96, 164 + [(236/(status_size + 6)), 20].max * i, i)
      end
      for i in 3..6
        draw_actor_parameter(@actor, 96, 168 + [(236/(status_size + 6)), 20].max * i, i)
      end
      for i in 7..(status_size + 6)
        draw_actor_parameter(@actor, 96, 172 + [(236/(status_size + 6)), 20].max * i, Extra_Status[i - 7])
      end
      self.contents.font.color = system_color
      self.contents.draw_text(320, 48, 80, 32, "EXP")
      self.contents.draw_text(320, 80, 80, 32, "Próximo")
      self.contents.draw_text(320, 160, 96, 32, "Equipamento")
      self.contents.font.color = normal_color
      self.contents.draw_text(320 + 80, 48, 84, 32, @actor.exp_s, 2)
      self.contents.draw_text(320 + 80, 80, 84, 32, @actor.next_rest_exp_s, 2)
      draw_item_name($data_weapons[@actor.weapon_id], 320 + 16, 208)
      if @actor.two_swords_style
        draw_item_name($data_weapons[@actor.armor1_id], 320 + 16, 256)
      else
        draw_item_name($data_armors[@actor.armor1_id], 320 + 16, 256)
      end
      draw_item_name($data_armors[@actor.armor2_id], 320 + 16, 304)
      draw_item_name($data_armors[@actor.armor3_id], 320 + 16, 352)
      draw_item_name($data_armors[@actor.armor4_id], 320 + 16, 400)
    else
      refresh_twohands
    end
  end
end

#==============================================================================
# ** Window_EquipRight
#------------------------------------------------------------------------------
#  This window displays items the actor is currently equipped with on the
#  equipment screen.
#==============================================================================

class Window_EquipRight < Window_Selectable
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_twohands refresh
  def refresh
    unless $atoa_script['Atoa Multi Slot']
      self.contents.clear
      @data = []
      @data.push($data_weapons[@actor.weapon_id])
      if @actor.two_swords_style
        @data.push($data_weapons[@actor.armor1_id])
      else
        @data.push($data_armors[@actor.armor1_id])
      end
      @data.push($data_armors[@actor.armor2_id])
      @data.push($data_armors[@actor.armor3_id])
      @data.push($data_armors[@actor.armor4_id])
      @item_max = @data.size
      self.contents.font.color = system_color
      self.contents.draw_text(4, 32 * 0, 92, 32, $data_system.words.weapon)
      if @actor.two_swords_style
        self.contents.draw_text(4, 32 * 1, 92, 32, $data_system.words.weapon)
      else
        self.contents.draw_text(4, 32 * 1, 92, 32, $data_system.words.armor1)
      end
      self.contents.draw_text(4, 32 * 2, 92, 32, $data_system.words.armor2)
      self.contents.draw_text(4, 32 * 3, 92, 32, $data_system.words.armor3)
      self.contents.draw_text(5, 32 * 4, 92, 32, $data_system.words.armor4)
      draw_item_name(@data[0], 92, 32 * 0)
      draw_item_name(@data[1], 92, 32 * 1)
      draw_item_name(@data[2], 92, 32 * 2)
      draw_item_name(@data[3], 92, 32 * 3)
      draw_item_name(@data[4], 92, 32 * 4)
    else
      refresh_twohands
    end
  end
end

#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
#  equipment screen.
#==============================================================================

class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_twohands refresh
  def refresh
    if @actor.two_swords_style and not $atoa_script['Atoa Multi Slot'] 
      if self.contents != nil
        self.contents.dispose
        self.contents = nil
      end
      @data = []
      if @equip_type == 0 or (@equip_type == 1 and @actor.two_swords_style)
        weapon_set = $data_classes[@actor.class_id].weapon_set
        for i in 1...$data_weapons.size
          next if Two_Hands_Weapons.include?(i) and @equip_type == 1
          next if Right_Hand_Weapons.include?(i) and @equip_type == 1
          next if Left_Hand_Weapons.include?(i) and @equip_type == 0
          if $game_party.weapon_number(i) > 0 and weapon_set.include?(i)
            @data.push($data_weapons[i])
          end
        end
      end
      if @equip_type > 1 or (@equip_type == 1 and not @actor.two_swords_style)
        armor_set = $data_classes[@actor.class_id].armor_set
        for i in 1...$data_armors.size
          if $game_party.armor_number(i) > 0 and armor_set.include?(i)
            if $data_armors[i].type_id == @equip_type
              @data.push($data_armors[i])
            end
          end
        end
      end
      @data.push(nil)
      @item_max = @data.size
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max-1
        draw_item(i)
      end
    else
      refresh_twohands
    end
  end
end

#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs equipment screen processing.
#==============================================================================

class Scene_Equip
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Frame Update (when right window is active)
  #--------------------------------------------------------------------------
  alias update_right_twohands update_right
  def update_right
    if (Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)) and not 
       $atoa_script['Atoa Multi Slot']
      @item_window.index = -1
      @item_window.refresh
      return
    end
    update_right_twohands
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  alias update_item_twohands update_item
  def update_item
    if Input.trigger?(Input::C) and not $atoa_script['Atoa Multi Slot']
      item = @item_window.item
      @actor.equip(@right_window.index, item == nil ? 0 : item.id)
      update_hands(item)
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      @right_window.refresh
      @item_window.refresh
      $game_system.se_play($data_system.equip_se)
      return
    end
    update_item_twohands
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_twohands refresh
  def refresh
    refresh_twohands 
    if @item_window.active and not $atoa_script['Atoa Multi Slot']
      item1 = @right_window.item
      item2 = @item_window.item
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      if item2 != nil and item2.type_id == 0 and Two_Hands_Weapons.include?(item2.id)
        if @actor.armor1_id != 0
          actor_reequip = [1, @actor.armor1_id]
          @actor.equip(1, 0)
        end
      elsif item2 != nil and (item2.type_id == 1 or (item2.type_id == 0 and
          @actor.two_swords_style))
        if @actor.weapon_id != 0 and Two_Hands_Weapons.include?(@actor.weapon_id)
          actor_reequip = [0, @actor.weapon_id]
          @actor.equip(0, 0)
        end
      end
      new_atk = @actor.atk
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      if actor_reequip != nil
        @actor.equip(actor_reequip[0], actor_reequip[1])
      end
      @actor.hp = last_hp
      @actor.sp = last_sp
      @left_window.set_new_parameters(new_atk, new_pdef, new_mdef)
    end
  end
  #--------------------------------------------------------------------------
  # * Update both hands equipment
  #     item : equipamento
  #--------------------------------------------------------------------------
  def update_hands(item)
    unless $atoa_script['Atoa Multi Slot']
      if item != nil and item.type_id == 0 and Two_Hands_Weapons.include?(item.id)
        @actor.equip(1, 0)
      elsif item != nil and (item.type_id == 1 or (item.type_id == 0 and
            @actor.two_swords_style))
        @actor.equip(0, 0) if @actor.current_weapon != nil and
                              Two_Hands_Weapons.include?(@actor.current_weapon.id)
      end
    else
      if item != nil and item.type_id == 0 and Two_Hands_Weapons.include?(item.id)
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          @actor.equip(i, 0) if id == 1
        end
      elsif item != nil and (item.type_id == 1 or (item.type_id == 0 and @actor.two_swords_style))
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          if @right_window.index != i and id == 0 and 
             Two_Hands_Weapons.include?(@actor.equip_id[id])
            @actor.equip(i, 0)
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
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_towhands step3_part1
  def step3_part1(battler)
    now_action(battler)
    if battler.actor? and battler.weapons.size > 1 and
      (battler.now_action.is_a?(RPG::Weapon) or battler.now_action.is_a?(RPG::Skill))
      battler.multi_attack = true
    end
    step3_part1_towhands(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_towhands step5_part4
  def step5_part4(battler)
    battler.multi_attack = false
    battler.selected_weapon = nil
    step5_part4_towhands(battler)
  end
  #--------------------------------------------------------------------------
  # * Set hit number
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_hit_number_towhands set_hit_number
  def set_hit_number(battler)
    set_hit_number_towhands(battler)
    if battler.multi_attack and (not battler.now_action.is_a?(RPG::Skill) or
       (battler.now_action.is_a?(RPG::Skill) and battler.now_action.double_hit?))
      sequence = battler.weapons.dup
      battler.attack_count = 0
      battler.current_action.action_sequence = sequence + action_sequences(battler, battler_action(battler))
      next_attack = battler.current_action.action_sequence.shift
      battler.selected_weapon = next_attack
    end
  end
  #--------------------------------------------------------------------------
  # * Set skills sequence
  #     battler : battler
  #--------------------------------------------------------------------------
  alias set_sequence_twohands set_sequence
  def set_sequence(battler)
    if battler.multi_attack and (battler.now_action.is_a?(RPG::Weapon) or
       (battler.now_action.is_a?(RPG::Skill) and battler.current_weapon.is_a?(RPG::Weapon)))
      if battler.current_action.action_sequence.first.numeric?
        battler.selected_weapon = nil
        set_sequence_twohands(battler)
      else
        next_attack = battler.current_action.action_sequence.shift
        battler.selected_weapon = next_attack
        battler.movement = check_include(next_attack, 'MOVETYPE/NOMOVE')
        battler.action_all = check_action_all(next_attack)
        battler.current_action.hit_times = action_hits(battler)
        battler.current_action.combo_times = action_combo(battler)
      end
    else
      set_sequence_twohands(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set physical attack pose
  #     battler  : battler
  #     critical : critical hit flag
  #--------------------------------------------------------------------------
  alias set_attack_pose_twohands set_attack_pose
  def set_attack_pose(battler, critical)
    basic = set_attack_pose_twohands(battler, critical)
    if battler.multi_attack and battler.now_action.is_a?(RPG::Weapon)
      basic = battler.attack_count % 2 == 0 ? basic : Second_Attack_Pose
      battler.attack_count += 1
    end
    return basic
  end
  #--------------------------------------------------------------------------
  # * Set skill pose
  #     battler  : battler
  #     magic    : magic skill flag
  #     critical : critical hit flag
  #--------------------------------------------------------------------------
  alias set_skill_pose_twohands set_skill_pose
  def set_skill_pose(battler, magic, critical)
    basic = set_skill_pose_twohands(battler, magic, critical)
    if battler.multi_attack and battler.now_action.is_a?(RPG::Skill) and 
       battler.now_action.double_hit? and battler.current_weapon.is_a?(RPG::Weapon)
      basic = battler.attack_count % 2 == 0 ? basic : Second_Attack_Pose
      battler.attack_count += 1
    end
    return basic
  end
end
=end