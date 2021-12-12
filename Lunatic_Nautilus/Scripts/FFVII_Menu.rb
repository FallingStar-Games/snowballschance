#==============================================================================
# ** FFVII Style Menu
#------------------------------------------------------------------------------
#   Author: FF12_Master
#   Version 1.1
#   11/5/2009
#      - V 1.0-
#             First Release
#      - V 1.1 -
#             Added a Playtime and Gold Menu Combined Script
#             Added a location Window
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #       menu_index : command cursor's initial position
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
     @menu_index = menu_index
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    @background = Plane.new #background initialization
    @background.bitmap = RPG::Cache.panorama("plaidpattern",0)
     # Make command window
     s1 = $data_system.words.item
     s2 = $data_system.words.skill
     s3 = $data_system.words.equip
     
    if $game_variables[2]< 10 
      #8 is when oatmeal is eaten. 10 is after kale chip event
     s4 = "???"
   else
     s4 = "Snackmaking" #"Status"
   end
   
     s5 = "Quicksave"
     s6 = "Diary"
     s7=  "End Game"
     @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6, s7])
     @command_window.index = @menu_index
     @command_window.x = 482
     @command_window.y = 0
     @command_window.z = 203
     @command_window.height = 250
     @command_window.width = 160
     # If number of party members is 0
     if $game_party.actors.size == 0
        # Disable items, skills, equipment, and status
        @command_window.disable_item(0)
        @command_window.disable_item(1)
        @command_window.disable_item(2)
        @command_window.disable_item(3)
     end
     # If save is forbidden
     if $game_system.save_disabled
        # Disable save
        @command_window.disable_item(4)
      end
      #if only allow diary if coda is there
   if $game_party.actors[0] != $game_actors[12]
     @command_window.disable_item(3)
    @command_window.disable_item(5)
  end
  #if progress is lower than a certain level, disable snackmaking
     if $game_variables[2]< 10
     @command_window.disable_item(3)
   end
     # Make play time window
     @playtime_window = Window_GoldTime.new
     @playtime_window.x = 483
     @playtime_window.y = 310
     @playtime_window.z = 201
     # Make location window
=begin
     @location_window = Window_location.new
     @location_window.x = 445
     @location_window.y = 423
     @location_window.z = 202
=end
     # Make status window
     @status_window = Window_MenuStatus.new
     @status_window.x = 2
     @status_window.y = 2
     @status_window.height = 480
     @status_window.width = 510
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
     @command_window.dispose
     @playtime_window.dispose
     @status_window.dispose
     @background.dispose
     #@location_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
      @background.oy -= 1
      @background.ox -= 1
     # Update windows
     @command_window.update
     @playtime_window.update
     @status_window.update
     # If command window is active: call update_command
     if @command_window.active
        update_command
        return
     end
     # If status window is active: call update_status
     if @status_window.active
        update_status
        return
     end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when command window is active)
  #--------------------------------------------------------------------------
  def update_command
     # If B button was pressed
     if Keys.trigger?($keyboard["cancel"])
       #Input.trigger?(Input::B)
        # Play cancel SE
        $game_system.se_play($data_system.cancel_se)
        # Switch to map screen
        $scene = Scene_Map.new
        return
     end
     # If C button was pressed
     if Keys.trigger?($keyboard["select"])
       #Input.trigger?(Input::C)
        # If command other than save or end game, and party members = 0
        if $game_party.actors.size == 0 and @command_window.index < 4
           # Play buzzer SE
           $game_system.se_play($data_system.buzzer_se)
           return
        end
        # Branch by command window cursor position
        case @command_window.index
        when 0   # item
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to item screen
           $scene = Scene_Item.new
        when 1   # skill
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Make status window active
           @command_window.active = false
           @status_window.active = true
           @status_window.index = 0
        when 2   # equipment
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Make status window active
           @command_window.active = false
           @status_window.active = true
           @status_window.index = 0
        when 3   # status
          if $game_party.actors[0] != $game_actors[12] || $game_variables[2]< 6
            # Play buzzer SE
           $game_system.se_play($data_system.buzzer_se)
           
         else
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
=begin           
           # Make status window active
           @command_window.active = false
           @status_window.active = true
           @status_window.index = 0
