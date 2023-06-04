#cooking calculations
#the number returned is an armor entry in the database.
# by Theo and lavendersiren

# https://docs.google.com/spreadsheets/d/19u9X0Dl11u5VOvVp4rr1xWDUScVVrAe5vPsyfMcDWaE/edit?usp=sharing
# use this spreadsheet as a reference!!

# note: everything is a mess here. Use the old one in GBJ for reference.
# snack system still needs to use this!
# When it comes to calculating values, you're on your own
# current cooking system is all common events and scriptlets now so it hardly even needs this

class Cookcalc
#under new system, this may only wind up being used for the snack system
  ResultHash = {
  #topping first, ingredient second
  #plain
  [0,0] => 16,
  [0,1] => 20,
  [0,2] => 17,
  [0,3] => 19,
  [0,4] => 21,
  [0,5] => 25,
  #poisoned
  [1,0] => 31,
  [1,1] => 32,
  [1,2] => 29,
  [1,3] => 30,
  [1,4] => 33,
  #boosted
  [2,0] => 18,
  [2,1] => 26,
  [2,2] => 23,
  [2,3] => 24,
  [2,4] => 27,

#-------------------------------------------------
# ---------------- this ---------------
  #snacks
  [4,5] => 40, #fourleaf compote
  [5,5] => 39, #threeleaf compote
  [1,6] => 42, #poison boiled shroom
  [2,6] => 41, #boiled shroom
  [3,6] => 45, #doubleboiled shroom
  [0,7] => 44, #seared fish
  [0,8] => 43,  #boiled worm
  [0,9] => 47  #pine tea
  }
  
    FoodPrefhash = {
  #meal first, this is what we're doing for now
  #2,3,4,6,12
  #likes 3 leaf, but not 4 leaf
  [16] => 0, #mash meal
  [17] => 1, #meaty meal
  [18] => 2, #veggie stirfry
  [19] => 3, #fishy dish
  [20] => 4, #Great fishy dish
  [21] => 5, #worm bake

  [25] => 6, #calzone
  [34] => 7, #Finn chipmeal
  [35] => 8, #Kale chipmeal
  }
  
  def self.armornum
    @ingre=$game_variables[10]
    @shroom=$game_variables[11]
    return ResultHash[[@shroom,@ingre]]
  end
#--------------------------------------------------------
# give me a  /  s  n  a  c  k    /
#
#--------------------
    def self.gimmesnack
  $game_party.gain_item(Cookcalc.armornum, 1)
  #grab the values from up there and use it to get an item
  
  #use the values up there to lose items
  if @ingre == 0
  #plain
elsif @ingre== 5 #compote
  $game_party.lose_item(8, 1) #lose the water here
  $game_party.gain_item(16,1) #gain bottle here
elsif @ingre== 6 #boiled shroom
  $game_party.lose_item(8, 1) #lose the water here
  $game_party.gain_item(16,1) #gain bottle here
elsif @ingre== 7 #grilled fish
  $game_party.lose_item(22, 1) #lose the fish
elsif @ingre== 8 #boiled worm
  $game_party.lose_item(19, 1) #lose the worm
  $game_party.lose_item(8, 1) #lose the water here
  $game_party.gain_item(16,1) #gain bottle here
elsif @ingre== 9 #pine tea
  $game_party.lose_item(13, 1) #lose the worm
  $game_party.lose_item(8, 1) #lose the water here
  $game_party.gain_item(16,1) #gain bottle here
  else
  p "what the hell did you put in your ingredience?"
  end
#p "gimme ur components"   
  #remove component
  if @shroom == 1
  $game_party.lose_item(10, 1) #poison
elsif @shroom== 2
  $game_party.lose_item(26, 1) #yellow
elsif @shroom== 3
  $game_party.lose_item(42, 1) #double cooked
elsif @shroom== 4
  $game_party.lose_item(37, 1) #4 leaf
elsif @shroom== 5
  $game_party.lose_item(38, 1) #3 leaf
