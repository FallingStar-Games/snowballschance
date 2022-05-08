#==============================================================================
# Perishable Items (Version 1.0a) by mad.array
#------------------------------------------------------------------------------
#  Use this script to give your items a limited shelf life.
#  To use, add a 'rotten' version of your item in the database, then
#  find def calculate_perish_time and add a case for your original item number.
#  e.g. (Item 1 = Potion, Item 33 = Potion [Rotten])
#  ---------------
#  when 1
#     return 400
# ----------------
# This is the amount of time, in frames, that your item will last before going
# off. Now 400 frames is only 20 seconds, so I'd use a larger number.
# 
# Next, find def rot_time and again add a case for your item. Only this time
# it will be returning the item that it will 'rot' into.
# e.g. 2
#  ---------------
#  when 1
#     return 33
# ----------------
#
# Now, enjoy. 400 Frames after picking up a Potion, it will be removed from 
# the item screen and replaced with it's rotten replacement. You can have your 
# rotten equivalent do anything that a normal item would do, so go nuts!
#==============================================================================
=begin
class Game_Party
  attr_accessor    :perishablelist
  
  alias perinitialize initialize
  def initialize
    perinitialize
    @perishablelist = []
  end
  
  alias perish_gain_item gain_item
  def gain_item(item_id, n)
    perish_gain_item(item_id, n)
    for i in 0...n
      pt = calculate_perish_time(item_id)
      if pt !=false
        pt += Graphics.frame_count
        @perishablelist[item_id] = [] if @perishablelist[item_id] == nil
        @perishablelist.push[item_id].push(pt)
      end
    end
  end
  
  alias perish_lose_item lose_item
  def lose_item(item_id, n)
    perish_lose_item(item_id, n)
    for i in 0...n
      @perishablelist[item_id].delete_at(0) if @perishablelist[item_id] != nil
    end
  end
  #--------------------------------------------------------
  #  Perishable item list
  #-------------------------------------------------------
  def calculate_perish_time(item_id)
    case item_id
    
    #------item 1 has a shelf life of 400 frames------
    when 1
    return 400 
    #---------------------------------
    end
    return false
  end
end

class Window_Item < Window_Selectable
  
  alias perish_draw draw_item
  def draw_item(index)
    perish_draw(index)
    item = @data[index]
    if item.is_a?(RPG::Item) && $game_party.perishablelist[item.id] != nil
      number = $game_party.item_number(item.id)
      changeamt = 0
      for i in 0...number
        if $game_party.perishablelist[item.id][i] < Graphics.frame_count
          changeamt +=1
        end
      end
      if changeamt > 0
        $game_party.gain_item(rot_item(item.id), changeamt)
        $game_party.lose_item(item.id, changeamt)
        refresh
      end
    end
  end
  #--------------------------------------------------------
  #  Expired item list
  #-------------------------------------------------------
  def rot_item(item_id)
    case item_id
    
    #---turns item 1 into item 5 --
    when 1
      return 5
    #------------------------
      
    end
    return false
  end
end
=end