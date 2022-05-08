#========================================
#  Leon's Crafting System
#  v1.03
#-------------------------------------------------------
#
#  Features:
#    By default, if the player has the items for a recipe, they will learn it.
#    You can set some to be triggered by events.
#
#  Instructions:
#    Put below all default scripts, but above Main.
#    Follow the examples in the module, and put in the numbers where needed.
#     it is the easiest way to make it usable without too much coding.
#
#  To make an item so an event must be triggered:
#     Add the ID number to the right area.  The right area for:
#       Items:  Item_Event_Triggered = []
#       Weapons:  Weapon_Event_Triggered = []
#       Armors:  Armor_Event_Triggered = []
#
#  If the item is evented, and needs to be added to the list, use this in call script
#  (without the 'For Items', 'For Weapons', and 'For Armors'):
#    For items:
#      $game_party.event_item.push(item_id)
#      $game_party.compile
#
#    For weapons:
#      $game_party.event_weapon.push(weapon_id)
#      $game_party.compile
#
#    For armors:
#      $game_party.event_armor.push(armor_id)
#      $game_party.compile
#
#  If you want each item to be added via 'recipe':
#    Set each item to be 'evented'.
#    To add them, use this in call script (without the 'For Items', 'For Weapons', and 'For Armors'):
#      For Items:
#        $game_party.item_recipe_availible.push(item_id)
#        $game_party.item_recipes_made[item_id] = 0
#      For Weapons:
#        $game_party.weapon_recipe_availible.push(weapon_id)
#        $game_party.weapon_recipes_made[weapon_id] = 0
#      For Armors:
#        $game_party.armor_recipe_availible.push(armor_id)
#        $game_party.armor_recipes_made[armor_id] = 0
#      
#
#
#  Additional Information:
#    If you are having troubles with the Craft_Item_Comp, Craft_Weapon_Comp, and
#    Craft_Armor_Comp:
#      The way it is set up is:
#        Craft_Item_Comp = {
#        item.id => [[item_id, item_type, number_needed], [item_id, item_type, number_needed]]
#        }
#      Make sure you have it set up like that, and you can have many more than that.  Also, as stated
#      below, the item_types are: 0-item, 1-weapon, 2-armor
#
#========================================
=begin
food component list:
5 wood
6 skipping stone
8 fresh water
9 snow
10 green mushroom
11 The fucking SUN

21 raw meat
22 raw fish
23 frozen veggies
24 veggie bullion
25 chili powder
26 yellow mushroom
27 meal kit

29 boiled water

=end