=end
           # exit back to map
           $scene = Scene_Map.new
           $game_temp.common_event_id = 53
           end
        when 4   # save
           # If saving is forbidden
           if $game_system.save_disabled
              # Play buzzer SE
              $game_system.se_play($data_system.buzzer_se)
              return
           end
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to save screen
           $scene = Scene_Save.new
        when 5   # use diary
             if $game_party.actors[0] != $game_actors[12]
           # Play buzzer SE
           $game_system.se_play($data_system.buzzer_se)
           else
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # exit back to map
           $scene = Scene_Map.new
           $game_temp.common_event_id = 34
          end
        when 6   # end game
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to end game screen
           $scene = Scene_End.new
        end
        return
     end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when status window is active)
  #--------------------------------------------------------------------------
  def update_status
     # If B button was pressed
     if Keys.trigger?($keyboard["cancel"])
       #Input.trigger?(Input::B)
        # Play cancel SE
        $game_system.se_play($data_system.cancel_se)
        # Make command window active
        @command_window.active = true
        @status_window.active = false
        @status_window.index = -1
        return
     end
     # If C button was pressed
     if Keys.trigger?($keyboard["select"])
       #Input.trigger?(Input::C)
        # Branch by command window cursor position
        case @command_window.index
        when 1   # skill
           # If this actor's action limit is 2 or more
           if $game_party.actors[@status_window.index].restriction >= 2
              # Play buzzer SE
              $game_system.se_play($data_system.buzzer_se)
              return
           end
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to skill screen
           $scene = Scene_Skill.new(@status_window.index)
        when 2   # equipment
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to equipment screen
           $scene = Scene_Equip.new(@status_window.index)
        when 3   # status
           # Play decision SE
           $game_system.se_play($data_system.decision_se)
           # Switch to status screen
           $scene = Scene_Status.new(@status_window.index)
        end
        return
     end
  end
end
#=============================================================================
# * Window_location
#-----------------------------------------------------------------------------
# handles the location window in the menu
#=============================================================================
class Window_location < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
#=begin
  def initialize
     super(0, 0, 320,60)
     self.contents = Bitmap.new(width - 32, height - 32)
     #self.contents.font.name = "Tahoma"
     #self.contents.font.size = 22
     self.contents.font.color = text_color(0)
     self.contents.draw_text(0, 0, 120, 30, $game_map.name.to_s)
   end
#=end

end

#==============================================================================
# ** FFVII Style - Window_PlayTime and Window_Gold Combined
#------------------------------------------------------------------------------
# Author: FF12_Master
# Version: 0.1
# 11/ 5/ 2009
#==============================================================================
 
class Window_GoldTime < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
     super(0, 0, 160,120)
     self.contents = Bitmap.new(width - 32, height - 32)
     refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
     self.contents.clear
     self.contents.font.color = system_color
     self.contents.draw_text(4, -4, 120, 32, "Play Time")
     @total_sec = Graphics.frame_count / Graphics.frame_rate
     hour = @total_sec / 60 / 60
     min = @total_sec / 60 % 60
     sec = @total_sec % 60
     text = sprintf("%02d:%02d:%02d", hour, min, sec)
     self.contents.font.color = normal_color
     self.contents.draw_text(4, 28, 120, 32, text, 2)
    
     cx = contents.text_size($data_system.words.gold).width
     self.contents.font.color = normal_color
       self.contents.draw_text(4, 65, 120-cx-2, 32, $game_party.gold.to_s, 2)
     self.contents.font.color = system_color
     self.contents.draw_text(124-cx, 65, cx, 32, $data_system.words.gold, 2)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
     super
     if Graphics.frame_count / Graphics.frame_rate != @total_sec
        refresh
     end
  end
end