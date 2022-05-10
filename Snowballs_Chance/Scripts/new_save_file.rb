#==============================================================================
# ** Scene_File modified
#------------------------------------------------------------------------------
#  Author: Wecoc
#==============================================================================

class Window_SaveFile < Window_Base
  attr_reader   :filename
  
  def initialize(file_index, filename)
    super(160, 64, 480, 480 - 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @file_index = file_index
    @filename = "Save#{@file_index + 1}.rxdata"
    @name_width = contents.text_size(@filename).width
    @time_stamp = Time.at(0)
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      file = File.open(@filename, "r")
      @time_stamp         = file.mtime
      @characters         = Marshal.load(file)
      @frame_count        = Marshal.load(file)
      @game_system        = Marshal.load(file)
      @game_switches      = Marshal.load(file)
      @game_variables     = Marshal.load(file)
      @game_self_switches = Marshal.load(file)
      @game_screen        = Marshal.load(file)
      @game_actors        = Marshal.load(file)
      @game_party         = Marshal.load(file)
      @game_troop         = Marshal.load(file)
      @game_map           = Marshal.load(file)
      @game_player        = Marshal.load(file)
      @total_sec = @frame_count / Graphics.frame_rate
      file.close
    end
    refresh
  end

  def refresh
    self.contents.clear
    self.contents.font.color = normal_color
    if @file_exist
      for i in 0...@characters.size
        bitmap = RPG::Cache.character(@characters[i][0], @characters[i][1])
        cw = bitmap.rect.width / 4
        ch = bitmap.rect.height / 4
        src_rect = Rect.new(0, 0, cw, ch)
        x = 170 - @characters.size * 32 + i * 80 - cw / 3
        # Character
        self.contents.blt(x + 24, 96 - ch, bitmap, src_rect)
        # Name
        draw_actor_name(@game_party.actors[i], x + 24, 110)
      end
      
      # Playing time
      hour = @total_sec / 60 / 60
      min = @total_sec / 60 % 60
      sec = @total_sec % 60
      time_string = sprintf("%02d:%02d:%02d", hour, min, sec)
      self.contents.font.color = normal_color
      self.contents.draw_text(128, 166, 300, 32, time_string, 2)
      
      # Date when saving
      self.contents.font.color = normal_color
      time_string = @time_stamp.strftime("%d/%m/%Y %H:%M")
      self.contents.draw_text(128, 190, 300, 32, time_string, 2)
      
      # level number (variable 8)
      self.contents.font.color = system_color
      self.contents.draw_text(4, 166, 120, 32, "Level")
      self.contents.font.color = normal_color
      self.contents.draw_text(50, 166, 48, 32, @game_variables[8].to_s)
      
      # level name
      self.contents.font.color = normal_color
      for i in 0...map_def.size
      #for i in 0...@game_map.map_def.size #old
        self.contents.draw_text(4, 190 + 24*i, 480, 32, map_def[i])
      end
      
      # diary entries (variable 27)
      self.contents.font.color = system_color
      self.contents.draw_text(4, 215, 120, 32, "Diary entries")
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 235, 48, 32, @game_variables[27].to_s)
  
    end
  end
end
=begin
class Game_Map
  #don't need this
 attr_reader   :map_id  
  def map_name
    @mpn = load_data("Data/MapInfos.rxdata")
   return @mpn[@map_id].name
 end
=end
 
  def map_def
    case @game_variables[8]#@map_id
    when -1
      return ["Enter Codetta"]
    when 0
      return ["Prologue"]
    when 1
      return ["The Basics"]
    when 2
      return ["Staying Safe"]
    when 3
      return ["Where the Heart is"]
    when 4
      return ["Fugue Episode"]
    when 5
      return ["Summit Threshold"]
    else
      return [""]
    end
  end
#end

class Scene_File
  
  FILE_SIZE = 12   # File Size
  
  def main
    @help_window = Window_Help.new
    @help_window.set_text(@help_text)
    
    command_text = "File "
    command_array = []
    for i in 0...FILE_SIZE
      command_array.push("#{command_text + (i+1).to_s}")
    end
    @command_window = Window_Command.new(160, command_array)
    @command_window.y = 64
    @command_window.height = 480 - 64
    @file_index = $game_temp.last_file_index
    @command_window.index = @file_index
    
    @savefile_windows = []
    for i in 0...FILE_SIZE
      @savefile_windows.push(Window_SaveFile.new(i, make_filename(i)))
      @savefile_windows[i].visible = false
    end
    
    @savefile_windows[@file_index].visible = true
    
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @help_window.dispose
    @command_window.dispose
    for i in @savefile_windows
      i.dispose
    end
  end

  def update
    @help_window.update
    @command_window.update
    for i in 0...@savefile_windows.size
      @savefile_windows[i].visible = (i == @file_index)
    end
    
    if Input.trigger?(Input::C)
      on_decision(make_filename(@file_index))
      $game_temp.last_file_index = @file_index
      return
    end

    if Input.trigger?(Input::B)
      on_cancel
      return
    end

    if Input.repeat?(Input::DOWN)
      if Input.trigger?(Input::DOWN) or @file_index < (FILE_SIZE-1)
        $game_system.se_play($data_system.cursor_se)
        @file_index = (@file_index + 1) % FILE_SIZE
        return
      end
    end
    if Input.repeat?(Input::UP)
      if Input.trigger?(Input::UP) or @file_index > 0
        $game_system.se_play($data_system.cursor_se)
        @file_index = (@file_index + (FILE_SIZE-1)) % FILE_SIZE
        return
      end
    end
  end
end