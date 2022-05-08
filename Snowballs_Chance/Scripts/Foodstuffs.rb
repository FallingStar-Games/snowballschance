#---------------------------------
# Foodstuffs script (disabled due to syntax errors)
# By shinyjiggly
# (heavily based off the work of Sixth of rpgmakerweb.com)
#---------------------------------
=begin

#if item [a] is used,

#and actor [1] is the target,
#then cause effect [A]

#elsif actor [2] is the target,
#then cause effect [B] ...
#for target in battler.target_battlers
#      target.item_effect(battler.current_item, battler)

class Game_Battler

alias food_bonus item_effect
def item_effect(battler.current_item, battler)
food_bonus(battler.current_item, battler)

def food_bonus(battler.current_item, battler)
	case battler.current_item
	when RPG::Item
		case item.id
		when 1 #item 1 effects
		
      when Game_Actor
	case self.id
		when 1; self.hp+= 255 #actor specific effects here
		when 3; self.hp+= 69 #actor specific effects here
		else; #everyone else effects here
		end #specify actor end
	end #item 1 end
		when 2 # item 2
		
      when Game_Actor
    case self.id
      when 1; #actor specific effects here
      when 2; #actor specific effects here
      else; #everyone else effects here
    end #item 2 end
	
	#stick other item stuff here
	
		else; #generic effects here
		
		end #end of item cases

  end #end of food bonus
  
end #end of item effect
end #end of class

=end
