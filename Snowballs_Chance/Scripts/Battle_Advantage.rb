#==============================================================================
# Battle Advantage
# by Atoa
#==============================================================================
# This script allows to set chance of advantages and disvantages (back attack,
# surprised...) occur on the begin of the battle
#==============================================================================
=begin
module Atoa
  # Do not remove these lines
  Advantage_Actions = {}
  Disvantage_Actions = {}
  Pre_Emptive_Actions = {}
  Surprised_Actions = {}
  Raid_Attack_Actions = {}
  Back_Attack_Actions = {}
  # Do not remove these lines
  
  # Allow Advantage (Actors take the first actions on the first turn, don't cancel
  # enemies actions) (Don't Work with ATB/CTB)
  Allow_Advantage = false
  # Adavantage Rate 
  Advantage_Rate = 5
  # Advantage Alert
  Advantage_Alert = 'The party starts in advantage!'
  
  # Allow Disvantage (Enemies take the first actions on the first turn, don't cancel
  # enemies actors) (Don't Work with ATB/CTB)
  Allow_Disvantage = false
  # Disvantage Rate
  Disvantage_Rate = 5
  # Disvantage Alert
  Disvantage_Alert = 'The party starts in disvantage!'

  # Allow Initiative (Only actors can take actions on the 1st turn)
  Allow_Pre_Emptive = true
  # Pre Emptive Rate
  Pre_Emptive_Rate = 5
  # Pre Emptive Alert
  Pre_Emptive_Alert = 'The party surprised the enemy!'
  
  # Allow Surprise (Only enemies can take actions on the 1st turn)
  Allow_Surprised = true
  # Surprised Rate
  Surprised_Rate = 5
  # Surprised Alert
  Surprised_Alert = 'The party was surprised by the enemy!'
  
  # Allow Raid Attack (Only actors can take actions on the 1st turn, increase
  # damage recived by enemies turned back)
  Allow_Raid_Attack = true
  # Raid Attack Rate
  Raid_Attack_Rate = 5
  # Raid Attack Alert
  Raid_Attack_Alert = 'The party attacks from behind!'
    
  # Allow Back Attack (Only enemies can take actions on the 1st turn, increase
  # damage recived by actors turned back)
  Allow_Back_Attack = true
  # Back Attack Rate
  Back_Attack_Rate = 5
  # Mensagem de Ataque por Trás
  Back_Attack_Alert = 'The party was attacked from behind!'
  
  # Damage multiplies for attacks from behind
  Back_Attack_Damage = 1.5

  # Invert battlers position during back attacks?
  # Works only if 'Battle_Style = 0' (side battle) ou 
  # 'Battle_Style = 1' (frontal battle) 
  Invert_Back_Attack = true
  
  # Use agility difference between battler to set advantaged
  Agi_Check_For_Advantage = true
  
  Battle_Screen_Dimensions = []
  Battle_Screen_Dimensions[0]= 640
  Battle_Screen_Dimensions[1]= 480
  
  #=============================================================================
    
  # Equipamentos que alteram a taxa de efeitos de vantagem
  #
  #  Advantage_Actions['Type'] = {ID => Value}
  #  Disvantage_Actions['Type'] = {ID => Value}
  #  Pre_Emptive_Actions['Type'] = {ID => Value}
  #  Surprised_Actions['Type'] = {ID => Value}
  #  Raid_Attack_Actions['Type'] = {ID => Value}
  #  Back_Attack_Actions['Type'] = {ID => Value}
  #
  #  'Type' = type of the effect that will set the change on the advantage rate.
  #    Can be one of the following values
  #      'Weapon' = The rate is changed when one of the set weapons is equiped
  #      'Armor' = The rate is changed when one of the set armors is equiped
  #      'Skill' = The rate is changed when one of the party members learned one of the set skills
  #      'Switch' = The rate is changed when one of the set switches is turned on
  #  ID = ID of the weapon, armor, skill or switch.
  #  Valor = Value of change in the advantage rate.
  #    Postive values are increases on the rate, Negative values are reducition
  
  #Pre_Emptive_Actions['Armor'] = {45 => 25}
  
  #Back_Attack_Actions['Armor'] = {44 => -25}
  
  #=============================================================================
    
  # You can also use 'Script Calls' to add/prevent automatically that some
  # of advantage situations occurs
  # These commands are valid onlu for *one* battle, so you must re-use it
  # if you want the effect for the next one.
  # 
  # This command ensure that an advantage situation occur on the next battle.
  # Using two won't have any effect, only one will be applied.
  #    $game_temp.advantage = true
  #    $game_temp.disvantage = true
  #    $game_temp.pre_emptive = true
  #    $game_temp.raid_attack = true
  #    $game_temp.back_attack = true
  #    $game_temp.surprised = true
  #
  # This command ensure that an advantage situation will not occur on the next battle.
  # These commands have an higher priority than the 'ensure' commands.
  #    $game_temp.no_advantage = true
  #    $game_temp.no_disvantage = true
  #    $game_temp.no_pre_emptive = true
  #    $game_temp.no_surprised = true
  #    $game_temp.no_raid_attack = true
  #    $game_temp.no_back_attack = true
  #
  # There is also an command that changes the advantage rates *permanently*
  #    $game_system.plus_advantage = X
  #    $game_system.plus_disvantage = X
  #    $game_system.plus_pre_emptive = X
  #    $game_system.plus_raid_attack = X
  #    $game_system.plus_back_attack = X
  #    $game_system.plus_surprised = X
  #
  #  Where X is an numeric value, if it's higher than zero, the chance increase,
  #  if lower, it decrease.
  #  This change is memorized on the save file, so to remove it, set the value to zero
  #=============================================================================
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Battle Advantage'] = true

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :advantage
  attr_accessor :disvantage
  attr_accessor :pre_emptive
  attr_accessor :raid_attack
  attr_accessor :back_attack
  attr_accessor :surprised
  attr_accessor :no_advantage
  attr_accessor :no_disvantage
  attr_accessor :no_pre_emptive
  attr_accessor :no_raid_attack
  attr_accessor :no_back_attack
  attr_accessor :no_surprised
  attr_accessor :clear_enemies_actions
  attr_accessor :invert_postion
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_advantage initialize
  def initialize
    initialize_advantage
    reset_advantages
  end
  #--------------------------------------------------------------------------
  # * Reset advantages values
  #--------------------------------------------------------------------------
  def reset_advantages
    @advantage = false
    @disvantage = false
    @pre_emptive = false
    @surprised = false
    @raid_attack = false
    @back_attack = false
    @no_advantage = false
    @no_disvantage = false
    @no_pre_emptive = false
    @no_surprised = false
    @no_raid_attack = false
    @no_back_attack = false
    @clear_enemies_actions = false
    @invert_postion = false
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
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :plus_advantage
  attr_accessor :plus_disvantage
  attr_accessor :plus_pre_emptive
  attr_accessor :plus_raid_attack
  attr_accessor :plus_back_attack
  attr_accessor :plus_surprised
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_advantage initialize
  def initialize
    initialize_advantage
    @plus_advantage = 0
    @plus_disvantage = 0
    @plus_pre_emptive = 0
    @plus_raid_attack = 0
    @plus_back_attack = 0
    @plus_surprised = 0
  end
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Set default battler direction
  #--------------------------------------------------------------------------
  alias default_battler_direction_advantage default_battler_direction
  def default_battler_direction
    default_battler_direction_advantage
    if @battler.turned_back
      case @battler.direction
      when 2 then @battler.direction = 8
      when 4 then @battler.direction = 6
      when 6 then @battler.direction = 4
      when 8 then @battler.direction = 2
      end
    end
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :turned_back
  attr_accessor :turn_front
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_advantage initialize
  def initialize
    initialize_advantage
    @turned_back = false
    @turn_front = false
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_advantage set_damage
  def set_damage(user, action = nil)
    set_damage_advantage(user, action)
    if user.target_damage[self].numeric? and self.turned_back and (action.nil? or
       (action != nil and (not action.magic? or Back_Attack_Magic)))
      user.target_damage[self] = (user.target_damage[self] * Back_Attack_Damage).to_i
      self.turn_front = true
    end
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
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  alias screen_x_advantage screen_x
  def screen_x
    base = screen_x_advantage
    base = Battle_Screen_Dimensions[0] - base  if $game_temp.invert_postion and Battle_Style == 0
    return base
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  alias screen_y_advantage screen_y
  def screen_y
    base = screen_y_advantage
    base = Battle_Screen_Dimensions[1] - base if $game_temp.invert_postion and Battle_Style == 1
    return base
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
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  alias screen_x_advantage screen_x
  def screen_x
    base = screen_x_advantage
    base = Battle_Screen_Dimensions[0] - base if $game_temp.invert_postion and Battle_Style == 0
    return base
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  alias screen_y_advantage screen_y
  def screen_y
    base = screen_y_advantage
    base = Battle_Screen_Dimensions[1] - base if $game_temp.invert_postion and Battle_Style == 1
    return base
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias start_advantage start
  def start
    start_advantage
    set_advantage
    no_advantage_check
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_advantage terminate
  def terminate
    $game_temp.invert_postion = false
    terminate_advantage
    reset_advantages
  end
  #--------------------------------------------------------------------------
  # * Create Display Viewport
  #--------------------------------------------------------------------------
  alias create_viewport_advantage create_viewport
  def create_viewport
    create_viewport_advantage
    advantage_preset
  end
  #--------------------------------------------------------------------------
  # * Show transition
  #--------------------------------------------------------------------------
  alias show_transition_advantage show_transition
  def show_transition
    show_transition_advantage
    show_advantage_message
  end
  #--------------------------------------------------------------------------  
  # * Set intro battlecry
  #--------------------------------------------------------------------------  
  alias set_intro_advantage set_intro
  def set_intro
    if $game_temp.back_attack or $game_temp.surprised
      return
    end
    set_intro_advantage
  end
  #--------------------------------------------------------------------------
  # * Start Pre-Battle Phase
  #--------------------------------------------------------------------------
  alias start_phase1_advantage start_phase1
  def start_phase1
    start_phase1_advantage
    unless $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
      $game_temp.clear_enemies_actions = false
      if $game_temp.pre_emptive
        $game_temp.clear_enemies_actions = true
      elsif $game_temp.surprised
        $game_party.clear_actions
        start_phase4
      elsif $game_temp.raid_attack
        $game_temp.clear_enemies_actions = true
      elsif $game_temp.back_attack
        $game_party.clear_actions
        start_phase4
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Pre-set advantages
  #--------------------------------------------------------------------------
  def advantage_preset
    if $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'] 
      for battler in $game_party.actors + $game_troop.enemies
        if $game_temp.pre_emptive
          battler.atb = (battler.actor? ? Max_Atb - battler.index : 0) if $atoa_script['Atoa ATB']
          battler.ctb = (battler.actor? ? Max_Ctb - battler.index : battler.ctb / 2) if $atoa_script['Atoa CTB']
        elsif $game_temp.surprised
          battler.atb = (battler.actor? ? 0 : Max_Atb - battler.index) if $atoa_script['Atoa ATB']
          battler.ctb = (battler.actor? ? battler.ctb / 2 : Max_Ctb - battler.index) if $atoa_script['Atoa CTB']
        elsif $game_temp.raid_attack
          battler.atb = (battler.actor? ? Max_Atb - battler.index : 0) if $atoa_script['Atoa ATB']
          battler.ctb = (battler.actor? ? Max_Ctb - battler.index : battler.ctb / 2) if $atoa_script['Atoa CTB']
          battler.turned_back = !battler.actor?
        elsif $game_temp.back_attack
          battler.atb = (battler.actor? ? 0 : Max_Atb - battler.index) if $atoa_script['Atoa ATB']
          battler.ctb = (battler.actor? ? battler.ctb / 2 : Max_Ctb - battler.index) if $atoa_script['Atoa CTB']
          battler.turned_back = battler.actor?
        end
      end
    end
    if $game_temp.raid_attack
      for enemy in $game_troop.enemies
        enemy.turned_back = true
      end
    elsif $game_temp.back_attack
      for actor in $game_party.actors
        actor.turned_back = true
      end
      $game_temp.battle_start = false
      $game_temp.skip_intro = false
    elsif $game_temp.surprised
      $game_temp.battle_start = false
      $game_temp.skip_intro = false
    end
    for battler in $game_party.actors + $game_troop.enemies
      @spriteset.battler(battler).default_battler_direction
    end
    @spriteset.update
  end
  #--------------------------------------------------------------------------
  # * Show advantage message
  #--------------------------------------------------------------------------
  def show_advantage_message
    if $game_temp.advantage
      pop_wait_help(Advantage_Alert)
    elsif $game_temp.disvantage
      pop_wait_help(Disvantage_Alert)
    elsif $game_temp.pre_emptive
      pop_wait_help(Pre_Emptive_Alert)
    elsif $game_temp.surprised
      pop_wait_help(Surprised_Alert)
    elsif $game_temp.raid_attack
      pop_wait_help(Raid_Attack_Alert)
    elsif $game_temp.back_attack
      pop_wait_help(Back_Attack_Alert)
    end
  end
  #--------------------------------------------------------------------------
  # * Set escape success rate
  #--------------------------------------------------------------------------
  alias set_escape_rate_advantage set_escape_rate
  def set_escape_rate
    base = set_escape_rate_advantage
    base = 100 if $game_temp.advantage or $game_temp.pre_emptive or $game_temp.raid_attack
    base = 0 if $game_temp.disvantage
    return base
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  alias phase3_setup_command_window_advantage phase3_setup_command_window
  def phase3_setup_command_window
    phase3_setup_command_window_advantage
    if @active_battler.turned_back and ($atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB'])
      @active_battler.turned_back = false
      @spriteset.battler(@active_battler).default_battler_direction
    end
  end
  #--------------------------------------------------------------------------
  # * Start Main Phase
  #--------------------------------------------------------------------------
  alias start_phase4_advantage start_phase4
  def start_phase4
    start_phase4_advantage
    if $game_temp.clear_enemies_actions
      $game_temp.clear_enemies_actions = false
      $game_troop.clear_actions
    end
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_advantage step3_part1
  def step3_part1(battler)
    unless cant_use_action(battler)
      battler.turned_back = false
      @spriteset.battler(battler).default_battler_direction
    end
    step3_part1_advantage(battler)
  end  
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 2)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part2_advantage step5_part2
  def step5_part2(battler)
    for target in $game_party.actors + $game_troop.enemies
      if target.turn_front and not target.hp0?
        target.turn_front = false
        target.turned_back = false
        @spriteset.battler(target).default_battler_direction
      end
    end
    step5_part2_advantage(battler)
  end  
  #--------------------------------------------------------------------------
  # * Make Action Orders
  #--------------------------------------------------------------------------
  alias make_action_orders_advantage make_action_orders
  def make_action_orders
    make_action_orders_advantage
    unless $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
      for battler in @action_battlers
        if ($game_temp.disvantage or $game_temp.back_attack or
            $game_temp.surprised) and battler.actor?
          battler.current_action.speed = 0
        elsif ($game_temp.advantage or $game_temp.pre_emptive or
               $game_temp.raid_attack) and not battler.actor?
          battler.current_action.speed = 0
        end
      end
      @action_battlers.sort! {|a, b| b.current_action.speed - a.current_action.speed }
      reset_advantages
    end
  end
  #--------------------------------------------------------------------------
  # * Clear advantage values
  #--------------------------------------------------------------------------
  def reset_advantages
    $game_temp.advantage = false
    $game_temp.disvantage = false
    $game_temp.pre_emptive = false
    $game_temp.surprised = false
    $game_temp.raid_attack = false
    $game_temp.back_attack = false
  end
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  alias update_turn_ending_advantage update_turn_ending
  def update_turn_ending
    update_turn_ending_advantage
    unless $atoa_script['Atoa ATB'] or $atoa_script['Atoa CTB']
      reset_advantages
      for battler in $game_party.actors + $game_troop.enemies
        battler.turned_back = false
        @spriteset.battler(battler).default_battler_direction
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Check no advantages allowed
  #--------------------------------------------------------------------------
  def no_advantage_check
    $game_temp.advantage = false if $game_temp.no_advantage or not Allow_Advantage
    $game_temp.disvantage = false if $game_temp.no_disvantage or not Allow_Disvantage
    $game_temp.pre_emptive = false if $game_temp.no_pre_emptive or not Allow_Pre_Emptive
    $game_temp.surprised = false if $game_temp.no_surprised or not Allow_Surprised
    $game_temp.raid_attack = false if $game_temp.no_raid_attack or not Allow_Raid_Attack
    $game_temp.back_attack = false if $game_temp.no_back_attack or not Allow_Back_Attack
    $game_temp.invert_postion = ($game_temp.back_attack and Invert_Back_Attack)
  end
  #--------------------------------------------------------------------------
  # * Set advantage
  #--------------------------------------------------------------------------
  def set_advantage
    return if advantage_set
    rate_advantage = set_advantage_rate('Advantage')
    rate_pre_emptive = set_advantage_rate('Pre_Emptive')
    rate_raid_attack = set_advantage_rate('Raid_Attack')
    rate_disvantage = set_advantage_rate('Disvantage')
    rate_back_attack = set_advantage_rate('Back_Attack')
    rate_surprised = set_advantage_rate('Surprised')
    return $game_temp.advantage = true if rand(100) < rate_advantage and Allow_Advantage
    return $game_temp.disvantage = true if rand(100) < rate_disvantage and Allow_Disvantage
    return $game_temp.pre_emptive = true if rand(100) < rate_pre_emptive and Allow_Pre_Emptive
    return $game_temp.surprised = true if rand(100) < rate_surprised and Allow_Surprised
    return $game_temp.raid_attack = true if rand(100) < rate_raid_attack and Allow_Raid_Attack
    return $game_temp.back_attack = true if rand(100) < rate_back_attack and Allow_Back_Attack
  end
  #--------------------------------------------------------------------------
  # * Set advantage rate
  #     action : action
  #--------------------------------------------------------------------------
  def set_advantage_rate(action)
    advantage_rate = eval(action + '_Rate')
    for type in ['Weapon', 'Armor', 'Skill', 'Switch']
      action_type = eval(action + '_Actions[type]')
      if action_type != nil
        case type
        when 'Weapon'
          for weapon in get_weapons
            next if action_type[action_id(weapon)].nil?
            advantage_rate += action_type[action_id(weapon)]
          end
        when 'Armors'
          for armor in get_armors
            next if action_type[type][action_id(armor)].nil?
            advantage_rate += action_type[type][action_id(armor)]
          end
        when 'Skills'
          for skill in get_skills
            next if action_type[type][skill].nil?
            advantage_rate += action_type[type][skill]
          end
        when 'Switches'
          for i in 0...$game_switches.size
            next if action_type[type][i].nil? or not $game_switches[i]
            advantage_rate += action_type[type][i]
          end
        end        
      end
    end
    advantage_rate += $game_system.plus_advantage if action == 'Advantage'
    advantage_rate += $game_system.plus_disvantage if action == 'Disvantage'
    advantage_rate += $game_system.plus_pre_emptive if action == 'Pre_Emptive'
    advantage_rate += $game_system.plus_raid_attack if action == 'Raid_Attack'
    advantage_rate += $game_system.plus_back_attack if action == 'Back_Attack'
    advantage_rate += $game_system.plus_surprised if action == 'Surprised'
    if Agi_Check_For_Advantage
      actors_agi = $game_party.avarage_stat('agi')
      enemies_agi = $game_troop.avarage_stat('agi')
      advantage_rate += (10 - (10 * enemies_agi / actors_agi))
    end
    return advantage_rate
  end
  #--------------------------------------------------------------------------
  # * Get party weapons
  #--------------------------------------------------------------------------
  def get_weapons
    weapons = []
    for actor in $game_party.actors
      weapons << actor.weapons
    end
    return weapons.flatten
  end
  #--------------------------------------------------------------------------
  # * Get party armors
  #--------------------------------------------------------------------------
  def get_armors
     armors = []
    for actor in $game_party.actors
      armors << actor.armors
    end
    return armors.flatten
  end
  #--------------------------------------------------------------------------
  # * Get party skills
  #--------------------------------------------------------------------------
  def get_skills
     skills = []
    for actor in $game_party.actors
      skills << actor.skills
    end
    return skills.flatten
  end
  #--------------------------------------------------------------------------
  # * Set automatic advantage
  #--------------------------------------------------------------------------
  def advantage_set
    return true if $game_temp.advantage or $game_temp.disvantage or 
      $game_temp.pre_emptive or $game_temp.back_attack or $game_temp.surprised
    return false
  end
end
=end