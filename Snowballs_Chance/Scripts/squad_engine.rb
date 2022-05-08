#==============================================================================
# ** Enhanced Squad Movement
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.0
#    12-25-2017 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#==============================================================================



#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_game_temp_initialize initialize
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :squad_party_move_route   # Squad member index in move route
  attr_accessor :squad_actor_move_route   # Squad actor id in move route
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Perform the original call
    squad_game_temp_initialize
    # Define player move route substitutes
    @squad_party_move_route = 0
    @squad_actor_move_route = 0
  end
end



#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_game_system_initialize initialize
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :allies                   # Squad Ally Array
  attr_accessor :squad_pathfinding1       # Auto-detection for NF Pathfinding 1
  attr_accessor :squad_party_size         # Set size for the party
  attr_accessor :squad_switch_id          # Switch that turns on/off the squad
  attr_accessor :squad_speed_freq         # How often the ally speed updates
  attr_accessor :squad_all_dead           # Switch that turns on/off all-dead?
  attr_accessor :remove_prevent_lead      # Can leader be removed from party?
  attr_accessor :remove_prevent_actor     # IDs of actors that can be removed
  attr_accessor :cycle_prevent            # Is the cycling system turned off?
  attr_accessor :leader_cycle_prevent     # Is the lead actor always lead?
  attr_accessor :waiting_cycle_prevent    # If non-available actors blocked
  attr_accessor :key_cycle_forward        # KEY used to cycle party forward
  attr_accessor :key_cycle_backward       # KEY used to cycle party backward
  attr_accessor :key_leader_wait          # KEY used to force leader to leave
  attr_accessor :key_party_gather         # KEY used to regroup the squad
  attr_accessor :regroup_timer            # Delay in seconds before regrouping
  attr_accessor :regroup_range            # Range ally must exceed for regroup
  attr_accessor :regroup_pathflash        # Style of regrouping
  attr_accessor :move_style               # movement style for squad
  attr_accessor :move_actor               # Array of squad member distances
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Perform the original call
    squad_game_system_initialize
    # Additional values
    @allies                 = nil
    @squad_pathfinding1     = false
    @squad_party_size       = Squad::SQUAD_PARTY_SIZE
    @squad_switch_id        = Squad::SQUAD_SWITCH_ID
    @squad_speed_freq       = Squad::SQUAD_UPDATE_RATE
    @squad_all_dead         = Squad::SQUAD_ALL_DEAD
    @remove_prevent_lead    = Squad::REMOVE_PREVENT_LEAD
    @remove_prevent_actor   = Squad::REMOVE_PREVENT_ACTOR
    @cycle_prevent          = Squad::CYCLE_PREVENT
    @leader_cycle_prevent   = Squad::LEADER_CYCLE_PREVENT
    @waiting_cycle_prevent  = Squad::UNAVAILABLE_CYCLE_PREVENT
    @key_cycle_forward      = Squad::KEY_CYCLE_FORWARD
    @key_cycle_backward     = Squad::KEY_CYCLE_BACKWARD
    @key_leader_wait        = Squad::KEY_LEADER_WAIT
    @key_party_gather       = Squad::KEY_PARTY_GATHER
    @regroup_timer          = Squad::REGROUP_TIMER
    @regroup_range          = Squad::REGROUP_RANGE
    @regroup_pathflash      = Squad::REGROUP_PATH
    @move_style             = Squad::MOVE_STYLE
    @move_actor             = Squad::MOVE_ACTOR
  end
end



#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :actor_id                 # actor ID
end



