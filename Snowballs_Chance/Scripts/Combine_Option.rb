#==============================================================================
# ** Menu Item Add-On:  Combine Option
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.2
#    02-11-2013
#    RGSS / RPGMaker XP
#==============================================================================
# 
#  INTRODUCTION:
#
#  This little feature adds itself  to the default Scene_Item class,  allowing
#  the player to combine two individual items together to create a new item in
#  their party's cache of goods.
#
#------------------------------------------------------------------------------


# ===== REQUIRED HASH ARRAYS - DO NOT TOUCH ===================================
COMBINE, COMBINE_W, COMBINE_A = {}, {}, {}
#==============================================================================


  # ITEM-TO-ITEM COMBINABLES
  # ========================
  # Both values in the ITEMS array may be item IDs.
  #
  #          CODE       ITEMS 
  # ==============      ========
    COMBINE['I12']    = [ 1, 1 ]  # Takes two potions and makes item 12


    
  # ITEM-TO-WEAPON COMBINABLES
  # ==========================
  # The first value in the ITEMS array is the item ID,
  # but the second value must be a weapon ID.
  # The below example converts ITEM 1 and WEAPON 1 into Item 12
  #
  #          CODE       ITEMS 
  # ==============      ========
    COMBINE_W['i12']  = [ 1, 1 ]


  # ITEM-TO-ARMOR COMBINABLES
  # ==========================
  # The first value in the ITEMS array is the item ID,
  # but the second value must be the ID of a piece of armor.
  # The below example converts ITEM 4 and ARMOR 12 into Weapon 6
  #
  #          CODE       ITEMS 
  # ==============      ========
    COMBINE_W['W6']   = [ 4, 12 ]    


  # NON-COMBINABLES
  # ==========================
  # This allows you to let the player combine items that don't
  # actually work together to make... garbage!  Garbage is the
  # actual item in the database (by ID) that will be generated
  # if the player tries without success.
  #
    NON_COMBINE       = false    # If you fail to combine items and make garbage
    NON_COMBINE_ITEM  = 33      # The ID of the garbage item.
    
    
#==============================================================================
# ** Window_ItemCombine
#------------------------------------------------------------------------------
#  This window displays items in possession on the item and battle screens.
#==============================================================================

