#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  This window displays amount of gold.
#==============================================================================

class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 160, 50)
    self.contents = Bitmap.new(width - 32, height - 32)
    #self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    cx = contents.text_size($data_system.words.gold).width
    self.contents.font.color = normal_color
    self.contents.font.size = Font.default_size
    #draw_text(x, y, width, height, str[, align]) 
    self.contents.draw_text(4, 0, 120-cx-2, 16, $game_party.gold.to_s, 2) #32
    self.contents.font.color = system_color
    self.contents.draw_text(124-cx, 0, cx, 16, $data_system.words.gold, 2)
  end
end