#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_game_party_initialize initialize
  alias squad_game_party_remove_actor remove_actor
  alias squad_game_party_all_dead? all_dead?
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actors                   # actors
  attr_accessor :party_max                # maximum allowed in party
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Perform the original call
    squad_game_party_initialize
    # Additional values
    @party_max    = $game_system.squad_party_size # Maximum party size
    @player_trans = false                         # Player transparent flag
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    # Obtain actor
    actor = $game_actors[actor_id]
    # Exit if party max has been reached or the actor is in the party
    return unless (@actors.size < @party_max and not @actors.include?(actor))
    # Add the Actor
    @actors.push(actor)
    # Refresh the player
    $game_player.refresh
    # Exit if we'ra adding the lead actor
    if @actors.size == 1
      $scene = Scene_Map.new
      return
    end
    # Set id for Ally
    index = @actors.size-1
    # Add Ally and Refresh
    $game_system.allies[index]  = Game_Ally.new(index)
    if $game_switches[$game_system.squad_switch_id] == true
      $game_system.allies[index].transparent = true
    end
    $game_system.allies[index].refresh
    # Move initially to Player Position
    $game_system.allies[index].moveto($game_player.x, $game_player.y)
    # Add to map if map spriteset exists
    if $scene.spriteset != nil
      $scene.spriteset.add_ally($game_system.allies[index])
    end
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    # Obtain actor
    actor = $game_actors[actor_id]
    # Exit if actor is not in the party
    return unless @actors.include?(actor)
    # Obtain index position of actor in party
    actor_index  = @actors.index(actor)
    # Exit if actor is party leader and cannot be removed
    return if $game_system.remove_prevent_lead && (actor_index == 0)
    # Exit if actor in party cannot be removed
    unless $game_system.remove_prevent_actor.nil?
      return if $game_system.remove_prevent_actor.include?(actor_id)
    end
    # Clear leadval and set as nil (doubles as a flag)
    leadval1 = nil
    # If handling the party leader
    if actor_index == 0
      # If additional party members exist
      unless $game_system.allies[1].nil?
        # Obtain position and graphic data for next actor
        leadval1 = $game_system.allies[1].x
        leadval2 = $game_system.allies[1].y
        leadval3 = $game_system.allies[1].direction
        leadval4 = false
        leadval5 = $game_system.allies[1].map_id
        # If We're 'all-cycling' with allies turned off
        if cycle_force_lead_position == true
          # Obtain Game Player Coordinates
          leadval1    = $game_player.x
          leadval2    = $game_player.y
          leadval3    = $game_player.direction  
        end
      end
    end
    # Create storage for location values
    val1 = []
    val2 = []
    val3 = []
    val4 = []
    val5 = []
    # Fill values with current ally placement
    for ally in $game_system.allies.values
      index = $game_system.allies.index(ally)
      val1[index] = ally.x
      val2[index] = ally.y
      val3[index] = ally.direction
      val4[index] = ally.transparent
      val5[index] = ally.map_id
    end
    index  = @actors.index(actor)
    val1.delete_at(index)
    val2.delete_at(index)
    val3.delete_at(index)
    val4.delete_at(index)
    val5.delete_at(index)
    # Original call
    squad_game_party_remove_actor(actor_id)
    # Handle deletion of actor from allies array
    index = $game_system.allies.length
    $game_system.allies.delete(index)
    # Remove from map if map spriteset exists
    $scene.spriteset.remove_ally if $scene.spriteset != nil
    # Loop all allies
    for ally in $game_system.allies.values
      index = $game_system.allies.index(ally)
      ally.x            = val1[index]
      ally.y            = val2[index]
      ally.direction    = val3[index]
      ally.transparent  = val4[index]
      ally.map_id       = val5[index]
      ally.moveto(val1[index], val2[index])
      # Refresh ally
      ally.refresh
    end
    # If the actor removed was the lead actor
    if actor_index == 0
      # And only if another actor was in the party
      unless leadval1.nil?
        # Replace game player position with next actor data
        $game_player.x            = leadval1
        $game_player.y            = leadval2
        $game_player.direction    = leadval3
        $game_player.transparent  = leadval4
        $game_player.map_id       = leadval5
        $game_player.moveto(leadval1, leadval2)
        # If position is different than current map
        if $game_player.map_id != $game_map.map_id
          # Set up a new map
          $game_map.setup($game_player.map_id)
          # Update map (run parallel process event)
          $game_map.update
          # Run automatic change for BGM and BGS set on the map
          $game_map.autoplay          
          # Move player to position
          $game_player.moveto(leadval1,leadval2)
          # Ensure player NOT transparent/hidden
          $game_player.transparent  = false
          # Switch to (or re-start) map screen
          $scene = Scene_Map.new
          # Loop all allies
          for ally in $game_system.allies.values
            index = $game_system.allies.index(ally)
            ally.force_wait = ($game_map.map_id != ally.map_id)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    # Perform the original call if new version not used
    return squad_game_party_all_dead? if $game_system.squad_all_dead == false
    # Exit false if number of party members is 0
    return false if $game_party.actors.size == 0
    # Exit false if lead actor is alive
    return false if @actors[0].hp > 0
    # Loop all allies
    for ally in $game_system.allies.values
      # If testing an active party member on the current map
      if ally.force_wait == false && (ally.map_id == $game_map.map_id)
        # Exit false if the squad member is alive
        return false if @actors[ally.actor_index].hp > 0
      end
    end
    # All squad members dead
    return true
  end
  #--------------------------------------------------------------------------
  # * Make Leader wait and switch to next member
  #--------------------------------------------------------------------------
  def leader_wait
    # Exit if no replacement members
    return unless members_available?
    # Set player's own wait flag
    $game_player.force_wait = true
    # Shift to next actor
    cycle_forward    
  end
  #--------------------------------------------------------------------------
  # * Determine ic cycle loop stops on current game player
  #--------------------------------------------------------------------------
  def members_available?
    # Loop all allies
    for ally in $game_system.allies.values
      # If testing an active party member on the map
      if ally.force_wait == false && ($game_map.map_id == ally.map_id)
        # Exit true if current ally is alive
        return true if @actors[ally.actor_index].hp > 0
      end
    end
    # Exit false
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Ally Member Exists on map and in party
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def ally_exist_member?(actor_index=nil)
    # Exit if nil
    return if actor_index.nil?
    # Exit false if actor is not in party
    return false if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Exit false if not on current map
    return false unless ally.map_id == $game_map.map_id
    # Exit true as must be in the map and party
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Ally Actor Exists on map and in party?
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def ally_exist_actor?(actor_id)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform Member Leave method
    return ally_exist_member?(actor_index)    
  end
  #--------------------------------------------------------------------------
  # * Leave Actor on Map by Party Placement
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def leave_member(actor_index=nil)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Exit if not on current map
    return unless ally.map_id == $game_map.map_id
    # Turn off 'wait' flag
    ally.force_wait = true     
  end
  #--------------------------------------------------------------------------
  # * Leave Actor on Map by Actor ID in database
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def leave_actor(actor_id=nil)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform Member Leave method
    leave_member(actor_index) 
  end
  #--------------------------------------------------------------------------
  # * Gather Actors on Map
  #--------------------------------------------------------------------------
  def gather_party
    # Loop all party members
    for i in 1...$game_party.actors.size
      # Run Gather Member
      gather_member(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Gather Actor on Map by Party Placement
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def gather_member(actor_index=nil)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Exit if not on current map
    return unless ally.map_id == $game_map.map_id
    # Turn off 'wait' flag
    ally.force_wait = false 
    # Exit unless pathfinding option available
    return unless $game_system.squad_pathfinding1 == true
    # Perform pathfinding function
    ally.find_path($game_player.x, $game_player.y)
  end
  #--------------------------------------------------------------------------
  # * Gather Actor on Map by Actor ID in database
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def gather_actor(actor_id=nil)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform Member Leave method
    gather_member(actor_index)    
  end
  #--------------------------------------------------------------------------
  # * Turn off all 'move route' flags for all members
  #--------------------------------------------------------------------------
  def end_move_route_party
    # Loop all party members
    for i in 1...$game_party.actors.size
      # Run 'end moves' on member
      end_move_route_member(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Turn off 'move route' flag by Party Placement
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def end_move_route_member(actor_index=nil)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Exit if not on current map
    return unless ally.map_id == $game_map.map_id
    # Turn off 'move route' flag
    ally.wait_move_route = false 
  end
  #--------------------------------------------------------------------------
  # * Turn off 'move route' flag by Actor ID in database
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def end_move_route_actor(actor_id=nil)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform 'end moves' on member method
    end_move_route_member(actor_index)    
  end
  #--------------------------------------------------------------------------
  # * Apply Opacity onto Party Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def set_opacity(actor_index, opacity)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Ensure no invalid opacity
    opacity = 0 if opacity < 0
    opacity = 255 if opacity > 255    
    # Apply opacity to ally
    ally.set_opacity(opacity)
    # Refresh ally
    ally.refresh
  end
  #--------------------------------------------------------------------------
  # * Apply Opacity onto Party Member
  #     actor_index : actor index
  #     blend       : blend setting (0=normal, 1=addition, 2=subtraction)
  #--------------------------------------------------------------------------
  def set_blend(actor_index, blend)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Ensure no invalid opacity
    blend = 0 if blend < 0
    blend = 2 if blend > 2    
    # Apply opacity to ally
    ally.set_blend(blend)
    # Refresh ally
    ally.refresh
  end
  #--------------------------------------------------------------------------
  # * Set Position of Party Member
  #     id          : ally id (actor_index)
  #     x           : map x-coordinate (logical)
  #     y           : map y-coordinate (logical)
  #     direction   : direction
  #--------------------------------------------------------------------------
  def set_positiong(actor_index, x, y, direction=nil)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]
    # Apply data to ally
    ally.moveto(x, y)
    ally.direction = direction unless direction.nil?
  end
  #--------------------------------------------------------------------------
  # * Set Position of Actor in Party
  #     id          : actor id
  #     x           : map x-coordinate (logical)
  #     y           : map y-coordinate (logical)
  #     direction   : direction
  #--------------------------------------------------------------------------
  def set_positiong_actor(actor_id, x, y, direction=nil)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform 'end moves' on member method
    set_positiong(actor_index, x, y, direction)
  end
  #--------------------------------------------------------------------------
  # * Convert Actor ID to Party Member Index (or nil)
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def convert_actor_to_party_member(actor_id=nil)
    # Exit if nil
    return nil if actor_id.nil?
    # Obtain actor
    actor = $game_actors[actor_id]
    # Exit if no valid actor
    return nil if actor.nil?
    # Obtain index position of actor in party (or nil)
    actor_index  = $game_party.actors.index(actor)
    # Return member position
    return actor_index
  end
  #--------------------------------------------------------------------------
  # * Cycle party forward
  #--------------------------------------------------------------------------
  def cycle_forward
    # Exit if party size is less than 2
    return if $game_party.actors.size <= 1
    # Exit if cycling turned off
    return if $game_system.cycle_prevent == true
    # Begin loop
    loop do
      # Cycle party in direction
      cycle_party
      # Break loop for first viable player
      break if cycle_available?
    end
    # Setup map if needed
    shift_to_map
  end
  #--------------------------------------------------------------------------
  # * Cycle party backwards
  #--------------------------------------------------------------------------
  def cycle_backward
    # Exit if party size is less than 2
    return if $game_party.actors.size <= 1
    # Exit if cycling turned off
    return if $game_system.cycle_prevent == true
    # Begin loop
    loop do
      # Cycle party in direction
      cycle_party(true)
      # Break loop for first viable player
      break if cycle_available?
    end
    # Setup map if needed
    shift_to_map
  end
  #--------------------------------------------------------------------------
  # * Determine ic cycle loop stops on current game player
  #--------------------------------------------------------------------------
  def cycle_available?
    # Always cycle if unavailable-cycle turned off
    return true  unless $game_system.waiting_cycle_prevent
    # Exit false if target not on map, is waiting, or dead
    return false unless $game_player.map_id == $game_map.map_id
    return false unless $game_player.force_wait == false
    return false unless @actors[0].hp > 0
    # Exit true
    return true
  end
  #--------------------------------------------------------------------------
  # * Cycle party specified direction
  #     backward : flag is cycling in reverse
  #--------------------------------------------------------------------------
  def cycle_party(backward=false)
    # Force current map members to player position if allies turned off
    cycle_apply_lead_position if cycle_force_lead_position == true
    # Delete last member from party and insert as lead if backward cycling
    temp = @actors.pop  if backward
    @actors.unshift(temp) if backward
    # If Leader Cycling turned off
    if $game_system.leader_cycle_prevent == true
      # Obtain next actor and delete from party
      temp = @actors[1]
      @actors.delete_at(1)
      # And put him at head of party if backwards cycling
      @actors.unshift(temp) if backward
    else
      # Delete lead from party if forward cycling
      temp = @actors.shift unless backward
    end
    # Push deleted actor to back of party
    @actors.push(temp) unless backward
    # Refresh player
    $game_player.refresh
    # Loop all allies
    for ally in $game_system.allies.values
      # Refresh ally
      ally.refresh
    end
    # If Leader Cycling turned off
    if $game_system.leader_cycle_prevent == true
      # Get ID for data extraction
      id = (backward == false) ? 1 : $game_party.actors.size-1
      # Obtain lead ally's data
      x                         = $game_system.allies[id].x
      y                         = $game_system.allies[id].y
      direction                 = $game_system.allies[id].direction
      force_wait                = $game_system.allies[id].force_wait
      map_id                    = $game_system.allies[id].map_id
      transparent               = $game_system.allies[id].transparent
    else
      # Obtain leader's data, and replace with last ally's
      x                         = $game_player.x
      y                         = $game_player.y
      direction                 = $game_player.direction
      force_wait                = $game_player.force_wait
      map_id                    = $game_player.map_id
      transparent               = $game_player.transparent
      # Get ID for data application
      id = (backward == false) ? 1 : $game_party.actors.size-1
      # Set Player Data from ally
      cycle_player_setting(id)
    end
    # Shift through allies
    cycle_allies(backward)
    # Get ID for data application
    id = (backward == false) ? $game_party.actors.size-1 : 1 
    # Apply data to lead ally
    cycle_ally_setting(id, x, y, direction, force_wait, map_id, @player_trans)
  end
  #--------------------------------------------------------------------------
  # * Cycle Player Data from Ally
  #     id : ally id (actor_index)
  #--------------------------------------------------------------------------
  def cycle_player_setting(id)
    # Apply data to player
    $game_player.moveto($game_system.allies[id].x, $game_system.allies[id].y)
    $game_player.center($game_system.allies[id].x, $game_system.allies[id].y)
    $game_player.direction    = $game_system.allies[id].direction
    $game_player.force_wait   = $game_system.allies[id].force_wait
    $game_player.map_id       = $game_system.allies[id].map_id
    $game_player.transparent  = $game_system.allies[id].transparent
    @player_trans             = $game_system.allies[id].transparent
  end
  #--------------------------------------------------------------------------
  # * Cycle Ally Settings
  #     id          : ally id (actor_index)
  #     x           : map x-coordinate (logical)
  #     y           : map y-coordinate (logical)
  #     direction   : direction
  #     force_wait  : forced wait flag
  #     map_id      : map ID
  #     transparent : transparent flag
  #--------------------------------------------------------------------------
  def cycle_ally_setting(id,x,y,direction,force_wait, map_id, transparent)  
    # Apply data to last ally
    $game_system.allies[id].moveto(x,y)
    $game_system.allies[id].direction    = direction
    $game_system.allies[id].force_wait   = force_wait
    $game_system.allies[id].map_id       = map_id
    $game_system.allies[id].transparent  = transparent
  end
  #--------------------------------------------------------------------------
  # * Determine if forced cycling into same lead position
  #     reverse : reverse direction flag
  #--------------------------------------------------------------------------
  def cycle_force_lead_position
    return false if $game_system.leader_cycle_prevent == true
    return false if $game_switches[$game_system.squad_switch_id] == false
    return true
  end
  #--------------------------------------------------------------------------
  # * Force all current-map members to player coordinates
  #--------------------------------------------------------------------------
  def cycle_apply_lead_position
    # Obtain Game Player Coordinates
    fx                         = $game_player.x
    fy                         = $game_player.y
    fdirection                 = $game_player.direction  
    # Loop all allies
    for ally in $game_system.allies.values
      # Skip if not on current map
      next if ally.map_id != $game_map.map_id
      # Apply game player facing and coordinates
      ally.x = fx
      ally.y = fy
      ally.direction = fdirection
      ally.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Cycle party data based on direction
  #     reverse : reverse direction flag
  #--------------------------------------------------------------------------
  def cycle_allies(reverse=false)
    # Loop all allies
    for i in 1...$game_party.actors.size-1
      # Determine target and source IDs based on direction
      id  = (reverse == false) ? i      : $game_party.actors.size - i
      j   = (reverse == false) ? i + 1  : id - 1
      jx  = $game_system.allies[j].x
      jy  = $game_system.allies[j].y
      $game_system.allies[id].moveto(jx, jy)
      $game_system.allies[id].direction   = $game_system.allies[j].direction
      $game_system.allies[id].force_wait  = $game_system.allies[j].force_wait
      $game_system.allies[id].map_id      = $game_system.allies[j].map_id
      $game_system.allies[id].transparent = $game_system.allies[j].transparent
    end
  end
  #--------------------------------------------------------------------------
  # * Cycle into next map
  #--------------------------------------------------------------------------
  def shift_to_map
    # Loop all allies
    for ally in $game_system.allies.values
      # Ensure allies on alternate map are transparent
      ally.transparent = true if ally.map_id != $game_player.map_id
    end
    # Remove any wait or transparent flags from player
    $game_player.force_wait   = false
    $game_player.transparent  = false
    @player_trans             = false
    # Exit if target map is the same as the current map
    return if $game_player.map_id == $game_map.map_id
    # Set up a new map
    $game_map.setup($game_player.map_id)
    # Now set the map to the new player
    $game_map.map_id = $game_player.map_id
    # Update map (run parallel process event)
    $game_map.update
    # Run automatic change for BGM and BGS set on the map
    $game_map.autoplay
    # Switch to (or re-start) map screen
    $scene = Scene_Map.new
  end
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
  alias squad_game_map_passable? passable?
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :map_id                   # map ID  
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil)
    # Perform the original call and obtain the passable result
    effective     = squad_game_map_passable?(x, y, d, self_event)
    # Exit false if the passable result is false
    return false  if effective == false
    # Obtain ally's passable result
    effective     = ally_passable?(x, y, d, self_event)
    # Exit with the ally's passable result
    return effective
  end
  #--------------------------------------------------------------------------
  # * Determine if Passable for Ally
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def ally_passable?(x, y, d, self_event = nil)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f
    # Loop all allies
    for ally in $game_system.allies.values
      # If ally is on current map
      next unless (ally.map_id == $game_map.map_id)
      # If ally other than self is consistent with coordinates
      next unless (ally.tile_id >= 0 and ally != self_event and ally.x == x and
        ally.y == y and not ally.through)
      # Impassable: If obstacle bit is set
      return false  if @passages[ally.tile_id] & bit != 0
      # Impassable: If obstacle bit is set in all directions
      return false  if @passages[ally.tile_id] & 0x0f == 0x0f
      # Passable:   If priorities other than that are 0
      return true   if @priorities[ally.tile_id] == 0
    end
    # Exit passable
    return true
  end
