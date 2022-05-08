=begin
-----------------------------------------------------------------------------
*** RECIPE CONFIGURATION ****************************************************
-----------------------------------------------------------------------------
INSTRUCTIONS:
This module contains the constant variables used for each recipe
format: 
RECIPE[index] = [recipe_id, [product_type, product_id],
                 [material_1_type, material_1_id, material_1_qty], ...]
recipe_id       : this is the ID number in "items" tab of database
product_type    : this is the "type" of item that will be created
                : 0 = item; 1 = weapon; 2 = armor
product_id      : this is the ID number in corresponding "type" tab of database
                : for finished product
material_1_type : first required material "type"
                : 0 = item; 1 = weapon; 2 = armor
material_1_id   : this is the ID number in corresponding "type" tab of database
                : for first material
material_1_qty  : the quantity required of first material to create product
*NOTE:*
This Script supports any number of required materials for each recipe, simply 
write in extra materials, following the same format 
EX. RECIPE[0] = [1, [0, 25], [0, 15, 5], [0, 12, 2], [0, 5, 1]]
that recipe would be found as the first item in the database, would create
item # 25 in the item database, and requires 5 item#15, 2 item#12 and 1 item#5
=end
=begin
module Crafting
  # Menu style, true - draw map and resize windows to fit contents
  # false - draw full windows
  RESIZE_MENU = true
  # Create array to hold recipe data
  #RECIPE[index] = [recipe_id, [product_type, product_id],
                 #[material_1_type, material_1_id, material_1_qty], ...]
  RECIPE = []
  # Create recipes below
  # cooked meat
  RECIPE[0] = [30, [0, 30], [0, 21, 1]]               
  # Full Potion
  RECIPE[1] = [34, [0, 3], [0, 2, 1], [0, 28, 1]]               
  # High Perfume
  RECIPE[2] = [35, [0, 5], [0, 4, 2], [0, 18, 1]]               
  # Iron Sword
  RECIPE[3] = [36, [1, 2], [1, 1, 1], [0, 13, 5], [0, 23, 5]] 
  # Ring of Water 
  RECIPE[4] = [37, [2, 32], [2, 26, 1], [2, 30, 1], [2, 29, 1], [0, 14, 1]]
end
#============================================================================
# ** Window_Prompt
#----------------------------------------------------------------------------
#   This window asks the user if they would like to create the item
#============================================================================
class Window_Prompt < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     item    : item that will be created
  #--------------------------------------------------------------------------
  def initialize
    super(200, ["Let's cook this", 'On second thought...'])
    self.x += 16
    self.y += 80
    self.z += 100
  end
