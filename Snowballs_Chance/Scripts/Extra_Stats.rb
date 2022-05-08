#==============================================================================
# ** Kitsune's Extra Statistics v 2.1
#------------------------------------------------------------------------------
#  by DerVVulfman
#  February 25, 2014
#  RPGMaker XP
#==============================================================================
#
#  INTRODUCTION:
#
#  This script is a model to allow  a game designer quickly add leveling actor
#  and non-leveling enemy statistics such as Strength, Desterity and the like.
#  These stats  must apply to both player  and enemy as they are a part of the
#  battler class.
#
#  This model is configured to display two new statistics (CHA and CONST) and
#  shows how to add these two new statistics within your game.   However,  it
#  does NOT show you  how to apply these new statistics into the combat engine
#  or other systems as these stats are yours to use to customize your game.
#
#  This script is a model.  It is up to you to apply it as you see fit.
#
#------------------------------------------------------------------------------
#
#  REGARDING STATISTICS AND THEIR FUNCTIONS IN-GAME
#
#  This system  does not apply any statistic  towards any function or activity
#  within the game.  Though the script itself has  (as an example)  a Charisma
#  statistic, it does not affect a player's ability to charm NPCs ro get lower
#  prices within a shop.  This is something that is the sole responcibility of
#  the end user.   All this system does is creates the values that you can use
#  towards that end.
#
#  Ex:
#    # If C button was pressed
#    if Input.trigger?(Input::C)
#      # Get item
#      @item = @buy_window.item
#      # Obtain a new price based on the party leader's charisma
#      new_price = @item.price - (15-$game_party.actors[0].cha).abs
#      # If item is invalid, or NEW price is higher than money possessed
#      if @item == nil or new_price > $game_party.gold
#      --- and etcetera ---
#
#------------------------------------------------------------------------------
#
#  NOTED AREAS TO CHANGE IN-SCRIPT
#
#  Within Game_Battler...
#
#  You would change the initialize method  to create value/variables  for your
#  new game statistics.  In this version, there are @cha_plus and @const_plus
#  values for use with the new Charisma and Constitution statistics the script
#  is creating.
#
#  There are foue new methods, the cha, const, cha= and const= methods. Each
#  is set up to read from the XTRA_STATS_RATE constant  and apply extra points
#  to the sctor stats,  though each reads  only one array  as you can see from
#  XTRA_STATS_RATE[i][0]  and   XTRA_STATS_RATE[i][1]  (for the  charisma  and
#  constitution values).  Also  note  that  each reads  their own  plus values
#  (either  @cha_plus or  @const_plus accordingly)  and references  data from
#  Game_Actor  (the base_cha  and base_const methods).   Make sure  that your
#  methods are written without referencing the wrong stat data.
#
#                              - - - - - - - - -
#
#  Within Game_Actor...
#  You will need to change  the setup method  to include  a set  of statements
#  that adds your new statistics  to each actor in your database.   Almost the
#  same, each creates an array for their respective statistic,  calls upon the
#  XTRA_STATS_ACTOR constant(reading the proper data from it for its stat) and
#  then generates data for their array & sets their plus data to 0 by default.
#
#  There are two new methods,  the base_cha and base_const methods.   Each is
#  set up to return the statistic's value  based on the actor's current level,
#  what weapon the actor is carrying and/or the armor the actor is wearing. It
#  not only refers  to the newly created array  for the stat  (from  the setup
#  method changed above,  but access data  from the  XTRA_STATS_WEAPS  and the
#  XTRA_STATS_ARMOR constants  you configure.   If no weapon or armor matches,
#  it assumes that no bonus is being given  for that weapon or piece of armor.
#  These methods are called by the methods you created in Game_Battler.
#
#                              - - - - - - - - -
#
#  Within Game_Enemy...
#
#  All you DO is add new methods,  one for each statistic  and given  the same
#  names as those used  for Game_Actor.   They follow the same basic setup and
#  returns data garnered from the XTRA_STATS_ENEMY constant if any.
#
#                              - - - - - - - - -
#
#  Within the WINDOWS...
#  
#  Within the Window_Base class in this script,  I made my own version of the
#  draw_actor_parameter method,  though I could have just as easily rewritten
#  the original.  This method draws the name of the statistics, garnering the
#  data from the XTRA_STATS_WORDS constant,  and then obtaining data from the
#  actor.cha or actor.const commands.  It is almost a mirror of the original
#  other than the changes.
#
#  Within the Window_EquipLeft command,  I changed the refresh method  so it
#  drew from my newly created draw_actor_parameter_2 method so it display the
#  name and data from my two respective statistics. Even after that, it would
#  test the new value of the data  and draw one of those '=>' arrows  if there
#  was any change to the statistics.
#
#  And the set_new_parameters within Window_EquipLeft was changed to accomo-
#  date the system having two different statistics to read and test.
#
#  Lastly, the Scene_Equip needed its refresh method changed so it can change
#  and set the actor's new statistics.  
#
#
#==============================================================================



  # Statistic names
  # =============================================================
  # This holds the abbreviated names of your new statistics.
  #
    XTRA_STATS_WORDS = ["CHA", "CON", "WIS"]
    
    
  # Actor States
  # =============================================================
  # This adds the new statistics to each of your actors.
  # By default, the actor's new statistics are set to 1 so any
  # actor not covered in this array will have 1 for that stat.
  #
  # FORMULA:  actor_id => [ stat_array_1, stat_array_2, ... ]
  #           where stat arrays are [start, increment]
  #
  # Described below.  Actor #1's cha stat starts at 10 and const starts at 12
  #                   Actor #2's cha stat starts at 20 and const starts at 24
  #                   Both have a 2pt curve for cha and 3pt curve for const
  #
  #
    XTRA_STATS_ACTOR = {0 => [[30, 2], [12, 3]],
                        2 => [[20, 2], [24, 3]] }  
    
    
  # Enemy States
  # =============================================================
  # This adds the new statistics to each of your enemies.
  # By default, the enemy's new statistics are set to 1 so any
  # enemy not covered in this array will have 1 for that stat.
  #
  # Described below.  Enemy #1's cha stat starts at 15 and const starts at 21
  #                   Enemy #2's cha stat starts at 22 and const starts at 44
  #                   Enemies have no curve as they don't level
  #
    XTRA_STATS_ENEMY = {1 => [15, 21],
                        2 => [22, 44] }  
  
                        
  # Weapon State Bonuses
  # =============================================================
  # This adds the new stat bonuses to each of your weapons.
  # By default, the weapon's new bonus stats are set to 0 so any
  # weapon not covered in this array will have 0 for that stat.
  #
  # Described below.  Weapon #1 gives a +1 bonus to cha and +2 to const scores
  #                   Weapon #2 gives a +2 bonus to cha and +4 to const scores
  #
    XTRA_STATS_WEAPS = {1 => [1,2],
                        2 => [2,4] }  

                        
  # Armor State Bonuses
  # =============================================================
  # This adds the new stat bonuses to each of your armor pieces.
  # By default, the armor's new bonus stats are set to 0 so any
  # armor not covered in this array will have 0 for that stat.
  #
  # Described below.  Armor #1 gives a +1 bonus to cha and +2 to const scores
  #                   Armor #2 gives a +2 bonus to cha and +4 to const scores
  #
    XTRA_STATS_ARMOR = {1 => [1,2],
                        2 => [2,4] }  
                        
  
  # State Effect Statistic Adjustment
  # =============================================================
  # This adds the new stat bonuses to each of your state effects.
  # By default, the state effect's new stats are set to 0 so any
  # state not covered in this array will have '0' for that stat.
  # However, you will want a base 100 stat for each attribute.
  #
  # Described below:  Each of the 16 basic status effects in the default system
  #                   with normal 100% ratings for each of the two new stats.
  #                   The exceptions are that status 2 (Stun) is set to 75% for
  #                   the charisma stat and a 60% rate for the 3rd stat (Venom)
  #
    XTRA_STATS_RATE  = {1   => [100,100],
                        2   => [ 75,100],
                        3   => [100, 60],
                        4   => [100,100],
                        5   => [100,100],
                        6   => [100,100],
                        7   => [100,100],
                        8   => [100,100],
                        9   => [100,100],
                        10  => [100,100],
                        11  => [100,100],
                        12  => [100,100],
                        13  => [100,100],
                        14  => [100,100],
                        15  => [100,100],
                        16  => [100,100] }  
                        
                        
                        
  
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias stats_init initialize
  def initialize
    stats_init
    @cha_plus  = 0
    @const_plus = 0
  end  
  #--------------------------------------------------------------------------
  # * Get Charisma (cha)
  #--------------------------------------------------------------------------
  def cha
    n = [[base_cha + @cha_plus, 1].max, 999].min
    for i in @states
      n *= XTRA_STATS_RATE[i][0] / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end  
  #--------------------------------------------------------------------------
  # * Get Constitution (const)
  #--------------------------------------------------------------------------
  def const
    n = [[base_const + @const_plus, 1].max, 999].min
    for i in @states
      n *= XTRA_STATS_RATE[i][1] / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Set Charisma (CHA)
  #     cha : new Charisma (CHA)
  #--------------------------------------------------------------------------
  def cha=(cha)
    @cha_plus += cha - self.cha
    @cha_plus = [[@cha_plus, -999].max, 999].min
  end
  
  #--------------------------------------------------------------------------
  # * Set Dexterity (DEX)
  #     dex : new Dexterity (DEX)
  #--------------------------------------------------------------------------
  def const=(const)
    @const_plus += const - self.const
    @const_plus = [[@const_plus, -999].max, 999].min
  end  
  
  #--------------------------------------------------------------------------
  # * Calculate Guild EXP
  #     guild_id : guild ID
  #--------------------------------------------------------------------------
  def make_stat_rank_list(array)
    stat_rank_list  = Array.new(101)
    stat_rank_list[1] = 0
    base_rate = array[0].to_i
    increase  = 2.4 + (array[1]).to_i / 100.0
    for i in 2..100
      n = base_rate * ((i + 3) ** increase) / (5 ** increase)
      stat_rank_list[i] = stat_rank_list[i-1] + Integer(n)
    end
    return stat_rank_list
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
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias stat_setup setup
  def setup(actor_id)
    # The original call
    stat_setup(actor_id)
    # Create the charisma stat
      @cha_array = []
      array = [0,0]
      array = XTRA_STATS_ACTOR[actor_id][0] if XTRA_STATS_ACTOR[actor_id] != nil
      @cha_array = make_stat_rank_list(array)
      @cha_plus  = 0
    # Create the constitution stat
      @const_array = []
      array = [0,0]
      array = XTRA_STATS_ACTOR[actor_id][1] if XTRA_STATS_ACTOR[actor_id] != nil
      @const_array = make_stat_rank_list(array)
      @const_plus  = 0
  end
  #--------------------------------------------------------------------------
  # * Get Basic Charisma
  #--------------------------------------------------------------------------
  def base_cha
    return 0 if @cha_array == nil
    n = @cha_array[@level+1]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? base_acquire_stat(XTRA_STATS_WEAPS, @weapon_id, 0) : 0
    n += armor1 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor1_id, 0) : 0
    n += armor2 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor2_id, 0) : 0
    n += armor3 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor3_id, 0) : 0
    n += armor4 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor4_id, 0) : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Constitution
  #--------------------------------------------------------------------------
  def base_const
    return 0 if @const_array == nil
    n = @const_array[@level+1]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? base_acquire_stat(XTRA_STATS_WEAPS, @weapon_id, 1) : 0
    n += armor1 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor1_id, 1) : 0
    n += armor2 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor2_id, 1) : 0
    n += armor3 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor3_id, 1) : 0
    n += armor4 != nil ? base_acquire_stat(XTRA_STATS_ARMOR, @armor4_id, 1) : 0
    return [[n, 1].max, 999].min
  end  
  #--------------------------------------------------------------------------
  # * Get Basic Constitution
  #   Constant Value : Value passed
  #   equip_ID : ID of the equipment
  #   type : what new stat is being accessed
  #--------------------------------------------------------------------------  
  def base_acquire_stat(constant_value, equip_id, type)
    temp = 0
    temp = constant_value[equip_id][type] if constant_value[equip_id] != nil
    return temp    
  end
