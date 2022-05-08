#--------------------------------------
# check terrain tag in front of player
# By lavendersiren
#-------------------------------------
class Terrain_Bluh < Game_Map


def self.terrain_frontcheck

case $game_player.direction
	      when 2
        unless $game_player.y+1==nil
		      next_terrain= $game_map.terrain_tag($game_player.x , $game_player.y+1)
			  end
	      when 4 
        unless $game_player.x-1==nil
		      next_terrain= $game_map.terrain_tag($game_player.x-1 , $game_player.y)
        end
	      when 6  
        unless $game_player.x+1==nil
		      next_terrain= $game_map.terrain_tag($game_player.x+1 , $game_player.y)
        end
	      when 8  
        unless $game_player.y-1==nil
		      next_terrain= $game_map.terrain_tag($game_player.x , $game_player.y-1)
        end
	    end

		$game_variables[22]=next_terrain
		
  end
  
end


