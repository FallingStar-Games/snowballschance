#==============================================================================
# ** Catergorized Items Menu
#------------------------------------------------------------------------------
# * Created by: albertfish
# * Version: 1.3
# * Last edited: October 22, 2009
#------------------------------------------------------------------------------
#  Version History:
#     Version 1.3: October 22, 2009
#       - Fixed a bug that did not weapons in the weapon category
#     Version 1.2: October 4, 2009
#       - Fixed a bug that did not allow you to remove the all items category
#     Version 1.1: September 13, 2009
#       - The variable for recent items is no longer global
#       - Some code removed
#       - Changed it so when you are in items window and you hit escape
#         it goes back to the category window.
#       - You can also select a category with enter now.
#     Version 1.0: September 13, 2009
#       - Initial release
#------------------------------------------------------------------------------
#  Description:
#     This is a complete redesign of the default items menu that sorts items
#     into categories for better organization.
#------------------------------------------------------------------------------
#  Features:
#     - Includes 10 different categories to sort items
#     - Easy to set up items to be sorted
#     - Easy to customize appearance
#     - Easy to customize which categories are active
#     - Extremely customizeable which allows you to set it up the way
#       you want it set up.
#------------------------------------------------------------------------------
#  Item Setup Instructions:
#     This script sorts items automatically based on certain aspects of the
#     item. To set up items to be sorted into correct categories follow this
#     guide.
#
#     Consumable Items - Must have Consumable flag set to yes
#                      - Must have Occasion flag set to anything other than
#                        never.
#     Weapons          - All items in Weapons tab in the database
#     Equipment        - All items in the Weapons and Armors tab
#     Body Equipment   - Must be under Armors tab
#                      - Kind must be Body Armor
#     Head Equipment   - Must be under Armors tab
#                      - Kind must be Helmet
#     Arm Equipment    - Must be under Armors tab
#                      - Kind must be Shield
#     Accessory        - Must be under Armors tab
#                      - Kind must be Accessory
#     Raw Materials    - Must be consumable
#                      - Must have occasion of never
#     Story Items      - Must be non consumable
#     All Items        - All of the above
#------------------------------------------------------------------------------
#  Install Instructions:
#     Place this script above the main script and below the default scripts.
#==============================================================================

#==============================================================================
# ** CIM_Config
#------------------------------------------------------------------------------
#  This module contains the configuration data of the menu.
#------------------------------------------------------------------------------
#  Begin Editable Area.
#==============================================================================

