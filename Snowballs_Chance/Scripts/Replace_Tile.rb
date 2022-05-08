#==============================================================================
# Replace Tile AddOn
# by Wecoc
# ---------------------------
=begin

  With this script you can replace tiles of a map like in RPG maker 2k.
  To call this on map, insert the next code on a Script command:
  
      $game_map.replace_tile(tile1,tile2,layer,autotile)
    
  tile1 => integer, initial tile of the tileset
  tile2 => integer, final tile of the tileset
  (layer) => integer, which layer will be altered (0 to 3) or all layers (-1)
            it equals -1 by default
  (autotile) => if true, the change will be on autotiles
            it's set false by default
  
=end
#==============================================================================

class Game_Map
  def replace_tile(a,b,layer=-1,autotile=false)
    @layer = layer
    if autotile == false
      for i in 0..width
        for j in 0..height
          if @layer == -1
            for l in 0..2
              data[i,j,l] = b+384 if data[i,j,l] == a+384
            end
          else
            l = @layer
            data[i,j,l] = b+384 if data[i,j,l] == a+384
          end
        end
      end
    else
      a0 = a*48 ; a1 = (a+1)*48
      b0 = b*48 ; b1 = (b+1)*48
      a_array = []
      b_array = []
      
      for i in a0...a1
        a_array.push(i)
      end
      for i in b0...b1
        b_array.push(i)
      end
      
      for i in 0..width
        for j in 0..height
          if @layer == -1
            for l in 0..2
              for k in 0..a_array.size
                data[i,j,l] = b_array[k] if data[i,j,l] == a_array[k]
              end
            end
          else
            l = @layer
            for k in 0..a_array.size
              if data[i,j,l] == a_array[k]
                data[i,j,l] = b_array[k]
              end
            end
          end
        end
      end
    end
  end
end