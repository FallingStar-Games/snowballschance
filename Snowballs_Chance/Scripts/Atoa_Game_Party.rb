#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actors       # actors
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias acbs_initialize_gameparty initialize
  def initialize
    acbs_initialize_gameparty
    @actors = []
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    actor = $game_actors[actor_id]
    if @actors.size < Max_Party and not @actors.include?(actor)
      @actors << actor
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Add an Actor by index
  #     actor_id : actor ID
  #     index    : index
  #--------------------------------------------------------------------------
  def add_actor_by_index(actor_id, index)
    actor = $game_actors[actor_id]
    if @actors.size < Max_Party and not @actors.include?(actor)
      @actors.insert(index, actor)
      @actors.compact!
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Check map slip damage
  #--------------------------------------------------------------------------
  def check_map_slip_damage
    slip_1 = Slip_Pop_State['Slip_1'].nil? ? nil : Slip_Pop_State['Slip_1']
    slip_2 = Slip_Pop_State['Slip_2'].nil? ? nil : Slip_Pop_State['Slip_2']
    for actor in @actors
      if actor.slip_damage? and not actor.dead?
        damage = 0
        for id in actor.states
          if slip_1 != nil and slip_1[id] != nil and slip_1[id][0] == 'hp'
            base_damage = slip_1[id][1] + actor.maxhp * slip_1[id][2] / 1000
            damage += base_damage + (base_damage * (rand(5) - rand(5)) / 100)
            damage = actor.hp - 1 if damage >= actor.hp and slip_1[id][4] = false
          end
          if slip_2 != nil and slip_2[id] != nil and slip_2[id][0] == 'hp'
            base_damage = slip_2[id][1] + actor.maxhp * slip_2[id][2] / 1000
            damage += base_damage + (base_damage * (rand(5) - rand(5)) / 100)
            damage = actor.hp - 1 if damage >= actor.hp and slip_1[id][4] = false
          end
        end
        actor.hp -= damage
        $game_system.se_play($data_system.actor_collapse_se) if actor.hp <= 0
        $game_screen.start_flash(Color.new(255,0,0,128), 4) if damage > 0
        $game_screen.start_flash(Color.new(0,0,255,128), 4) if damage < 0
        #$game_temp.gameover = $game_party.all_dead? #edited!
      end
      if actor.sp > 0 and actor.slip_damage?
        damage = 0
        for id in actor.states
          if slip_1 != nil and slip_1[id] != nil and slip_1[id][0] == 'sp'
            base_damage = slip_1[id][1] + actor.maxsp * slip_1[id][2] / 1000
            damage += base_damage + (base_damage * (rand(5) - rand(5)) / 100)
            damage = actor.sp - 1 if damage >= actor.sp and slip_1[id][4] = false
          end
          if slip_2 != nil and slip_2[id] != nil and slip_2[id][0] == 'sp'
            base_damage = slip_2[id][1] + actor.maxsp * slip_2[id][2] / 1000
            damage += base_damage + (base_damage * (rand(5) - rand(5)) / 100)
            damage = actor.sp - 1 if damage >= actor.sp and slip_1[id][4] = false
          end
        end
        actor.sp -= damage
        $game_screen.start_flash(Color.new(0,255,0,128), 4) if damage > 0
        $game_screen.start_flash(Color.new(255,255,128), 4) if damage < 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get stat avarage value
  #     stat : status
  #--------------------------------------------------------------------------
  def avarage_stat(stat)
    value = 0
    for target in @actors
      value += eval("target.#{stat}")
    end
    value /= [@actors.size, 1].max
    return value
  end
  #--------------------------------------------------------------------------
  # * Get battlers avarage position
  #--------------------------------------------------------------------------
  def avarage_position
    x = 0
    y = 0
    for target in @actors
      x += target.actual_x
      y += target.actual_y
    end
    x /= [@actors.size, 1].max
    y /= [@actors.size, 1].max
    return [x, y]
  end
end