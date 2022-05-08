#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
# Diary Scene
# Author: ForeverZer0
# Version: 1.11
# Date: 1.17.2014
#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
#
# Introduction:
#
#   This is a basic script that will allow you to keep a "diary" or notepad in 
#   your game. It is very simple to use, and uses a simple interface for 
#   displaying the notes.
#
# Features:
#
#   - Group your notes into "chapters".  
#   - Automatically formats text to fit on each line in a legible format.
#   - Simple script call to add text.
#   - Option to define each note in the script editor, then simply use a script 
#     call to add it.
#   - Option to use the map as the background.
#
# Instructions:
#
#   - Place script above main, and below default scripts.
#   - Make configurations below.
#   - To call the scene, use this syntax:  $scene = Scene_Diary.new
#   - To add an entry, use this syntax:
#
#     Diary.add_entry(CHAPTER, TEXT)
#      
#     CHAPTER: An arbitrary integer to define what group to add the note to.
#     TEXT: Either a string which will be the text added to the diary, or an
#           integer which will return the string defined in the configuration
#           below. The second method will make it easier to make long notes
#           without filling up the little script call box.
#
# Author's Notes:
#
#  - Please be sure to report any bugs/issues with the script. Enjoy!
#
#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
=begin
module Diary
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                         BEGIN CONFIGURATION
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  MAP_BACKGROUND = false
  # Set to true if you would like the map to show behind the window.
  RETURN_SCENE = Scene_Menu #Scene_Map
  # The scene that the game returns to when you exit the diary.
  SCENE_ARGUMENTS = []
  # Define any arguments that may need called with scene if need be. Place them
  # in the array in the order in which they are normally called.
  
  def self.chapter_name(chapter)
    # Define the names of the "chapters".
    # when CHAPTER then "CHAPTER_NAME"
    return case chapter
    when 0 then 'Controls'
    when 1 then 'Departure'
    when 2 then 'Foraging'
    end
  end
  
  def self.entry(index)
    # Define the strings that correspond with each index. The index can be called
    # instead of actual text to add an entry.
    # when INDEX then "TEXT"
    return case index
    when 0 then 'Directional Keys: move forwards in that direction\n
      S: Collect snow/water/???\n
      A: Toggle the HUD \n
      Spacebar: Examine objects, Get others to speak to you\n
      PG up/PG dwn: Turn without moving\n
      Esc: Menu\n
      F12: Pause\n
      \q[coda_face]'
    when 1 then 'Directional Keys: move forwards in that direction\n
      S: Collect snow/water/Freeze water\n
      A: Toggle the HUD \n
      Spacebar: Examine objects, Get others to speak to you\n
      PG up/PG dwn: Turn without moving\n
      Esc: Menu\n
      F12: Pause
      
      \q[coda_face]'
    when 2 then 'aaaaaaaaaaaaaaa '
    when 3 then 'This place is very strange, and everyone talks funny. It\'s all vaguely 
the same, yet different. Where am I?'
    when 4 then 'Here\'s how you can skip lines.\n\nThat made a line break. Now to see
your value stored in variable 5: \v[5]'
    end
  end

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                           END CONFIGURATION
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  
  def self.add_entry(chapter, text)
    # Add the chapter number if it does not exist.
    if $game_party.diary[chapter] == nil
      $game_party.diary[chapter] = []
    end
    if text.is_a?(String)
      # Add the new entry to the end of the chapter.
      $game_party.diary[chapter].push(text)
    elsif text.is_a?(Integer)
      # Get the defined note if the text is a number.
      $game_party.diary[chapter].push(self.entry(text))
    end
  end
end

#===============================================================================
# ** Window_Diary
#===============================================================================

class Window_Diary < Window_Base
  
  attr_reader :lines
  
  def initialize
    super(0, 64, 640, 416)
    self.back_opacity = Diary::MAP_BACKGROUND ? 160 : 255
    self.contents = Bitmap.new(width - 32, height - 32)
    @lines = []
  end
  
  def chapter=(chapter)
    # Reset the current entries.
    entries = $game_party.diary[chapter]
    entries = [''] if entries == nil
    # Divide the current entries into lines based off the text size and length.
    @lines = entries.collect {|text| self.contents.slice_text(text, 608) }
    @lines.flatten!
    refresh
  end
  
  def refresh
    # Dispose bitmap, returning if no lines are defined.
    self.contents.clear
    return if @lines.size == 0
    self.contents.dispose
    # Create bitmap to contain the lines.
    self.contents = Bitmap.new(self.width - 32, @lines.size * 32)
    # Draw each line.
    @lines.each_index {|i| self.contents.draw_text(0, i*32, 608, 32, @lines[i])}
  end