module CIM_Config
  # If this value is true the category icons will be displayed in a 
  # separate window. If you set it to false, the icons will be displayed
  # in the category title bar.
  # Default value: true
  CATEGORIES_WINDOW = true
  
  # This value determines if there is a recent items category.
  # Default value: true
  RECENT_ITEMS = true
  
  # This value determines if there is a consumable items category.
  # Default value: true
  CONSUME_ITEMS = true
  
  # This value determines if there is equipment categories.
  # Default value: true
  EQUIPMENT = false
  
  # This value determines if the equipment is displayed as a single
  # category.
  # Default value: false
  SINGLE_EQUIPMENT_CATEGORY = true
  
  # This value determines if there is a raw materials category.
  # Default value: true
  RAW_MATERIALS = true
  
  # This value determines if there is a quest items category.
  # Default value: true
  QUEST_ITEMS = true
  
  # This value determines if there is a all items category.
  # Default value: true
  ALL_ITEMS = true
  
  # This values determines where the all items category will be.
  # 1 is the very first position, 2 the second, and so on.
  # Warning! If this number is larger than the number of categories
  # then it will cause an error.
  # For example, if there are 5 categories and the number is set to 7
  # an error will occur.
  # Default Value: 2
  ALL_ITEMS_POSITION = 2
  
  # This value determines if the unhighlighted category icons are translucent
  # or opaque.
  # Default value: true
  UNSELECTED_TRANSLUCENT = false
  
  # This value determines if there is a selection cursor for the category 
  # window.
  # Default Value: true
  CATEGORY_CURSOR = true
  
  # This is where you set the category title alignment.
  #   0 = Left
  #   1 = Center
  #   2 = Right
  # Default value: 1
  TITLE_ALIGNMENT = 1
  
  # This is where you set how the icon in the help window is displayed.
  #   0 = Not displayd
  #   1 = Normal Size
  #   2 = Double Size
  # Default value: 2
  ICON_DISPLAY = 1
  
  # Set the menu item icons. These must be size 24px by 24px.
  # The icons must be placed in the icons folder in the games directory
  # and the file name of the icons must be placed between the quotation
  # marks.  
  I_RECENT = "sparkleicox2"  
  I_CONSUME = "groceriesx2"  
  I_WEAPONS = ""  
  I_BODY = ""   
  I_HEAD = ""   
  I_ARM = ""  
  I_ACCESSORY = "" 
  
  I_RAW = "rawx2" 
  I_QUEST = "importantx2" 
  I_ALL = "everythingx2" 
  # This next one is used when you group the different equipment into
  # one category.
  I_EQUIPMENT = "mealx2" 
  
  # Set the menu item text. This is the text that will display at the bottom
  # informing the player what each category is.
  T_RECENT = "Recent Items"  
  T_CONSUME = "Basic Items"  
  T_WEAPONS = "Weapons"  
  T_BODY = "Clothes"  
  T_HEAD = "Hats"  
  T_ARM = "Arm Equipment"  
  T_ACCESSORY = "Accessories"  
  T_RAW = "Raw Materials"  
  T_QUEST = "Important"  
  T_ALL = "All Items"  
  # This next one is used when you group the different equipment into
  # one category.
  T_EQUIPMENT = "Meals"  

  #============================================================================
  #  End Editable Area.
  #----------------------------------------------------------------------------
  #  Warning! Do not edit beyond this point unless you know what you are doing!
  #============================================================================
  ITEMS_MENU_ICONS = []
  ITEMS_MENU_TEXT = []
  ITEM_ID = []
  
  # Add recent items category
  if RECENT_ITEMS
    ITEMS_MENU_TEXT.push(T_RECENT)
    ITEMS_MENU_ICONS.push(I_RECENT)
    ITEM_ID.push("Recent")
  end
  # Add consumable items category
  if CONSUME_ITEMS
    ITEMS_MENU_TEXT.push(T_CONSUME)
    ITEMS_MENU_ICONS.push(I_CONSUME)
    ITEM_ID.push("Consume")
  end
  # Add equipment category(s)
  if SINGLE_EQUIPMENT_CATEGORY && EQUIPMENT
    ITEMS_MENU_TEXT.push(T_EQUIPMENT)
    ITEMS_MENU_ICONS.push(I_EQUIPMENT)
    ITEM_ID.push("Equip")
  elsif EQUIPMENT
    ITEMS_MENU_TEXT.push(T_WEAPONS)
    ITEMS_MENU_ICONS.push(I_WEAPONS)
    ITEM_ID.push("Weapon")
    ITEMS_MENU_TEXT.push(T_BODY)
    ITEMS_MENU_ICONS.push(I_BODY)
    ITEM_ID.push("Body")
    ITEMS_MENU_TEXT.push(T_HEAD)
    ITEMS_MENU_ICONS.push(I_HEAD)
    ITEM_ID.push("Head")
    ITEMS_MENU_TEXT.push(T_ARM)
    ITEMS_MENU_ICONS.push(I_ARM)
    ITEM_ID.push("Arm")
    ITEMS_MENU_TEXT.push(T_ACCESSORY)
    ITEMS_MENU_ICONS.push(I_ACCESSORY)
    ITEM_ID.push("Accessory")
  end
  # Add raw materials category
  if RAW_MATERIALS
    ITEMS_MENU_TEXT.push(T_RAW)
    ITEMS_MENU_ICONS.push(I_RAW)
    ITEM_ID.push("Raw")
  end
  # Add quest items category
  if QUEST_ITEMS
    ITEMS_MENU_TEXT.push(T_QUEST)
    ITEMS_MENU_ICONS.push(I_QUEST)
    ITEM_ID.push("Quest")
  end
  # Add all items category
  if QUEST_ITEMS
    ITEMS_MENU_TEXT.insert(ALL_ITEMS_POSITION - 1, T_ALL)
    ITEMS_MENU_ICONS.insert(ALL_ITEMS_POSITION - 1, I_ALL)
  end
  # Add all items category
  if ALL_ITEMS
    ITEM_ID.insert(ALL_ITEMS_POSITION - 1, "All")
  end
