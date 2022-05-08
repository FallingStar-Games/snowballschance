#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Draw State
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  alias acbs_draw_actor_state_windobase draw_actor_state
  def draw_actor_state(actor, x, y, width = 0)
    unless Icon_States  
      acbs_draw_actor_state_windobase(actor, x, y, 120) 
      return
    end
    status_icon = []
    actor.states.sort!
    for i in actor.states
      if $data_states[i].rating >= 1
        begin
          status_icon << RPG::Cache.icon($data_states[i].name + '_st')
          break if status_icon.size > (Icon_max - 1) or i == 1
        rescue
        end
      end
    end
    for icon in status_icon
      rect = Rect.new(0, 0, Icon_X, Icon_Y)
      self.contents.blt(x + X_Adjust, y + Y_Adjust + 4, icon, rect, 255)
      x += Icon_X + 2
    end
  end
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
      parameter_name = Damage_Algorithm_Type > 1 ? Status_Vitality :
        $data_system.words.dex
      parameter_value = actor.dex
    when 5
      parameter_name = $data_system.words.agi
      parameter_value = actor.agi
    when 6
      parameter_name = $data_system.words.int
      parameter_value = actor.int
    when 7
      parameter_name = Status_Evasion
      parameter_value = actor.eva
    end
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, w, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + w, y, 36, 32, parameter_value.to_s, 2)
  end
end

#==============================================================================
# ** Window_Command
#------------------------------------------------------------------------------
#  This window deals with general command choices.
#==============================================================================

class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :commands    # Commands
  #--------------------------------------------------------------------------
  # * Enable Item
  #     index : item number
  #--------------------------------------------------------------------------
  def enable_item(index)
    draw_item(index, normal_color)
  end
end

#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler    # Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_window_help initialize
  def initialize
    acbs_initialize_window_help
    if $game_temp.in_battle
      self.z = 4000
      self.back_opacity = Base_Opacity
    end
  end
  #--------------------------------------------------------------------------
  # * Set Enemy
  #     enemy : name and status displaying enemy
  #--------------------------------------------------------------------------
  alias acbs_set_enemy_windobase set_enemy
  def set_enemy(enemy)
    unless Icon_States  
      acbs_set_enemy_windobase(enemy)
      return
    end
    draw_enemy_name(enemy)
  end
  #--------------------------------------------------------------------------
  # * Draw enemy name and states
  #     enemy : name and status displaying enemy
  #--------------------------------------------------------------------------
  def draw_enemy_name(enemy)
    text = enemy.name
    align = 1
    if text != @text or align != @align
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.font.name = $defaultfont
      self.contents.font.size = 20
      self.contents.draw_text(4, 0, self.width - 40, 32, text, align)
      #self.contents.draw_text(4, 0, self.width - 40, 32, text, align)
      text_width = self.contents.text_size(text).width
      x = (text_width + self.width)/2
      draw_actor_state(enemy, x, 0)
      @text = text
      @align = align
      @actor = nil
    end
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #  text    : text string displayed in window
  #  align   : alignment (0..flush left, 1..center, 2..flush right)
  #  battler : battler
  #--------------------------------------------------------------------------
  def set_text(text, align = 0, battler = nil)
    if text != @text or align != @align or @battler != battler
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.font.size = 20
      self.contents.font.name = $defaultfont
      self.contents.draw_text(4, 0, self.width - 40, 32, text, align)
      @text = text
      @align = align
      @actor = nil
      @battler = battler
    end
    self.visible = true
  end
end

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays items in possession on the item and battle screens.
#==============================================================================

class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_windowitem initialize
  def initialize
    acbs_initialize_windowitem
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 1000
      self.back_opacity = Base_Opacity
    end
  end
