#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
# Script-Command Messages
# Author: ForeverZer0
# Version: 1.0
# Date: 7.14.2010
#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
#
# Introduction:
#   Very simple fix to a (personally) irritating problem with the normal text
#   command for events.  I prefer to use slightly smaller font sizes for my
#   games, but with the default event command system, I am forced to break to a
#   new line at intervals, even though the text does not even extend to the end
#   of the message box. This script will fix that issue by using the "Script"
#   command to write your text in, and automatically size the lines correctly
#   and go to the next line only when required, and even to a second box if the
#   total text does not fit in a single message box.
#
# Features:
#   - Very simple to use, merely uses the "Script" command instead of the "Show
#     Text" command.
#   - Automatically breaks to new lines, but only when needed.
#   - Automatically breaks to a new message box if total text does not fit in
#     one.
#   - Can fit much more text into message boxes.
#   - Very high compatibility with all(?) message systems out there. It creates
#     the proper "Show Text" commands on the fly, so it does not alter any
#     scripts, just reorganizes how the event command is interpreted.
#
#  Instructions:
#   - Use this script call:  text("MESSAGE", TEXT_WIDTH)
#   - MESSAGE = The message you want displayed. Must be a string. ("")
#   - TEXT_WIDTH = can be omitted, and the default value will be used. The text
#                  will break to a new line after it reaches the given width.
#
# Credits/Thanks:
#   - Special thanks to Blizzard. It uses his text_slice method to measure
#     the line lengths.
#
# Notes/Issues:
#   - Do not use this command with messages that are very short.
#   - Commands such as "\v[ID]", \c[COLOR], etc. must have an extra "\" added to
#     work properly, and a backslash character must be written as "\\\". It is
#     a minor nuisance, but easiest way to bypass the problem.
#
#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

  DEFAULT_TEXT_WIDTH = 448
  # This is good for the default message system's message boxes. If you use a
  # different size message box, set this to the bitmap's width.

class Interpreter
 
  def text(string, width = DEFAULT_TEXT_WIDTH)
    if $game_map.command_added[@event_id] == nil
      $game_map.command_added[@event_id] = []
    end
    return if $game_map.command_added[@event_id].include?(@index)
    bitmap, words = Bitmap.new(width, 32), string.split(' ') 
    result, current_text, command = [], words.shift, []
    words.each_index {|i|
      if bitmap.text_size("#{current_text} #{words[i]}").width > width
        result.push(current_text)
        current_text = words[i]
      else
        current_text = "#{current_text} #{words[i]}"
      end
      result.push(current_text) if i == words.size-1}
    bitmap.dispose
    result.each_index {|i|
      code = i%4 == 0 ? 101 : 401
      command.push(RPG::EventCommand.new(code, @event_id, [result[i]]))}
    command.each_index {|i| @list.insert(@index+1+i, command[i])}
    $game_map.command_added[@event_id].push(@index)
  end
end 

class Game_Map
 
  attr_accessor :command_added
 
  alias zer0_script_message_setup setup
  def setup(map_id)
    @command_added = []
    zer0_script_message_setup(map_id)
  end
end