end



#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_game_character_initialize initialize
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :character_name           # character file name
  attr_accessor :character_hue            # character hue
  attr_accessor :direction                # direction
  attr_accessor :x                        # map x-coordinate (logical)
  attr_accessor :y                        # map y-coordinate (logical)
  attr_accessor :force_wait               # character wait command
  attr_accessor :map_wait                 # character wait command
  attr_accessor :map_id                   # map ID
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Perform the original call
    squad_game_character_initialize
    # Additional values
    @force_wait                     = false  # Character's forced wait flag
    @map_id                         = 0      # Character's Map ID
    $game_system.squad_pathfinding1 = true if defined?(find_path)
  end
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def passable?(x, y, d) 
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    return false unless $game_map.valid?(new_x, new_y)
    return true if @through
    return false unless $game_map.passable?(x, y, d, self)
    return false unless $game_map.passable?(new_x, new_y, 10 - d)
    return false if impassable_events?(new_x, new_y)    
    return false if impassable_allies?(new_x, new_y)
    return false if impassable_player?(new_x, new_y)
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Events Impassable?
  #     x : x-coordinate
  #     y : y-coordinate  
  #--------------------------------------------------------------------------
  def impassable_events?(x, y)
    for event in $game_map.events.values
      next unless event.x == x and event.y == y
      next if event.through
      if self != $game_player and !self.is_a?(Game_Ally)
        return true
      end
      return true if event.character_name != ""
    end
    return false
	end
  #--------------------------------------------------------------------------
  # * Determine if Ally Impassable?
  #     x : x-coordinate
  #     y : y-coordinate  
  #--------------------------------------------------------------------------
  def impassable_allies?(x, y)
    for ally in $game_system.allies.values
      # Skip unless ally is on current map
      next unless ally.map_id == $game_map.map_id
      # Skip unless ally's coordinates are consistent with move destination
      next unless ally.x == x and ally.y == y
      # skip if through is ON
      next if ally.through
      # Skip if testing the game player
      next if self == $game_player
      # Impassable:  Player is self and ally forced to move
      ally.move_away_from_player    unless self.is_a?(Game_Ally)
      ally.move_random              if self.is_a?(Game_Ally)
      return true
    end
    # Exit passable
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Player Impassable?
  #     x : x-coordinate
  #     y : y-coordinate  
  #--------------------------------------------------------------------------
  def impassable_player?(x, y)
    return false  unless $game_player.x == x and $game_player.y == y
    return true   unless $game_player.through
    return true   if @character_name != ""
    return false
  end  
  #--------------------------------------------------------------------------
  # * Face Ally Party Member
  #     actor_index : actor Index
  #--------------------------------------------------------------------------
  def face_ally_member(actor_index)
    # Exit if nil
    return if actor_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[actor_index].nil?    
    # Obtain the ally
    ally = $game_system.allies[actor_index]    
    # Get difference in ally coordinates
    sx = @x - ally.x
    sy = @y - ally.y
    # Exit If coordinates are equal
    return if sx == 0 and sy == 0
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Set Position of Actor in Party
  #     id          : actor id
  #     x           : map x-coordinate (logical)
  #     y           : map y-coordinate (logical)
  #     direction   : direction
  #--------------------------------------------------------------------------
  def face_ally_actor(actor_id)
    # Run Conversion from Actor ID to party index
    actor_index = convert_actor_to_party_member(actor_id)
    # Perform 'end moves' on member method
    face_ally_member(actor_index)
  end
  #--------------------------------------------------------------------------
  # * Convert Actor ID to Party Member Index (or nil)
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def convert_actor_to_party_member(actor_id=nil)
    # Exit if nil
    return nil if actor_id.nil?
    # Obtain actor
    actor = $game_actors[actor_id]
    # Exit if no valid actor
    return nil if actor.nil?
    # Obtain index position of actor in party (or nil)
    actor_index  = $game_party.actors.index(actor)
    # Return member position
    return actor_index
  end
