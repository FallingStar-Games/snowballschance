#==============================================================================
# ** Enhanced Squad Movement
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.0
#    12-25-2017 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#==============================================================================



module Squad
  # ===========================================================================
    MOVE_ACTOR = {} # Do not edit
  # ===========================================================================
  
  # GENERAL STETTINGS
  # =================
  # Here are two generic values controlling party size and the switch 
  # that hides/shows the squad.
  #
    SQUAD_PARTY_SIZE            = 5     # Size of party allowed   
    SQUAD_SWITCH_ID             = 23     # Switch that turns squad off (hides)
    SQUAD_UPDATE_RATE           = 9     # (0-9) Rate of Speed/Freq update
    SQUAD_ALL_DEAD              = true  # If using squad-based all-dead variant
  
  
  # ACTOR_REMOVAL
  # ==============
  # This system controls whether party members can or cannot be removed with
  # the 'remove_actor' command (ie: "Change Party Member" event command).
  #
    REMOVE_PREVENT_LEAD       = false
    REMOVE_PREVENT_ACTOR      = [] #[2,7]
    
    
  # PARTY CYCLING
  # =============
  # This controls player rotation or cycling, and can control whether the lead
  # actor can be replaced during the cycling.
  #
    CYCLE_PREVENT             = true   # If cycling is enabled at all
    LEADER_CYCLE_PREVENT      = true   # If the lead actor can be changed
    UNAVAILABLE_CYCLE_PREVENT = true    # If 0 HP, Waiting or not-on-map halted
    
    
  # PLAYER CONTROL
  # ==============
  # This defines actor hotkeys which control party movement functions.
  #
    KEY_CYCLE_FORWARD     = nil #Input::L    # Default (Q key)
    KEY_CYCLE_BACKWARD    = nil #Input::R    # Default (W key)
    KEY_LEADER_WAIT       = nil #Input::X    # Default (A key)
    KEY_PARTY_GATHER      = nil #Input::R  # (W key)
    
  
  
  # AUTO-REGROUP
  # ============
  # This controls if the party members that stray too far from the party leader
  # may use a technique to get back to the game player.
  # 
    REGROUP_TIMER   = 2     # Seconds that pass before testing (nil to disable)
    REGROUP_RANGE   = 7     # Tile distance before running (nil to disable)
    REGROUP_PATH    = false  # If true, uses Pathfinding*. Else members 'flash'

    
    # PARTY MOVEMENT
  # ==============
  # Controls how the party follows the lead actor utilizing 'squad' mechanics
  # rather than the classic caterpillar, single-file system.
  # 
    MOVE_STYLE      = 3   # Styles: 0=Default, 1=Party, 2=Class, 3=Distance
    MOVE_ACTOR[2]   = 5   # (If move style is 3) Actor 7 may stay 6 tiles away
    MOVE_ACTOR[3]   = 3   # (If move style is 3) Actor 7 may stay 6 tiles away
    MOVE_ACTOR[6]   = 2   # (If move style is 3) Actor 7 may stay 6 tiles away
    MOVE_ACTOR[4]   = 4 
    MOVE_ACTOR[5]   = 4 
  
end
