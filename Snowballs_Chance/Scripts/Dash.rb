=begin
#==============================================================================
# Game_Player Dash by Necrofear #moving? or
#==============================================================================
class Game_Player
  alias dash_update update
  def update
    unless  !moving? or $game_system.map_interpreter.running? or
           @move_route_forcing or $game_temp.message_window_showing
      if Keys.trigger?($keyboard["select"])
        #Input.press?(Input::C) #The key you push to initiate
        @move_speed = 5 #Sets running speed faster
      else
        @move_speed = 4 #Sets walking speed to regular
      end
    end
    dash_update
  end
end
=end