end

#===============================================================================
# ** Bitmap
#===============================================================================
    
class Bitmap
  
  # Blizzard's slice_text method. Updated by KK20 to include
  #  \n     -  New line
  #  \v[ID] -  Variable
  def slice_text(text, width)
    # Replace all instances of \v[n] to the game variable's value
    text.gsub!("\v") {"\\v"}
    text.gsub!("\V") {"\\v"}
    text.gsub!("\Q") {"\\q"}
    text.gsub!("\q") {"\\q"}
    #text.gsub!("F12") {"sdkfjogjdogjodjgodjgos"}
    text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
    text.gsub!(/\\[Qq]\[([\w]+)\]/) { "\026[#{$1}]" } 
    
    # Break up the text into lines
    lines = text.split("\\n")
    result = []
    # For each line generated from \n
    lines.each{|text_line|
      # Divide text into each individual word
      words = text_line.split(' ')
      current_text = words.shift
      # If there were less than two words in that line, just push the text
      if words.empty?
        result.push(current_text == nil ? "" : current_text)
        next
      end #edit

      # Evaluate each word and determine when text overflows to a new line
      words.each_index {|i|
      
                  if current_text == "\026[#{$1}]" 
          text.sub!(/\[([\w]+)\]/, "")
          bitmap = RPG::Cache.picture($1.to_s)
          rect = Rect.new(0, 0, bitmap.width, bitmap.height)
          contents.blt(0, 0, bitmap, rect)
          #contents.blt(4+@x, 32*@y+4, bitmap, rect)
          @x += bitmap.width + 4
          #@y += bitmap.height
          next
        end
        
        if self.text_size("#{current_text} #{words[i]}").width > width
          result.push(current_text)
          current_text = words[i]
        else
          current_text = "#{current_text} #{words[i]}"
        end
        result.push(current_text) if i >= words.size - 1
      }
    }
    return result
  end
end

#===============================================================================
# ** Scene_Diary
#===============================================================================

class Scene_Diary
  
  def main
    # Create the windows.
    @sprites = [Window_Help.new, Window_Diary.new]
    @sprites[1].windowskin = RPG::Cache.windowskin("paperskinx2")#new
    if Diary::MAP_BACKGROUND
      @sprites.push(Spriteset_Map.new)
      @sprites[0].back_opacity = 160
    end
    @keys = $game_party.diary.keys.sort
    @names = @keys.collect {|chapter| Diary.chapter_name(chapter) }
    # Find current index, setting to first chapter if undefined.
    @index = @keys.index(Diary.chapter_name(@chapter))
    @index = 0 if @index == nil
    # Set the information for each window.
   
    @sprites[0].set_text(@names[@index] == nil ? '' : @names[@index], 1)
    @sprites[1].chapter = @keys[@index]
   
    # Transition Graphics.
    Graphics.transition
    # Main loop.
    loop { Graphics.update; Input.update; update; break if $scene != self }
    # Dispose windows.
    Graphics.freeze
    @sprites.each {|sprite| sprite.dispose }
  end
  
  def update
    # Branch by what input is recieved.
    if Input.repeat?(Input::UP) || Input.trigger?(Input::UP) 
      $game_system.se_play($data_system.cursor_se)
      @sprites[1].oy -= 32 if @sprites[1].oy if @sprites[1].oy > 0
    elsif Input.repeat?(Input::DOWN) || Input.trigger?(Input::DOWN)
      $game_system.se_play($data_system.cursor_se)
      @sprites[1].oy += 32 if @sprites[1].oy < (@sprites[1].contents.height-384)
    elsif Input.trigger?(Input::L) || Input.trigger?(Input::R)
      $game_system.se_play($data_system.decision_se)
      # Change the current index.
      @index += Input.trigger?(Input::L) ? -1 : 1
      @index %= @keys.size
      # Display the name of the current chapter in the header.
      @sprites[0].set_text(@names[@index], 1)
      # Change the current chapter.
      @sprites[1].chapter = @keys[@index]
    elsif Input.trigger?(Input::B)
      # Play cancel SE and return to the defined scene.
      $game_system.se_play($data_system.cancel_se)
      args, scene = Diary::SCENE_ARGUMENTS, Diary::RETURN_SCENE
      $scene = (args == []) ? scene.new : scene.new(*args)
    end
  end
  
end

#===============================================================================
# ** Game_Party
#===============================================================================

class Game_Party
  
  attr_accessor :diary
  
  alias zer0_diary_init initialize
  def initialize
    zer0_diary_init
    @diary = {}
  end
end
=end