else
  #do nothing
  end
  
end #end of snack
#--------------------------------------------------------------
  def self.gimmearmor
  $game_party.gain_armor(Cookcalc.armornum, 1)
  #remove ingre and remove shroom
  #convert ingre back to its item
  #it's a number from 0-8
p "is this armor method even used?"  
if @ingre == 0
  #plain
elsif @ingre== 1
  $game_party.lose_item(21, 1) #meat
elsif @ingre== 2
  $game_party.lose_item(22, 1) #ok fish
elsif @ingre== 3
  $game_party.lose_item(51, 1) #great fish
elsif @ingre== 4
  $game_party.lose_item(19, 1) #worm
elsif @ingre== 5
  $game_party.lose_item(23, 1) #veggies
  
# Note: chips are weird since they're stored in variables. 
# the thing checks if there's at least 3 snack servings first anyways.
elsif @ingre== 6
  $game_variables[43]-=3 #finn's chips
elsif @ingre== 7
  $game_variables[44]-=3 #kale chips
elsif @ingre== 8
  $game_party.lose_item(12, 1) #calzone
else
  p "what the hell did you put in your ingredience?"
  end
p "toppings"  
  #remove topping
  if @shroom == 1
  $game_party.lose_item(10, 1) #poison
elsif @shroom== 2
  $game_party.lose_item(26, 1) #yellow
elsif @shroom== 3
  $game_party.lose_item(25, 1) #chili powder
elsif @shroom== 4
  $game_party.lose_item(38, 1) #tri-leaf
elsif @shroom== 5
  $game_party.lose_item(37, 1) #quad-leaf
elsif @shroom== 6
  $game_party.lose_item(13, 1) #needleleleles
else
  #do nothing
  end
$game_party.lose_item(27, 1) #meal kit is always used
  end #end of meal stuff

  def self.newequip
  if $game_variables[9]<=0
    p "ur a bitche"
  else
     if $game_variables[9]==1
    @bbb= 12 #coda 
  else
  if $game_variables[9]==2
    @bbb= 6 #topaz
  else
  if $game_variables[9]==3
    @bbb= 3 #vern
  else
  if $game_variables[9]==4
    @bbb= 2 #frie
  else
  if $game_variables[9]==5
    @bbb= 4 #arctos
  else
    p "ur a bitch"
  end
  
end

  end
  end
  end
  
  end

  $game_actors[@bbb].equip(1, Cookcalc.armornum)
end
#----------------------------------
  def self.multi
    #somehow this is actually being used in the new system!
#this returns a number to be used to determine a thing, between 0 and 4
#this thing is returning nil?

  if $game_variables[9]<=0
    p "ur a bitche"
    #it's also calling me a bitche
    else
  if $game_variables[9]==1 #if we're at the last one cooking stuff
    @bbb= 12 #coda 
    else
  if $game_variables[9]==2
    @bbb= 6 #topaz
    else
  if $game_variables[9]==3
    @bbb= 3 #vern
    else
  if $game_variables[9]==4
    @bbb= 2 #frie
    else
  if $game_variables[9]==5
    @bbb= 4 #arctos
    else
    p "ur a bitch"
  end
  p "party members amount is " + $game_variables[9] + " now."
end

end

  end
  end
  
  end
#current actor is the one determined by bbb up there
#meal refers to whats in bbb's armor1 slot
#topping refers to what's in bbb's armor2 slot
#auracharge refers to what's in bbb's armor4 slot
    actor=$data_actors[@bbb].id
    meal= $game_actors[@bbb].armor1_id
    topping= $game_actors[@bbb].armor2_id
    
    auracharge= $game_actors[@bbb].armor4_id
    p "is this even used"
    
    
    #return FoodPrefhash[[actor,meal,topping,auracharge]] #edit, kinda iffy tho
    
    #gives the meal in the foodpref hash, this is used in foodpower2
    return FoodPrefhash[[meal]]
    
end


end