end


#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_game_player_update update
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :move_speed               # speed
  attr_accessor :move_frequency           # action frequency
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Perform the original call
    squad_game_player_update
    # Exit if the interpreter is running
    return if $game_system.map_interpreter.running?
    # Defined keystroke actions
    $game_party.cycle_forward  if squad_key?($game_system.key_cycle_forward)
    $game_party.cycle_backward if squad_key?($game_system.key_cycle_backward)
    $game_party.leader_wait    if squad_key?($game_system.key_leader_wait)
    $game_party.gather_party   if squad_key?($game_system.key_party_gather)
  end
  #--------------------------------------------------------------------------
  # * Test Squad Key
  #     key : key trigger
  #--------------------------------------------------------------------------
  def squad_key?(key)
    return false if key.nil?
    return true if Input.trigger?(key)
    return false
  end
end



#==============================================================================
# ** Game_Ally
#------------------------------------------------------------------------------
#  This class handles active party members.  Its functions keep the members
#  following the player unless acted upon. Refer to "$game_system.allies" for
#  each instance of this class.
#==============================================================================

class Game_Ally < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actor_index                 # Actor index
  attr_accessor :actor_opacity               # Ally Opacity setting
  attr_accessor :actor_blend                 # Ally Blend setting
  attr_accessor :force_wait                  # Force wait by command 
  attr_accessor :wait_move_route             # Force wait for move rounte
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def initialize(actor_index)
    # Inherit method from parent class
    super()
    # Set actor and actor map at start
    @actor_index  = actor_index
    @map_id       = $game_player.map_id
    # Refresh
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Exit method with clean/empty graphics if invalid party or member
    return if refresh_empty
    # Set Actor graphics for ally
    actor           = $game_party.actors[@actor_index]
    @character_name = actor.character_name
    @character_hue  = actor.character_hue
    @opacity        = (@actor_opacity.nil?) ? 255 : @actor_opacity
    @blend_type     = (@actor_blend.nil?) ? 0 : @actor_blend
  end
  #--------------------------------------------------------------------------
  # * Obtain refresh flag if party is empty
  #--------------------------------------------------------------------------
  def refresh_empty
    # Set empty effective flag if party is empty or invalid actor
    effective = true if $game_party.actors.size == 0 
    effective = true if $game_party.actors[@actor_index].nil?
    # Reset values to default if empty flag is true
    if effective == true
      @character_name = ""
      @character_hue  = 0
    end
    # Exit effective
    return effective
  end
  #--------------------------------------------------------------------------
  # * Set Ally Opacity
  #     value : opacity setting (0-255)
  #--------------------------------------------------------------------------
  def set_opacity(value=nil)
    @actor_opacity = value
  end
  #--------------------------------------------------------------------------
  # * Set Ally Blend
  #     value : blend setting (0=normal, 1=addition, 2=subtraction)
  #--------------------------------------------------------------------------
  def set_blend(value=nil)
    @actor_blend = value
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Unless not on the current map
    unless @map_id != $game_map.map_id
      # Set transparency based on squad on/off switch
      @transparent = $game_switches[$game_system.squad_switch_id] 
    end
  
    # Exit with original parent system if ally set with move route flag
    return super if @wait_move_route == true 
    # Exit if ally waiting
    return if @force_wait == true
    # Exit if not in the same map
    return if @map_id != $game_map.map_id
    # Regroup proper and active allies if 'stuck'
    clear_path
    update_autoregroup
    # Handle ally speed and move frequency
    update_speed_and_frequency
    update_moving if !moving?
    # Inherit method remainder from parent class
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when keeping active allies near the leader when stuck)
  #--------------------------------------------------------------------------
  def update_autoregroup
    # Acquire delay and calculate seconds (min 1 second)
    delay = $game_system.regroup_timer
    return              if delay.nil?
    delay = 1           if delay < 1
    delay *= Graphics.frame_rate
    # Perform only at interval
    return              if Graphics.frame_count % delay != 0   
    # Determine if in range, or exit
    range   = $game_system.regroup_range
    return              if range.nil?
    range   = 4         if range < 0
    return              if in_range?(range)
    # Determine if regrouping or exiting 
    return              if $game_system.regroup_pathflash.nil?
    update_pathfinding  if $game_system.regroup_pathflash == true
    update_relocate     if $game_system.regroup_pathflash == false
  end
  #--------------------------------------------------------------------------
  # * Frame Update (keeping active allies near the leader by Pathfinding)
  #--------------------------------------------------------------------------
  def update_pathfinding
    # Exit if pathfinding option exists and running
    return unless $game_system.squad_pathfinding1 == true
    # Clear and reset path
    clear_path
    find_path($game_player.x, $game_player.y)
  end
  #--------------------------------------------------------------------------
  # * Frame Update (keeping active allies near the leader by Pathfinding)
  #--------------------------------------------------------------------------
  def update_relocate
    $game_party.set_positiong(@actor_index, $game_player.x, $game_player.y)
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when handling ally speed and frequency)
  #--------------------------------------------------------------------------
  def update_speed_and_frequency
    return    if $game_system.squad_speed_freq.nil?
    rate = $game_system.squad_speed_freq + 1
    rate = 1  if rate < 1
    rate = 10 if rate > 10
    rate *= 4
    return if Graphics.frame_count % rate != 0
    update_speed
    update_frequency
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when handling ally speed)
  #--------------------------------------------------------------------------
  def update_speed
    return if $game_player.move_speed == @move_speed
    @move_speed = $game_player.move_speed
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when handling ally frequency)
  #--------------------------------------------------------------------------
  def update_frequency
    return if $game_player.move_frequency == @move_frequency
    @move_frequency = $game_player.move_frequency
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Perform movement if not actually moving
  #--------------------------------------------------------------------------
  def update_moving
    # Exit if pathfinding option exists and running
    if $game_system.squad_pathfinding1 == true
      return if @runpath == true
    end
    # Exit if actually moving
    return unless !moving?
    # Unless squad on/off switch engaged
    unless $game_switches[$game_system.squad_switch_id] == true
      # Force ally aside if player is in in same coords
      move_random if in_range?(0)
    end
    # Perform ally movement style
    update_movement
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Determining ally move style
  #--------------------------------------------------------------------------
  def update_movement
    # Branch actor movement based on defined move style
    case $game_system.move_style
    when 1  ; update_movement_party_order
    when 2  ; update_movement_class_position
    when 3  ; update_movement_actor_distance
    else    ; update_movement_basic
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Ally distance set within two tiles
  #--------------------------------------------------------------------------
  def update_movement_basic
    # Move actor based on two-tile distance
    move_toward_player if !in_range?(2)
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Ally distance based on party order
  #--------------------------------------------------------------------------
  def update_movement_party_order
    # Move player based on party index order (Actor index)
    move_toward_player if !in_range?(@actor_index+1)
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Ally distance based on combat position (near/middle/far)
  #--------------------------------------------------------------------------
  def update_movement_class_position
    # Branch based on actor's class position
    case $data_classes[$game_party.actors[@actor_index].class_id].position
    when 0 ; move_toward_player if !in_range?(1)  # Front Position
    when 1 ; move_toward_player if !in_range?(2)  # Middle Position
    when 2 ; move_toward_player if !in_range?(3)  # Rear Position
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update : Ally distance customized per actor (else 2 tile default)
  #--------------------------------------------------------------------------
  def update_movement_actor_distance
    # Assume distance of 2 tiles
    dist  = 2
    # Obtain actor_id
    actor_id   =  $game_party.actors[@actor_index].id
    # Obtain new distance of actor has custom distance in config
    if $game_system.move_actor.has_key?(actor_id)
      dist = $game_system.move_actor[actor_id]
    end
    # Move according to distance (or custom distance)
    move_toward_player if !in_range?(dist)
  end
  #--------------------------------------------------------------------------
  # * In range of player?
  #     range : range in tiles
  #--------------------------------------------------------------------------
  def in_range?(range)
    # Obtain player's coordinates
    playerx = $game_player.x
    playery = $game_player.y
    # Obtain mathematical square values of player/ally x and y coordinates
    x = (playerx - @x) * (playerx - @x)
    y = (playery - @y) * (playery - @y)
    # Calculate range from player/ally coordinates
    r = x + y
    # Return true/false after comparison
    return (r <= (range * range)) ? true : false
  end
  #--------------------------------------------------------------------------
  # * Facing the player?
  #--------------------------------------------------------------------------
  def facing_player?
    # Obtain player's coordinates
    playerx = $game_player.x
    playery = $game_player.y
    # Branch by direction and exit true if facing
    case event_direction
    when 2 ; return true if playery >= @y
    when 4 ; return true if playerx <= @x
    when 6 ; return true if playerx >= @x
    when 8 ; return true if playery <= @y
    end
    # Exit false
    return false
  end
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
     #Exit false #(this command only really works player vs event)
    return false 
  end
