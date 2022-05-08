class Game_Temp
  attr_accessor :map_bgm_pos
  alias :fmodex_old_temp_initialize :initialize unless $@
  def initialize
    fmodex_old_temp_initialize
    @map_bgm_pos = 0
  end
end

class Scene_Map
  alias :fmodex_old_map_call_battle :call_battle unless $@
  def call_battle
    $game_temp.map_bgm_pos = FMod.bgm_position
    fmodex_old_map_call_battle
  end
end

class Scene_Battle
  def judge
    # If all dead determinant is true, or number of members in party is 0
    if $game_party.all_dead? or $game_party.actors.size == 0
      # If possible to lose
      if $game_temp.battle_can_lose
############################################################################
#   ADDED $game_temp.map_bgm_pos AS 2ND PARAMETE TO bgm_play
############################################################################
        # Return to BGM before battle starts
        $game_system.bgm_play($game_temp.map_bgm, $game_temp.map_bgm_pos)
############################################################################        
        # Battle ends
        battle_end(2)
        # Return true
        return true
      end
      # Set game over flag
      $game_temp.gameover = true
      # Return true
      return true
    end
    # Return false if even 1 enemy exists
    for enemy in $game_troop.enemies
      if enemy.exist?
        return false
      end
    end
    # Start after battle phase (win)
    start_phase5
    # Return true
    return true
  end
  
  def start_phase5
    # Shift to phase 5
    @phase = 5
############################################################################
#   ADDED $game_temp.map_bgm_pos AS 2ND PARAMETE TO bgm_play
#   AND SWITCHED PLAY ORDER SO BGM IS PLAYED FIRST
############################################################################
    # Return to BGM before battle started
    $game_system.bgm_play($game_temp.map_bgm, $game_temp.map_bgm_pos)
    # Play battle end ME
    $game_system.me_play($game_system.battle_end_me)
############################################################################
    # Initialize EXP, amount of gold, and treasure
    exp = 0
    gold = 0
    treasures = []
    # Loop
    for enemy in $game_troop.enemies
      # If enemy is not hidden
      unless enemy.hidden
        # Add EXP and amount of gold obtained
        exp += enemy.exp
        gold += enemy.gold
        # Determine if treasure appears
        if rand(100) < enemy.treasure_prob
          if enemy.item_id > 0
            treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            treasures.push($data_armors[enemy.armor_id])
          end
        end
      end
    end
    # Treasure is limited to a maximum of 6 items
    treasures = treasures[0..5]
    # Obtaining EXP
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp += exp
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    # Obtaining gold
    $game_party.gain_gold(gold)
    # Obtaining treasure
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
    # Make battle result window
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    # Set wait count
    @phase5_wait_count = 100
  end

  
  def update_phase5
    # If wait count is larger than 0
    if @phase5_wait_count > 0
      # Decrease wait count
      @phase5_wait_count -= 1
      # If wait count reaches 0
      if @phase5_wait_count == 0
        # Show result window
        @result_window.visible = true
        # Clear main phase flag
        $game_temp.battle_main_phase = false
        # Refresh status window
        @status_window.refresh
      end
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
############################################################################
#   REMOVED $game_system.play_bgm BECAUSE IT'S DONE AUTOMATICALLY
#   WHEN ME IS DONE PLAYING
############################################################################
############################################################################
      # Battle ends
      battle_end(0)
    end
  end
end