class Window_ItemCombine < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :first_item               # Initial item being combined
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(160, 64, 320, 416)
    @column_max = 1
    refresh
    self.index = 0
    @first_item = 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    # Add items from inventory, going through every item in database order
    for i in 1...$data_items.size
      if $game_party.item_number(i) > 0
        @data.push($data_items[i])
      end
    end
    for i in 1...$data_weapons.size
      if $game_party.weapon_number(i) > 0
        @data.push($data_weapons[i])
      end
    end
    for i in 1...$data_armors.size
      if $game_party.armor_number(i) > 0
        @data.push($data_armors[i])
      end
    end
    # If item count is not 0, make a bit map and draw all items
    @item_max = @data.size
    if @item_max > 0
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
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if NON_COMBINE == true
      # Set enabled color regardless
      self.contents.font.color = normal_color
    else
      # Set disabled color if not combinable
      self.contents.font.color = disabled_color
      # Check items on list
      if item.is_a?(RPG::Item)# if it's an item
        for items in COMBINE.keys #check the items in the combine keys
          if COMBINE[items].include?(@first_item) #if the first item in the array is available
            if COMBINE[items].include?(item.id) 
              if @first_item == item.id #checks if the first item is the item id
                if COMBINE[items][0] == COMBINE[items][1]
                  if $game_party.item_number(item.id) != 1
                    self.contents.font.color = normal_color
                  end
                end
              else
                self.contents.font.color = normal_color
              end
            end
          end
        end
      end
      # Check weapons on list
      if item.is_a?(RPG::Weapon)
        for items in COMBINE_W.keys
          if COMBINE_W[items][0] == @first_item
            if COMBINE_W[items][1] == item.id
              self.contents.font.color = normal_color
            end
          end
        end
      end
      # Check armor on list
      if item.is_a?(RPG::Armor)
        for items in COMBINE_A.keys
          if COMBINE_A[items][0] == @first_item
            if COMBINE_A[items][1] == item.id
              self.contents.font.color = normal_color
            end
          end
        end
      end
    end
    # The rest
    x = 4
    y = index * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Help Text Update
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.item == nil ? "" : self.item.description)
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
  alias combinable_main main
  def main
    # Create the decision option window
    @combine_decision         = Window_Command.new(160, ["Use", "Combine"] )
    @combine_decision.visible = false
    @combine_decision.active  = false
    @combine_decision.x       = 240
    @combine_decision.y       = 32
    @combine_decision.z       = 1000
    # Create the combinable item window
    @combine_window = Window_ItemCombine.new
    @combine_window.visible = false
    @combine_window.active  = false
    @combine_window.z       = 1000
    # The original call
    combinable_main
    # Dispose of windows
    @combine_decision.dispose
    @combine_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias combinable_update update
  def update
    @combine_decision.update
    @combine_window.update
    # If option wiindow is active: call update_combinable_decision
    if @combine_decision.active
      update_combinable_decision
      return
    end
    # If option wiindow is active: call update_combinable_decision
    if @combine_window.active
      update_combinable_selection
      return
    end
    # The original call
    combinable_update
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  alias combinable_update_item update_item
  def update_item
    # If C button was pressed
    if Input.trigger?(Input::C)
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
      did_check = update_combinable_check(@item.id)
      if did_check == true
        $game_system.se_play($data_system.decision_se)
        @combine_decision.visible   = true
        @combine_decision.active    = true
        @item_window.active         = false
        @combine_window.first_item  = @item.id
        @combine_window.refresh
        return
      end
    end
    # The original call
    combinable_update_item
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------
  def update_combinable_check(id)
    effective = false
    # Sort through Hash and get keys
    for items in COMBINE.keys
      effective = true if COMBINE[items].include?(id)
    end
    return effective
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when combine decision window is active)
  #--------------------------------------------------------------------------  
  def update_combinable_decision
    @combine_decision.refresh
    choice = @combine_decision.index
    # If B button was pressed
    if Input.trigger?(Input::B)
      @combine_decision.visible = false
      @combine_decision.active  = false    
      @item_window.active = true
      return
    end
    # If C button was pressed
    if Input.trigger?(Input::C)
      $game_system.se_play($data_system.decision_se)
      case choice
        when 0 ; update_combinable_use  # USE
        when 1 ;  @item_window.help_window.set_text("Combining")
                  @combine_window.visible = true
                  @combine_window.active  = true
      end
      @combine_decision.visible   = false
      @combine_decision.active    = false
    end
    # Branch on choice if applicable
    return
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item use window is active - remnant of item window)
  #--------------------------------------------------------------------------  
  def update_combinable_use
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
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when item window is active)
  #--------------------------------------------------------------------------  
  def update_combinable_selection
    # If B button was pressed
    if Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Erase target window
      @item_window.active = true
      @combine_window.visible = false
      @combine_window.active = false
      return
    end    
    # If B button was pressed
    if Input.trigger?(Input::C)
      # Get currently selected data on the item window
      @combine_item = @combine_window.item
      object_combine = nil
      # Cycle through items
      if @combine_item.is_a?(RPG::Item)
        for items in COMBINE.keys
          if COMBINE[items].include?(@item.id)
            if COMBINE[items].include?(@combine_item.id)
              if @item.id == @combine_item.id
                if COMBINE[items][0] == COMBINE[items][1]
                  if $game_party.item_number(@item.id) != 1
                    object_combine = items
                  end
                end
              else
                object_combine = items
              end
            end
          end
        end
      end
      # Cycle through Weapons
      if @combine_item.is_a?(RPG::Weapon)
        for items in COMBINE_W.keys
          if COMBINE_W[items][0] == @combine_item
            if COMBINE_W[items][1] == @item.id
              object_combine = items
            end
          end
        end
      end
      # Cycle through Armors
      if @combine_item.is_a?(RPG::Armor)
        for items in COMBINE_A.keys
          if COMBINE_A[items][0] == @combine_item
            if COMBINE_A[items][1] == @item.id
              object_combine = items
            end
          end
        end
      end
      # Perform the combining
      if object_combine != nil
        $game_system.se_play($data_system.decision_se)
        return perform_combine(object_combine, @item, @combine_item)
      end
      # Perform garbage if turned on
      if NON_COMBINE == true
        $game_system.se_play($data_system.buzzer_se)
        return perform_combine(NON_COMBINE_ITEM, @item, @combine_item)
      end
      # Play buzzer SE
      $game_system.se_play($data_system.buzzer_se)
      @combine_window.visible = false
      @combine_window.active  = false
      @item_window.active     = true
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when actively performing combine)
  #--------------------------------------------------------------------------  
  def perform_combine(combined_object, item1, item2)
    # Part 1:  Erase the item
    $game_party.lose_item(item1.id, 1)
    # Part 2:  Erase the item, weapon or armor
    case item2
    when RPG::Item    ; $game_party.lose_item(item2.id, 1)
    when RPG::Weapon  ; $game_party.lose_weapon(item2.id, 1)
    when RPG::Armor   ; $game_party.lose_armor(item2.id, 1)   
    end    
    # If the item is defined as the Non-Combine Item value
    if combined_object == NON_COMBINE_ITEM
      # Part 2a: Add the Non-Combine Item
      $game_party.gain_item(NON_COMBINE_ITEM, 1)
    # Otherwise
    else
      # Part 3: Determine item type and ID
      if COMBINE.has_key?(combined_object)
        c_type = combined_object.slice(0,1)
        c_id   = combined_object.slice(1,(combined_object.size-1)).to_i
      end
      if COMBINE_W.has_key?(combined_object)
        c_type = combined_object.slice(0,1)
        c_id   = combined_object.slice(1,(combined_object.size-1)).to_i
      end
      if COMBINE_A.has_key?(combined_object)
        c_type = combined_object.slice(0,1)
        c_id   = combined_object.slice(1,(combined_object.size-1)).to_i
      end
      # Part 4: Add the item based on type
      c_type = c_type.upcase  
      case c_type
      when "I" ; $game_party.gain_item(c_id, 1)
      when "W" ; $game_party.gain_weapon(c_id, 1)
      when "A" ; $game_party.gain_armor(c_id, 1)
      end
    end
    # Part 5: Refresh the item window
    @combine_window.visible = false
    @combine_window.active  = false    
    @item_window.refresh
    @item_window.active = true
    @item_window.index = 0
  end
end