end



#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc.
#  It's used within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_spriteset_map_initialize initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Perform the original call
    squad_spriteset_map_initialize
    # Loop all allies
    for ally in $game_system.allies.values
      # Set ally transparency based on current map ID
      ally.transparent = (ally.map_id != $game_map.map_id) ? true : false
      # Force Ally transparent if switch forces invisible
      if $game_switches[$game_system.squad_switch_id] == true
        ally.transparent = true
      end
      # Define sprite for ally
      add_ally(ally)
    end
  end
  #--------------------------------------------------------------------------
  # * Add Ally Sprite
  #     ally : actor/ally
  #--------------------------------------------------------------------------
  def add_ally(ally)
    # Define sprite for ally
    sprite = Sprite_Character.new(@viewport1, ally)
    # Push into the sprites array
    @character_sprites.push(sprite)
  end
  #--------------------------------------------------------------------------
  # * Remove Ally Sprite
  #--------------------------------------------------------------------------
  def remove_ally
    # Obtain index from the sprites array
    index = @character_sprites.length-1
    # Dispose the sprite
    @character_sprites[index].dispose
    # Remove from the sprites array
    @character_sprites.pop
  end
end



#==============================================================================
# ** Interpreter
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_interpreter_command_209 command_209
  #--------------------------------------------------------------------------
  # * Set Move Route
  #--------------------------------------------------------------------------
  def command_209
    # If player substituted by actor ID value
    if $game_temp.squad_actor_move_route != 0
      # Perform the movement for the party member
      command_209_squad_actor($game_temp.squad_actor_move_route)
      # Return true
      return true
    end 
    # If player substituted by a party index value
    if $game_temp.squad_party_move_route != 0
      # Perform the movement for the party member
      command_209_squad_party($game_temp.squad_party_move_route)
      # Return true
      return true
    end
    # Obtain the effective return for the original call
    effective = squad_interpreter_command_209
    # Return effective
    return effective
  end
  #--------------------------------------------------------------------------
  # * Set Move Route for ally by actor_id
  #--------------------------------------------------------------------------
  def command_209_squad_actor(actor_id=nil)
    # Exit if no valid member index
    return if actor_id.nil?
    # Obtain party index from actor ID
    member_index = convert_actor_to_party_member(actor_id)
    # Exit if actor is not in party
    return if member_index.nil?
    # Exit if not on current map
    return if $game_system.allies[member_index].map_id != $game_map.map_id
    # Turn on 'move route wait' flag
    $game_system.allies[member_index].wait_move_route = true
    # Apply the move route commands to the ally actor character
    $game_system.allies[member_index].force_move_route(@parameters[1])
    # Erase the value for the party index substitute
    $game_temp.squad_actor_move_route = 0
  end
  #--------------------------------------------------------------------------
  # * Set Move Route for ally by party index
  #--------------------------------------------------------------------------
  def command_209_squad_party(member_index=nil)
    # Exit if nil
    return if member_index.nil?
    # Exit if actor is not in party
    return if $game_system.allies[member_index].nil?
    # Exit if not on current map
    return if $game_system.allies[member_index].map_id != $game_map.map_id
    # Turn on 'move route wait' flag
    $game_system.allies[member_index].wait_move_route = true
    # Apply the move route commands to the ally member character
    $game_system.allies[member_index].force_move_route(@parameters[1])
    # Erase the value for the party index substitute
    $game_temp.squad_party_move_route = 0
  end
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  def command_355
    # Set first line to script
    script = @list[@index].parameters[0] + "\n"
    # Loop
    loop do
      # If next event command is second line of script or after
      break unless @list[@index+1].code == 655
      # Add second line or after to script
      script += @list[@index+1].parameters[0] + "\n"
      # Advance index
      @index += 1
    end
    # Evaluation
    result = eval(script)
    # If return value is false (must test with false class)
    return false if result == FalseClass
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Convert Actor ID to Party Member Index (or nil)
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def convert_actor_to_party_member(actor_id=nil)
    # Exit if nil
    return nil if actor_id.nil?
    # Obtain actor
    actor = $game_actors[actor_id]
    # Exit if no valid actor
    return nil if actor.nil?
    # Obtain index position of actor in party (or nil)
    actor_index  = $game_party.actors.index(actor)
    # Return member position
    return actor_index
  end  
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Apply new opacity settings to an individual Party Member
  #     actor_index : actor index
  #     opacity     : opacity (0-255)
  #--------------------------------------------------------------------------
  def ALLY_Opacity(actor_index, opacity)
    $game_party.set_opacity(actor_index, opacity)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Apply new blend settings to an individual Party Member
  #     actor_index : actor index
  #     blend       : blend setting (0=normal, 1=addition, 2=subtraction)
  #--------------------------------------------------------------------------
  def ALLY_Blend(actor_index, blend)
    $game_party.set_blend(actor_index, blend)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Set new position for an individual Party Member
  #     actor_index : actor index
  #     x           : x-position
  #     y           : y-position
  #     d           : facing direction (2,4,6,8) - assuming no 8Dir in play -
  #--------------------------------------------------------------------------
  def ALLY_Position(actor_index, x, y, d=nil)
    $game_party.set_positiong(actor_index, x, y, d)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Set new position for an individual Party Member
  #     actor_index : actor index
  #     x           : x-position
  #     y           : y-position
  #     d           : facing direction (2,4,6,8) - assuming no 8Dir in play -
  #--------------------------------------------------------------------------
  def ALLY_Position_Actor(actor_index, x, y, d=nil)
    $game_party.set_positiong_actor(actor_index, x, y, d)
  end  
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Determine if Ally Member exists on map and in party
  #     actor_index : actor index
  #--------------------------------------------------------------------------  
  def ALLY_Exist_Member?(actor_index=nil)
    return $game_party.ally_exist_member?(actor_index)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Determine if Ally Actor exists on map and in party
  #     actor_id : actor ID
  #--------------------------------------------------------------------------  
  def ALLY_Exist_Actor?(actor_id=nil)
    return $game_party.ally_exist_actor?(actor_id)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'wait command' on Party Members
  #--------------------------------------------------------------------------
  def GATHER_Party()
    $game_party.gather_party
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'wait command' on individual Party Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def GATHER_Member(actor_index=nil)
    $game_party.gather_member(actor_index)  
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'wait command' on Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def GATHER_Actor(actor_id=nil)
    $game_party.gather_actor(actor_id)    
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Apply 'wait command' on individual Party Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def LEAVE_Member(actor_index=nil)
    $game_party.leave_member(actor_index)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Apply 'wait command' on Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def LEAVE_Actor(actor_id=nil)
    $game_party.leave_actor(actor_id)
  end  
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Apply 'wait command' to the Player and cycle to next Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def LEAVE_Leader()
    $game_party.leader_wait
  end  
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Attaches the next 'Move Route' command to a Party Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def MOVEROUTE_Member(actor_index=nil)
    return if actor_index.nil?
    $game_temp.squad_party_move_route = actor_index
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Attaches the next 'Move Route' command to an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def MOVEROUTE_Actor(actor_id=nil)
    return if actor_id.nil?
    $game_temp.squad_actor_move_route = actor_id
  end  
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'Move Route' command on Party Members
  #--------------------------------------------------------------------------
  def END_MOVEROUTE_Party()
    $game_party.end_move_route_party
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'Move Route' command on individual Party Member
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def END_MOVEROUTE_Member(actor_index=nil)
    $game_party.end_move_route_member(actor_index)
  end
  #--------------------------------------------------------------------------
  # * SHORTCUT:  Ends 'Move Route' command on Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def END_MOVEROUTE_Actor(actor_id=nil)
    $game_party.end_move_route_actor(actor_id)
  end
