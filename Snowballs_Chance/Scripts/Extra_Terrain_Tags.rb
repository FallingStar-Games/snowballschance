#==============================================================================
# ** Extra Terrain Tags
#------------------------------------------------------------------------------
#    version 1.0
#    by DerVVulfman
#    10-18-2013
#    RGSS / RPGMaker XP
#==============================================================================
#
#  INTRODUCTION:
#
#  This script allows you to have more than the default 0-7 terrain tags in
#  any individual tileset of your choice. You do this by adding or altering
#  values within the configurable MAP_TERRAINS set of hash arrays.
#
#  A must for anyone who extensively uses terrain tags within their projects.
#
#------------------------------------------------------------------------------
#
#  ADDING NEW TERRAIN TAGS:
#
#  You can increase  the number of terrain tags  to each individual tileset
#  in your database.  All you need is the index value of your tileset (such
#  as index 1 for 'Gralslands',  index 5 for 'Beach',  index 15 for 'Fort')
#  and the MAP_TERRAINS hash.
#
#                               *    *    *
#
#  SYNTAX:  MAP_TERRAINS[key] = { hash list }
#
#  The MAP_TERRAINS hash allows you to assign terrain tag values  to one or
#  more tiles within a specified tileset.  It is easy to specify which tile
#  set is being altered  as the index value  of the tileset is used  as the
#  key value for the hash itself.  An example is as follows:
#
#                    MAP_TERRAIN[20] = { hash list }
#
#  As you can see, this MAP_TERRAINS hash will apply whatever changes it
#  contains directly to tileset #20,  or the  'Desert Town In'  tileset.
#  That's assuming  you are using  the default tilesets in your project.
#
#  After deciding  that you are going  to change or add new terrain tags
#  to a tileset,  you must then decide which tiles  receive the new tags
#  and make a list which points them out.   This is the hash list to the
#  right of the MAP_TERRAINS value, and a typical hash list must have at
#  least one tile-to-tag set.
#
#                               *    *    *
#
#  SYNTAX:  =  { tile => tag, tile => tag, ... tile => tag  }
#
#  The hash list allows you to select an individual tile  and set a terrain
#  tag to it.  You can have just one tile changed,  or fifty tiles altered.
#  There is no actual limit  except how large you want your MAP_TERRAINS to
#  grow...  and your patience.   You can have multiple tiles share the same
#  terrain tag.   But you cannot apply any more than one tag to a tile.  If
#  you do so by accident, the very last occurance of the 'tile-to-tag' will
#  be used.
#
#  A tile can be specified in the hash list in two ways.  One way is if the
#  user knows the tile_id of the tile.   Not many people  know the formula,
#  but a layman's formula  will be  presented later.   The other way  is by 
#  using the tile's X/Y position in the tileset.  And this is easy to do if
#  you just consider the  TILESET GRID  section of these instructions.  For
#  your consideration, an example is shown below showing their use:
#
#  SYNTAX:  MAP_TERRAINS[4] = { [0,2] => 12, 384 => 12, [3,2] => 14 }
#
#  Oooh... Extensive!
#
#  Okay.  If you notice, I used tileset #4 (Mountains) as a sample tileset.
#  That is just so it would be easy  to discuss what is going on within the
#  sample code above.  
#
#  The first 'set tile-to-tag'  in the sample is:  [0,2] => 12   This lets
#  you apply terrain tag 12 to whatever tile is in the top row, 3rd space.
#  True...  that is an autotile.   But the system can account for that and
#  can also change the terrain tags of autotiles.
#
#  The second set 'tile-to-tag' in this sample is: 384 => 12    Unlike the
#  first set, this one applies terrain tag 12 to a tile by its actual tile
#  ID value. Just so you know, this tile ID value indicates the first tile
#  on the second row which is a green grass tile. I figured... if the auto
#  tile for grass was going to be terrain tag 12,why not make the one that
#  isn't an autotile the same?
#
#  And the third set 'tile-to-tag' in this sample is [3,2] => 14. I didn't
#  feel like having a  'bad-luck'  number act as a terrain tag in the demo
#  so I skipped it and went straight to tag #14 ( ^_- ).  And if you count
#  how far left & how many tiles down you go,  you'll find that I selected
#  a big shrubbery or overgrowth looking tile.
#
#  And that's pretty much it.
#
#------------------------------------------------------------------------------
#
#  YOUR TILESET GRID:
#
#  To apply a terrain tag to a tile within your tileset,  you must identify
#  the tile by its x and y coordinates.   Using standard index values,  the 
#  top-left tile would have a coordinate value of 0,0.   The top-right tile
#  would have a coordinate value of 7, 0.   It goes by  the traditional X/Y
#  system of coordinates like below:
#
#    +-------+-------+-------+-------+-------+-------+-------+-------+
#    |  x y  |  x y  |  x y  |  x y  |  x y  |  x y  |  x y  |  x y  |
#    | [0,0] | [1,0] | [2,0] | [3,0] | [4,0] | [5,0] | [6,0] | [7,0] |
#    |       |       |       |       |       |       |       |       |
#    +-------+-------+-------+-------+-------+-------+-------+-------+
#    |       |       |       |       |       |       |       |       |
#    | [0,1] | [1,1] | [2,1] | [3,1] | [4,1] | [5,1] | [6,1] | [7,1] |
#    |       |       |       |       |       |       |       |       |
#    +-------+-------+-------+-------+-------+-------+-------+-------+
#    |       |       |       |       |       |       |       |       |
#
#  And yes, you are seeing this right.  This system even permits the change
#  of terrain tags for the autotiles as well.
#
#------------------------------------------------------------------------------
#
#  YOUR TILE IDs (a layman's guide):
#
#  Not many people actually calculate the tile IDs  for a given tile within
#  a tileset.  It can be a headache.   Still,  using a tile ID can prove to
#  be faster than using X/Y coordinates  when applying terrain tags (though
#  marginal the difference may be).
#
#                               *    *    *
#
#  First, let me say that autotiles (the top row) do not have a single tile
#  ID value, but a range of tile IDs. That is because the system splits the
#  tile ID into 48 individual parts for rendering on the map.
#
#  Yes, there are literally 48 different ways the terrain tag may be drawn.
#  The first autotile in your terrain tag covers tile IDs 0-47.  The second
#  uses tile IDs from 48-95, and so on... all the way up to tile 383.
#
#  FORMULA RANGE:  Start_ID = tile * 48 / End_ID = ((tile+1) * 48) - 1
#
#  So with that, the 1st waterfall autotile in the Mountain tileset  (going
#  as tile #5) would generate a range of 240-287, worked out like this:
#
#  Start_ID = 5 * 48 (ie 240) / End_ID = ( 6 * 48 ) -1 ( or 287)
#
#  Still... it would probably be easier for you to use an [x/y] array.
#
#                               *    *    *
#
#  The remaining tiles are a lot easier to calculate.   The first tile that
#  isn't an autotile is tile ID 384,  the second is 385, and so forth.   If
#  you want to actively determine the ID of your tile, just use the formula:
#
#  FORMULA:  Tile_ID = 376 + x + (y * 8)
#
#  This assumes that you count that all the autotiles in the top most spot
#  in your tileset have a y-coordinate of 0,  and the left most coordinate
#  for any tile is an x-coordinate of 0.
#
#  As you actively do the math and determine the tile IDs instead of making
#  this system  determine the IDs,  it may run faster.   However, the speed
#  difference may only be marginal.
#  
#
#==============================================================================
#
#  TERMS AND CONDITIONS:
#
#  Free for use, even in commercial games.
#
#==============================================================================


