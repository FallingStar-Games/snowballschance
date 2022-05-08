
#==============================================================================
# ** Large Party
#------------------------------------------------------------------------------
#  Author: Dargor
#  Version 1.4
#  16/05/2014
#==============================================================================

#==============================================================================
# ** Large Party Customization Module
#==============================================================================
 
module Dargor
  module Large_Party
    # Maximum number of actors allowed in the party
    Max_Size = 10
    # Battle status window refresh rate (used in phase5)
    Battle_Refresh_Rate = 32
  end
end
 
#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================
 
class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_actor_index  # @actor_index in battle scene
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_temp_initialize initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    large_party_temp_initialize
    @battle_actor_index = 0
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
  attr_accessor :max_size   # Max number of actors allowed in the party
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_initialize initialize
  alias large_party_add_actor add_actor
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    large_party_initialize
    @max_size = Dargor::Large_Party::Max_Size
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    # Original method
    large_party_add_actor(actor_id)
    # Get actor
    actor = $game_actors[actor_id]
    # If the party has less than 4 members and this actor is not in the party
    if @actors.size < @max_size and not @actors.include?(actor)
      # Add actor
      @actors.push(actor)
      # Refresh player
      $game_player.refresh
    end
  end
end

#==============================================================================
# ** Window_MenuStatus #it's not over here stap messing with the window
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================
 
class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias large_party_menu_status_initialize initialize
  alias large_party_menu_status_refresh refresh
  alias large_party_menu_status_update_cursor_rect update_cursor_rect
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Original method
    large_party_menu_status_initialize
    # Adjust contents height
    @item_max = $game_party.actors.size
    height = @item_max * 120 #*120
    self.contents = Bitmap.new(width - 32, height - 32)
    # Refresh
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(*args)
    # Original method
    large_party_menu_status_refresh(*args)
    # Adjust default height
    self.height = 480 #480
  end
  #--------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #--------------------------------------------------------------------------
  def update_cursor_rect
    large_party_menu_status_update_cursor_rect
    row = @index / @column_max
    if row < self.top_row
      self.top_row = row
    end
    if row > self.top_row + (self.page_row_max - 1)
      self.top_row = row - (self.page_row_max - 1)
    end
    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 116 - self.oy #116
    self.cursor_rect.set(x, y, cursor_width, 96) #96
  end
  #--------------------------------------------------------------------------
  # * Top Row
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / 116 #116
  end
  #--------------------------------------------------------------------------
  # * Set Top Row
  #     row : new row
  #--------------------------------------------------------------------------
  def top_row=(row)
    if row < 0
      row = 0
    end
    if row > row_max - 1
      row = row_max - 1
    end
    self.oy = row * 116 #116
  end
  #--------------------------------------------------------------------------
  # * Page Row Max
  #--------------------------------------------------------------------------
  def page_row_max
    return 4 #was4
  end
end

#there was more but it sucked so I just kept the menu stuff