end

#==============================================================================
# ** Window_Blank
#------------------------------------------------------------------------------
#  This window deals with blank window backgrounds.
#==============================================================================

class Window_Blank < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x        : window x coordinate
  #     y        : window y coordinate
  #     width    : window width
  #     height   : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
end

#==============================================================================
# ** Window_Category
#------------------------------------------------------------------------------
#  This window deals with item category command choices.
#==============================================================================

class Window_Category < Window_Selectable
  #--------------------------------------------------------------------------
  # * include the CMS_Config module
  #--------------------------------------------------------------------------
  include CIM_Config
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     width    : window width
  #     commands : command text string array
  #--------------------------------------------------------------------------
  def initialize(width, commands)
    # Compute window height from command quantity
    cw = 32 + ITEMS_MENU_TEXT.size * 32
    super(640 - cw, 0, cw, 64)
    @column_max = ITEMS_MENU_TEXT.size
    @item_max = ITEMS_MENU_TEXT.size
    @commands = commands
    @select = 0
    self.contents = Bitmap.new(cw - 32, height - 32)
    refresh
    self.index = 0
    self.opacity = 0 unless CATEGORIES_WINDOW
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #     color : text color
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = Rect.new(0, 0, 24, 24)
    bitmap = RPG::Cache.icon(ITEMS_MENU_ICONS[index])
    self.contents.blt(4 + 32 * index, 4, bitmap, rect) unless UNSELECTED_TRANSLUCENT && index != @select
    self.contents.blt(4 + 32 * index, 4, bitmap, rect, 160) if UNSELECTED_TRANSLUCENT && index != @select
  end
  #--------------------------------------------------------------------------
  # * Disable Item
  #     index : item number
  #--------------------------------------------------------------------------
  def disable_item(index)
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    @select = @index
    # If cursor position is less than 0
    if @index < 0 || !CATEGORY_CURSOR
      self.cursor_rect.empty
      return
    end
    # Update cursor rectangle
    self.cursor_rect.set(@index*32, 0, 32, 32)
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(ITEMS_MENU_TEXT[self.index])
  end
end

#==============================================================================
# ** Window_ItemTop
#------------------------------------------------------------------------------
#  This window shows top bar with the title "Items" on it.
#==============================================================================