end



#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_scene_map_main main
  alias squad_scene_map_update update
  alias squad_scene_map_transfer_player transfer_player
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset                # map spriteset
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Start Allies 
    main_allies_start
    # Perform the original call
    squad_scene_map_main
  end
  #--------------------------------------------------------------------------
  # * Main Processing : Installing Allies
  #--------------------------------------------------------------------------
  def main_allies_start
    # Exit method if allies already available
    return unless $game_system.allies.nil?
    # Set player to current map
    $game_player.map_id = $data_system.start_map_id
    # Create the allies array based on starting party
    $game_system.allies = {}
    for i in 1...$data_system.party_members.size
      $game_system.allies[i] = Game_Ally.new(i)
    end
    # Move allies to initial position, current map and refresh
    for ally in $game_system.allies.values
      ally.moveto($data_system.start_x, $data_system.start_y)
      ally.refresh
      ally.map_id = $data_system.start_map_id
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Loop all allies
    for key in $game_system.allies.keys
      # Update the ally
      $game_system.allies[key].update
    end
    # Perform the original call
    squad_scene_map_update
  end
  #--------------------------------------------------------------------------
  # * Player Place Move
  #--------------------------------------------------------------------------
  def transfer_player
    # Loop all allies
    for ally in $game_system.allies.values
      # Skip if ally waiting
      next if ally.force_wait == true
      # Set up ally position
      ally.moveto($game_temp.player_new_x, $game_temp.player_new_y)
      # Set ally on a new map
      ally.map_id = $game_temp.player_new_map_id
    end
    # Set player on a new map (needed for member cycling)
    $game_player.map_id = $game_temp.player_new_map_id
    # Perform the original call
    squad_scene_map_transfer_player
    # Loop all allies (enforce map position)
    for ally in $game_system.allies.values
      # Skip if ally waiting
      next if ally.force_wait == true
      # Set up ally position
      ally.moveto($game_temp.player_new_x, $game_temp.player_new_y)
    end
  end
