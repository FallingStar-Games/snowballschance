#==============================================================================
# Equipment Multi Slots
# By Atoa
#==============================================================================
# This scripts add an multi equipment slot system, wich allows you to add
# an new variety of equipment.
#
# Add this script above all actor related scripts.
#
# IMPORTANT:
# - If you using the multi slot equip system, the event command for changing 
#   equips will be screwed.
#   So if you need to force any equip change with events, make an Script Call
#   and add this command:
#
#    $game_actors[Actor ID].equip(Slot Index, Equip ID)
#
#      Slot Index = remember that indexes starts from 0, so the 1st slot will
#        be index 0, the 2nd will be index 1...
# - This script change a lot of funcitons and may cause incompatiblities
#   with other systems, if that happens you will have to choose wich system use.
#==============================================================================
=begin

module Atoa
  # Do not remove or change these lines
  Equip_Lock = {}
  Armor_Lock = {}
  # Do not remove or change these lines
  
  # Equipment Kinds
  # The order of the values here define the order that the equipment will be
  # shown in the menu
  # If you repeat an value, means that the actor can equip more than one
  # equip of that type,
  Equip_Kinds = [0,1,3]
  # 0 = Weapons (if you add more than one value equal zero, all these equips
  #     will be considered 'right hand', so they won't remove the shield)
  # 1 = Shields (any equip set as 'Shield' will be exchanged by a weapon if
  #     the actor have the dual wielding)
  # 2 = Helmets
  # 3 = Armors
  # 4 = Accessories
  # Values above 5 are the extra slots, use to creat equipments like Boots, Capes...
  # You must set the IDs of the extra slots equips in 'Extra_Equips_ID'
  #
  # It's recomended that you leave only one 'Weapon' and one 'Shield', once
  # it interfere in the Dual Wielding and 2 Haded Weapons
  
  # You can change this value individually for each actor making an script call
  # and adding this command:
  # $game_actors[actor_id].equip_kind = [x,y,z]
  #   actor_id = actor ID
  #   [x,y,z] = new equip kind configuration
  
  # IDs of the equipments
  # Extra_Equips_ID = {kind => [equips_ids]}
  #  kind = equipment type, set on Equip_Kinds
  #  equips_ids = id of the armors of this equip type
  
  Extra_Equips_ID = {5 => [38,39]}
  
  # Name of the equips shown in the equip and status window
  Equip_Names = ["Tool","Today's Meal","Outfit"]
  # The order here is the order that the names are shown in the menu, set
  # them according to the values set in 'Equip_Kinds'.
  # if you change the value of the kinds with script calls, remember to change
  # the names.
  
  # You can change this value individually for each actor making an script call
  # and adding this command:
  # $game_actors[actor_id].equip_names = [x,y,z]
  #   actor_id = actor ID
  #   [x,y,z] = new equip names configuration
  
  # Equipment Lock, these lines allows you to 'lock' an determined type of 
  # equipment, don't allow the actor to stay without equipment of this type
  # You can change equips freely, but can't remove.
  # E.g.: You have an Bow user character, and don't want him to stay without bows.

  #  Equip_Lock[equip_kind] = {actor_id =>[equip_type_id]}
  #    equip_kind = kind of the equipment
  #      'Weapon' for weapons, 'Armor' for armors
  #    actor_id = actor id
  #    equip_type_id = id of the equipment
  #      0 = right hand weapon
  #      1 = left hand weapon or shield
  #      2,3,4... = armors
  Equip_Lock['Weapon']= {1 => [0], 2 => [0], 3 => [0], 4 => [0], 
                         5 => [0], 6 => [0], 7 => [0], 8 => [0]}
  
  Equip_Lock['Armor']= {12 => [1], 2 => [1]}
  #=============================================================================
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Multi Slot'] = true

#==============================================================================
# ** RPG::Armor
#------------------------------------------------------------------------------
# Class that manage armors
#==============================================================================