class Window_ItemTop < Window_Base  
  #--------------------------------------------------------------------------
  # * include the CMS_Config module
  #--------------------------------------------------------------------------
  include CIM_Config
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    cw = 32 + ITEMS_MENU_TEXT.size * 32
    super(0, 0, 640 - cw, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @text = ITEMS_MENU_TEXT[0]
    @width = 640 - cw
    update
    self.opacity = 0 unless CATEGORIES_WINDOW
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    self.contents.clear
    self.contents.draw_text(0, 0, @width - 32, 32, @text, TITLE_ALIGNMENT)
  end
  def set_text(text)
    @text = text
  end
end

#==============================================================================
# ** Window_ItemHelp
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================

class Window_ItemHelp < Window_Base
  #--------------------------------------------------------------------------
  # * include the CMS_Config module
  #--------------------------------------------------------------------------
  include CIM_Config
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 640, 128)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #  text  : text string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def set_text(text, item, align = 0)
    # If at least one part of text and alignment differ from last time
    if text != @text or align != @align
      # Redraw text
      self.contents.clear
      # Redraw icon
      if item
        bitmap = RPG::Cache.icon(item.icon_name)
        width = bitmap.width
        height = bitmap.height
        src_rect = Rect.new(0, 0, width, height)
        dest_rect = Rect.new(0, 24, width * 2, height * 2)
        self.contents.stretch_blt(dest_rect, bitmap, src_rect) if ICON_DISPLAY == 2
        self.contents.blt(0, 36, bitmap, src_rect)if ICON_DISPLAY == 1
      else
        width = 0
      end
      self.contents.font.color = normal_color
      self.contents.draw_text(4 + width * ICON_DISPLAY, 32, self.width - 40, 32, text, align)
      @text = text
      @align = align
      @actor = nil
    end
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # * Set Display
  #  text  : text string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def set_display(text, icon, align = 0)
    # If at least one part of text and alignment differ from last time
    if text != @text or align != @align
      # Redraw text
      self.contents.clear
      # Redraw icon
      if icon
        bitmap = RPG::Cache.icon(icon)
        width = bitmap.width
        height = bitmap.height
        src_rect = Rect.new(0, 0, width, height)
        dest_rect = Rect.new(0, 24, width * 2, height * 2)
        self.contents.stretch_blt(dest_rect, bitmap, src_rect)
      else
        width = 0
      end
      self.contents.font.color = normal_color
      self.contents.draw_text(4 + width * 2, 32, self.width - 40, 32, text, align)
      @text = text
      @align = align
      @actor = nil
    end
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #     actor : status displaying actor
  #--------------------------------------------------------------------------
  def set_actor(actor)
    if actor != @actor
      self.contents.clear
      draw_actor_name(actor, 4, 0)
      draw_actor_state(actor, 140, 0)
      draw_actor_hp(actor, 284, 0)
      draw_actor_sp(actor, 460, 0)
      @actor = actor
      @text = nil
      self.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Set Enemy
  #     enemy : name and status displaying enemy
  #--------------------------------------------------------------------------
  def set_enemy(enemy)
    text = enemy.name
    state_text = make_battler_state_text(enemy, 112, false)
    if state_text != ""
      text += "  " + state_text
    end
    set_text(text, 1, 1)
  end
end

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays items in possession on the item and battle screens.
#==============================================================================

