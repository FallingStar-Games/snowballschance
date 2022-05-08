#==============================================================================
# Individual Battle Commands
# by Atoa
# Based on Charlie FLeed script
#==============================================================================
# This scripts allows you to make diferent commands for each actor
#
# Now you can not only add an command to an skill, you can also add an command
# to an actor (like in RM2000/2003/VX) and add an skill directly to an command
# so if you select the command, the skill will be used without opening the
# skill menu
# 
# IMPORTANT: If you using the 'Atoa ATB' or 'Atoa CTB', put this script bellow them
#==============================================================================

module Atoa
  # Do not remove or change these lines
  Skill_Command = {}
  Actor_Command = {}
  Usable_Command = {}
  Command_Color = {}
  Custom_Command_Order = {}
  # Do not remove or change these lines

  # Skill Commands.
  # These commands appear automatically when an actor learn one of the skill
  # that is part of the command.
  #
  # Skill_Command[Command_Name] = [Skills_IDs]
  #
  Skill_Command['Magic'] = [ 6, 7, 9, 10, 11, 12, 14, 15, 
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
    35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
    54, 55, 56]
  
  Skill_Command['Techs'] = [1, 2, 3, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68,
    69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 82]
  
  # Skill_Command['Summon'] = [83,84,85,86]
  
  # Skill_Command['Limit Break'] = [108]
  
  # Skill_Command['Unite'] = [100,103]
    
  # Actor Commands.
  # These are the commands linked to the actors, they will be shown even if
  # the actor has none of the skill of this command.
  # You can add the same command for different actors, the list of skills shown
  # will be separated for each
  #
  # Actor_Command[Command_Name] = {Actor_id => [Skills_IDs]}
  #
  # Actor_Command['Skill'] = {1 => [88,92,97,126], 2 => [89,93,99,146], 3 => [90,95,96,106,147]}
    
  #Actor_Command['Temporal Arts'] = {4 => [46,47,48,49,50]}
  
  # Usable Commands.
  # These commands are linked directly to an skill. Once you choose one of them
  # you will use without opening the skill menu.
  # This command appear automatically once the actor learn the skill linked to
  # the command. The skill linked to the command aren't shown in the skill
  # menu outside battle
  #
  # Direct_Comman[Command_Name] = Skill_ID
  #
  #Usable_Command['Steal'] = 82
  #Usable_Command['Return'] = 87
  
  Usable_Command['Gunblitz'] = 4
  Usable_Command['Lethal Strike'] = 5
  Usable_Command['Deadly Blow'] = 8
  Usable_Command['Escape'] = 13
  # Commands Color
  # You can add different colors for each command name
  #  Command_Color[Command_Name] = [red, green, blue]
  #Command_Color['Limit Break'] = [255, 255, 0]
  Custom_Command_Order[12] = ['Item','Attack','Defend','Escape']
  # Custom Command Order
  # You can change the order that the commands are shown for specific actors.
  # You must add *all* possible commands that the actor can have for skill commands.
  # They will be shown only if the actor fills the conditions for it.
  # Commands not listed here will be never shown for that actor, even if he fills the
  # condition to have that command. You can use that to remove basic commands
  # like "Attack" and "Defend" from an Actor.
  #Custom_Command_Order[2] = ['Attack','Defend','Item','Magic','Techs','Skill','Summon']
  
  #==============================================================================
  # Window Settings
  #==============================================================================
  
  # Show command list in status menu?
  Show_Commands_In_Menu = false
  
  # Position of command window in status menu
  Menu_Commands_Postition = [216,160]
  # Note: you must edit the status menu, or the command window will stay above
  # other informations
    
  # Command Window Border Opacity
  Command_Window_Border_Opacity = 255
  
  # Command Window Back Opacity
  Command_Window_Back_Opacity = 160
  
  # Max number of commands shown
  Max_Commands_Shown = 5
  
  # Image filename for window backgeound, must be on the Windowskin folder
  Command_Window_Bg = ''
  
  # Position of the backgroun image
  # Command_Window_Bg_Postion = [Position X, Position Y]
  Command_Window_Bg_Position = [0, 0]
  
  #==============================================================================
  # OVEDRIVE COMMANDS
  #==============================================================================
  # This part only has effect if used toghter with the Skill Overdrive Script.
  # With it you can make commands that are only shown if the Overdrive bar is full
  # Just add the command name bellow. Remember that the command must be configurated
  # according the other options. You can add how many commands you want
  Overdrive_Commands = ['Limit Break']
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Individual Commands'] = true

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :command_order
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_ibc initialize
  def initialize
    initialize_ibc
    @command_order = Custom_Command_Order
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
  attr_accessor :individual_commands
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_ibc setup
  def setup(actor_id)
    setup_ibc(actor_id)
    @individual_commands = []
  end
  #--------------------------------------------------------------------------
  # * Refresh commands
  #--------------------------------------------------------------------------
  def refresh_commands
    @individual_commands = []
    for i in 0...@skills.size
      skill = $data_skills[@skills[i]]
      if skill != nil
        for command in Skill_Command.dup
          if command[1].include?(skill.id) and not @individual_commands.include?(command[0])
            next if $atoa_script['Atoa Overdrive'] and (Overdrive_Commands.include?(command[0]) and !self.overdrive_full?)
            @individual_commands << command[0]
          end
        end
        for command in Usable_Command.dup
          #
          if command[1] == skill.id and not @individual_commands.include?(command[0])
            next if $atoa_script['Atoa Overdrive'] and (Overdrive_Commands.include?(command[0]) and !self.overdrive_full?)
            #sticks the thing in command slot 0 into the array of individual commands
            @individual_commands << command[0]
          end
        end        
      end
    end
    for command in Actor_Command.dup
      if command[1].include?(@actor_id) and not @individual_commands.include?(command[0])
        @individual_commands << command[0]
      end
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
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias add_actor_ibc add_actor
  def add_actor(actor_id)
    add_actor_ibc(actor_id)
    actor = $game_actors[actor_id]
    actor.refresh_commands
  end
  #--------------------------------------------------------------------------
  # * Add an Actor by index
  #     actor_id : actor ID
  #     index    : index
  #--------------------------------------------------------------------------
  alias add_actor_by_index_ibc add_actor_by_index
  def add_actor_by_index(actor_id, index)
    add_actor_by_index_ibc(actor_id, index)
    actor = $game_actors[actor_id]
    actor.refresh_commands
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :escape_name
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_ibc phase3_setup_command_window
  def phase3_setup_command_window
    phase3_setup_command_window_ibc
    @active_battler.refresh_commands
    set_commands
    @actor_command_window.dispose
    @actor_command_window = Window_Command_IBC.new(160, @individual_commands, @active_battler)
    comand_size = (@individual_commands.size >= 5 ? 5 : @individual_commands.size)
    command_window_position
    @actor_command_window.y = @actor_command_window.y + 120 - 24 * comand_size 
    @actor_command_window.back_opacity = [Command_Window_Back_Opacity, 1].max
    @actor_command_window.opacity = [Command_Window_Border_Opacity, 1].max
    @actor_command_window.z = 4500
    @actor_command_window.index = 0
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = Battle_Name_Window
    set_name_window_position
  end
  #--------------------------------------------------------------------------
  # * Set commands
  #--------------------------------------------------------------------------
  def set_commands
    if $game_system.command_order[@active_battler.id] != nil
      @individual_commands = []
      basic_commands = [$data_system.words.attack, $data_system.words.item, $data_system.words.guard]
      custom_commands = @active_battler.individual_commands.dup
      commands = Custom_Command_Order[@active_battler.id].dup
      for i in 0...commands.size
        @individual_commands << commands[i] if basic_commands.include?(commands[i])
        @individual_commands << commands[i] if custom_commands.include?(commands[i])
      end
      return
    end
    s1 = $data_system.words.attack
    s2 = $data_system.words.item
    s3 = $data_system.words.guard
    s4 = @escape_name if @escape_type == 0
    @individual_commands = [s1] + @active_battler.individual_commands + [s2, s3]
    if @escape_type == 0
      @individual_commands = [s1]+  @active_battler.individual_commands + [s2, s3, s4]
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  alias update_phase3_basic_command_ibc update_phase3_basic_command
  def update_phase3_basic_command
    @direct_command = false
    @command_name = @actor_command_window.commands[@actor_command_window.index]
    if Input.trigger?(Input::C)
      if @active_battler.disabled_commands.include?(@command_name)
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      case @command_name
      when @escape_name
        if $game_temp.battle_can_escape == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        $game_system.se_play($data_system.decision_se)
        update_phase2_escape
        return
      end
      if @active_battler != nil and 
        
        @active_battler.individual_commands.include?(@command_name)#active battler's individual commands hace command name in them
        
        if Usable_Command.include?(@command_name) #if the usable command has [command name] in it
          #unless skill can use it true
          unless @active_battler.skill_can_use?(Usable_Command[@command_name])
            #slap their little pizza hands away from it
            $game_system.se_play($data_system.buzzer_se)
            return
          end
          
          #now that we got that out of the way,
          #let's call this current action kind 1
          @active_battler.current_action.kind = 1
          @commands_category = @command_name
          @direct_command = true
          #this is considered a direct command, 
          #and the command category is just it's name
          @active_battler.current_action.skill_id = Usable_Command[@command_name] #might need to go after
          confirm_action_select($data_skills[Usable_Command[@command_name]]) 
          #then confirm the selection of [this skill] which is a usable command which is also a skill in the database
          #it selects the skill in the database which is [command name]
          #and then gives this to the thing
          return
        else
          $game_system.se_play($data_system.decision_se)
          @active_battler.current_action.kind = 1
          @commands_category = @command_name
          start_skill_select
          return
        end
      end
    end
    update_phase3_basic_command_ibc
    if $atoa_script['Atoa CTB'] and @active_battler != nil and 
       @active_battler.individual_commands.include?(@command_name) and
       Usable_Command.include?(@command_name)
      @active_battler.selected_action = $data_skills[Usable_Command[@command_name]]
    end
  end
  #--------------------------------------------------------------------------
  # * Start Skill Selection
  #--------------------------------------------------------------------------
  alias start_skill_select_ibc start_skill_select
  def start_skill_select
    start_skill_select_ibc
    @skill_window.dispose
    @skill_window = Window_Skill.new(@active_battler, @commands_category)
    @skill_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # * Activate command window
  #--------------------------------------------------------------------------
  def active_command_window
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @help_window.visible = false
    @active_battler_window.visible = true if Battle_Name_Window
  end
  #--------------------------------------------------------------------------
  # * End Enemy Selection
  #--------------------------------------------------------------------------
  alias end_enemy_select_ibc end_enemy_select
  def end_enemy_select
    end_enemy_select_ibc
    if @actor_command_window.commands[@actor_command_window.index] == $data_system.words.attack
      @active_battler_window.visible = true 
      @actor_command_window.active = true
      @actor_command_window.visible = true
      @help_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Updat (actor command phase : enemy selection)
  #--------------------------------------------------------------------------
  alias update_phase3_enemy_select_ibc update_phase3_enemy_select
  def update_phase3_enemy_select
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_enemy_select
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @enemy_arrow.index
      end_enemy_select
      end_direct_command_selection
      return
    end
    update_phase3_enemy_select_ibc
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : actor selection)
  #--------------------------------------------------------------------------
  alias update_phase3_actor_select_ibc update_phase3_actor_select
  def update_phase3_actor_select
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_actor_select
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      @active_battler.current_action.target_index = @actor_arrow.index
      end_actor_select
      end_direct_command_selection
      return
    end
    update_phase3_actor_select_ibc
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all enemies selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_enemies_ibc update_phase3_select_all_enemies
  def update_phase3_select_all_enemies
    @enemy_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_enemies
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_enemies
      end_direct_command_selection
      return
    end
    update_phase3_select_all_enemies_ibc
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all actors selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_actors_ibc update_phase3_select_all_actors
  def update_phase3_select_all_actors
    @actor_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_actors
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_actors
      end_direct_command_selection
      return
    end
    update_phase3_select_all_actors_ibc
  end      
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : all battlers selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_all_battlers_ibc update_phase3_select_all_battlers
  def update_phase3_select_all_battlers
    @battler_arrow_all.update_multi_arrow
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_all_battlers
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_all_battlers
      end_direct_command_selection
      return
    end
    update_phase3_select_all_battlers_ibc
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : self selection)
  #--------------------------------------------------------------------------
  alias update_phase3_select_self update_phase3_select_self #alias update_phase3_select_self update_phase3_select_self
  def update_phase3_select_self_ibc #def update_phase3_select_self
    @self_arrow.update
    if Input.trigger?(Input::B) and @direct_command
      $game_system.se_play($data_system.cancel_se)
      end_select_self
      active_command_window
      return
    end
    if Input.trigger?(Input::C) and @direct_command
      $game_system.se_play($data_system.decision_se)
      end_select_self
      end_direct_command_selection
      return
    end
    update_phase3_select_self
  end
  #--------------------------------------------------------------------------
  # * End direct command selection
  #--------------------------------------------------------------------------
  def end_direct_command_selection
    @direct_command = false
    phase3_next_actor
    @help_window.visible = false
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
  #     actor        : actor
  #     command_type : skill type
  #--------------------------------------------------------------------------
  def initialize(actor, command_type = '')
    super(0, 128, 640, 352)
    @command_type = command_type
    @actor = actor
    @column_max = 2
    refresh
    self.index = 0
    if $game_temp.in_battle
      self.y = 320
      self.height = 160
      self.z = 900
      self.back_opacity = Base_Opacity
    end
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
    for i in 0...@actor.skills.size
      skill = $data_skills[@actor.skills[i]]
      commands = []
      for command in Usable_Command.dup
        commands <<  command[1] unless commands.include?(command[1])
      end
      next if commands.include?(skill.id)
      if skill != nil and $game_temp.in_battle and skill_in_command?(skill)
        @data << skill unless @data.include?(skill)
      elsif skill != nil and not $game_temp.in_battle
        @data << skill unless @data.include?(skill)
      end
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Check if skill is valid for command
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_in_command?(skill)
    if Skill_Command[@command_type] != nil and 
       Skill_Command[@command_type].include?(skill.id)
      return true 
    elsif Actor_Command[@command_type] != nil and
       Actor_Command[@command_type].include?(@actor.id) and
       Actor_Command[@command_type][@actor.id].include?(skill.id)
      return true 
    end
    return false
  end