class RPG::Armor
  #--------------------------------------------------------------------------
  # * Type ID setting
  #--------------------------------------------------------------------------
  def type_id
    if Extra_Equips_ID != nil
      for kind in Extra_Equips_ID.dup
        return kind[0] if kind[1].include?(@id)
      end
    end
    return @kind + 1
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
  attr_accessor :weapon_fix
  attr_accessor :armor_fix
  attr_accessor :equip_kind
  attr_accessor :equip_names
  attr_accessor :equip_id
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_multislot setup
  def setup(actor_id)
    setup_multislot(actor_id)
    @equip_id = []
    @equip_kind = equip_kind
    @equip_names = equip_names
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id == 0 and i == 0
        @equip_id[i] = @weapon_id
      elsif id != 0 and (1..4).include?(id)
        @equip_id[i] = eval("@armor#{id}_id")
      else
        @equip_id[i] = 0
      end
    end
    @weapon_fix = [@weapon_fix]
    @weapon_fix[1] = @armor1_fix if $atoa_script['Atoa Two Hands'] and  two_swords_style
    @armor_fix = [false]
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if (1..4).include?(id) and not ($atoa_script['Atoa Two Hands'] and id == 1 and
         two_swords_style)
        @armor_fix[i] = eval("@armor#{id}_fix")
      elsif id > 0 and not ($atoa_script['Atoa Two Hands'] and id == 1 and two_swords_style)
        @armor_fix[i] = false
      end
    end 
    @armor_fix[1] = @armor1_fix unless $atoa_script['Atoa Two Hands'] and two_swords_style
    @equip_id[1] = 0 if $atoa_script['Atoa Two Hands'] and
      (Two_Hands_Weapons.include?(@weapon_id) or two_swords_style)
    for equip in armors do update_auto_state(nil, equip) end
  end
  #--------------------------------------------------------------------------
  # * Get equip slots name
  #--------------------------------------------------------------------------
  def equip_names
    return @equip_names.nil? ? Equip_Names : @equip_names
  end
  #--------------------------------------------------------------------------
  # * Set new slot names
  #     n : new names
  #--------------------------------------------------------------------------
  def equip_names=(n)
    @equip_names = n
  end
  #--------------------------------------------------------------------------
  # * Get equips kind
  #--------------------------------------------------------------------------
  def equip_kind
    return @equip_kind.nil? ? Equip_Kinds : @equip_kind
  end
  #--------------------------------------------------------------------------
  # * Set new equips kind
  #     n : new kinds
  #--------------------------------------------------------------------------
  def equip_kind=(n)
    for i in 0...@equip_kind.size
      equip(i, 0) if @equip_kind[i] != n[i]
    end
    @equip_kind = n
    set_equip_id
  end
  #--------------------------------------------------------------------------
  # * Set equips ID
  #--------------------------------------------------------------------------
  def set_equip_id
    for i in 0...@equip_kind.size
      @equip_id[i] = 0 if @equip_id[i] == nil
    end
  end
  #--------------------------------------------------------------------------
  # * Get weapons
  #--------------------------------------------------------------------------
  def weapons
    result = []
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id == 0 or ($atoa_script['Atoa Two Hands'] and id == 1 and two_swords_style)
        @weapon_id = @equip_id[i].nil? ? 0 : @equip_id[i] if id == 0
        result << $data_weapons[@equip_id[i]]
      end
    end
    result.delete_if {|x| x == nil }
    return result
  end
  #--------------------------------------------------------------------------
  # * Get armors
  #--------------------------------------------------------------------------
  def armors
    result = []
    for i in 0...@equip_kind.size
      id = @equip_kind[i]
      if id > 0 and not ($atoa_script['Atoa Two Hands'] and id == 1 and two_swords_style)
        eval("@armor#{id}_id = @equip_id[i].nil? ? 0 : @equip_id[i]") if id < 5
        result << $data_armors[@equip_id[i]]
      end
    end
    result.delete_if {|x| x == nil }
    return result
  end
  #--------------------------------------------------------------------------
  # * Equipment lock
  #    type : equip type
  #--------------------------------------------------------------------------
  def lock_equip(type)
    equip = (type == 0 or ($atoa_script['Atoa Two Hands'] and type == 1 and
      two_swords_style)) ? 'Weapon' : 'Armor'
    id = @equip_kind[type]
    if Equip_Lock[equip] != nil
      eqp = Equip_Lock[equip].dup
    else
      return false
    end
    return (eqp.include?(@actor_id) and eqp[@actor_id].include?(id))
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id         : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    type = @equip_kind[equip_type]
    if type == 0  
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@equip_id[equip_type], 1)
        @equip_id[equip_type] = id
        $game_party.lose_weapon(id, 1)
      end
    elsif type == 1
      if $atoa_script['Atoa Two Hands'] and two_swords_style
        if id == 0 or $game_party.weapon_number(id) > 0
          $game_party.gain_weapon(@equip_id[equip_type], 1)
          @equip_id[equip_type] = id
          $game_party.lose_weapon(id, 1)
        end
      else
        if id == 0 or $game_party.armor_number(id) > 0
          update_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
          $game_party.gain_armor(@equip_id[equip_type], 1)
          @equip_id[equip_type] = id
          $game_party.lose_armor(id, 1)
        end
      end
    elsif type > 1
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@equip_id[equip_type]], $data_armors[id])
        $game_party.gain_armor(@equip_id[equip_type], 1)
        @equip_id[equip_type] = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Remove secondary equip
  #--------------------------------------------------------------------------
  def remove_left_equip_actor
    for i in 0...@equip_kind.size
      equip(i, 0) if @equip_kind[i] == 1
    end
  end
  #--------------------------------------------------------------------------
  # * Remove secondary equip by class
  #     class_id : class ID
  #--------------------------------------------------------------------------
  def remove_left_equip_class(class_id)
    if class_id == @class_id
      for i in 0...@equip_kind.size
        equip(i, 0) if @equip_kind[i] == 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change Class ID
  #     class_id : new class ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    remove_equip_class_change(class_id, @class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      for i in 0...@equip_kind.size
        if @equip_kind[i] == 0 or ($atoa_script['Atoa Two Hands'] and
           @equip_kind[i] == 1 and two_swords_style)
          equip(i, 0) unless equippable?($data_weapons[@equip_id[i]])
        else
          equip(i, 0) unless equippable?($data_armors[@equip_id[i]])
        end
      end
    end
  end