end
#============================================================================
# ** Window_Materials
#----------------------------------------------------------------------------
#   This window displays required materials to synthesize recipe
#============================================================================
class Window_Materials < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(recipe)
    super(320, 64, 320, 416)
    refresh(recipe)
    self.index = -1 
    self.active = false
  end
  #--------------------------------------------------------------------------
  # * Current Item
  #--------------------------------------------------------------------------
  def cur_item #item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh Contents
  #--------------------------------------------------------------------------
  def refresh(recipe)
    @recipe = recipe
    if self.contents != nil
      self.contents.clear
      self.contents = nil
    end
    # If no recipes are possessed do not draw item
    @data = []
    if @recipe == nil
      self.height = 96 if Crafting::RESIZE_MENU
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
      # Memorize font size
      font_size = self.contents.font.size
      # Draw Header
      self.contents.font.color = system_color
      self.contents.draw_text(4, 0, 212, 32, 'Ingredients')
      self.contents.font.size = 14
      self.contents.draw_text(204, 0, 24, 32, 'need', 2)
      self.contents.draw_text(252, 0, 24, 32, 'held', 2)
      # Restore font size
      self.contents.font.size = font_size
      self.contents.draw_text(228, 0, 16, 32, '/', 1)
      return
    end
    @qty_req = []
    # Add items required
    for i in 2...@recipe.size
      case @recipe[i][0]
      when 0 # Item
        @data.push($data_items[@recipe[i][1]])
      when 1 # Weapon
        @data.push($data_weapons[@recipe[i][1]])
      when 2 # Armor
        @data.push($data_armors[@recipe[i][1]])
      end
      @qty_req.push(@recipe[i][2])
    end
    @item_max = @data.size
    # Resize ingredients list
    if Crafting::RESIZE_MENU
      self.height = @item_max * 32 + 64
      self.height = 416 if self.height > 416
    end
    # Draw items required
    self.contents = Bitmap.new(self.width - 32, @item_max * 32 + 32)
    for i in 0...@item_max
      draw_item(i)
    end
    # Memorize font size
    font_size = self.contents.font.size
    # Draw Header
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 212, 32, 'Ingredients')
    self.contents.font.size = 14
    self.contents.draw_text(204, 0, 24, 32, 'need', 2)
    self.contents.draw_text(252, 0, 24, 32, 'held', 2)
    # Restore font size
    self.contents.font.size = font_size
    self.contents.draw_text(228, 0, 16, 32, '/', 1)
  end
  #-------------------------------------------------------------------------
  # * Draw Ingredients
  #-------------------------------------------------------------------------
  def draw_item(index)
    cur_item = @data[index]
    x = 4
    y = index * 32 + 32
    # get number of items held
    case cur_item
    when RPG::Item
      number = $game_party.item_number(cur_item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(cur_item.id)
    when RPG::Armor
      number = $game_party.armor_number(cur_item.id)
    end
    self.contents.font.color = number >= @qty_req[index] ? 
                               normal_color : disabled_color
    rect = Rect.new(x, y, self.width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(cur_item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, cur_item.name)
    self.contents.draw_text(x + 200, y, 24, 32, @qty_req[index].to_s, 2)
    self.contents.draw_text(x + 224, y, 16, 32, '/', 1)
    self.contents.draw_text(x + 248, y, 24, 32, number.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # If cursor position is less than 0
    if @index < 0
      self.cursor_rect.empty
      return
    end
    # Get current row
    row = @index
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
    cursor_width = self.width - 32
    # Calculate cursor coordinates
    x = 0
    y = @index * 32 - self.oy + 32
    # Update cursor rectangle
    self.cursor_rect.set(x, y, cursor_width, 32)
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.cur_item == nil ? "" : self.cur_item.description)
  end
end


#============================================================================
# ** Window_Recipe
#----------------------------------------------------------------------------
#   This window displays recipes currently in possesion
#============================================================================
class Window_Recipe < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 64, 320, 416)
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Current Recipe
  #--------------------------------------------------------------------------
  def recipe
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh Contents
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.clear
      self.contents = nil
    end
    @data = []
    # Add Recipes in possession
    for i in 0...Crafting::RECIPE.size
      recipe_id = Crafting::RECIPE[i][0]
      if $game_party.item_number(recipe_id) > 0
        @data.push(Crafting::RECIPE[i])
      end
    end
    @item_max = @data.size
    # Resize recipe window
    if Crafting::RESIZE_MENU
      self.height = @data[0] == nil ? 96 : @item_max * 32 + 64
      self.height = 416 if self.height > 416
    end
    # If Any recipes are possessed, draw them
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, @item_max * 32 + 32)
      for i in 0...@item_max
        draw_recipes(i)
      end
    else
      self.contents = Bitmap.new(width - 32, height - 32)
    end
    # Draw Header
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 268, 32, 'Recipes Held', 1)
  end
  #-------------------------------------------------------------------------
  # * Draw Recipes
  #-------------------------------------------------------------------------
  def draw_recipes(index)
    recipe = @data[index]
    x = 4
    y = index * 32 + 32
    # check if recipe is can be created
    self.contents.font.color = recipe_can_create?(recipe) ? 
                               normal_color : disabled_color
    rect = Rect.new(x, y, self.width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon($data_items[recipe[0]].icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, $data_items[recipe[0]].name)
  end
  #--------------------------------------------------------------------------
  # * Can Recipe be Created
  #     recipe    : array with recipe data
  #--------------------------------------------------------------------------
  def recipe_can_create?(recipe)
    return false unless recipe
    for i in 2...recipe.size
      case recipe[i][0]
      when 0 # Item
        unless $game_party.item_number(recipe[i][1]) >= recipe[i][2]
          return false
        end
      when 1 # Weapon
        unless $game_party.weapon_number(recipe[i][1]) >= recipe[i][2]
          return false
        end
      when 2 # Armor
        unless $game_party.armor_number(recipe[i][1]) >= recipe[i][2]
          return false
        end
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Rectangle
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # If cursor position is less than 0
    if @index < 0
      self.cursor_rect.empty
      return
    end
    # Get current row
    row = @index
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
    cursor_width = self.width - 32
    # Calculate cursor coordinates
    x = 0
    y = @index * 32 - self.oy + 32
    # Update cursor rectangle
    self.cursor_rect.set(x, y, cursor_width, 32)
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    if self.recipe == nil
      cur_item = nil
      @help_window.set_text('')
    else
      case self.recipe[1][0]
      when 0 # item
        cur_item = $data_items[self.recipe[1][1]]
      when 1 # weapon
        cur_item = $data_weapons[self.recipe[1][1]]
      when 2 # armor
        cur_item = $data_armors[self.recipe[1][1]]
      end
      bitmap = RPG::Cache.icon(cur_item.icon_name)
      @help_window.set_text('Creates       ' + cur_item.name)
      @help_window.contents.blt(78, 4, bitmap, Rect.new(0, 0, 24, 24))
    end
  end
end
#============================================================================
# ** Scene_Crafting
#----------------------------------------------------------------------------
#    This scene handles the menu used for crafting new items
#============================================================================
class Scene_Crafting
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Draw map in background
   @background = Plane.new #background initialization
   @background.bitmap = RPG::Cache.panorama("plaidpattern",0)
    #map = Spriteset_Map.new if Crafting::RESIZE_MENU
    # Create Windows
    @recipe_window = Window_Recipe.new
    @index = 0
    @material_index = 0
    @material_window = Window_Materials.new(@recipe_window.recipe)
    @help_window = Window_Help.new
    # Associate help window
    @material_window.help_window = @help_window
    @recipe_window.help_window = @help_window
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update Graphics
      Graphics.update
      # Update Input
      Input.update
      # Update Frame
      update
      # If scene has changed
      if $scene != self
        break
      end
    end
    # Dispose windows
    @background.dispose
    #map.dispose if Crafting::RESIZE_MENU
    @recipe_window.dispose
    @material_window.dispose
    @help_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
   @background.ox -= 1 #move the background here
   @background.oy -= 1
    # Update current window
    @help_window.update
    if @recipe_window.active
      @recipe_window.update
      @material_window.refresh(@recipe_window.recipe)
      update_recipe
      return
    else
      @material_window.update
      update_material
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Update Recipe Window
  #--------------------------------------------------------------------------
  def update_recipe
    # if B button is pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Return to main menu
      $scene = Scene_Menu.new(4)
      return
    end
    # if C button is pressed
    if Input.trigger?(Input::C)
      # Get recipe
      recipe = @recipe_window.recipe
      # check if recipe can be created
      if @recipe_window.recipe_can_create?(recipe)
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Prompt player
        create_item_prompt(recipe)
        return
      else
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
    # if Right button is pressed
    if Input.trigger?(Input::RIGHT)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # Switch to materials window
      @index = @recipe_window.index
      @recipe_window.index = -1
      @recipe_window.active = false
      @material_window.active = true
      @material_window.index = @material_index
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Update Material Window
  #--------------------------------------------------------------------------
  def update_material
    # if B Button is pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Return to main menu
      $scene = Scene_Menu.new
      return
    end
    # if Left button is pressed
    if Input.trigger?(Input::LEFT)
      # Play cursor SE
      $game_system.se_play($data_system.cursor_se)
      # Switch to recipes window
      @material_index = @material_window.index
      @material_window.index = -1
      @material_window.active = false
      @recipe_window.index = @index
      @recipe_window.active = true
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Create Item Prompt
  #--------------------------------------------------------------------------
  def create_item_prompt(recipe)
    # Create item Prompt
    command = Window_Prompt.new
    # Deactivate recipe window
    @recipe_window.active = false
    # Loop until selection is made
    loop do
      # Update Graphics
      Graphics.update
      # Update input
      Input.update
      # Update commands
      command.update
      # if B button is pressed
      if Input.trigger?(Input::B)
        # Play cancel SE
        $game_system.se_play($data_system.cancel_se)
        # Return to recipe window
        break
      end
      # if C button is pressed
      if Input.trigger?(Input::C)
        case command.index
        when 0 # Create
          # Play create SE
          $game_system.se_play($data_system.equip_se)
          # Add item to inventory
          case recipe[1][0]
          when 0 # item
            $game_party.gain_item(recipe[1][1], 1)
          when 1 # weapon
            $game_party.gain_weapon(recipe[1][1], 1)
          when 2 # armor
            $game_party.gain_armor(recipe[1][1], 1)
          end
          # Remove ingredients
          for i in 2...recipe.size
            case recipe[i][0]
            when 0 # item
	      # BREWMEISTER's MODIFICATION for consumable/non-consumable items
              if $data_items[recipe[i][1]].consumable   ##BREW
                $game_party.lose_item(recipe[i][1], recipe[i][2])
              end                                       ##BREW
              # END MODIFICATION
            when 1 # weapon
              $game_party.lose_weapon(recipe[i][1], recipe[i][2])
            when 2 # armor
              $game_party.lose_armor(recipe[i][1], recipe[i][2])
            end
          end
          # Refresh recipe window
          @recipe_window.refresh
          break
        when 1 # Cancel
          # Play cancel SE
          $game_system.se_play($data_system.cancel_se)
          # Return to recipe window
          break
        end
      end
    end
    command.dispose
    @recipe_window.active = true
  end
end
=end