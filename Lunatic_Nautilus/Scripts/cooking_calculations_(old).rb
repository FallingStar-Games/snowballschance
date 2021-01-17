#cooking calculations
#the number returned is an armor entry in the database.
# by Theo and lavendersiren

class Cookcalc

  ResultHash = {
  #mushroom first, ingredient second
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
  #Actor first, meal second
  #2,3,4,6,12
  #Frie
  [2,16] => 4,
  [2,17] => 3,
  [2,18] => 1,
  [2,19] => 0,
  [2,20] => 1,
  [2,21] => 2,
  #curious about worms
  [2,23] => 3,
  [2,24] => 0,
  [2,25] => 2,
  [2,26] => 1,
  [2,27] => 1,
  #fucking 0, are you serious?
  [2,29] => 0,
  [2,30] => 0,
  [2,31] => 0,
  [2,32] => 0,
  [2,33] => 0,
  
  #Vern
  [3,16] => 1,
  [3,17] => 3,
  [3,18] => 2,
  [3,19] => 3,
  [3,20] => 1,
  [3,21] => 0, #worm
  
  [3,23] => 4,
  [3,24] => 4,
  [3,25] => 4,
  [3,26] => 2,
  [3,27] => 0, #worm plus
  
  [3,29] => 0,
  [3,30] => 0,
  [3,31] => 0,
  [3,32] => 0,
  [3,33] => 0,  

  #Arctos 
  [4,16] => 1,
  [4,17] => 3,
  [4,18] => 2,
  [4,19] => 3,
  [4,20] => 1,
  [4,21] => 2, #worm
  
  [4,23] => 4,
  [4,24] => 4,
  [4,25] => 4,
  [4,26] => 2,
  [4,27] => 2, #worm plus
  
  [4,29] => 0,
  [4,30] => 0,
  [4,31] => 0,
  [4,32] => 0,
  [4,33] => 0,  
  
  #Topaz
  [6,16] => 1,
  [6,17] => 0,
  [6,18] => 2,
  [6,19] => 0,
  [6,20] => 3,
  [6,21] => 0, #worm
  
  [6,23] => 0,
  [6,24] => 0,
  [6,25] => 0,
  [6,26] => 4,
  [6,27] => 0, #worm plus
  
  [6,29] => 0,
  [6,30] => 0,
  [6,31] => 0,
  [6,32] => 0,
  [6,33] => 0, 
  #Coda
  [12,16] => 1,
  [12,17] => 2,
  [12,18] => 2,
  [12,19] => 2,
  [12,20] => 2,
  [12,21] => 3, #worm
  
  [12,23] => 4,
  [12,24] => 4,
  [12,25] => 3,
  [12,26] => 4,
  [12,27] => 4, #worm plus
  
  [12,29] => 0,
  [12,30] => 0,
  [12,31] => 0,
  [12,32] => 0,
  [12,33] => 0 
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
  #it's a number from 0-4

if @ingre == 0
  #plain
elsif @ingre== 1
  $game_party.lose_item(25, 1) #spicy
elsif @ingre== 2
  $game_party.lose_item(21, 1) #meat
elsif @ingre== 3
  $game_party.lose_item(22, 1) #fish
elsif @ingre== 4
  $game_party.lose_item(19, 1) #worm
elsif @ingre== 5
  $game_party.lose_item(12, 1) #calzone
else
  p "what the hell did you put in your ingredience?"
  end
  
  #remove shroom
  if @shroom == 1
  $game_party.lose_item(10, 1) #poison
elsif @shroom== 2
  $game_party.lose_item(26, 1) #yellow
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
#this returns a number to be used to determine a thing, between 0 and 4

#this thing is returning nil?

  if $game_variables[9]<=0
    p "ur a bitche"
    #it's also calling me a bitche
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

    actor=$data_actors[@bbb].id
    meal= $game_actors[@bbb].armor1_id
    
    
    
    
    return FoodPrefhash[[actor,meal]]
end


end