end


#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window class contains cursor movement and scroll functions.
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_windowselectable_multislot update
  def update
    if self.is_a?(Window_EquipRight)
      super
      if self.active and @item_max > 0 and @index >= 0
        if Input.repeat?(Input::DOWN)
          if (@column_max == 1 and Input.trigger?(Input::DOWN)) or
             @index < @item_max - @column_max
            $game_system.se_play($data_system.cursor_se)
            @index = (@index + @column_max) % @item_max
          end
        end
        if Input.repeat?(Input::UP)
          if (@column_max == 1 and Input.trigger?(Input::UP)) or
             @index >= @column_max
            $game_system.se_play($data_system.cursor_se)
            @index = (@index - @column_max + @item_max) % @item_max
          end
        end
        if Input.repeat?(Input::RIGHT)
          if @column_max >= 2 and @index < @item_max - 1
            $game_system.se_play($data_system.cursor_se)
            @index += 1
          end
        end
        if Input.repeat?(Input::LEFT)
          if @column_max >= 2 and @index > 0
            $game_system.se_play($data_system.cursor_se)
            @index -= 1
          end
        end
        if Input.repeat?(Input::R)
          @index == @item_max if @index < @item_max
        end
        if Input.repeat?(Input::L)
          @index == @item_max if @index < @item_max
        end
      end
      if self.active and @help_window != nil
        update_help
      end
      update_cursor_rect
    else
      update_windowselectable_multislot
    end
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
  def refresh
    
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
      draw_actor_parameter(@actor, 96, 172 + [(236/(status_size + 6)), 20].max * i, Extra_Status[i - 7]) if Extra_Status[i - 7] != nil
    end
    self.contents.font.color = system_color
    self.contents.draw_text(320, 48, 80, 32, 'EXP')
    self.contents.draw_text(320, 80, 80, 32, 'Next')
    self.contents.draw_text(400, 128, 128, 32, 'Equipment')
    self.contents.font.color = normal_color
    self.contents.draw_text(400, 48, 84, 32, @actor.exp_s, 2)
    self.contents.draw_text(400, 80, 84, 32, @actor.next_rest_exp_s, 2)
    self.contents.font.color = system_color    
    data = []
    for i in 0...@actor.equip_kind.size
      id = @actor.equip_kind[i]
      if id == 0
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id == 1 and ($atoa_script['Atoa Two Hands'] and @actor.two_swords_style)
        data.push($data_weapons[@actor.equip_id[i]])
      elsif id != 0 or ($atoa_script['Atoa Two Hands'] and id == 1 and not @actor.two_swords_style)
        data.push($data_armors[@actor.equip_id[i]])
      end
    end
    self.contents.font.color = system_color
    return if data.size == 0
    for i in 0...@actor.equip_names.size
      name = @actor.equip_names[i]
      self.contents.draw_text(320, 160 + [(280/data.size), 24].max * i, 92, 32, name)
    end
    for i in 0...data.size
      draw_item_name(data[i], 412, 160 + [(280/data.size), 24].max * i)
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(272, 64, 368, 192)
    self.contents = Bitmap.new(width - 32, actor.equip_kind.size * 32)
    @actor = actor
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = []
    for i in 0...@actor.equip_kind.size
      id = @actor.equip_kind[i]
      if id == 0
        @data.push($data_weapons[@actor.equip_id[i]])
      elsif id == 1 and ($atoa_script['Atoa Two Hands'] and @actor.two_swords_style)
        @data.push($data_weapons[@actor.equip_id[i]])
      elsif id != 0 or ($atoa_script['Atoa Two Hands'] and id == 1 and not @actor.two_swords_style)
        @data.push($data_armors[@actor.equip_id[i]])
      end
    end
    @item_max = @data.size
    self.contents.font.color = system_color
    for i in 0...@actor.equip_names.size
      name = @actor.equip_names[i]
      self.contents.draw_text(4, 32 * i, 92, 32, name)
    end
    for i in 0...@data.size
      draw_item_name(@data[i], 92, 32 * i)
    end
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.item == nil ? '' : self.item.description)
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
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    if @equip_type == 0 or ($atoa_script['Atoa Two Hands'] and 
       @equip_type == 1 and @actor.two_swords_style)
      weapon_set = $data_classes[@actor.class_id].weapon_set
      for i in 1...$data_weapons.size
        next if $atoa_script['Atoa Two Hands'] and Two_Hands_Weapons.include?(i) and @equip_type == 1
        next if $atoa_script['Atoa Two Hands'] and Right_Hand_Weapons.include?(i) and @equip_type == 1
        next if $atoa_script['Atoa Two Hands'] and Left_Hand_Weapons.include?(i) and @equip_type == 0
        if $game_party.weapon_number(i) > 0 and weapon_set.include?(i)
          @data.push($data_weapons[i])
        end
      end
    end
    if @equip_type > 0 and not ($atoa_script['Atoa Two Hands'] and @equip_type == 1 and @actor.two_swords_style)
      armor_set = $data_classes[@actor.class_id].armor_set
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0 and armor_set.include?(i)
          if $data_armors[i].type_id == @equip_type
            @data.push($data_armors[i])
          end
        end
      end
    end
    @data.push(nil) unless @actor.lock_equip(@equip_type)
    @item_max = @data.size
    self.contents = Bitmap.new(width - 32, [row_max, 1].max * 32)
    self.opacity = Equip_Window_Opacity if $atoa_script['Atoa New Status']
    for i in 0...(@actor.lock_equip(@equip_type) ? @item_max : @item_max - 1)
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if $atoa_script['Atoa New Status']
      case Equip_Menu_Syle
      when 0,1,2
        x = 4 + index % 2 * (288 + 32)
        y = index / 2 * 32
      when 3,4
        x = 4
        y = index * 32
      end
    else
      x = 4 + index % 2 * (288 + 32)
      y = index / 2 * 32
    end
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ':', 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

