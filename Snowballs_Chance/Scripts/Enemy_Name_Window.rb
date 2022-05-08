#==============================================================================
# Enemy Name Window
# By Atoa
#==============================================================================
# This script adds an window with the names of the enemies
#==============================================================================
=begin
module Atoa
  
  # Enemy_Name_Window_Settings = [Position X, Position Y, width, height, opacity, transparent border]
  Enemy_Name_Window_Settings = [0 , 64, 160, 160, 160, false]

  # Position of enemy name window
  Enemy_Name_Window_Position = [0, 64]
  
  # Auto adjust enemy window height according to the enemy number
  Auto_Adjust_Height = true
  
  # Always show window(true) or show only during action selection (false)
  Always_Visible = false
  
  # Show amount of enemies of the same type?
  Show_Enemy_Number = true
  
  # Show enemies with the same name separatedely
  Show_Name_Duplicates = false
  
  # Reorder enemy name, if true, the order won't be based on the enemy index
  Sort_Enemy_Names = false
  
  # Filename of the Enemy Name Window background image, must be on the Windowskin fonder
  # Leave nil or '' for no image
  Enemy_Window_Back = ''
  
  # Enemy Name background image postion adjust
  # Enemy_Window_Bg_Position = [Position X, Position Y]
  Enemy_Window_Bg_Position = [0, 0]

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Enemy Name'] = true

#==============================================================================
# ** Window_Enemy_Name
#------------------------------------------------------------------------------
#  This window displays enemies name in battle
#==============================================================================

class Window_Enemy_Name < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    pos1 = [Enemy_Name_Window_Settings[0], Enemy_Name_Window_Settings[1]]
    pos2 = [Enemy_Name_Window_Settings[2], Enemy_Name_Window_Settings[3]]
    @pos = [pos1[0], pos1[1], [pos2[0], 64].max, [pos2[1], 64].max]
    super(*@pos)
    self.z = 2000
    self.back_opacity = Enemy_Name_Window_Settings[4]
    self.opacity = Enemy_Name_Window_Settings[4] if Enemy_Name_Window_Settings[5]
    if Enemy_Window_Back != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Enemy_Window_Back)
      @background_image.x = self.x + Enemy_Window_Bg_Position[0]
      @background_image.y = self.y + Enemy_Window_Bg_Position[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    enemy_ammount = {}
    enemy_name = []
    for enemy in $game_troop.enemies
      enemy_ammount[enemy.name] = 0
    end
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemy_ammount[enemy.name] += 1
        enemy_name << enemy.name
      end
    end
    enemy_name.sort! if Sort_Enemy_Names
    enemy_name.uniq! unless Show_Name_Duplicates
    height = Auto_Adjust_Height ? (enemy_name.size * 32) : @pos[3] - 32
    return if height == 0
    self.contents = Bitmap.new(@pos[2] - 32, height)
    self.height = height + 32 if Auto_Adjust_Height
    i = 0
    for name in enemy_name
      self.contents.font.color = normal_color
      self.contents.draw_text(4, i * 32, width - 32, 32, name)
      number = enemy_ammount[name].to_s
      self.contents.draw_text(0, i * 32, width - 36, 32, number, 2) if Show_Enemy_Number
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @background_image.visible = n if @background_image != nil
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Create Display Viewport
  #--------------------------------------------------------------------------
  alias create_viewport_enemywindow create_viewport 
  def create_viewport
    create_viewport_enemywindow
    @enemy_name_window = Window_Enemy_Name.new
    @enemy_name_window.visible = Always_Visible
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_enemywindow terminate
  def terminate
    terminate_enemywindow
    @enemy_name_window.dispose if @enemy_name_window != nil
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  alias start_phase2_enemywindow start_phase2
  def start_phase2
    @enemy_name_window.refresh  if @enemy_name_window != nil
    @enemy_name_window.visible = true  if @enemy_name_window != nil
    start_phase2_enemywindow
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_enemywindow step5_part4
  def step5_part4(battler)
    @enemy_name_window.refresh if @enemy_name_window != nil
    step5_part4_enemywindow(battler)
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias update_phase3_enemywindow update_phase3
  def update_phase3
    @enemy_name_window.visible = true if @enemy_name_window != nil
    update_phase3_enemywindow
  end
  #--------------------------------------------------------------------------
  # * Frame Update (main phase)
  #--------------------------------------------------------------------------
  alias update_phase4_enemywindow update_phase4
  def update_phase4
    @enemy_name_window.visible = Always_Visible if @enemy_name_window != nil
    update_phase4_enemywindow
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias atoa_update_enemywindow update
  def update
    refresh_enemy_name_window
    atoa_update_enemywindow
  end
  #--------------------------------------------------------------------------
  # * Update Enemy Name Window
  #--------------------------------------------------------------------------
  def refresh_enemy_name_window
    if @alive_enemies_name_window != enemies_alive_name_window
      @alive_enemies_name_window = enemies_alive_name_window
      @enemy_name_window.refresh  if @enemy_name_window != nil
    end
  end
  #--------------------------------------------------------------------------
  # * Check alive enemies
  #--------------------------------------------------------------------------
  def enemies_alive_name_window
    alive = 0
    for i in 0...$game_troop.enemies.size
      alive += 1 unless $game_troop.enemies[i].dead?
    end
    return alive
  end
end
=end