module Terrains
  
  MAP_TERRAINS = {}
  MAP_TERRAINS[17] = { [0,60] => 8,  # topleft    corner
                       [2,60] => 9,  # topright    corner
                       [4,60] => 10, # bottomleft  corner
                       [5,60] => 11, # bottomright corner
                       
                       [0,61] => 12, # no ice here
                       [1,61] => 12, # no ice here
                       [2,61] => 12, # no ice here
                       [3,61] => 12, # no ice here
                       [4,61] => 12, # no ice here
                       [5,61] => 12, # no ice here
                       [6,61] => 12, # no ice here
                       [7,61] => 12, # no ice here
                       
                       [0,63] => 12, # no ice here
                       [1,63] => 12, # no ice here
                       [2,63] => 12, # no ice here
                       [3,63] => 12, # no ice here
                       [4,63] => 12, # no ice here
                       [5,63] => 12, # no ice here
                       [6,63] => 12, # no ice here
                       [7,63] => 12 # no ice here
                       } 
  
  
end



#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles the map. It includes scrolling and passable determining
#  functions. Refer to "$game_map" for the instance of this class.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias extra_tags_game_map_setup setup
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(map_id)
    # Perform the original call
    extra_tags_game_map_setup(map_id)
    # Setup Extra Terrains
    setup_extra_terrain_tags
  end
  #--------------------------------------------------------------------------
  # * Setup extra terrain tags
  #--------------------------------------------------------------------------
  def setup_extra_terrain_tags
    # Exit if the map doesn't have extra terrain tags
    return unless Terrains::MAP_TERRAINS.has_key?(@map.tileset_id)
    # Create the temp hash array
    terrains = {}
    # Push terrain tag data into the temp hash
    terrains = Terrains::MAP_TERRAINS[@map.tileset_id]
    # Cycle through the hash data
    terrains.each do |tile_array, n|
      # If the data is an x/y array
      if tile_array.is_a?(Array)
        # Obtain X/Y coords in tileset
        x, y = tile_array[0], tile_array[1]
        # If the top row, it is an autotile
        if y == 0
          # AutoTiles have 48 tile IDs each (48 x 8 == 384)
          for i in 0..47
            # Adjust based on which Autotile
            tile_id = (x * 48) + i
            # Overwrite Each Terrain Tag
            @terrain_tags[tile_id] = n
          end
        # Otherwise, a normal tile
        else
          # Tiles of 384 on up (376 + 8 == 384)
          tile_id = 376 + x + (y * 8)
          # Overwrite Single Terrain Tag
          @terrain_tags[tile_id] = n
        end
      # Otherwise, the actual tile id is used
      else
        # Overwrite Single Terrain Tag
        @terrain_tags[tile_array] = n
      end
    end
  end
end