end

#==============================================================================
# ** Window_Command_IBC
#------------------------------------------------------------------------------
#  This window deals command choices for individual battle commands.
#==============================================================================

class Window_Command_IBC < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :commands
  #--------------------------------------------------------------------------
  # Initialize the objects
  #     width    : window width
  #     commands : command text string array
  #     battler  : battler
  #--------------------------------------------------------------------------
  def initialize(width, commands, battler = nil)
    if $game_temp.in_battle
      comand_size = (commands.size >= 5 ? 192 : commands.size * 32 + 32)
    else
      comand_size =  commands.size * 32 + 32
    end
    comand_size = [comand_size, Max_Commands_Shown * 32 + 32].min
    super(0, 0, width, comand_size)
    @battler = battler
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    self.index = 0
    if Command_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Command_Window_Bg)
      @background_image.x = Command_Window_Bg_Position[0]
      @background_image.y = Command_Window_Bg_Position[1]
      @background_image.z = 4499
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      if $game_temp.in_battle and @battler != nil and 
         Usable_Command.include?(@commands[i]) and not
         @battler.skill_can_use?(Usable_Command[@commands[i]])
        draw_item(i, disabled_color)
      elsif $game_temp.in_battle and @commands[i] == $scene.escape_name and
         $game_temp.battle_can_escape == false
        draw_item(i, disabled_color)
      else
        draw_item(i, normal_color)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #     color : color
  #--------------------------------------------------------------------------
  def draw_item(index, color)
    self.contents.font.color = set_font_color(index, color)
    rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index]) 
    #draws the text for the commands
  end
  #--------------------------------------------------------------------------
  # * Get font color
  #     index : item number
  #     color : color
  #--------------------------------------------------------------------------
  def set_font_color(index, color)
    return color if Command_Color[@commands[index]].nil?
    c = Command_Color[@commands[index]].dup
    return Color.new(c[0],c[1],c[2])
  end
  #--------------------------------------------------------------------------
  # * Enable Item
  #     index : item number
  #--------------------------------------------------------------------------
  def enable_item(index)
    draw_item(index, normal_color)
  end
  #--------------------------------------------------------------------------
  # * Disable Item
  #     index : item number
  #--------------------------------------------------------------------------
  def disable_item(index)
    draw_item(index, disabled_color)
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
# ** Scene_Status
#------------------------------------------------------------------------------
#  This class performs status screen processing.
#==============================================================================

