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
  def replace_tile(intialtile,finaltile,layer=-1,autotile=false)
    @layer = layer
    if autotile == false
      for currentwidth in 0..width
        for currentheight in 0..height
          if @layer == -1 #if we're working on all layers
            for currentlayer in 0..2 #do all this stuff for all 3 layers
              data[currentwidth,currentheight,currentlayer] = finaltile+384 if data[currentwidth,currentheight,currentlayer] == intialtile+384
            end #cram the width and height and layer into data array and set it to final tile plus 384 if data as set up is still at initial tile stuff
          else
            currentlayer = @layer #store the layer in currentlayer
            data[currentwidth,currentheight,currentlayer] = finaltile+384 if data[currentwidth,currentheight,currentlayer] == intialtile+384
          end #set the stuff in data
        end
      end
    else #if it is an autotile
      init0 = intialtile*48 ; init1 = (intialtile+1)*48 
      #initial0 if initial tile times 48, initial1 is one more than initialtile times 48
      final0 = finaltile*48 ; final1 = (finaltile+1)*48
      #do the same shit with final tile stuff
      init_array = [] 
      final_array = [] #set these arrays up
      
      for currentwidth in init0...init1
        init_array.push(currentwidth)
      end
      for currentwidth in final0...final1
        final_array.push(currentwidth)
      end
      ass = 0 #test var
      for currentwidth in 0..width 
        for currentheight in 0..height
          if @layer == -1 #if we're working with all the layers
            for currentlayer in 0..2 #there are 3 layers in every map
              for atilepermutcount in 0..init_array.size #autotile permutation count, goeds up to 48 from 0
                
                if asslord != nil
                data[currentwidth,currentheight,currentlayer] = final_array[atilepermutcount] if data[currentwidth,currentheight,currentlayer] == init_array[atilepermutcount]
                ass += 1
                puts(ass) #log this shit
              else
                put("asses")
                break
              end
              
              end
            end
          else #if it's just one layer
            currentlayer = @layer #log the layer here
            for atilepermutcount in 0..init_array.size # make autotile permutationcount go from 0 to however big the array of stuff from the initial tile ended up
              if data[currentwidth,currentheight,currentlayer] == init_array[atilepermutcount] #if the data matches the initial
                data[currentwidth,currentheight,currentlayer] = final_array[atilepermutcount] #then set the data to the final
              end
            end
          end
        end
      end
    end
  end
end