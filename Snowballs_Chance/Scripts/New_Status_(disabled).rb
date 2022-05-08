#==============================================================================
# New Status
# By Atoa
#==============================================================================
# This script allows you to add new status for equipments
# Hit Rate, Critical Rate, Critical Damage, Critical Rate Resist,
# Critical Damage Resist
#==============================================================================
=begin
module Atoa
  # Do not remove this line
  Speacial_Status = {}
  # Do not remove this line

  # Here you can set some values to change the equip and status menu
  # This script isn't comatible with complex equip and status menu systems, 
  # so use this area to customize your menus
  
  # Exhibition style of the equip menu
  Equip_Menu_Syle = 2
  # 0 = Default, shows atk, pdef, mdef
  # 1 = Default, shows atk, pdef, mdef, str, dex, int, agi
  # 2 = Default, shows str, dex, int, agi
  # 3 and 4 = custom, shows all status (including the news)
  
  # Window Opacity
  Equip_Window_Opacity = 255
  
  # Show map on background
  Show_Map_Equip_Menu = false
  
  # Background image
  Equip_Menu_Back = nil
  # If you want to use your own backgruon image, add the filename here.
  # the graphic must be on the Windowskin folder.
  # if the value = nil, no image will be used.
  # Remember to reduce the window transparency.
  
  # Define here which symbols/letters will be used to show status alteration
  # On the side there are a few exemples on symbols you can also use
  Stat_Nil  = '=' # '■' '↔' '±' '=' '>'
  Stat_Up   = '+' # '▲' '↑' '»' '+' '>'
  Stat_Down = '-' # '▼' '↓' '«' '-' '>'
  
  # New Status Exhibition
  Extra_Status = [7,8,9]
  # 7 = Evasion
  # 8 = Hit Rate
  # 9 = Critical Rate
  # 10 = Critical Damage
  # 11 = Critical Rate Resist
  # 12 = Critical Damage Resist
  

  # Name of the new status
  Stat_Eva = 'EVAD'
  Stat_Hit = 'hit'
  Stat_Crt = 'CRIT-HIT'
  Stat_Dmg = 'CRIT-DMG'
  Stat_Res_Crt = 'ANTI-CRIT'
  Stat_Res_Dmg = 'ANTI-CRIT-DMG'
  
  # Show map as background of the equip menu?
  Show_Map_Equip_Menu = false
  
  # Show image as background of the equip menu?
  Equip_Menu_Back = nil
  # Add the image filename here (as an string), the image must be on the 
  # Windowskin folder.
  # Leave nil for no image.
  
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

  #NOTE: GO TO CUSTOM DAMAGE TO CHANGE THESE
  
    #Note: New Status is the script page with the code for making this stuff work
  Speacial_Status['Weapon'] = {
  1 => {'hit' => -20, 'CRIT-HIT' => +10},  #gunaxe
  36 => {'dmg' => 200}
  }
  
    Speacial_Status['Armor'] = {
  35 => {'rcrt' => 20, 'rdmg' => -50}, 
  36 => {'hit' =>20,'crt' => 25,'dmg' => 50}
  }
  
  
  #Speacial_Status['Weapon'] = {
  #35 => {'hit' => -20,'crt' => 20}, 
  #36 => {'dmg' => 200}
  #}
  
  #Speacial_Status['Armor'] = {
  #35 => {'rcrt' => 20, 'rdmg' => -50}, 
  #36 => {'hit' =>20,'crt' => 25,'dmg' => 50}
  #}
  #=============================================================================

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa New Status'] = true

#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
# Class that manage weapons
#==============================================================================

