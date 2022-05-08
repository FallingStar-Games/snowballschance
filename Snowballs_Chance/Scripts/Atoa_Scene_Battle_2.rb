#==============================================================================
# ** Scene_Battle (part 2)
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  alias acbs_start_phase2_scenebattle start_phase2
  def start_phase2
    return if judge
    @escape_ratio += 1
    @help_window.visible = false
    for battler in $game_party.actors + $game_troop.enemies
      battler.defense_pose = false
    end
    acbs_start_phase2_scenebattle
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    if rand(100) < set_escape_rate
      $game_system.se_play($data_system.escape_se)
      battle_end(1)
      play_map_bmg
    else
      @escape_ratio += 2
      $game_party.clear_actions
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # * Set escape success rate
  #--------------------------------------------------------------------------
  def set_escape_rate
    actors_agi = $game_party.avarage_stat("agi")
    enemies_agi = $game_troop.avarage_stat("agi")
    return @escape_ratio * actors_agi / enemies_agi
  end
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  #--------------------------------------------------------------------------
  def start_phase5
    @phase = 5
    @help_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Set items droped by enemies
  #--------------------------------------------------------------------------
  def treasure_drop(enemy)
    if rand(100) < enemy.treasure_prob
      treasure = $data_items[enemy.item_id] if enemy.item_id > 0
      treasure = $data_weapons[enemy.weapon_id] if enemy.weapon_id > 0
      treasure = $data_armors[enemy.armor_id] if enemy.armor_id > 0
    end
    return treasure
  end
  #--------------------------------------------------------------------------
  # * EXP Gain
  #--------------------------------------------------------------------------
  def gain_exp
    exp = exp_gained
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp += exp
        @status_window.level_up(i) if actor.level > last_level
      end
    end
    return exp
  end
  #--------------------------------------------------------------------------
  # * Set gained EXP
  #--------------------------------------------------------------------------
  def exp_gained
    for enemy in $game_troop.enemies
      exp = exp.nil? ? enemy.exp : exp + enemy.exp
    end
    if EXP_Share
      actor_number = 0
      for actor in $game_party.actors
        actor_number += 1 unless actor.cant_get_exp?
      end
      exp = exp / [actor_number, 1].max
    end
    return exp
  end
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  def update_phase5
    return if not_in_position($game_party.actors) or collapsing
    unless $game_temp.battle_victory
      set_result_window
    end
    if @phase5_wait_count > 0 and $game_temp.battle_victory
      @phase5_wait_count -= 1
      update_result_window
      return
    end
    battle_end(0) if Input.trigger?(Input::C) and $game_temp.battle_victory
  end
  #--------------------------------------------------------------------------
  # * Show result window
  #--------------------------------------------------------------------------
  def set_result_window
    $game_system.me_play($game_system.battle_end_me)
    play_map_bmg
    treasures = []
    for enemy in $game_troop.enemies
      gold = gold.nil? ? enemy.gold : gold + enemy.gold
      treasures << treasure_drop(enemy) unless enemy.hidden
    end
    exp = gain_exp
    treasures = treasures.compact
    gain_battle_spoil(gold, treasures)
    @status_window.visible = false
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    @result_window.add_multi_drops
    $game_temp.battle_victory = true
    set_victory_battlecry
    @phase5_wait_count = Victory_Time
  end
  #--------------------------------------------------------------------------
  # * Add items and gold to inventory
  #     gold      : gold ammount
  #     treasures : items
  #--------------------------------------------------------------------------
  def gain_battle_spoil(gold, treasures)
    $game_party.gain_gold(gold)
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Result Window Update
  #--------------------------------------------------------------------------
  def update_result_window
    if @phase5_wait_count == 0
      @result_window.update
      @result_window.visible = true
      $game_temp.battle_main_phase = false
      @status_window.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Set allies victory battlecry
  #--------------------------------------------------------------------------
  def set_victory_battlecry
    @victory_battlercry_battler
    battle_cry_set = []
    for battler in $game_party.actors
      if check_bc_basic(battler, "VICTORY") and not battler.dead?
        battle_cry_set << battler
      end
    end
    unless battle_cry_set.empty? or $game_temp.no_actor_victory_bc
      @victory_battlercry_battler = rand(battle_cry_set.size)
    end 
    if @last_active_actor != nil and not @last_active_actor.dead? and not
       $game_temp.no_actor_victory_bc and battle_cry_set.include?(@last_active_enemy)
      @victory_battlercry_battler = @last_active_actor
    end
    battle_cry_basic(@victory_battlercry_battler, "VICTORY") if @victory_battlercry_battler != nil
  end
  #--------------------------------------------------------------------------
  # * Check if all battlers returned to their postions
  #     party : party actors
  #--------------------------------------------------------------------------
  def not_in_position(party)
    for battler in party
      next unless battler.exist?
      return true if battler.actual_x != battler.base_x
      return true if battler.actual_y != battler.base_y
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check if an battler is during collapse
  #--------------------------------------------------------------------------
  def collapsing
    for battler in $game_party.actors + $game_troop.enemies
      return true if @spriteset.battler(battler).collapsing?
    end
    return false
  end
end