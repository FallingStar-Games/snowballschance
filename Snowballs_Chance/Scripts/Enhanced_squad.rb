#==============================================================================
# ** Enhanced Squad Movement
#------------------------------------------------------------------------------
#    by DerVVulfman
#    version 1.0
#    12-25-2017 (mm/dd/yyyy)
#    RGSS / RPGMaker XP
#------------------------------------------------------------------------------
#    Based on Squad Movement by Near Fantastica (Jaime Webster)
#    Initial script creation on May 23, 2005
#==============================================================================
#
#  INTRODUCTION:
#  =============
#    Caterpillar, or party-following systems, have been around in RPGMaker
#    games for years.   Yet most follow the same basic single-file design.
#    Not so with Near Fantastica's  Squad Movement system,  a system which
#    allows the player to deliver a couple of limited commands.
#
#    Now revised, this rendition of Near Fantastica's Squad Movement comes
#    with a detailed configuration system, and a host of script calls that
#    can give the game developer a strong sense of power over the player's
#    visible party.
#
#------------------------------------------------------------------------------
#
#  FEATURES:
#  =========
#    * Party following system that does not use single=file movement.
#    * Player keyboard control.
#    * Multiple squad move styles.
#    * Ability to leave party members behind, even on other maps.
#    * Party Members able to be controlled by MOVE ROUTE system.
#    * Can handle party members stuck in passages.
#    * Compatible with Near Fantastica Pathfinding V1.
#    * Expansive Configuration and Script Calls system.
#    * BONUS:  Revised and repaired 'command_355' script method.
#
#
#------------------------------------------------------------------------------
#
#  INSTALLATION:
#  =============
#    Install the three script pages (This document, Config and Engine) below
#    Scene_Debug and above Main like so:
#
#        Scene_Debug
#        * Enhanced Squad Movement
#        * Config
#        * Engine
#        Main
#
#    Adjust the settings within the Config page as you see fit. And read the
#    commands under 'Script Calls' for additional features.
#
#
#------------------------------------------------------------------------------
#
#  PATHFINDING
#  ===========
#    This system is compatible with Near Fantastica's Pathfinding ver. #1.
#    This version of Pathfinding does not wholly rely on moving map events
#    or the Game Player,  but can move other objects just as long as it is
#    a properly created object with the Game_Character class as a parent.
#
#    Commands from Pathfinding  #1  are already integrated  within Enhanced
#    Squad Movements, these being enhancements to the Gather Actors and the
#    auto-regrouping system.
#
#
#------------------------------------------------------------------------------
#
#  AUTO REGROUPING
#  ===============
#    This feature ensures  that squad members cannot be  accidentally left
#    behind.  Using either Near Fantastica's Pathfinding,  or by a simpler
#    automatic position system, party members that straggle too far behind
#    the player can eventually find him.
#
#    Using Near Fantastica's Pathfinding system, the squad members will be
#    directed to the exact spot where the player is standing when the auto
#    regroup system is executed.  A timed system, the squad member(s)  can
#    change their  path according  to the player's  most current location.
#    But it does require Near Fantastica's system to be installed.
#
#    Using the Sudden or Flash Regroup system, squad members will suddenly
#    appear  in the same x/y coordinates  of the player before they spread
#    out. It may be less impressive, but it is a more accurate system. And
#    it does not rely on any outside scripts to function.
#
#    The auto-regrouping system has three configurable values which can be
#    altered through the Game_System class. These three values control how
#    often the system take effect (in seconds),  how far each squad member
#    must be from the party leader  (in tiles)  to take effect,  and which
#    of the two above described methods are used to return the squad member
#    to the leader.
#
#    * While using Near Fantastica's Pathfinding may be preferred, it is
#      not as accurate or effective, and may have actors 'pausing' for a
#      time.
#
#
#------------------------------------------------------------------------------
#
#  RUNNING MOVE ROUTES:
#  ====================
#    One of the systems built into this system allows you to move squad
#    members by way of a script call that selects the squad member, and
#    the use of map event MOVE ROUTE commands.   An example  of such is
#    shown below:
#
#         @>Script: MOVEROUTE_Member(2)
#         @>Set Move Route:Player
#          :               :$>Move Left
#          :               :$>Move Left
#          :               :$>Move Left
#          :               :$>Move Down
#          :               :$>Move Down
#
#
# 
#    Apart from the use  of a command (MOVEROUTE_Member),  nothing else
#    was really needed to inform the system that a squad member was un-
#    der the influence of the move route command.  
#
#    However, the squad member will be under the influence of a special
#    move route flag which will prevent  the member  from following the
#    party leader.   This flag  is only erased  by an additional script
#    call from one of the END_MOVEROUTE commands.
#
#    Also, special script calls were added for use within the move route
#    system which lets you turn targeted characters towards a squad mem-
#    ber/ally.   These script calls  are 'face_ally_member(actor_index)'
#    and 'face_ally_actor(actor_id). Simple in itself, making the player
#    turn towards an ally that is actor #3 in the database would be like
#    the below code:
#
#         @>Set Move Route:Player
#           :               :$>Script: face_ally_actor(3)
#
#
#
#    I bet you're asking "Can I move an ally with pathfinding?"   Wait.
#    You're not asking that?  WHY NOT!!!   Well, just in case, you CAN!
#    All you have to do is pass the 'find_path' command from  Near Fan-
#    tastica's first Pathfinding script through the move route's script
#    call feature.  Just as simple as making the player or an ally turn
#    to face another squad member, the below example can move the fifth
#    actor to a location of 30,25 on the map (assuming it' not blocked:
#
#         @>Script: MOVEROUTE_Actor(5)
#         @>Set Move Route:Player
#           :               :$>Script: find_path(30,25)
#
#
#    Just remember, if the destination is blocked, the ally won't move.
#  
#
#------------------------------------------------------------------------------
#
#  SCRIPT CALLS:
#  =============
#    The Enhanced Squad System comes with  a veritable host of commands at
#    your beck and call.  Presented below, they have been divided into two
#    groups, one which allows one to bypass and change pre-configured set-
#    tings, the other giving the game developer  more control over the in-
#    dividual squad members.
#
#
#  Configuation Calls:
#  -------------------
#    These are the script calls  that can change the values defined within
#    the Configuration Page.  These likewise explain the values within the
#    configuration page itself.
#
#  * $game_system.squad_party_size = numeric
#      This value  sets the  maximum size  for the party.   The normal default 
#      value for RPGMaker XP is 4,  so going beyond  might require  additional
#      edits to menu and battle scripts to show the additional members.
#
#  * $game_system.squad_switch_id = numrtic
#      This sets which RMXP Switch (by its ID) that hides/reveals the squad.
#
#  * $game_system.squad_speed_freq = numrtic
#      This sets how fast/often the ally's speed and movement frequency is up-
#      dated to match  the player character's.   With this, scripts that add a
#      'dash' move will allow allies to run at the same speed as the player.
#      It can be set to 'nil' to not use the feature.
#
#  * $game_system.squad_all_dead = boolrsn (true/false)
#      This determines  if you're using  a newer rendition  of the  Game Party
#      method that determines  if everyone is dead (true)  or using  the older
#      one as a default (false).
#
#  * $game_system.remove_prevent_lead = boolrsn (true/false)
#      This value determines  if it is possible  for the player  to be removed
#      from the party  by way of the 'CHANGE PARTY MEMBER' map event.  It does
#      not affect party cycling or player abandonment.
#
#  * $game_system.remove_prevent_actor = array (or nil)
#      This is an array  which may hold the IDs of actors  (from the database)
#      that can't be removed from the party by using the 'CHANGE PARTY MEMBER"
#      map event. It does not affect party cycling. It can also be set to nil.
#
#  * $game_system.cycle_prevent = boolrsn (true/false)
#      This is a simple true/false switch that determines if the party cycling
#      or rotation system is enabled or not.  If true,  it is disabled and not
#      possible to rotate through  the party members  except when  an actor is
#      removed from the party.
#
#  * $game_system.leader_cycle_prevent = boolrsn (true/false)
#      This is  a simple true/false switch  that determines if  the lead party
#      member retains his/her position as the lead while all other members may
#      be affected  by party cycling or rotation.   It only functions if party
#      cycling is enabled.
#
#  * $game_system.waiting_cycle_prevent = boolrsn (true/false)
#      This is another  simple true/false switch,  its purpose is to determine 
#      if valid and available party members can be rotated into the lead actor
#      position or not.   While set to true,  only living party members on the
#      same map that are not flagged as 'waiting' may become party leader. But
#      if set to false, anyone in the current party (dead, waiting, or another
#      map) may become the party leader.
#      NOTE:  If you change  the party leader  to one on a different map,  not
#             only will the map change,  but all member 'wait' flags to match.
#
#  * $game_system.key_cycle_forward = Input Class Key Value (or nil)
#      This value lets you assign an input key  (ex: Input::B)  to perform the
#      function of cycling the party forward.   By this, the lead party member
#      will take position  in the rear of the party  and the next party member
#      will assume the lead.  This value can be set to nil to avoid its use.
#
#  * $game_system.key_cycle_backward = Input Class Key Value (or nil)
#      This value lets you assign an input key  (ex: Input::B)  to perform the
#      function of cycling  the party backward.  This value  can be set to nil 
#      to avoid its use.
#
#  * $game_system.key_leader_wait = Input Class Key Value (or nil)
#      This value lets you assign an input key  (ex: Input::B)  to perform the
#      function of leaving  the current party leader behind and cycling to the
#      next in command as party leader.  This value can be set to nil to avoid
#      its use.
#
#  * $game_system.key_party_gather = Input Class Key Value (or nil)
#      This value lets you assign an input key  (ex: Input::B)  to perform the
#      function  of gathering together  all party members  on the current map.
#      This value can be set to nil to avoid its use.
#
#  * $game_system.regroup_timer = numeric (or nil)
#      This value is part of the follower regroup system  which prevents squad
#      members from getting stuck or lagging too far behind. The value you set
#      here determines  how many seconds pass  before it runs its test.  Or it
#      can be set to nil to disable the system.
#
#  * $game_system.regroup_range = numeric (or nil)
#      Also part of the follower/regroup system, this value determines how far
#      the allies must be (in tiles) before the regroup system kicks in. Again,
#      it can be set to nil  to disable.   But if a numeric value is set,  the
#      smalleset range is 4 tiles out.
#
#  * $game_system.regroup_pathflash = boolean (true/false) (or nil)
#      This value lets you assign an input key  (ex: Input::B)  to perform the
#      The last part  of the  follower/regroup system,  this true/false  value
#      determines how squad members regroup with the party leader.   If set to
#      true, then it uses Near Fantastica's V1 Pathfinding system (if it is in
#      the project).   And if set to false, party members merely appear in the
#      same spot as the leader.  A value of nil turns the feature off.
#
#  * $game_system.move_style = numeric
#      This value  lets you  determine the manner  in which  the party members
#      follow behind  the party leader.   Numeric,  it is a value from 0 to 3:
#      STYLES:  0 = Default ......... all members try  to stay within 2 tiles.
#               1 = Party ........... tile distances are based on party order.
#               2 = Class ........... this is based  on class combat position. * 
#               3 = Custom Distance . Party members stay within 2 tiles unless
#                                     they have a distance  defined in a hash.
#               * Class Combat Position:  A setting  in the  'Class'  database
#                 of 'Front/Middle/Rear'. Front is closest to the party leader
#                 while rear is furthest.
#
#  * $game_system.move_actor = hash array by actor ID               
#      A hash array,  so not recommended for editing except by advanced users.
#      This identifies each custom distance setting to an individually defined
#      party member.  Again, not recommended for edit.  It is easier to set in
#      the configuration page.
#
#                              *       *       *
#
#  Control Calls:
#  -------------------
#    These are script calls that  let you control individual party members
#    or the party leader.
#
#  * ALLY_Opacity(actor_index, opacity)
#    -or- $game_party.set_opacity(actor_index, opacity)
#    Here, you can adjust the opacity of a squad party member in a 0-255 range.
#
#
#  * ALLY_Blend(actor_index, blend)
#    -or- $game_party.set_blend(actor_index, blend)
#    Here, you can set the blend style for a squad party member. A blend value
#    of 0 is the default style, 1 is addition and 2 is subtraction blending.
#
#
#  * ALLY_Position(actor_index, x, y [, d])
#    -or- $game_party.set_positiong(actor_index, x, y [, d])
#    Here, you can set the x/y coordinates of an individual party member, and
#    optionall the facing direction.
#
#
#  * ALLY_Exist_Member?(actor_index=nil)
#    -or- $game_party.ally_exist_member?(actor_index)
#    This command lets you know  if your party currently has a specific ally
#    traveling with you.   The party member  must be on  the same map as the
#    resst of the party for this to return a true value.
#
#
#  * ALLY_Exist_Actor?(actor_id=nil)
#    -or- $game_party.ally_exist_actor?(actor_id)
#    This command lets you know if your party currently has a specific actor
#    from the  database traveling with you.   The actor must be in the party
#    and on the same map as the resst of the party for this to return true.
#
#
#  * GATHER_Party
#    -or- $game_party.gather_party
#    This command turns off all 'wait' flags to actors on the current map.
#
#
#  * GATHER_Member(actor_index=nil)
#    -or- $game_party.gather_member(actor_index)  
#    This command turns off the 'wait' flag to a party member, but only works
#    if the party member is on the current map.
#
#
#  * GATHER_Actor(actor_id=nil)
#    -or- $game_party.gather_actor(actor_id)    
#    This command  turns off the 'wait'  flag to an actor defined in the data-
#    base, but only works if the actor is in the party and on the current map.
#
#
#  * LEAVE_Member(actor_index=nil)
#    -or- $game_party.leave_member(actor_index)
#    This command flags  a party member  with the  'wait' flag,  forcing it to
#    stay put.   But it only works if the party member  is on the current map.
#
#
#  * LEAVE_Actor(actor_id=nil)
#    -or- $game_party.leave_actor(actor_id)
#    This command flags an actor with the 'wait' flag, forcing it to stay put.
#    But it only works if the actor is in the party and is on the current map.
#
#
#  * LEAVE_Leader
#    -or- $game_party.leader_wait
#    This command forces the lead  to stay put on the current map,  flagging it
#    with the wait command. The next party member advances to the lead position
#    in its place.  But this only works if there is a party member available to
#    take its place.
#
#
#  * MOVEROUTE_Member(actor_index=nil)
#    -or- $game_temp.squad_party_move_route = actor_index
#    This command sets the next 'move route' map event to affect a squad member
#    by the party member index.
#
#
#  * MOVEROUTE_Actor(actor_id=nil)
#    -or- $game_temp.squad_actor_move_route = actor_id
#    This command sets the next 'move route' map event to affect a squad member
#    by the member's actor ID value.
#
#
#  * END_MOVEROUTE_Party
#    -or- $game_party.end_move_route_party
#    This removes the 'move route performance' flags from any squad member on
#    the current map.
#
#
#  * END_MOVEROUTE_Member(actor_index=nil)
#    -or- $game_party.end_move_route_member(actor_index)
#    This removes a 'move route performance' flag from the squad member identi-
#    fied by its party indes position.   Without the flag's removal, the squad
#    member will remain fixed  as if he was under the 'wait' flag.   This com-
#    mand only works on squad members on the current map.
#
#
#  * END_MOVEROUTE_Actor(actor_id=nil)
#    -or- $game_party.end_move_route_actor(actor_id)
#    This removes a 'move route performance' flag from the squad member iden-
#    tified by its actor id value.   Without the flag's removal, the squad
#    member will remain fixed  as if he was under the 'wait' flag.   This com-
#    mand only works on squad members on the current map.
#
#
#==============================================================================
#
#  COMPATIBILITY:
#
#  Fairly compatible for RPGMaker XP systems.  It performs a rewrite of the
#  add_actor method within Game_Party  and a major rewrite of the passable?
#  method within Game_Character.  All other methods were aliased.
#
#------------------------------------------------------------------------------
#
#  CREDITS AND THANKS:
#
#  Credits definitely go to Near Fantastica (aka Jaime Webster) for the ori-
#  ginal version of this system.
#
#------------------------------------------------------------------------------
#
#  TERMS AND CONDITIONS:
#
#  Free for use, even in commercial games.  Due credits to both myself and 
#  to Near Fantastica are required.
#
#==============================================================================