class Scene_Status
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias main_scenestatus_ibc main
  def main
    set_command_window if Show_Commands_In_Menu
    main_scenestatus_ibc
    @command_window.dispose if Show_Commands_In_Menu
  end
  #--------------------------------------------------------------------------
  # * Set command window
  #--------------------------------------------------------------------------
  def set_command_window
    actor = $game_party.actors[@actor_index]
    actor.refresh_commands
    if ($atoa_script['Atoa ATB'] and Escape_Type == 0) or $atoa_script['Atoa CTB']
      @escape_type = 0
    end
    set_commands
    @command_window = Window_Command_IBC.new(160, @individual_commands, actor)
    @command_window.x = Menu_Commands_Postition[0]
    @command_window.y = Menu_Commands_Postition[1]
    @command_window.z = 1000
    @command_window.active = false
    @command_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * Set commands
  #--------------------------------------------------------------------------
  def set_commands
    actor = $game_party.actors[@actor_index]
    if Custom_Command_Order[actor.id] != nil
      @individual_commands = []
      basic_commands = [$data_system.words.attack, $data_system.words.item, $data_system.words.guard]
      custom_commands = actor.individual_commands.dup
      commands = Custom_Command_Order[actor.id].dup
      for i in 0...commands.size
        @individual_commands << commands[i] if basic_commands.include?(commands[i])
        @individual_commands << commands[i] if custom_commands.include?(commands[i])
      end
      return
    end
    s1 = $data_system.words.attack
    s2 = $data_system.words.item
    s3 = $data_system.words.guard
    s4 = @escape_name if @escape_type == 0
    @individual_commands = [s1] + actor.individual_commands + [s2, s3]
    if @escape_type == 0
      @individual_commands = [s1]+  actor.individual_commands + [s2, s3, s4]
    end
  end
end