#========================================
#  module Craft_Items
#    Notes:
#      item.types are:  0-item, 1-weapon, 2-armor
#========================================
module Craft_Items
 #---------------------------------------------
 #  Recipes for Items
 #  Craft_Item_Comp = {item_id => [[item.id, item.type, # needed], etc...]
 # Remember: item 5 is wood. Wood is needed to make boiled water.
 #---------------------------------------------
 Craft_Item_Comp = { #boiled
 8 => [[9, 0, 1]], #snow becomes fresh water 
 17=> [[11, 0, 1],[9, 0, 1]], #The Sun + snow = pain
 29 => [[8, 0, 1]] , #fresh water becomes boiled water 

 47 => [[9, 0, 1], [25, 0, 1]], #snow + chili powder = hot snow??? 
 }
 #---------------------------------------------
 #  Recipes for Weapons
 #  Craft_Weapon_Comp = {weapon_id => [[item.id, item.type, # needed], etc...]
 #---------------------------------------------
 Craft_Weapon_Comp = {
 18 => [[5, 0, 1], [10, 0, 1]], #poison stick
 19 => [[5, 0, 1], [25, 0, 1]] #hot stick
 }
 #---------------------------------------------
 #  Recipes for Armors
 #  Craft_Armor_Comp = {Armor_id => [[item.id, item.type, # needed], etc...]
 # remember: item 27 is the meal kit! item 29 is boiled water!
 # these two are needed for all meals!
 #---------------------------------------------
 Craft_Armor_Comp = {
 #basic
 16 => [[27, 0, 1],[29, 0, 1]], #plain meal
 17 => [[21, 0, 1], [27, 0, 1],[29, 0, 1]], #meaty meal
 18 => [[26, 0, 1], [27, 0, 1],[29, 0, 1]], #shroom meal
 19 => [[22, 0, 1], [27, 0, 1],[29, 0, 1]], #fishy dish
 20 => [[25, 0, 1], [27, 0, 1],[29, 0, 1]], #hot vegan dish
 21 => [[19, 0, 1], [27, 0, 1],[29, 0, 1]], #worm bake
 
 29 => [[25, 0, 1]], #calzone
 
 #shroom boosted dishes
 23 => [[26, 0, 1],[21, 0, 1], [27, 0, 1],[29, 0, 1]], #meaty meal+
 24 => [[26, 0, 1],[22, 0, 1], [27, 0, 1],[29, 0, 1]], #fishy dish+
 26 => [[26, 0, 1],[25, 0, 1], [27, 0, 1],[29, 0, 1]], #hot vegan dish+
 27 => [[26, 0, 1],[19, 0, 1], [27, 0, 1],[29, 0, 1]], #worm bake+
 
  #shroom poisoned dishes
 29 => [[10, 0, 1],[21, 0, 1], [27, 0, 1],[29, 0, 1]], #poison meaty meal
 30 => [[10, 0, 1],[22, 0, 1], [27, 0, 1],[29, 0, 1]], #poison fishy dish
 31 => [[10, 0, 1], [27, 0, 1],[29, 0, 1]], #poison shroom meal
 32 => [[10, 0, 1],[25, 0, 1], [27, 0, 1],[29, 0, 1]], #poison hot vegan dish
 33 => [[10, 0, 1],[19, 0, 1], [27, 0, 1],[29, 0, 1]], #poison worm bake
 }
 #---------------------------------------------
 #  Tells which item recipes are evented.
 #  Item_Event_Triggered = [id1, id2...etc]
 #---------------------------------------------
 Item_Event_Triggered = [2]
 #---------------------------------------------
 #  Tells which weapon recipes are evented.
 #  Weapon_Event_Triggered = [id1, id2...etc]
 #---------------------------------------------
 Weapon_Event_Triggered = []
 #---------------------------------------------
 #  Tells which armor recipes are evented.
 #  Armor_Event_Triggered = [id1, id2...etc]
 #---------------------------------------------
 Armor_Event_Triggered = []
