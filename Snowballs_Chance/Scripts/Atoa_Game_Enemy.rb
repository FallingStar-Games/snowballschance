#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :steal_items     # steal item list
  attr_accessor :steal_attempt   # steal attempts value
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     troop_id     : troop ID
  #     member_index : troop member index
  #     enemy_id     : enemy ID
  #--------------------------------------------------------------------------
  def initialize(troop_id, member_index, enemy_id = nil)
    super()
    @troop_id = troop_id
    @member_index = member_index
    troop = $data_troops[@troop_id]
    @enemy_id = enemy_id.nil? ? troop.members[@member_index].enemy_id : enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @maxhp = maxhp
    @maxsp = maxsp
    @hp = @maxhp
    @sp = @maxsp
    @str = base_str
    @dex = base_dex
    @agi = base_agi
    @int = base_int
    @gold = gold
    @exp = exp
    @hidden = enemy_id.nil? ? troop.members[@member_index].hidden : false
    @immortal = enemy_id.nil? ? troop.members[@member_index].immortal : false
    @steal_items = Enemy_Steal[@enemy_id].to_a
    @steal_attempt = 0
    @moving = @sp_damage = false
    battler_position_setup
  end
  #--------------------------------------------------------------------------
  # * Check if battler is an actor
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  #--------------------------------------------------------------------------
  # * Decide if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    return super
  end 
  #--------------------------------------------------------------------------
  # * Type string setting
  #--------------------------------------------------------------------------
  def type_name
    return 'Enemy'
  end
  #--------------------------------------------------------------------------
  # Definição de arma atual
  #--------------------------------------------------------------------------
  def current_weapon
    return nil
  end
  #--------------------------------------------------------------------------
  # * Set initial position
  #--------------------------------------------------------------------------
  def battler_position_setup
    base_x = @troop_id == 0 ? 0 : self.screen_x
    base_y = @troop_id == 0 ? 0 : self.screen_y
    @base_x = @original_x = @actual_x = @target_x = @initial_x = @hit_x = @damage_x = base_x
    @base_y = @original_y = @actual_y = @target_y = @initial_y = @hit_y = @damage_y = base_y
  end
  #--------------------------------------------------------------------------
  # * Set multi drop items
  #--------------------------------------------------------------------------
  def multi_drops
    drop_items = []
    return drop_items if Enemy_Drops[@enemy_id].nil?
    Enemy_Drops[@enemy_id].each do |item, drop_rate|
      item = item.split('')
      if item[0] == 'i'
        item = item.join
        item.slice!('i')
        if (rand(1000) < (drop_rate * 10).to_i) and not 
           (item_id == $data_items[item.to_i].id)
          drop_items << $data_items[item.to_i]
        end
      elsif item[0] == 'a'
        item = item.join
        item.slice!('a')
        if (rand(1000) < (drop_rate * 10).to_i) and not 
           (armor_id == $data_armors[item.to_i].id)
          drop_items << $data_armors[item.to_i]
        end
      elsif item[0] == 'w'
        item = item.join
        item.slice!('w')
        if (rand(1000) < (drop_rate * 10).to_i) and not 
           (weapon_id == $data_weapons[item.to_i].id)
          drop_items << $data_weapons[item.to_i]
        end
      end
    end
    return drop_items
  end
  #--------------------------------------------------------------------------
  # * Set steal items
  #     user : user
  #     ext  : steal action extensio
  #--------------------------------------------------------------------------
  def stole_item_set(user, ext)
    return false unless ext != nil
    @item_stole = @item_to_steal = @stole_item_index = nil
    steal_success = rand(100) < (Steal_Rate + self.steal_attempt) * user.agi / self.agi
    self.steal_attempt += 1
    return nil if self.steal_items.nil? or self.steal_items == []
    return false unless steal_success
    @item_stole = []
    ext.slice!('STEAL/')
    self.steal_items.each do |item, steal_rate|
      item = item.split('')
      if item[0] == 'i' and not ext == 'GOLD'
        item = item.join
        item.slice!('i')
        @item_stole << $data_items[item.to_i] if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == 'a' and not ext == 'GOLD'
        item = item.join
        item.slice!('a')
        @item_stole << $data_armors[item.to_i] if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == 'w' and not ext == 'GOLD'
        item = item.join
        item.slice!('w')
        @item_stole << $data_weapons[item.to_i] if rand(1000) < (steal_rate * 10).to_i
      elsif item[0] == 'g' and not ext == 'ITEM'
        item = item.join
        item.slice!('g')
        @item_stole << item.to_i if rand(1000) < (steal_rate * 10).to_i
      end
    end
    return false if @item_stole == []
    self.steal_attempt = 0
    @stole_item_index = rand(@item_stole.size)
    @item_to_steal = @item_stole[@stole_item_index]
    if Multi_Steal
      self.steal_items.delete_at(@stole_item_index)
    else
      self.steal_items = []
    end
    return @item_to_steal
  end
  #--------------------------------------------------------------------------
  # * Make Action
  #--------------------------------------------------------------------------
  def make_action
    self.current_action.clear
    return unless self.movable?
    available_actions = []
    rating_max = 0
    for action in self.actions
      n = get_battle_turn
      a = action.condition_turn_a
      b = action.condition_turn_b
      next if (b == 0 and n != a) or (b > 0 and (n < 1 or n < a or n % b != a % b))
      next if self.hp * 100.0 / self.maxhp > action.condition_hp
      next if $game_party.max_level < action.condition_level
      switch_id = action.condition_switch_id
      next if switch_id > 0 and $game_switches[switch_id] == false
      next if action.kind == 1 and not skill_can_use?(action.skill_id) and Enemy_Dont_Skip_Action
      available_actions.push << action
      rating_max = [rating_max, action.rating].max
    end
    ratings_total = 0
    for action in available_actions
      ratings_total += action.rating - (rating_max - 3)  if action.rating > rating_max - 3
    end
    if ratings_total > 0
      value = rand(ratings_total)
      for action in available_actions
        if action.rating > rating_max - 3
          if value < action.rating - (rating_max - 3)
            self.current_action.kind = action.kind
            self.current_action.basic = action.basic
            self.current_action.skill_id = action.skill_id
            self.current_action.decide_random_target_for_enemy
            return
          else
            value -= action.rating - (rating_max - 3)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Turn
  #--------------------------------------------------------------------------
  def get_battle_turn
    return $game_temp.battle_turn
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen X-Coordinate
  #--------------------------------------------------------------------------
  def screen_x
    return $data_troops[@troop_id].members[@member_index].x + Enemy_Position_AdjustX
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Y-Coordinate
  #--------------------------------------------------------------------------
  def screen_y
    return $data_troops[@troop_id].members[@member_index].y + Enemy_Position_AdjustY
  end
  #--------------------------------------------------------------------------
  # * Get Battle Screen Z-Coordinate
  #--------------------------------------------------------------------------
  def screen_z
    return screen_y
  end
end