class RPG::Weapon
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  def hit
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['hit'] != nil ? wpn[@id]['hit'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  def crt
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['crt'] != nil ? wpn[@id]['crt'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  def dmg
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['dmg'] != nil ? wpn[@id]['dmg'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  def rcrt
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['rcrt'] != nil ? wpn[@id]['rcrt'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  def rdmg
    wpn = Speacial_Status['Weapon']
    return wpn[@id] != nil && wpn[@id]['rdmg'] != nil ? wpn[@id]['rdmg'] : 0
  end
end

#==============================================================================
# ** RPG::Armor
#------------------------------------------------------------------------------
# Class that manage armors
#==============================================================================

class RPG::Armor
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  def hit
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['hit'] != nil ? arm[@id]['hit'] : 0
    #give us the number for the armor if it doesn't equal nil, 
    #and armor hit rate doesn't equal zero
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Rate
  #--------------------------------------------------------------------------
  def crt
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['crt'] != nil ? arm[@id]['crt'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Rate
  #--------------------------------------------------------------------------
  def dmg
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['dmg'] != nil ? arm[@id]['dmg'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Hit Evasion Rate
  #--------------------------------------------------------------------------
  def rcrt
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['rcrt'] != nil ? arm[@id]['rcrt'] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Critical Damage Resist Rate
  #--------------------------------------------------------------------------
  def rdmg
    arm = Speacial_Status['Armor']
    return arm[@id] != nil && arm[@id]['rdmg'] != nil ? arm[@id]['rdmg'] : 0
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Parameter
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type
  #     w     : draw width
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type, w = 132)
    case type
    when 0
      parameter_name = $data_system.words.atk
      parameter_value = actor.atk
    when 1
      parameter_name = $data_system.words.pdef
      parameter_value = actor.pdef
    when 2
      parameter_name = $data_system.words.mdef
      parameter_value = actor.mdef
    when 3
      parameter_name = $data_system.words.str
      parameter_value = actor.str
    when 4
      parameter_name = $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = Stat_Eva
      parameter_value = actor.eva
    when 8
      parameter_name = Stat_Hit
      parameter_value = actor.hit
    when 9
      parameter_name = Stat_Crt
      parameter_value = actor.crt
    when 10
      parameter_name = Stat_Dmg
      parameter_value = actor.dmg
    when 11
      parameter_name = Stat_Res_Crt
      parameter_value = actor.rcrt
    when 12
      parameter_name = Stat_Res_Dmg
      parameter_value = actor.rdmg
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, w + 32, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + w, y, 64, 32, parameter_value.to_s, 2)
  end
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  
    def draw_actor_facegraphic(actor, x, y)
    bitmap = RPG::Cache.picture(actor.name + "_face")
    end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_newstats refresh
  def refresh
    unless $atoa_script['Atoa Multi Slot'] or $atoa_script['Atoa Two Hands']
      self.contents.clear
      #draw_actor_face_graphic(@actor,40,110)
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
      for i in 7..(Extra_Status.size + 6)
        draw_actor_parameter(@actor, 96, 172 + [(236/(status_size + 6)), 20].max * i,
          Extra_Status[i - 7])
      end
      self.contents.font.color = system_color
      self.contents.draw_text(320, 48, 80, 32, "EXP")
      self.contents.draw_text(320, 80, 80, 32, "Próximo")
      self.contents.draw_text(320, 160, 96, 32, "Equipamento")
      self.contents.font.color = normal_color
      self.contents.draw_text(320 + 80, 48, 84, 32, @actor.exp_s, 2)
      self.contents.draw_text(320 + 80, 80, 84, 32, @actor.next_rest_exp_s, 2)
      draw_item_name($data_weapons[@actor.weapon_id], 320 + 16, 208)
      draw_item_name($data_armors[@actor.armor1_id], 320 + 16, 256)
      draw_item_name($data_armors[@actor.armor2_id], 320 + 16, 304)
      draw_item_name($data_armors[@actor.armor3_id], 320 + 16, 352)
      draw_item_name($data_armors[@actor.armor4_id], 320 + 16, 400)
    else
      refresh_newstats
    end
  end
end

#==============================================================================
# ** Window_EquipLeft
#------------------------------------------------------------------------------
# Esta é a janela que exibe as mudanças de parâmetros dos equipamentos.
#==============================================================================

class Window_EquipLeft < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    case Equip_Menu_Syle
    when 0,2
      super(0, 64, 272, 192)
    when 1
      super(0, 64, 272, 224)
    when 3
      super(0, 64, 272, 416)
    when 4
      super(368, 64, 272, 416)
    end
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = Equip_Window_Opacity
    @actor = actor
    @new_equip = nil
    @last_equip = nil
    @last_atk = @actor.atk
    @last_pdef = @actor.pdef
    @last_mdef = @actor.mdef
    @last_str = @actor.str
    @last_dex = @actor.dex
    @last_agi = @actor.agi
    @last_int = @actor.int
    @last_eva = @actor.eva
    @last_hit = @actor.hit
    @last_ctr = @actor.crt
    @last_dmg = @actor.dmg
    @last_rcrt = @actor.rcrt
    @last_rdmg = @actor.rdmg
    
    
    refresh
  end 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @equip_stat, @base_stat, @new_stat = false, false, false
    case Equip_Menu_Syle
    when 0
      @equip_stat = true
      y_adjust = 64
      draw_actor_name(@actor, 12, 0)
      draw_actor_level(@actor, 12, 32)
    when 1
      @equip_stat = true
      @base_stat = true
      y_adjust = 0
    when 2
      @base_stat = true
      y_adjust = 32
      draw_actor_name(@actor, 12, 0)
    when 3,4
      @equip_stat = true
      @base_stat = true
      @new_stat = true
      y_adjust = 0
    end
    self.contents.font.color = system_color
    y = 0
    for i in 0..13
      if ((0..2).include?(i) and @equip_stat) or ((3..6).include?(i) and @base_stat) or
         ((7..13).include?(i) and @new_stat)
        draw_actor_parameter(@actor, 12, y * 28 + y_adjust, i, 104)
        draw_change_arrow(y, y_adjust, i)
        y += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw stat change arrow
  #     y      : draw spot y-coordinate
  #     adjust : position adjust
  #     type   : parameter type
  #--------------------------------------------------------------------------
  def draw_change_arrow(y, adjust, type)
    case type
    when 0
      old_value = @actor.atk
      new_value = @new_atk
    when 1
      old_value = @actor.pdef
      new_value = @new_pdef
    when 2
      old_value = @actor.mdef
      new_value = @new_mdef
    when 3
      old_value = @actor.str
      new_value = @new_str
    when 4
      old_value = @actor.dex
      new_value = @new_dex
    when 5
      old_value = @actor.agi
      new_value = @new_agi
    when 6
      old_value = @actor.int
      new_value = @new_int
    when 7
      old_value = @actor.eva
      new_value = @new_eva
    when 8
      old_value = @actor.hit
      new_value = @new_hit
    when 9
      old_value = @actor.crt
      new_value = @new_crt
    when 10
      old_value = @actor.dmg
      new_value = @new_dmg
    when 11
      old_value = @actor.rcrt
      new_value = @new_rcrt
    when 12
      old_value = @actor.rdmg
      new_value = @new_rdmg
    end
    if new_value != nil
      if old_value == new_value
        self.contents.font.color = text_color(7)      
        self.contents.draw_text(172, y * 28 + adjust, 40, 32, Stat_Nil, 1)
        self.contents.font.color = normal_color
      elsif old_value < new_value
        self.contents.font.color = text_color(4)      
        self.contents.draw_text(172, y * 28 + adjust, 40, 32, Stat_Up, 1)
        self.contents.font.color = text_color(3)
      elsif old_value > new_value
        self.contents.font.color = text_color(6)      
        self.contents.draw_text(172, y * 28+ adjust, 40, 32, Stat_Down, 1)
        self.contents.font.color = text_color(2)
      end
      self.contents.draw_text(192, y * 28 + adjust, 48, 32, new_value.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # Definir os parâmetros after changing equipment
  #     new_atk  : attack power after changing equipment
  #     new_pdef : physical defense after changing equipment
  #     new_mdef : magic defense after changing equipment
  #     new_str  : strenght after changing equipment
  #     new_dex  : dexterity after changing equipment
  #     new_agi  : agility after changing equipment
  #     new_int  : inteligence after changing equipment
  #     new_eva  : evasion after changing equipment
  #     new_hit  : hit after changing equipment
  #     new_crt  : critical hit after changing equipment
  #     new_dmg  : critical damage after changing equipment
  #     new_rcrt : critical evade after changing equipment
  #     new_rdmg : critical resist after changing equipment
  #--------------------------------------------------------------------------
  def set_new_parameters(new_atk = nil, new_pdef  = nil, new_mdef = nil, new_str  = nil,
        new_dex = nil, new_agi = nil, new_int = nil, new_eva = nil, new_hit = nil, 
        new_crt = nil, new_dmg = nil, new_rcrt = nil, new_rdmg = nil)
        
    if @new_str != new_str or @new_dex != new_dex or @new_agi != new_agi or 
       @new_int != new_int or @new_atk != new_atk or @new_pdef != new_pdef or
       @new_mdef != new_mdef or @new_eva != new_eva or @new_hit != new_hit or
       @new_crt != new_crt or @new_dmg != new_dmg or @new_rcrt != new_rcrt or
       @new_rdmg != new_rdmg 
      @last_equip = @new_equip
      @new_atk = new_atk
      @new_pdef = new_pdef
      @new_mdef = new_mdef
      @new_str = new_str
      @new_dex = new_dex
      @new_agi = new_agi
      @new_int = new_int
      @new_eva = new_eva
      @new_hit = new_hit
      @new_crt = new_crt
      @new_dmg = new_dmg
      @new_rcrt = new_rcrt
      @new_rdmg = new_rdmg
      refresh
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
    case Equip_Menu_Syle
    when 0,2
      super(272, 64, 368, 192)
    when 1
      super(272, 64, 368, 224)
    when 3
      super(272, 64, 368, 192)
    when 4
      super(0, 64, 368, 192)
    end
    equip_size = $atoa_script['Atoa Multi Slot'] ? actor.equip_kind.size : 5 
    self.contents = Bitmap.new(width - 32, equip_size * 32)
    @actor = actor
    self.opacity = Equip_Window_Opacity
    refresh
    self.index = 0
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
  # * Object Initialization
  #     actor      : actor
  #     equip_type : equip region
  #--------------------------------------------------------------------------
  def initialize(actor, equip_type)
    case Equip_Menu_Syle
    when 0,2
      super(0, 256, 640, 224)
      @column_max = 2
    when 1
      super(0, 288, 640, 192)
      @column_max = 2
    when 3
      super(272, 256, 368, 224)
      @column_max = 1
    when 4
      super(0, 256, 368, 224)
      @column_max = 1
    end
    @actor = actor
    @equip_type = equip_type
    refresh
    self.active = false
    self.index = -1
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
  alias main_newstats main
  def main
    @spriteset = Spriteset_Map.new if Show_Map_Equip_Menu
    if Equip_Menu_Back != nil
      @back_image = Sprite.new
      @back_image.bitmap = RPG::Cache.windowskin(Equip_Menu_Back)
    end
    main_newstats
    @back_image.dispose if Equip_Menu_Back != nil
    @spriteset.dispose if Show_Map_Equip_Menu
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias refresh_newstats refresh
  def refresh
    refresh_newstats
    unless $atoa_script['Atoa Multi Slot']
      item1 = @right_window.item
      @left_window.set_new_parameters if @right_window.active
      if @item_window.active
        item2 = @item_window.item
        last_hp = @actor.hp
        last_sp = @actor.sp
        @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
        if $atoa_script['Atoa Two Hands']
          re_equip = []
          if @item2 != nil and @item2.type_id == 0 and Two_Hands_Weapons.include?(@item2.id)
            re_equip << [1, @actor.armor1_id]
            @actor.equip(1, 0)
          elsif @item2 != nil and (@item2.type_id == 1 or (@item2.type_id == 0 and @actor.two_swords_style))
            if Two_Hands_Weapons.include?(@actor.weapon_id)
              re_equip << [0, @actor.weapon_id]
              @actor.equip(1, 0)
            end
          end
        end
        new_atk = @actor.atk
        new_pdef = @actor.pdef
        new_mdef = @actor.mdef
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
        @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
        if $atoa_script['Atoa Two Hands']
          for equip in re_equip
            @actor.equip(equip[0], equip[1])
          end
        end
        @actor.hp = last_hp
        @actor.sp = last_sp
        @left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_str, new_dex, 
            new_agi, new_int, new_eva, new_hit, new_crt, new_dmg, new_rcrt, new_rdmg)
      end
    end
  end
end
=end