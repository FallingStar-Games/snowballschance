#==============================================================================
# ** Throw_Sprite
#------------------------------------------------------------------------------
#  This sprite is used to display throw animations.
#==============================================================================

class Throw_Sprite < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :active_battler       # active battler
  attr_accessor :target_battler       # target battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport      : viewport
  #     obj           : object setting
  #     active        : active battler
  #     active_sprite : active battler sprite
  #     target        : target battler
  #     target_sprite : target battler sprite
  #     returning     : return flag
  #--------------------------------------------------------------------------
  def initialize(viewport, obj, active, active_sprite, target, target_sprite, returning)
    super(viewport)
    set_throw_object(obj, active, active_sprite, target, target_sprite) unless returning
    set_throw_return(obj, active, active_sprite, target, target_sprite) if returning
  end
  #--------------------------------------------------------------------------
  # * Set throw animation
  #     obj           : object setting
  #     active        : active battler
  #     active_sprite : active battler sprite
  #     target        : target battler
  #     target_sprite : target battler sprite
  #--------------------------------------------------------------------------
  def set_throw_object(obj, active, active_sprite, target, target_sprite)
    pose = Pose_Sprite[active.battler_name]
    if pose and pose['ThrowStart'] != nil and pose['ThrowStart'][active.pose_id] != nil
      pose_value = pose['ThrowStart'][active.pose_id]
      base_throw = [pose_value[0],pose_value[1]]
    else
      base_throw = [obj[7],obj[8]]
    end
    @throw_curve = obj[1]
    @active_battler = active
    @target_battler = target
    @target_sprite = target_sprite
    @active_sprite = active_sprite
    @throw_speed = obj[6].nil? ? 300 : obj[6]
    @throw_adjust = [base_throw[0],base_throw[1],obj[9],obj[10]]
    case active.direction
    when 2 then loop_animation($data_animations[obj[2]])
    when 4 then loop_animation($data_animations[obj[3]])
    when 6 then loop_animation($data_animations[obj[4]])
    when 8 then loop_animation($data_animations[obj[5]])
    end
    @boomerang = false
    set_throw_init_postion
    set_throw_end_position
    throw_arc_init
    update
  end
  #--------------------------------------------------------------------------
  # * Check throw end
  #--------------------------------------------------------------------------
  def throw_end
    return (@target_x == @actual_x and @target_y == @actual_y)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    loop_animation(nil)
    super
  end
  #--------------------------------------------------------------------------
  # * Set throw initial position
  #--------------------------------------------------------------------------
  def set_throw_init_postion
    x = @throw_adjust[0].nil? ? 0 : @throw_adjust[0]
    y = @throw_adjust[1].nil? ? 0 : @throw_adjust[1]
    @arc_ajdust = 0
    self.x = @active_sprite.x - @active_sprite.ox + @active_sprite.center_x + x
    self.y = @active_sprite.y - @active_sprite.oy + @active_sprite.center_y + y
    @init_x = @actual_x = self.x
    @init_y = @actual_y = self.y
  end
  #--------------------------------------------------------------------------
  # * Set throw end position
  #--------------------------------------------------------------------------
  def set_throw_end_position
    x = @throw_adjust[2].nil? ? 0 : @throw_adjust[2]
    y = @throw_adjust[3].nil? ? 0 : @throw_adjust[3]
    @target_x = @target_sprite.x - @target_sprite.ox + @target_sprite.center_x + x
    @target_y = @target_sprite.y - @target_sprite.oy + @target_sprite.center_y + y
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    update_position
    fix_current_position
    update_current_position
  end
  #--------------------------------------------------------------------------
  # * Position update
  #--------------------------------------------------------------------------
  def update_position
    if @target_x != @actual_x or @target_y != @actual_y
      speed = set_speed
      distance_x = @target_x - @actual_x
      distance_y = @target_y - @actual_y
      @move_x = @move_y = 1
      if distance_x.abs < distance_y.abs
        @move_x = 1.0 / (distance_y.abs.to_f / distance_x.abs)
      elsif distance_y.abs < distance_x.abs
        @move_y = 1.0 / (distance_x.abs.to_f / distance_y.abs)
      end
      speed_x = speed * (distance_x > 0 ? 8 : -8)
      speed_y = speed * (distance_y > 0 ? 8 : -8)
      @actual_x += (@move_x * speed_x).to_i
      @actual_y += (@move_y * speed_y).to_i
      update_arc
    end
  end
  #--------------------------------------------------------------------------
  # * Update throw arc
  #--------------------------------------------------------------------------
  def update_arc
    if @arc_count > 0
      @arc_count -= @throw_speed / 200.0
      if @arc_count >= @arc_peak
        n = @arc_count - @arc_peak
      else
        n = @arc_peak - @arc_count
      end
      @arc_ajdust = (((@arc_peak ** 2) - (n ** 2)) * 3/ 2).to_i
    end
  end
  #--------------------------------------------------------------------------
  # * Fix current position
  #--------------------------------------------------------------------------
  def fix_current_position
    @actual_x = @target_x if not_in_distance(@actual_x, @target_x, @init_x)
    @actual_y = @target_y if not_in_distance(@actual_y, @target_y, @init_y)
  end
  #--------------------------------------------------------------------------
  # * Current position update
  #--------------------------------------------------------------------------
  def update_current_position
    self.x = @actual_x
    if @boomerang
      self.y = [@actual_y + @arc_ajdust, @actual_y].max
    else
      self.y = [@actual_y - @arc_ajdust, @actual_y].min
    end
    self.z = self.y + 100
  end
  #--------------------------------------------------------------------------
  # * Ger throw sprite
  #--------------------------------------------------------------------------
  def set_speed
    return @throw_speed / 100.0
  end
  #--------------------------------------------------------------------------
  # * Check positions
  #     x : current position
  #     y : target position
  #     z : final position
  #--------------------------------------------------------------------------
  def not_in_distance(x, y, z)
    return ((y < z and not x.between?(y, z)) or (y > z and not x.between?(z, y)))
  end
  #--------------------------------------------------------------------------
  # * Set throw arc init
  #--------------------------------------------------------------------------
  def throw_arc_init
    x_plus = ((@init_x.to_f - @target_x.to_f) / 32).abs
    y_plus = ((@init_y.to_f - @target_y.to_f) / 32).abs
    @arc_peak = Math.sqrt(((x_plus ** 2) + (y_plus ** 2))).to_f * @throw_curve / 10.0
    @arc_count = @arc_peak * 2 
  end
  #--------------------------------------------------------------------------
  # * Set throw return animation
  #     obj           : object setting
  #     active        : active battler
  #     active_sprite : active battler sprite
  #     target        : target battler
  #     target_sprite : target battler sprite
  #--------------------------------------------------------------------------
  def set_throw_return(obj, active, active_sprite, target, target_sprite)
    @throw_curve = obj[1]
    @active_battler = active
    @target_battler = target
    @target_sprite = target_sprite
    @active_sprite = active_sprite
    @throw_speed = obj[6].nil? ? 300 : obj[6]
    @throw_adjust = [obj[7],obj[8],obj[9],obj[10]]
    case active.direction
    when 2 then loop_animation($data_animations[obj[5]])
    when 4 then loop_animation($data_animations[obj[4]])
    when 6 then loop_animation($data_animations[obj[3]])
    when 8 then loop_animation($data_animations[obj[2]])
    end
    @boomerang = true
    set_ret_init_postion
    set_ret_end_position
    throw_arc_init
    update
  end
  #--------------------------------------------------------------------------
  # * Set return end position
  #--------------------------------------------------------------------------
  def set_ret_end_position
    x = @throw_adjust[0].nil? ? 0 : @throw_adjust[0]
    y = @throw_adjust[1].nil? ? 0 : @throw_adjust[1]
    @target_x = @active_sprite.x - @active_sprite.ox + @active_sprite.center_x + x
    @target_y = @active_sprite.y - @active_sprite.oy + @active_sprite.center_y + y
    @arc_ajdust = 0
  end
  #--------------------------------------------------------------------------
  # * Ser return start position
  #--------------------------------------------------------------------------
  def set_ret_init_postion
    x = @throw_adjust[2].nil? ? 0 : @throw_adjust[2]
    y = @throw_adjust[3].nil? ? 0 : @throw_adjust[3]
    self.x = @target_sprite.x - @target_sprite.ox + @target_sprite.center_x + x
    self.y = @target_sprite.y - @target_sprite.oy + @target_sprite.center_y + y
    @init_x = @actual_x = self.x
    @init_y = @actual_y = self.y
  end
  #--------------------------------------------------------------------------
  # * Update loop animation
  #--------------------------------------------------------------------------
  def update_loop_animation
    if Graphics.frame_count % 2 == 0
      @_loop_animation_index += 1
      @_loop_animation_index %= @_loop_animation.frame_max
    end
    frame_index = @_loop_animation_index % @_loop_animation.frame_max
    cell_data = @_loop_animation.frames[frame_index].cell_data
    position = @_loop_animation.position
    animation_set_sprites(@_loop_animation_sprites, cell_data, position, @_loop_animation)
    for timing in @_loop_animation.timings
      animation_process_timing(timing, true) if timing.frame == frame_index
    end
  end
end

#==============================================================================
# ** Mirage_Sprite
#------------------------------------------------------------------------------
#  This sprite is used to display mirage effects
#==============================================================================

class Mirage_Sprite < RPG::Sprite
  #--------------------------------------------------------------------------
  attr_accessor :mirage_count
end