end



#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Get Basic Charisma
  #--------------------------------------------------------------------------
  def base_cha
    n = 0
    n = XTRA_STATS_ENEMY[@enemy_id][0] if XTRA_STATS_ENEMY[@enemy_id] != nil
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Get Basic Constitution
  #--------------------------------------------------------------------------
  def base_const
    n = 0
    n = XTRA_STATS_ENEMY[@enemy_id][1] if XTRA_STATS_ENEMY[@enemy_id] != nil
    return [[n, 1].max, 999].min
  end
end


#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Parameter #2
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : parameter type (0-6)
  #--------------------------------------------------------------------------
  def draw_actor_parameter_2(actor, x, y, type)
    parameter_name = ""
    parameter_name = XTRA_STATS_WORDS[type] if XTRA_STATS_WORDS[type] != nil
    parameter_value = 0
    case type
    when 0 ; parameter_value = actor.cha
    when 1 ; parameter_value = actor.const
    end
    parameter_value = 0 if parameter_value == nil
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, 32, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 120, y, 36, 32, parameter_value.to_s, 2)
  end
end


#==============================================================================
# ** Window_EquipLeft
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 4, 32)
    
    # PLEASE NOTE:  This changes the attributes, but not the 'would-be'
    # attributes.  I did not continue further on this.  There are no
    # values of @new_cha or @new_const to fiddle with
    
    # My change ----------------------------
    draw_actor_parameter_2(@actor, 4, 64, 0)
    draw_actor_parameter_2(@actor, 4, 96, 1)
    # END change ----------------------------
    
    draw_actor_parameter(@actor, 4, 128, 2)
    
    # My change ----------------------------
    if @new_cha != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 64, 40, 32, "->", 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 64, 36, 32, @new_cha.to_s, 2)
    end
    if @new_const != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 96, 40, 32, "->", 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 96, 36, 32, @new_const.to_s, 2)
    end
    # END change ----------------------------
    
    if @new_mdef != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 128, 40, 32, "->", 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(200, 128, 36, 32, @new_mdef.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Set parameters after changing equipment
  #     new_atk  : attack power after changing equipment
  #     new_pdef : physical defense after changing equipment
  #     new_mdef : magic defense after changing equipment
  #--------------------------------------------------------------------------
  def set_new_parameters(new_cha, new_const, new_mdef)
    if @new_cha != new_cha or @new_const != new_const or @new_mdef != new_mdef
      @new_cha = new_cha
      @new_const = new_const
      @new_mdef = new_mdef
      refresh
    end
  end
end



#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs equipment screen processing.
#==============================================================================

class Scene_Equip
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Set item window to visible
    @item_window1.visible = (@right_window.index == 0)
    @item_window2.visible = (@right_window.index == 1)
    @item_window3.visible = (@right_window.index == 2)
    @item_window4.visible = (@right_window.index == 3)
    @item_window5.visible = (@right_window.index == 4)
    # Get currently equipped item
    item1 = @right_window.item
    # Set current item window to @item_window
    case @right_window.index
    when 0
      @item_window = @item_window1
    when 1
      @item_window = @item_window2
    when 2
      @item_window = @item_window3
    when 3
      @item_window = @item_window4
    when 4
      @item_window = @item_window5
    end
    # If right window is active
    if @right_window.active
      # Erase parameters for after equipment change
      @left_window.set_new_parameters(nil, nil, nil)
    end
    # If item window is active
    if @item_window.active
      # Get currently selected item
      item2 = @item_window.item
      # Change equipment
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      
      # My change ----------------------------
      # Get parameters for after equipment change
      new_cha = @actor.cha
      new_const = @actor.const
      new_mdef = @actor.mdef
      # END change ----------------------------
    
      # Return equipment
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      @actor.hp = last_hp
      @actor.sp = last_sp
      
      # My change ----------------------------
      # Draw in left window
      @left_window.set_new_parameters(new_cha, new_const, new_mdef)
      # END change ----------------------------
      
    end
  end
end