end

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays usable skills on the skill and battle screens.
#==============================================================================

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  alias acbs_initialize_windowskill initialize
  def initialize(actor)
    acbs_initialize_windowskill(actor)
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 1000
      self.back_opacity = Base_Opacity
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    self.contents.font.color = set_skill_color(skill.id)
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    draw_skill_cost(skill, x, y)
  end
  #--------------------------------------------------------------------------
  # * Set skill text color
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def set_skill_color(skill_id)
    if @actor.skill_can_use?(skill_id)
      return normal_color
    else
      return disabled_color
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Cost
  #     skill : skill
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_skill_cost(skill, x, y)
    return if Hide_Zero_SP
    cost = @actor.calc_sp_cost(skill)
    self.contents.font.size = 20
    self.contents.draw_text(x + 232, y, 48, 32, cost.to_s, 2)
  end
end

#==============================================================================
# ** Window_PartyCommand
#------------------------------------------------------------------------------
#  This window is used to select whether to fight or escape on the battle
#  screen.
#==============================================================================

class Window_PartyCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialise_windowpartycommand initialize
  def initialize
    acbs_initialise_windowpartycommand
    self.z = 4000
  end
end

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_windowbattlestatus initialize
  def initialize
    acbs_initialize_windowbattlestatus
    self.z = 900
    self.back_opacity = Base_Opacity
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    super
  end
end

#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :exp         # experience
  attr_accessor :gold        # gold
  attr_accessor :treasures   # items
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  alias acbs_intialize_battleresult initialize
  def initialize(exp, gold, treasures)
    acbs_intialize_battleresult(exp, gold, treasures)
    self.back_opacity = 100 #Base_Opacity
    self.z = 4000
  end
  #--------------------------------------------------------------------------
  # * Add extra item drops
  #--------------------------------------------------------------------------
  def add_multi_drops
    @extra_treasures = []
    for enemy in $game_troop.enemies
      @extra_treasures << enemy.multi_drops
    end
    @extra_treasures.flatten!
    for item in @extra_treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    @treasures << @extra_treasures
    @treasures.flatten!
    @treasures.sort! {|a, b| a.id <=> b.id}
    @treasures.sort! do |a, b|
      a_class = a.is_a?(RPG::Item) ? 0 : a.is_a?(RPG::Weapon) ? 1 : 2
      b_class = b.is_a?(RPG::Item) ? 0 : b.is_a?(RPG::Weapon) ? 1 : 2
      a_class <=> b_class
    end
    self.height = [@treasures.size * 32 + 64, 288].min
    self.contents = Bitmap.new(width - 32, @treasures.size * 32 + 32)
    self.y = 100 - height / 2 # 160
    refresh
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if @treasures.size * 32 + 64 > 288
      if Input.press?(Input::UP)
        self.oy -= 4 if self.oy > 0
      elsif Input.press?(Input::DOWN)
        self.oy += 4 if self.oy < @treasures.size * 32 + 64 - 288
      end
    end
  end
end

#==============================================================================
# ■ Window_NameCommand
#------------------------------------------------------------------------------
# This window displays the name of the active battler
#==============================================================================

class Window_NameCommand < Window_Base
  #--------------------------------------------------------------------------
  # initialize object
  #     actor : Herói
  #     x     : Desenhar a partir da coordenada x
  #     y     : Desenhar a partir da coordenada y
  #--------------------------------------------------------------------------
  def initialize(actor, x, y) #make the box
    super(x, y, 190, 50) #location, size
    self.contents = Bitmap.new(width - 44, height - 32 ) 
    #self.contents = Bitmap.new(width - 44, height - 32 ) 
    #-32 #put the stuff up and right 32
    self.contents.font.name = $defaultfont
    self.back_opacity = Base_Opacity #0
    #draw_actor_battle_face(actor, width-44, height-32, 255) #add the face
    self.z = 4000
    refresh(actor)
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    self.contents.font.color = normal_color
    self.contents.draw_text(-32, -8, 128, 32, actor.name, 1) if actor != nil
  end #0,-8,128,32
end