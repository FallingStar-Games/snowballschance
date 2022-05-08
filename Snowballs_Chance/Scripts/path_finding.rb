#==============================================================================
#  ■ Path Finding
#==============================================================================
# Near Fantastica
# Version 1
# 29.11.05
#==============================================================================
# Lets the Player or Event draw a path from an desonation to the source. This
# method is very fast and because the pathfinding is imbedded into the Game
# Character the pathfinding can be interrupted or redrawn at any time. 
#==============================================================================
# Player :: $game_player.find_path(x,y)
# Event Script Call :: self.event.find_path(x,y)
# Event Movement Script Call :: self.find_path(x,y)
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  alias nf_pf_game_character_initialize initialize
  alias nf_pf_game_character_update update
  #--------------------------------------------------------------------------
  attr_accessor :map
  attr_accessor :runpath
  #--------------------------------------------------------------------------
  def initialize
    nf_pf_game_character_initialize
    @map = nil
    @runpath = false
  end
  #--------------------------------------------------------------------------
  def update
    run_path if @runpath == true
    nf_pf_game_character_update
  end
  #--------------------------------------------------------------------------
  def run_path
    return if moving?
    step = @map[@x,@y]
    if step == 1
      @map = nil
      @runpath = false
      return
    end
    dir = rand(2)
    case dir
    when 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step -1 and step != 0
      move_up if @map[@x,@y-1] == step - 1 and step != 0
    when 1
      move_up if @map[@x,@y-1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step -1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
    end
  end
  #--------------------------------------------------------------------------
  def find_path(x,y)
    sx, sy = @x, @y
    result = setup_map(sx,sy,x,y)
    @runpath = result[0]
    @map = result[1]
    @map[sx,sy] = result[2] if result[2] != nil
  end
  #--------------------------------------------------------------------------
  def clear_path
    @map = nil
    @runpath = false
  end
  #--------------------------------------------------------------------------
  def setup_map(sx,sy,ex,ey)
    map = Table.new($game_map.width, $game_map.height)
    map[ex,ey] = 1
    old_positions = []
    new_positions = []
    old_positions.push([ex, ey])
    depth = 2
    depth.upto(100){|step|
      loop do
        break if old_positions[0] == nil
        x,y = old_positions.shift
        return [true, map, step] if x == sx and y+1 == sy
        if $game_player.passable?(x, y, 2) and map[x,y + 1] == 0
          map[x,y + 1] = step
          new_positions.push([x,y + 1])
        end
        return [true, map, step] if x-1 == sx and y == sy
        if $game_player.passable?(x, y, 4) and map[x - 1,y] == 0
          map[x - 1,y] = step
          new_positions.push([x - 1,y])
        end
        return [true, map, step] if x+1 == sx and y == sy
        if $game_player.passable?(x, y, 6) and map[x + 1,y] == 0
          map[x + 1,y] = step
          new_positions.push([x + 1,y])
        end
        return [true, map, step] if x == sx and y-1 == sy
        if $game_player.passable?(x, y, 8) and map[x,y - 1] == 0
          map[x,y - 1] = step
          new_positions.push([x,y - 1])
        end
      end
      old_positions = new_positions
      new_positions = []
    }
    return [false, nil, nil]
  end
end
  
class Game_Map
  #--------------------------------------------------------------------------
  alias pf_game_map_setup setup
  #--------------------------------------------------------------------------
  def setup(map_id)
    pf_game_map_setup(map_id)
    $game_player.clear_path
  end
end
  
class Game_Player
  #--------------------------------------------------------------------------
  alias pf_game_player_update update
  #--------------------------------------------------------------------------
  def update
    $game_player.clear_path if Input.dir4 != 0
    pf_game_player_update
  end
end
  
class Interpreter
  #--------------------------------------------------------------------------
  def event
    return $game_map.events[@event_id]
  end
end