end
#========================================
#  END module Craft_Items
#========================================


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Game_Party
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Game_Party
 
 alias leon_cs_gameparty_initialize initialize
 alias leon_cs_gameparty_gainitem gain_item
 alias leon_cs_gameparty_gainweapon gain_weapon
 alias leon_cs_gameparty_gainarmor gain_armor
 
 attr_accessor :item_recipes_made
 attr_accessor :item_recipe_availible
 attr_accessor :weapon_recipes_made
 attr_accessor :weapon_recipe_availible
 attr_accessor :armor_recipes_made
 attr_accessor :armor_recipe_availible
 attr_accessor :event_item
 attr_accessor :event_weapon
 attr_accessor :event_armor
 
 def initialize
   #------------------------------------------------
   # Used to record what items have been made.
   #------------------------------------------------
   @item_recipes_made = {}
   #------------------------------------------------
   # Used to show availible item recipes.
   #------------------------------------------------
   @item_recipe_availible = []
   #------------------------------------------------
   # Used to record what items have been made.
   #------------------------------------------------
   @weapon_recipes_made = {}
   #------------------------------------------------
   # Used to show availible item recipes.
   #------------------------------------------------
   @weapon_recipe_availible = []
   #------------------------------------------------
   # Used to record what items have been made.
   #------------------------------------------------
   @armor_recipes_made = {}
   #------------------------------------------------
   # Used to show availible item recipes.
   #------------------------------------------------
   @armor_recipe_availible = []
   #------------------------------------------------
   #  Shows which ones need triggered events
   #------------------------------------------------
   @event_item = []
   @event_weapon = []
   @event_armor = []
   leon_cs_gameparty_initialize
 end
 
 def gain_item(item_id, n)
   leon_cs_gameparty_gainitem(item_id, n)
   compile
 end
 
 def gain_weapon(weapon_id, n)
   leon_cs_gameparty_gainweapon(weapon_id, n)
   compile
 end
 
 def gain_armor(armor_id, n)
   leon_cs_gameparty_gainarmor (armor_id, n)
   compile
 end
 
 def compile
   ci = Craft_Items
   for i in 0...ci::Craft_Item_Comp.keys.size
     @counter = 0
     for j in 0...ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]].size
       case ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][1]
       when 0
         item = ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][0]
         #every time there is an item change it is called, and is 1
         if @items.keys.include?(item) and @items[item] >= ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 1
         item = ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][0]
         #doesn't come up often
         if @weapons.keys.include?(item) and @weapons[item] >= ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 2
         item = ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][0]
         #uncommon
         if @armors.keys.include?(item) and @armors[item] >= ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]][j][2]
           @counter += 1
         end
       end
       if @counter == ci::Craft_Item_Comp[ci::Craft_Item_Comp.keys[i]].size
         unless @item_recipe_availible.include?(ci::Craft_Item_Comp.keys[i])
           if ci::Item_Event_Triggered.include?(ci::Craft_Item_Comp.keys[i])
             if @event_item.include?(ci::Craft_Item_Comp.keys[i])
               @item_recipe_availible.push(ci::Craft_Item_Comp.keys[i])
               @item_recipes_made[ci::Craft_Item_Comp.keys[i]] = 0
               return
             end
           else
             @item_recipe_availible.push(ci::Craft_Item_Comp.keys[i])
             @item_recipes_made[ci::Craft_Item_Comp.keys[i]] = 0
           end
         end
       end
     end
   end
   
   for i in 0...ci::Craft_Weapon_Comp.keys.size
     @counter = 0
     #item is usually 1 right after an item does a thing here
     for j in 0...ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]].size
       case ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][1]
       when 0
         item = ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][0]
         #item is sometimes 2, sometimes 1
         if @items.keys.include?(item) and @items[item] >= ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 1
         item = ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][0]
         if @weapons.keys.include?(item) and @weapons[item] >= ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 2
         item = ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][0]
         if @armors.keys.include?(item) and @armors[item] >= ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]][j][2]
           @counter += 1
         end
       end
       if @counter == ci::Craft_Weapon_Comp[ci::Craft_Weapon_Comp.keys[i]].size
         unless @weapon_recipe_availible.include?(ci::Craft_Weapon_Comp.keys[i])
           if ci::Weapon_Event_Triggered.include?(ci::Craft_Weapon_Comp.keys[i])
             if @event_weapon.include?(ci::Craft_Weapon_Comp.keys[i])
               @weapon_recipe_availible.push(ci::Craft_Weapon_Comp.keys[i])
               @weapon_recipes_made[ci::Craft_Weapon_Comp.keys[i]] = 0
               return
             end
           else
             @weapon_recipe_availible.push(ci::Craft_Weapon_Comp.keys[i])
             @weapon_recipes_made[ci::Craft_Weapon_Comp.keys[i]] = 0
           end
         end
       end
     end
   end
   
   for i in 0...ci::Craft_Armor_Comp.keys.size #note: this stuff is always active
     @counter = 0
     
     for j in 0...ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]].size
       case ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][1]
       when 0
         item = ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][0]
         #gives the item id
         if @items.keys.include?(item) and @items[item] >= ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 1
         item = ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][0]
         if @weapons.keys.include?(item) and @weapons[item] >= ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][2]
           @counter += 1
         end
       when 2
         item = ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][0]
         if @armors.keys.include?(item) and @armors[item] >= ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]][j][2]
           @counter += 1
         end
       end
       if @counter == ci::Craft_Armor_Comp[ci::Craft_Armor_Comp.keys[i]].size
         #before error, gives entire laundry list of a lot of numbers per item
         unless @armor_recipe_availible.include?(ci::Craft_Armor_Comp.keys[i])
           #prints numbers only when item obtained
           if ci::Armor_Event_Triggered.include?(ci::Craft_Armor_Comp.keys[i])
             if @event_armor.include?(ci::Craft_Armor_Comp.keys[i])
               @armor_recipe_availible.push(ci::Craft_Armor_Comp.keys[i])
               @armor_recipes_made[ci::Craft_Armor_Comp.keys[i]] = 0
               #doesn't even do the thing
               return
             end
           else
             @armor_recipe_availible.push(ci::Craft_Armor_Comp.keys[i])
             @armor_recipes_made[ci::Craft_Armor_Comp.keys[i]] = 0
             #error happens before this can be called, printing of numbers only happens when item is gotten
           end
         end
       end
     end
   end
 end
 
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  END Game_Party
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#=============================================
#  Window_Craft_Info
#=============================================
class Window_Craft_Info < Window_Base
 def initialize
   super(0, 0, 640, 64) 
   self.contents = Bitmap.new(width - 32, height - 32)
   self.contents.font.name = $defaultfonttype
   self.contents.font.size = $defaultfontsize
 end

 def update(help_text)
   self.contents.clear
   self.contents.draw_text(0, 0, 614, 32, help_text, 1)
 end