#==============================================================================
# ** Window_ShopStatus
#------------------------------------------------------------------------------
#  This window displays number of items in possession and the actor's equipment
#  on the shop screen.
#==============================================================================

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    return if @item.nil?
    case @item
    when RPG::Item
      number = $game_party.item_number(@item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(@item.id)
    when RPG::Armor
      number = $game_party.armor_number(@item.id)
    end
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 200, 32, 'On hand')
    self.contents.font.color = normal_color
    self.contents.draw_text(204, 0, 32, 32, number.to_s, 2)
    return if @item.is_a?(RPG::Item)
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.equippable?(@item)
        self.contents.font.color = normal_color
      else
        self.contents.font.color = disabled_color
      end
      self.contents.draw_text(4, 64 + 64 * i, 120, 32, actor.name)
      for n in 0...actor.equip_kind.size
        id = actor.equip_kind[n]
        if @item.is_a?(RPG::Weapon) 
          item1 = $data_weapons[actor.equip_id[n]] if id == 0
        else
          if $data_armors[actor.equip_id[n]].type == @item.type_id and not
             (@item.type_id == 1 and actor.two_swords_style)
            item1 = $data_armors[actor.equip_id[n]]
          end
        end
      end
      if actor.equippable?(@item)
        change = 0
        if @item.is_a?(RPG::Weapon)
          atk1 = item1 != nil ? item1.atk : 0
          atk2 = @item != nil ? @item.atk : 0
          change = atk2 - atk1
        elsif @item.is_a?(RPG::Armor) and @item.kind <= 2
          pdef1 = item1 != nil ? item1.pdef : 0
          mdef1 = item1 != nil ? item1.mdef : 0
          pdef2 = @item != nil ? @item.pdef : 0
          mdef2 = @item != nil ? @item.mdef : 0
          change = pdef2 - pdef1 + mdef2 - mdef1
        elsif @item.is_a?(RPG::Armor) and  @item.kind > 2
          change = 0
          item1 = nil
        end
        if change > 0 and actor.equippable?(@item)
          self.contents.font.color = text_color(3)
        elsif change < 0 and actor.equippable?(@item)
          self.contents.font.color = text_color(2)
        end
        self.contents.draw_text(64, 64 + 64 * i, 128, 32,sprintf('%+d', change), 2)
        self.contents.font.color = normal_color
      end
      if item1 != nil
        x = 4
        y = 64 + 64 * i + 32
        bitmap = RPG::Cache.icon(item1.icon_name)
        opacity = self.contents.font.color == normal_color ? 255 : 128
        self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
        self.contents.draw_text(x + 28, y, 212, 32, item1.name)
      end
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
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @actor = $game_party.actors[@actor_index]
    @help_window = Window_Help.new
    @left_window = Window_EquipLeft.new(@actor)
    @right_window = Window_EquipRight.new(@actor)
    @right_window.index = @equip_index
    item_window_update
    @right_window.help_window = @help_window
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.help_window = @help_window")
    end
    refresh
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      break if $scene != self
    end
    Graphics.freeze
    @help_window.dispose
    @left_window.dispose
    @right_window.dispose
    item_window_dispose  
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @help_window.opacity = Equip_Window_Opacity if $atoa_script['Atoa New Status']
    if @right_window.index > @right_window.data.size - 1
      @right_window.index = @right_window.data.size - 1
    end
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.visible = (@right_window.index == #{i})")
    end
    item1 = @right_window.item
    eval("@item_window = @item_window#{@right_window.index + 1}")
    @left_window.set_new_parameters(nil, nil, nil) if @right_window.active
    if @item_window.active
      @item2 = @item_window.item
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, @item2 == nil ? 0 : @item2.id)
      re_equip = []
      if $atoa_script['Atoa Two Hands'] and @item2 != nil and @item2.type_id == 0 and Two_Hands_Weapons.include?(@item2.id)
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          if id == 1
            re_equip << [i, @actor.equip_id[i]]
            @actor.equip(i, 0)
          end
        end
      elsif @item2 != nil and (@item2.type_id == 1 or ($atoa_script['Atoa Two Hands'] and
         @item2.type_id == 0 and @actor.two_swords_style))
        for i in 0...@actor.equip_kind.size
          id = @actor.equip_kind[i]
          if $atoa_script['Atoa Two Hands'] and @right_window.index != i and id == 0 and 
             Two_Hands_Weapons.include?(@actor.equip_id[id])
            re_equip << [i, @actor.equip_id[i]]
            @actor.equip(i, 0)
          end
        end
      end
      new_atk = @actor.atk
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      if $atoa_script['Atoa New Status']
        new_str = @actor.str
        new_dex = @actor.dex
        new_agi = @actor.agi
        new_int = @actor.int
        new_eva = @actor.eva
        new_hit = @actor.hit
        new_crt = @actor.crt 
        new_dmg = @actor.dmg
        new_rcrt = @actor.rcrt
        new_rdmg = @actor.rdmg
      end
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      for equip in re_equip
        @actor.equip(equip[0], equip[1])
      end
      @actor.hp = last_hp
      @actor.sp = last_sp
      if $atoa_script['Atoa New Status']
        @left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_str, new_dex, 
          new_agi, new_int, new_eva, new_hit, new_crt, new_dmg, new_rcrt, new_rdmg)
      else
        @left_window.set_new_parameters(new_atk, new_pdef, new_mdef)
      end
    end
  end
  #-------------------------------------------------------------------------- 
  # * Update item window
  #-------------------------------------------------------------------------- 
  def item_window_update
    for i in 0...@actor.equip_kind.size
      type = @actor.equip_kind[i]
      eval("@item_window#{i+1} = Window_EquipItem.new(@actor, type)")
    end
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i + 1}.help_window = @help_window")
    end
    refresh
  end
  #-------------------------------------------------------------------------- 
  # * Dispose item window
  #-------------------------------------------------------------------------- 
  def item_window_dispose
    for i in 0...@actor.equip_kind.size
      eval("@item_window#{i+1}.dispose if @item_window#{i+1} != nil")
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  alias update_item_multislot update_item
  def update_item
    if Input.trigger?(Input::C)
      item = @item_window.item
      @actor.equip(@right_window.index, item == nil ? 0 : item.id)
      update_hands(item) if $atoa_script['Atoa Two Hands']
      @right_window.active = true
      @item_window.active = false
      @item_window.index = -1
      @right_window.refresh
      @item_window.refresh
      $game_system.se_play($data_system.equip_se)
      return
    end
    update_item_multislot
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when right window is active)
  #--------------------------------------------------------------------------
  def update_right
    if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
      @item_window.index = -1
      @item_window.refresh
    end
    if Input.trigger?(Input::B)
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_Menu.new(2)
      return
    end
    if Input.trigger?(Input::C)
      if @actor.equip_fix?(@right_window.index) or (@item_window.data.size == 0 and 
          @actor.lock_equip(@right_window.index))
        return $game_system.se_play($data_system.buzzer_se)
      end
      $game_system.se_play($data_system.decision_se)
      @right_window.active = false
      @item_window.active = true
      @item_window.index = 0
      return
    end
    if Input.trigger?(Input::R)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size + 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
    if Input.trigger?(Input::L)
      $game_system.se_play($data_system.cursor_se)
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
  end
end
=end