#==============================================================================
# Popup Window by Regi
#------------------------------------------------------------------------------
# Version: 1.21  |  Last Updated: 12/30/11
#------------------------------------------------------------------------------
#  This pop-up window displays a small line of text. It will disappear after
#  a customizable time and won't inhibit movement, unlike Window_Message.
#------------------------------------------------------------------------------
#  Syntax: popup(text, item, value)
#==============================================================================
 
class Window_Popup < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 200, 320, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = false
    self.z = 2222
#=============================================================================
# START CUSTOMIZATION
#=============================================================================
    self.back_opacity = 180                   # windowskin opacity
    self.contents.font.name = $defaultfont      # font name
    self.contents.font.color = normal_color   # font color
    self.contents.font.size = 22              # font size
  end
 
  #--------------------------------------------------------------------------
  # * Predefined text
  #--------------------------------------------------------------------------
  def get_text(index)
    return case index
    # Define shortcuts for displaying text
      when 0 then 'Quicksave file deleted! Remember to save again!'
      when 1 then 'New Diary Entry!'
      when 2 then 'Screenshot saved!'
      when 3 then 'You forget this immediately.'
      when 4 then 'Hurry up!!'
    end
#=============================================================================
# END CUSTOMIZATION
#=============================================================================
  end
 
  #--------------------------------------------------------------------------
  # * Draw popup text
  #--------------------------------------------------------------------------
  def refresh_popup_text(text, item, value)
    self.contents.clear
    # Get text
    if text.is_a?(String)
      string1 = text
    elsif text.is_a?(Integer)
      string1 = get_text(text)
    end
    if item.nil?
      string2 = ''
    else
      string2 = item.name + (value > 0 ? ' x ' + value.to_s : '')
    end
    # Adjust width (fit window to text)
    w1 = self.contents.text_size(string1).width
    w2 = self.contents.text_size(string2).width + (item.nil? ? 0 : 32)
    width = w1 + w2
    self.width = width + 40
    # Adjust x position (center window)
    self.x = (640 - self.width) / 2
    # Draw text
    self.contents = Bitmap.new(self.width - 32, height - 32)
    self.contents.draw_text(4, 0, w1, 32, string1)
    unless item.nil?
      # Draw icon and item value
      bitmap = RPG::Cache.icon(item.icon_name)
      self.contents.blt(w1 + 4, 4, bitmap, Rect.new(0, 0, 24, 24))
      self.contents.draw_text(w1 + 32, 0, w2, 32, string2)
    end
  end
 
  def refresh
    super
  end
 
end
 
#==============================================================================
# ** Scene Map
#==============================================================================
class Scene_Map
 
  attr_accessor :popup_window
  attr_accessor :popup_count
 
  alias reg_popup_main main
  def main
    # Create window
    @popup_window = Window_Popup.new
    @popup_count = -1
    # Normal Scene_Map processing
    reg_popup_main
    # Dispose of window
    @popup_window.dispose
  end
 
  alias reg_popup_update update
  def update
    reg_popup_update
    # Update counter
    if @popup_count >= 0
      @popup_count -= 1
    end
    if @popup_count == 0
      @popup_window.visible = false
    end
  end
end
 
#==============================================================================
# ** Interpreter (new command)
#==============================================================================
class Interpreter
  def popup(text = '', item = nil, value = 0)
    $scene.popup_window.refresh_popup_text(text, item, value)
    $scene.popup_window.visible = true
    Audio.se_play('Audio\SE\doodah', 80, 100) 
    $scene.popup_count = 50 #80
  end

#--------------------------------------------------------------------------
  # * Change Items #optional
  #--------------------------------------------------------------------------
  def command_126
    # Get value to operate
    value = operate_value(@parameters[1], @parameters[2], @parameters[3])
    # Increase / decrease items
    $game_party.gain_item(@parameters[0], value)
    # Popup Window
    text = (value > 0 ? 'Acquired' : 'Lost')
    popup(text, $data_items[@parameters[0]], value)
    # Continue
    return true
  end

end