end
#=============================================
#  END Window_Craft_Info
#=============================================


#=============================================
#  Window_Craft_List
#=============================================
class Window_Craft_List < Window_Selectable
 def initialize
   super(0, 64, 256, 416) #super(0, 64, 256, 416)
   self.contents = Bitmap.new(width - 32, height - 32)
   self.contents.font.name = $defaultfonttype
   self.contents.font.size = $defaultfontsize
   self.index = 0
   $game_system.bgm_memorize
   Audio.bgm_play("Audio/BGM/cooking.it")
   refresh
 end
 
 def list
   if @data[index] != nil
     return @data[index]
   end
 end
 
 def refresh
   ci = Craft_Items
   if self.contents != nil
     self.contents.dispose
     self.contents = nil
     
   end
   @data = []
   for i in 0...$game_party.item_recipe_availible.size
     @data.push($data_items[$game_party.item_recipe_availible[i]])
   end
   for i in 0...$game_party.weapon_recipe_availible.size
     @data.push($data_weapons[$game_party.weapon_recipe_availible[i]])
   end
   for i in 0...$game_party.armor_recipe_availible.size
     @data.push($data_armors[$game_party.armor_recipe_availible[i]])
   end
   
   @item_max = @data.size
   
   if @item_max > 0
     self.contents = Bitmap.new(width - 32, row_max * 32 + 32)
     self.contents.font.name = $defaultfonttype  # "Items" window font
     self.contents.font.size = $defaultfontsize
    #gives an actual database entry here instead of just a number
   self.contents.font.color = system_color
   self.contents.draw_text(0, 0, 120, 32, "Name:")
   self.contents.draw_text(0, 0, 224, 32, "On hand:", 2)
   self.contents.font.color = normal_color
     for i in 0...@item_max
       draw_item(i)
     end
   end
 end
 
 def draw_item(index)
   item = @data[index]

   x = 4
   y = index * 32

   
   case item
   when RPG::Item
     if $game_party.item_recipes_made[item.id] > 0
       self.contents.draw_text(x, y + 32, 224, 32, item.name)
       self.contents.draw_text(x - 8, y + 32, 224, 32, $game_party.item_recipes_made[item.id].to_s, 2)
     else
       self.contents.draw_text(x, y + 32, 224, 32, "New Snack")
     end
   when RPG::Weapon
     if $game_party.weapon_recipes_made[item.id] > 0
       self.contents.draw_text(x, y + 32, 224, 32, item.name)
       self.contents.draw_text(x - 8, y + 32, 224, 32, $game_party.weapon_recipes_made[item.id].to_s, 2)
     else
       self.contents.draw_text(x, y + 32, 224, 32, "New... weapon?")
     end
   when RPG::Armor
     if $game_party.armor_recipes_made[item.id] > 0
       self.contents.draw_text(x, y + 32, 224, 32, item.name)
       self.contents.draw_text(x - 8, y + 32, 224, 32, $game_party.armor_recipes_made[item.id].to_s, 2)
     else
       self.contents.draw_text(x, y + 32, 224, 32, "New Dish")
     end
   end
 end
 
def update_cursor_rect
    # If cursor position is less than 0
    if @index < 0
      self.cursor_rect.empty
      return
    end
    # Get current row
    row = @index / @column_max
    # If current row is before top row
    if row < self.top_row
      # Scroll so that current row becomes top row
      self.top_row = row
    end
    # If current row is more to back than back row
    if row > self.top_row + (self.page_row_max - 2)
      # Scroll so that current row becomes back row
      self.top_row = row - (self.page_row_max - 2)
    end
    # Calculate cursor width
    cursor_width = self.width / @column_max - 32
    # Calculate cursor coordinates
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 32 - self.oy
    # Update cursor rectangle
    self.cursor_rect.set(x, y+32, cursor_width, 32)
  end
 
