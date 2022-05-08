#----------------------------------------------------------------
#
# JayRay Map Scroll Advanced
#
# This tiny scriptlet allows you to set up a script call in event
# commands to go to a specific distance from a point, even at angles.
# Great for World Maps, Comic Book cutscenes, and more.
#
# To call, simply enter a script in event, replacing xdistpan and ydistpan
# with either positive numbers or negative numbers - this is for pixels
#  $game_map.scroll_dispan(xdistpan, ydistpan)
#
# If you'd rather scroll quickly to a location that's a certain number of
# tiles away, instead you'd call ...
# $game_map.scroll_distilepan(xdistpan, ydistpan)
#
# Use smaller distances for a scrolling illusion, and good luck!
#
#

class Game_Map
  #--------------------------------------------------------------------------
  # * Scroll to specific distances on map
  #     xdistpan = How much - or + horizontally (x) you will need to scroll
  #      ydistpan = How much - or + vertically (y) you will need to scroll
  #--------------------------------------------------------------------------
  def scroll_dispan(xdistpan,ydistpan)
    @display_y = [@display_y + xdistpan, (self.height - 15) * 128].min
    @display_x = [@display_x + ydistpan, 0].max
  end
  def scroll_distilepan(xdistpan,ydistpan)
    @display_y = [@display_y + (xdistpan * 32), (self.height - 15) * 128].min
    @display_x = [@display_x + (ydistpan * 32), 0].max
  end
end