#==============================================================================
# Enemy Auto States
# By Atoa
#==============================================================================
# This script allows you to create effects that stay always active for enemies
#==============================================================================

module Atoa
  # Do not remove this line
  Auto_Status_Enemy = {}
  # Do not remove this line
  
  # Auto_Status_Enemy[Enemy_ID] = [States,...]
  #   A = Enemy ID
  #   States = States ID

  #Auto_Status_Enemy[1] = [7] #makes enemy asleep

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Enemy Auto States'] = true

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     troop_id     : troop ID
  #     member_index : troop member index
  #     enemy_id     : enemy ID
  #--------------------------------------------------------------------------
  alias initialize_enemystatus initialize
  def initialize(troop_id, member_index, enemy_id = nil)
    initialize_enemystatus(troop_id, member_index, enemy_id)
    update_auto_state
  end
  #--------------------------------------------------------------------------
  # * Update Auto States
  #--------------------------------------------------------------------------
  def update_auto_state
    st = Auto_Status_Enemy
    multi_auto_state_id = (st != nil and st[@enemy_id] != nil) ? st[@enemy_id] : []
    for state in multi_auto_state_id
      add_state(state, true)
    end
  end
end