end
#=============================================
#  END Window_Craft_List
#=============================================

   
#=============================================
#  Window_Craft_Desc
#=============================================
class Window_Craft_Desc < Window_Base
 def initialize(item)
   super(256, 64, 384, 316)
   self.contents = Bitmap.new(width - 32, height - 32)
   self.contents.font.name = $defaultfonttype
   self.contents.font.size = $defaultfontsize
   refresh(item)
 end
 
 def refresh(item)
   self.contents.clear
   ci = Craft_Items
   if item != nil
     self.contents.font.color = system_color
     self.contents.draw_text(0, 64, 352, 32, "Ingredients:", 1)
     self.contents.draw_text(0, 96, 150, 32, "Name:")
     self.contents.draw_text(190, 96, 120, 32, "Required:")
     self.contents.draw_text(280, 96, 120, 32, "On hand:")
     self.contents.font.color = normal_color
     @items = []
     bitmap = RPG::Cache.icon(item.icon_name) #icon
     opacity = self.contents.font.color == normal_color ? 255 : 128
     self.contents.blt(0, 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
     case item
     when RPG::Item
       if $game_party.item_recipes_made[item.id] > 0
         self.contents.draw_text(28, 0, 200, 32, item.name)
         self.contents.draw_text(10, 32, 352, 32, item.description)
       else
         self.contents.draw_text(28, 0, 200, 32, "New Snack/component")
         self.contents.draw_text(10, 32, 352, 32, "This might be good to eat in a pinch, or not.")
       end
     when RPG::Weapon
       if $game_party.weapon_recipes_made[item.id] > 0
         self.contents.draw_text(28, 0, 200, 32, item.name)
         self.contents.draw_text(10, 32, 352, 32, item.description)
       else
         self.contents.draw_text(28, 0, 200, 32, "New... weapon???")
         self.contents.draw_text(10, 32, 352, 32, "Probably not edible, but maybe useful?")
       end
     when RPG::Armor
       if $game_party.armor_recipes_made[item.id] > 0
         self.contents.draw_text(28, 0, 200, 32, item.name)
         self.contents.draw_text(10, 32, 352, 32, item.description)
       else
         self.contents.draw_text(28, 0, 200, 32, "New Dish")
         self.contents.draw_text(10, 32, 352, 32, "This one looks like it'll turn out well...")
       end
     end
     case item
     when RPG::Item
       #p ci::Craft_Item_Comp[item.id] #what is this
       for i in 0...ci::Craft_Item_Comp[item.id].size
         item2 = ci::Craft_Item_Comp[item.id][i][0]
         case ci::Craft_Item_Comp[item.id][i][1]
         when 0
           @items.push([$data_items[ci::Craft_Item_Comp[item.id][i][0]], ci::Craft_Item_Comp[item.id][i][2]])
         when 1
           @items.push([$data_weapons[ci::Craft_Item_Comp[item.id][i][0]], ci::Craft_Item_Comp[item.id][i][2]])
         when 2
           @items.push([$data_armors[ci::Craft_Item_Comp[item.id][i][0]], ci::Craft_Item_Comp[item.id][i][2]])
         end
       end
     when RPG::Weapon
       for i in 0...ci::Craft_Weapon_Comp[item.id].size
         item2 = ci::Craft_Weapon_Comp[item.id][i][0]
         case ci::Craft_Weapon_Comp[item.id][i][1]
         when 0
           @items.push([$data_items[ci::Craft_Weapon_Comp[item.id][i][0]], ci::Craft_Weapon_Comp[item.id][i][2]])
         when 1
          @items.push([$data_weapons[ci::Craft_Weapon_Comp[item.id][i][0]], ci::Craft_Weapon_Comp[item.id][i][2]])
         when 2
           @items.push([$data_armors[ci::Craft_Weapon_Comp[item.id][i][0]], ci::Craft_Weapon_Comp[item.id][i][2]])
         end
       end
     when RPG::Armor
       for i in 0...ci::Craft_Armor_Comp[item.id].size
         item2 = ci::Craft_Armor_Comp[item.id][i][0]
         case ci::Craft_Armor_Comp[item.id][i][1]
         when 0
           @items.push([$data_items[ci::Craft_Armor_Comp[item.id][i][0]], ci::Craft_Armor_Comp[item.id][i][2]])
         when 1
           @items.push([$data_weapons[ci::Craft_Armor_Comp[item.id][i][0]], ci::Craft_Armor_Comp[item.id][i][2]])
         when 2
           @items.push([$data_armors[ci::Craft_Armor_Comp[item.id][i][0]], ci::Craft_Armor_Comp[item.id][i][2]])
         end
       end
     end
     for i in 0...@items.size
       x = 5
       y = i * 32 + 128
       case @items[i][0]
       when RPG::Item
         if $game_party.item_number(@items[i][0].id) >= @items[i][1]
           self.contents.font.color = normal_color
         else
           self.contents.font.color = disabled_color
         end
         bitmap = RPG::Cache.icon(@items[i][0].icon_name) #icon
         opacity = self.contents.font.color == normal_color ? 255 : 128
         self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
         self.contents.draw_text(x + 28, y, 200, 32, @items[i][0].name)
         self.contents.draw_text(x + 210, y, 50, 32, @items[i][1].to_s)
         self.contents.draw_text(x + 290, y, 50, 32, $game_party.item_number(@items[i][0].id).to_s)
       when RPG::Weapon
         if $game_party.weapon_number(@items[i][0].id) >= @items[i][1]
           self.contents.font.color = normal_color
         else
           self.contents.font.color = disabled_color
         end
         bitmap = RPG::Cache.icon(@items[i][0].icon_name) #icon
         opacity = self.contents.font.color == normal_color ? 255 : 128
         self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
         self.contents.draw_text(x + 28, y, 200, 32, @items[i][0].name)
         self.contents.draw_text(x + 210, y, 50, 32, @items[i][1].to_s)
         self.contents.draw_text(x + 290, y, 50, 32, $game_party.weapon_number(@items[i][0].id).to_s)
       when RPG::Armor
         if $game_party.armor_number(@items[i][0].id) >= @items[i][1]
           self.contents.font.color = normal_color
         else
           self.contents.font.color = disabled_color
         end
         bitmap = RPG::Cache.icon(@items[i][0].icon_name) #icon
         opacity = self.contents.font.color == normal_color ? 255 : 128
         self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
         self.contents.draw_text(x + 28, y, 200, 32, @items[i][0].name)
         self.contents.draw_text(x + 210, y, 50, 32, @items[i][1].to_s)
         self.contents.draw_text(x + 290, y, 50, 32, $game_party.armor_number(@items[i][0].id).to_s)
       end
     end
   end
 end
end
#=============================================
#  END Window_Craft_Desc
#=============================================


#=============================================
#  Scene_Craft
#=============================================
class Scene_Craft
 def main
   @background = Plane.new #background initialization
   @background.bitmap = RPG::Cache.panorama("plaidpattern",0)
   @info_window = Window_Craft_Info.new
   @list_window = Window_Craft_List.new
   @desc_window = Window_Craft_Desc.new(@list_window.list)
   
   Graphics.transition
   loop do
     Graphics.update
     Input.update
     update
     if $scene != self
       break
     end
   end
   Graphics.freeze
   
   @info_window.dispose
   @list_window.dispose
   @desc_window.dispose
   @background.dispose
 end
 
 def update
   @background.ox -= 1 #move the background here
   @background.oy -= 1
   ci = Craft_Items
   @info_window.update("Select a dish to create!")
   @list_window.update
   @desc_window.update
   if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
     @desc_window.refresh(@list_window.list)
   end
   if Input.trigger?(Input::B)
     $game_system.se_play($data_system.cancel_se)
     $scene = Scene_Map.new
     $game_system.bgm_restore
   end
   if Input.trigger?(Input::C)
     @counter = 0
     case @list_window.list
     when RPG::Item
       for i in 0...ci::Craft_Item_Comp[@list_window.list.id].size
         case ci::Craft_Item_Comp[@list_window.list.id][i][1]
         when 0
           if $game_party.item_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 1
           if $game_party.weapon_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 2
           if $game_party.armor_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         end
       end
       if @counter == ci::Craft_Item_Comp[@list_window.list.id].size
         for i in 0...ci::Craft_Item_Comp[@list_window.list.id].size
           case ci::Craft_Item_Comp[@list_window.list.id][i][1]
           when 0
             if $game_party.item_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
               $game_party.lose_item(ci::Craft_Item_Comp[@list_window.list.id][i][0], ci::Craft_Item_Comp[@list_window.list.id][i][2])
             end
           when 1
             if $game_party.weapon_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
               $game_party.lose_weapon(ci::Craft_Item_Comp[@list_window.list.id][i][0], ci::Craft_Item_Comp[@list_window.list.id][i][2])
             end
           when 2
             if $game_party.armor_number(ci::Craft_Item_Comp[@list_window.list.id][i][0]) >= ci::Craft_Item_Comp[@list_window.list.id][i][2]
               $game_party.lose_armor(ci::Craft_Item_Comp[@list_window.list.id][i][0], ci::Craft_Item_Comp[@list_window.list.id][i][2])
             end
           end
         end
         $game_system.se_play($data_system.decision_se)
         $game_party.gain_item(@list_window.list.id, 1)
         $game_party.item_recipes_made[@list_window.list.id] += 1
         @list_window.refresh
         @desc_window.refresh(@list_window.list)
       end
     when RPG::Weapon
       for i in 0...ci::Craft_Weapon_Comp[@list_window.list.id].size
         case ci::Craft_Weapon_Comp[@list_window.list.id][i][1]
         when 0
           if $game_party.item_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 1
           if $game_party.weapon_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 2
           if $game_party.armor_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         end
       end
       if @counter == ci::Craft_Weapon_Comp[@list_window.list.id].size
         for i in 0...ci::Craft_Weapon_Comp[@list_window.list.id].size
           case ci::Craft_Weapon_Comp[@list_window.list.id][i][1]
           when 0
             if $game_party.item_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
               $game_party.lose_item(ci::Craft_Weapon_Comp[@list_window.list.id][i][0], ci::Craft_Weapon_Comp[@list_window.list.id][i][2])
             end
           when 1
             if $game_party.weapon_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
               $game_party.lose_weapon(ci::Craft_Weapon_Comp[@list_window.list.id][i][0], ci::Craft_Weapon_Comp[@list_window.list.id][i][2])
             end
           when 2
             if $game_party.armor_number(ci::Craft_Weapon_Comp[@list_window.list.id][i][0]) >= ci::Craft_Weapon_Comp[@list_window.list.id][i][2]
               $game_party.lose_armor(ci::Craft_Weapon_Comp[@list_window.list.id][i][0], ci::Craft_Weapon_Comp[@list_window.list.id][i][2])
             end
           end
         end
       $game_system.se_play($data_system.decision_se)
       $game_party.gain_weapon(@list_window.list.id, 1)
       $game_party.weapon_recipes_made[@list_window.list.id] += 1
       @list_window.refresh
       @desc_window.refresh(@list_window.list)
       end
     when RPG::Armor
       for i in 0...ci::Craft_Armor_Comp[@list_window.list.id].size
         case ci::Craft_Armor_Comp[@list_window.list.id][i][1]
         when 0
           if $game_party.item_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 1
           if $game_party.weapon_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         when 2
           if $game_party.armor_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
             @counter += 1
           end
         end
       end
       if @counter == ci::Craft_Armor_Comp[@list_window.list.id].size
         for i in 0...ci::Craft_Armor_Comp[@list_window.list.id].size
           case ci::Craft_Armor_Comp[@list_window.list.id][i][1]
           when 0
             if $game_party.item_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
               $game_party.lose_item(ci::Craft_Armor_Comp[@list_window.list.id][i][0], ci::Craft_Armor_Comp[@list_window.list.id][i][2])
             end
           when 1
             if $game_party.weapon_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
               $game_party.lose_weapon(ci::Craft_Armor_Comp[@list_window.list.id][i][0], ci::Craft_Armor_Comp[@list_window.list.id][i][2])
             end
           when 2
             if $game_party.armor_number(ci::Craft_Armor_Comp[@list_window.list.id][i][0]) >= ci::Craft_Armor_Comp[@list_window.list.id][i][2]
               $game_party.lose_armor(ci::Craft_Armor_Comp[@list_window.list.id][i][0], ci::Craft_Armor_Comp[@list_window.list.id][i][2])
             end
           end
         end
       $game_system.se_play($data_system.decision_se)
       $game_party.gain_armor(@list_window.list.id, 1)
       $game_party.armor_recipes_made[@list_window.list.id] += 1
       @list_window.refresh
       @desc_window.refresh(@list_window.list)
       end
     end
   end
   return
 end
end