class Window_ItemMenu < Window_Selectable
  #--------------------------------------------------------------------------
  # * include the CMS_Config module
  #--------------------------------------------------------------------------
  include CIM_Config
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 640, 352)
    @column_max = 2
    @category = ITEM_ID[0]
    refresh
    self.index = -1
    @category_select = true
    # If in battle, move window to center of screen
    # and make it semi-transparent
    if $game_temp.in_battle
      self.y = 64
      self.height = 256
      self.back_opacity = 160
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    case @category
    when "Recent"
      if @items_max > 20
        return @recent[self.index + (@items_max - 20)]
      else
        return @recent[self.index]
      end
    when "Consume"
      return @consumable[self.index]
    when "Weapon"
      return @weapon[self.index]
    when "Body"
      return @body[self.index]
    when "Head"
      return @head[self.index]
    when "Arm"
      return @arm[self.index]
    when "Accessory"
      return @accessory[self.index]
    when "Raw"
      return @raw[self.index]
    when "Quest"
      return @quest[self.index]
    when "Equip"
      return @equipment[self.index]
    when "All"
      return @all[self.index]
    end
  end
  #--------------------------------------------------------------------------
  # * Set Category
  #--------------------------------------------------------------------------
  def category(index)
    @category = ITEM_ID[index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    
    @recent = []
    @consumable = []
    @weapon = []
    @body = []
    @head = []
    @arm = []
    @accessory = []
    @raw = []
    @quest = []
    @equipment = []
    @all = []
    # Add item
    for i in 1...$data_items.size
      if $game_party.item_number(i) > 0
        # Add recent items
        if $game_party.recent_items.size < 20
          for u in 0...$game_party.recent_items.size
            if $data_items[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Item)
              @recent[($game_party.recent_items.size - 1) - u] = ($data_items[i])
            end
          end
        else
          for u in $game_party.recent_items.size-20...$game_party.recent_items.size
            if $data_items[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Item)
              @recent[21 - (u - ($game_party.recent_items.size-20))] = ($data_items[i])
            end
          end
        end
        
        # Add consumable, raw and quest items
        if $data_items[i].consumable
          if $data_items[i].occasion == 3
            @raw.push($data_items[i])
          else
            @consumable.push($data_items[i])
          end
        else
          @quest.push($data_items[i])
        end
        @all.push($data_items[i])
      end
    end
    
    # Also add weapons and armors if outside of battle
    unless $game_temp.in_battle
      for i in 1...$data_weapons.size
        if $game_party.weapon_number(i) > 0
          # Add recent items
          if $game_party.recent_items.size < 20
            for u in 0...$game_party.recent_items.size
              if $data_weapons[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Weapon)
                @recent[($game_party.recent_items.size - 1) - u] = ($data_weapons[i])
              end
            end
          else
            for u in $game_party.recent_items.size-20...$game_party.recent_items.size
              if $data_weapons[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Weapon)
                @recent[21 - (u - ($game_party.recent_items.size-20))] = ($data_weapons[i])
              end
            end
          end
          
          # Add weapons
          @weapon.push($data_weapons[i])
          @equipment.push($data_weapons[i])
          @all.push($data_weapons[i])
        end
      end
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0
          # Add recent armors
          if $game_party.recent_items.size < 20
            for u in 0...$game_party.recent_items.size
              if $data_armors[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Armor)
                @recent[($game_party.recent_items.size - 1) - u] = ($data_armors[i])
              end
            end
          else
            for u in $game_party.recent_items.size-20...$game_party.recent_items.size
              if $data_armors[i].id == $game_party.recent_items[u].id && $game_party.recent_items[u].is_a?(RPG::Armor)
                @recent[21 - (u - ($game_party.recent_items.size-20))] = ($data_armors[i])
              end
            end
          end
          
          # Add armors
          if $data_armors[i].kind == 2 # Body Armor
            @body.push($data_armors[i])
          elsif $data_armors[i].kind == 1 # Head Armor
            @head.push($data_armors[i])
          elsif $data_armors[i].kind == 0 # Arm Armor
            @arm.push($data_armors[i])
          elsif $data_armors[i].kind == 3 # Accessories
            @accessory.push($data_armors[i])
          end
          @equipment.push($data_armors[i])
          @all.push($data_armors[i])
        end
      end
    end
    
    # Repaint
    if @category == "Recent"
      @item_max = @recent.size
    elsif @category == "Consume"
      @item_max = @consumable.size
    elsif @category == "Weapon"
      @item_max = @weapon.size
    elsif @category == "Body"
      @item_max = @body.size
    elsif @category == "Head"
      @item_max = @head.size
    elsif @category == "Arm"
      @item_max = @arm.size
    elsif @category == "Accessory"
      @item_max = @accessory.size
    elsif @category == "Raw"
      @item_max = @raw.size
    elsif @category == "Quest"
      @item_max = @quest.size
    elsif @category == "Equip"
      @item_max = @equipment.size
    elsif @category == "All"
      @item_max = @all.size
    end
    @items_max = @item_max
    if @item_max == 0 
      self.contents.dispose if self.contents != nil
      self.contents = Bitmap.new(width - 32, height - 32)
    end
      if @item_max > 20 && @category == "Recent"
        self.contents = Bitmap.new(width - 32, height - 32)
        for i in @recent.size-20...@recent.size
          draw_item(i)
        end
        @items_max = @item_max
        @item_max = 20
      elsif @item_max > 0
        self.contents = Bitmap.new(width - 32, row_max * 32)
        for i in 0...@item_max
          draw_item(i)
        end
      end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    case @category
    when "Recent"
      item = @recent[index]
    when "Consume"
      item = @consumable[index]
    when "Weapon"
      item = @weapon[index]
    when "Body"
      item = @body[index]
    when "Head"
      item = @head[index]
    when "Arm"
      item = @arm[index]
    when "Accessory"
      item = @accessory[index]
    when "Raw"
      item = @raw[index]
    when "Quest"
      item = @quest[index]
    when "Equip"
      item = @equipment[index]
    when "All"
      item = @all[index]
    end
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and
       $game_party.item_can_use?(item.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    if @item_max > 20 && @category == "Recent"
      y = (index - (@item_max - 20)) / 2 * 32
    else
      y = index / 2 * 32
    end
    if item != nil
      rect = Rect.new(x, y, self.width / @column_max - 32, 32)
      self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
      bitmap = RPG::Cache.icon(item.icon_name)
      opacity = self.contents.font.color == normal_color ? 255 : 128
      self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
      self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
      self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
      self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    if @index >= 0
      @help_window.set_text(self.item == nil ? "" : self.item.description, self.item)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if self.active and @item_max >= 0 and @index >= 0
      if Keys.trigger?($keyboard["up"]) && @index <= 1
        #Input.trigger?(Input::UP)
        @index = -1
      end
    end
    super
  end
  def cat_select(tf)
    @category_select = tf
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # If cursor position is less than 0
    if @index < 0 || @category_select
      self.cursor_rect.empty
      return
    end
    # Get current row
    row = @index / @column_max
    # If current row is before top row
    if row < self.top_row
      # Scroll so that current row becomes top row
      self.top_row = row
    end
    # If current row is more to back than back row
    if row > self.top_row + (self.page_row_max - 1)
      # Scroll so that current row becomes back row
      self.top_row = row - (self.page_row_max - 1)
    end
    # Calculate cursor width
    cursor_width = self.width / @column_max - 32
    # Calculate cursor coordinates
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 32 - self.oy
    # Update cursor rectangle
    self.cursor_rect.set(x, y, cursor_width, 32)
  end
  #--------------------------------------------------------------------------
  # * Draw Items after use
  #--------------------------------------------------------------------------
  def draw_items(index)
    if @category == "Recent" && @recent.size > 20
      draw_item(index + (@item_max - 20))
    else
      draw_item(index)
    end
  end
end

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs item screen processing.
#==============================================================================

class Scene_Item
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make help window, item window
    @top_window = Window_Blank.new(0, 0, 640, 64) unless CIM_Config::CATEGORIES_WINDOW
    @help_window = Window_ItemHelp.new
    @itemtop_window = Window_ItemTop.new
    @help_windowback = Window_Blank.new(0, 416, 640, 64)
    @help_window.y = 384
    @item_window = Window_ItemMenu.new
    @item_window.active = false
    # Associate help window
    @item_window.help_window = @help_window
    # Make target window (set to active)
    @category_window = Window_Category.new(320, [])
    @category_window.active = true
    @category_window.help_window = @itemtop_window
    # Make target window (set to invisible / inactive)
    @target_window = Window_Target.new
    @target_window.visible = false
    @target_window.active = false
    @item_window.refresh
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @help_window.dispose
    @item_window.dispose
    @target_window.dispose
    @help_windowback.dispose
    @category_window.dispose
    @itemtop_window.dispose
    @top_window.dispose unless CIM_Config::CATEGORIES_WINDOW
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    @help_window.update
    @item_window.update
    @target_window.update
    @help_windowback.update
    @category_window.update
    @category_window.refresh
    @itemtop_window.update
    @top_window.update unless CIM_Config::CATEGORIES_WINDOW
    # If item window is active: call update_item
    if @item_window.active
      update_item
      return
    end
    # If target window is active: call update_target
    if @target_window.active
      update_target
      return
    end
    # If target window is active: call update_target
    if @category_window.active
      @help_window.set_display ("", "")
      update_category
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  def update_item
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Set category window active
      @item_window.active = false
      @item_window.cat_select(true)
      @category_window.active = true
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
      # Get currently selected data on the item window
      @item = @item_window.item
      # If not a use item
      unless @item.is_a?(RPG::Item)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # If it can't be used
      unless $game_party.item_can_use?(@item.id)
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      # If effect scope is an ally
      if @item.scope >= 3
        # Activate target window
        @item_window.active = false
        @target_window.x = (@item_window.index + 1) % 2 * 304
        @target_window.visible = true
        @target_window.active = true
        # Set cursor position to effect scope (single / all)
        if @item.scope == 4 || @item.scope == 6
          @target_window.index = -1
        else
          @target_window.index = 0
        end
      # If effect scope is other than an ally
      else
        # If command event ID is valid
        if @item.common_event_id > 0
          # Command event call reservation
          $game_temp.common_event_id = @item.common_event_id
          # Play item use SE
          $game_system.se_play(@item.menu_se)
          # If consumable
          if @item.consumable
            # Decrease used items by 1
            $game_party.lose_item(@item.id, 1)
            # Draw item window item
            @item_window.draw_item(@item_window.index)
          end
          # Switch to map screen
          $scene = Scene_Map.new
          return
        end
      end
      return
    end
    # If UP button was pressed
    if Keys.trigger?($keyboard["up"]) && @item_window.index == -1
      #Input.trigger?(Input::UP)
      # Set category window active
      @item_window.active = false
      @item_window.cat_select(true)
      @category_window.active = true
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when target window is active)
  #--------------------------------------------------------------------------
  def update_target
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # If unable to use because items ran out
      unless $game_party.item_can_use?(@item.id)
        # Remake item window contents
        @item_window.refresh
      end
      # Erase target window
      @item_window.active = true
      @target_window.visible = false
      @target_window.active = false
      @item_window.refresh
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
      # If items are used up
      if $game_party.item_number(@item.id) == 0
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # If target is all
      if @target_window.index == -1
        # Apply item effects to entire party
        used = false
        for i in $game_party.actors
          used |= i.item_effect(@item)
        end
      end
      # If single target
      if @target_window.index >= 0
        # Apply item use effects to target actor
        target = $game_party.actors[@target_window.index]
        used = target.item_effect(@item)
      end
      # If an item was used
      if used
        # Play item use SE
        $game_system.se_play(@item.menu_se)
        # If consumable
        if @item.consumable
          # Decrease used items by 1
          $game_party.lose_item(@item.id, 1)
          # Redraw item window item
          @item_window.draw_items(@item_window.index)
        end
        # Remake target window contents
        @target_window.refresh
        # If all party members are dead
        if $game_party.all_dead?
          # Switch to game over screen
          $scene = Scene_Gameover.new
          return
        end
        # If common event ID is valid
        if @item.common_event_id > 0
          # Common event call reservation
          $game_temp.common_event_id = @item.common_event_id
          # Switch to map screen
          $scene = Scene_Map.new
          return
        end
      end
      # If item wasn't used
      unless used
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when category window is active)
  #--------------------------------------------------------------------------
  def update_category
    @item_window.category(@category_window.index)
    @item_window.cat_select(true)
    if Keys.repeat?($keyboard["right"])|| Keys.repeat?($keyboard["left"])
      #Input.repeat? (Input::RIGHT) || Input.repeat? (Input::LEFT)
    @item_window.refresh
    end
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to menu screen
      $scene = Scene_Menu.new(0)
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
      # Get currently selected data on the item window
      @item = @category_window.index
      # Set item window active
      @item_window.active = true
      @item_window.index = 0
      @category_window.active = false
      @item_window.cat_select(false)
      # Play decision SE
      $game_system.se_play($data_system.decision_se)
      return
    end
    # If DOWN button was pressed
    if Keys.trigger?($keyboard["down"])
      #Input.trigger?(Input::DOWN)
      # Set item window active
      @item_window.active = true
      @item_window.index = 0
      @category_window.active = false
      @item_window.cat_select(false)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      return
    end
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  attr_reader     :recent_items
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias af_cim_init_gp initialize
  def initialize
    af_cim_init_gp
    @recent_items = []
  end
  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def gain_item(item_id, n)
    # Update quantity data in the hash.
    if item_id > 0
      @items[item_id] = [[item_number(item_id) + n, 0].max, 99].min
      gain_recent_item(item_id) if n >= 0
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Weapons (or lose)
  #     weapon_id : weapon ID
  #     n         : quantity
  #--------------------------------------------------------------------------
  def gain_weapon(weapon_id, n)
    # Update quantity data in the hash.
    if weapon_id > 0
      @weapons[weapon_id] = [[weapon_number(weapon_id) + n, 0].max, 99].min
      gain_recent_weapon(weapon_id) if n >= 0
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Armor (or lose)
  #     armor_id : armor ID
  #     n        : quantity
  #--------------------------------------------------------------------------
  def gain_armor(armor_id, n)
    # Update quantity data in the hash.
    if armor_id > 0
      @armors[armor_id] = [[armor_number(armor_id) + n, 0].max, 99].min
      gain_recent_armor(armor_id) if n >= 0
    end
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def lose_item(item_id, n)
    # Reverse the numerical value and call it gain_item
    gain_item(item_id, -n)
    for i in 0...@recent_items.size
      if $game_party.item_number(@recent_items[i].id) == 0 && @recent_items[i].is_a?(RPG::Item) && @recent_items[i].id == item_id
        @recent_items.delete_at(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Lose Weapons
  #     weapon_id : weapon ID
  #     n         : quantity
  #--------------------------------------------------------------------------
  def lose_weapon(weapon_id, n)
    # Reverse the numerical value and call it gain_weapon
    gain_weapon(weapon_id, -n)
    for i in 0...@recent_items.size
      if $game_party.item_number(@recent_items[i].id) == 0 && @recent_items[i].is_a?(RPG::Weapon) && @recent_items[i].id == weapon_id
        @recent_items.delete_at(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Lose Armor
  #     armor_id : armor ID
  #     n        : quantity
  #--------------------------------------------------------------------------
  def lose_armor(armor_id, n)
    # Reverse the numerical value and call it gain_armor
    gain_armor(armor_id, -n)
    if $game_party.item_number(armor_id) <= 0
    for i in 0...@recent_items.size
      if $game_party.item_number(@recent_items[i].id) == 0 && @recent_items[i].is_a?(RPG::Armor) && @recent_items[i].id == armor_id
        @recent_items.delete_at(i)
      end
    end
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Recent Items
  #     item_id  : item ID
  #--------------------------------------------------------------------------
  def gain_recent_item(item_id)
    for i in 0...@recent_items.size
      if @recent_items[i].id == $data_items[item_id].id && @recent_items[i].is_a?(RPG::Item)
        @recent_items.delete_at(i)
      end
    end
    @recent_items.push($data_items[item_id])
    if @recent_items.size > 40
      @recent_items.delete_at(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Recent Weapons
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  def gain_recent_weapon(weapon_id)
    for i in 0...@recent_items.size
      if @recent_items[i].id == $data_weapons[weapon_id].id && @recent_items[i].is_a?(RPG::Weapon)
        @recent_items.delete_at(i)
      end
    end
    @recent_items.push($data_weapons[weapon_id])
    if @recent_items.size > 40
      @recent_items.delete_at(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Recent Armor
  #     armor_id  : armor ID
  #--------------------------------------------------------------------------
  def gain_recent_armor(armor_id)
    for i in 0...@recent_items.size
      if @recent_items[i].id == $data_armors[armor_id].id && @recent_items[i].is_a?(RPG::Armor)
        @recent_items.delete_at(i)
      end
    end
    @recent_items.push($data_armors[armor_id])
    if @recent_items.size > 40
      @recent_items.delete_at(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def equip_item(item_id, n)
    # Update quantity data in the hash.
    if item_id > 0
      @items[item_id] = [[item_number(item_id) + n, 0].max, 99].min
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Weapons (or lose)
  #     weapon_id : weapon ID
  #     n         : quantity
  #--------------------------------------------------------------------------
  def equip_weapon(weapon_id, n)
    # Update quantity data in the hash.
    if weapon_id > 0
      @weapons[weapon_id] = [[weapon_number(weapon_id) + n, 0].max, 99].min
    end
  end
  #--------------------------------------------------------------------------
  # * Gain Armor (or lose)
  #     armor_id : armor ID
  #     n        : quantity
  #--------------------------------------------------------------------------
  def equip_armor(armor_id, n)
    # Update quantity data in the hash.
    if armor_id > 0
      @armors[armor_id] = [[armor_number(armor_id) + n, 0].max, 99].min
    end
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================
class Game_Actor
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     equip_type : type of equipment
  #     id    : weapon or armor ID (If 0, remove equipment)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0  # Weapon
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.equip_weapon(@weapon_id, 1)
        @weapon_id = id
        $game_party.lose_weapon(id, 1)
      end
    when 1  # Shield
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.equip_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 2  # Head
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.equip_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 3  # Body
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.equip_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 4  # Accessory
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.equip_armor(@armor4_id, 1)
        @armor4_id = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
end