end



#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias squad_scene_battle_main main
  alias squad_scene_battle_battle_end battle_end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Remove the force_wait actors from the party
    remove_wait_actors
    # Perform the original call
    squad_scene_battle_main
    # Return the force_wait actors to the party
    restore_wait_actors
  end
  #--------------------------------------------------------------------------
  # * Battle Ends
  #     result : results (0:win 1:lose 2:escape)
  #--------------------------------------------------------------------------
  def battle_end(result)
    # Perform the original call
    squad_scene_battle_battle_end(result)
    # Return the force_wait actors to the party
    restore_wait_actors
  end
  #--------------------------------------------------------------------------
  # * Remove actors flagged with the force_wait
  #--------------------------------------------------------------------------
  def remove_wait_actors
    if $BTEST==false
    # Temporary holder array for force_wait members
    @wait_holder = []
    # Remove battle states
    for i in 1...$game_party.actors.size
      # Obtain actor data
      actor = $game_actors[$game_party.actors[i].id]    
      # Only perform if actor is waiting
      next unless $game_system.allies[i].force_wait == true
      # Push the actor into the temporary holder array
      @wait_holder.push([i,actor])
      # Temporarily erase the actor from the party
      $game_party.actors.delete_at(i)
    end
    end
  end
  #--------------------------------------------------------------------------
  # * Return actors flagged with the force_wait
  #--------------------------------------------------------------------------
  def restore_wait_actors
    # Exit if no actors in temporary holder array 
    return if @wait_holder == []
    # Create temporary party array
    new_actors = []
    # Loop all allies in temporary holder array
    for ally in @wait_holder
      # Skip if ally invalid
      next if ally.nil?
      # Obtain ally's actor_index number
      ally_number = ally[0]
      # Obtain ally's actor data
      ally_member = ally[1]
      # Loop all party members
      for index in 0...$game_party.actors.size
        # Get actor from party
        actor = $game_actors[$game_party.actors[index].id]
        # If loop inex doesn't match ally actor_index
        if index != ally_number
          # Just push the party actor into the temp party array
          new_actors.push(actor)
        # Otherwise
        else
          # First push the ally back into the temp party array
          new_actors.push(ally_member)
          # Then push the party actor into the temp party array
          new_actors.push(actor)
        end
      end
    end
    # Reintroduce new actors back to Game_Party
    $game_party.actors = new_actors
    # Erase the temporary holder array
    @wait_holder = []
  end
end