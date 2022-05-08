#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :dmg_mirror              # Damage exhibition inversion
  attr_accessor :move_pose               # move pose flag
  attr_accessor :jump_count              # jump count
  attr_accessor :pattern                 # pose pattern value
  attr_accessor :name_init               # batter name initial character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible =  false
    @battler_mirror = false
    @fast_appear = (Show_Graphics_Transition and not @battler.hidden and not @battler.invisible)
    @dmg_mirror = false
    @animated = false
    @can_move = false
    @moving = false
    @move_set = false
    @move_pose = false
    @reste_idle_anim = false
    @update_base_position = false
    @battler.defense_pose = false
    @battler.idle_pose = true
    @battler.move_pose = false
    @dead = true if @battler.dead?
    @start_dead = @battler.dead?
    @throw_object = []
    @mirage = []
    @battler.pose_id = 0
    @battler.state_animation_id = 0
    @jump_adjust = 0
    @pattern = 1
    @delay = 0
    @frames = 1
    @frame_delay = 0
    @current_frame = 0
    @shadow_ajust_x = 0
    @shadow_ajust_y = 0
    @jump_count = 0
    @bounce_count = 0
    @mirage_count = 0
    @shake_x = 0
    @shake_y = 0
    @actual_x = @battler.actual_x
    @actual_y = @battler.actual_y
    default_battler_direction
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias acbs_dispose_sprite dispose
  def dispose
    @shadow.dispose if @shadow != nil
    acbs_dispose_sprite
  end  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    return self.bitmap = nil && loop_animation(nil) && pose_animation(nil) if @battler.nil?
    update_battler_bitmap
    update_current_frame
    update_base_position
    update_move_anim
    update_movement
    update_damage
    update_moving
    update_effect
    update_position
    update_idle_anim
    update_pose
    update_throw
  end
  #--------------------------------------------------------------------------
  # * Battler bitmap update
  #--------------------------------------------------------------------------
  def update_battler_bitmap
    make_battler_change if battler_change_verification
  end
  #--------------------------------------------------------------------------
  # * Check battler change
  #--------------------------------------------------------------------------
  def battler_change_verification
    return true if @battler.battler_name != @battler_name
    return true if @battler.battler_hue != @battler_hue
    return true if @battler.direction != @battler_direction
    return false
  end
  #--------------------------------------------------------------------------
  # * Make battler change
  #--------------------------------------------------------------------------
  def make_battler_change
    @battler_name = @battler.battler_name
    @battler_hue = @battler.battler_hue
    @battler_direction = @battler.direction
    set_name_init
    set_graphic_bitmap
    set_battler_patterns
    set_frame_dimensions
    set_bitmap_rect 
    set_shadow_bitmap
    update_current_frame(true)
  end
  #--------------------------------------------------------------------------
  # * Battler position update
  #--------------------------------------------------------------------------
  def update_position
    self.x = actual_x_position
    self.y = actual_y_position
    self.z = @actual_z + (@battler.action? ? 1 : 0)
    update_shadow if @shadow != nil
    self.mirror = @battler_mirror
    self.mirror = Invert_All_Battlers ? (self.mirror ? false : true) : self.mirror
  end
  #--------------------------------------------------------------------------
  # * Get battler real X postion
  #--------------------------------------------------------------------------
  def actual_x_position
    return @actual_x + set_adjust[0]
  end
  #--------------------------------------------------------------------------
  # * Get battler real Y postion
  #--------------------------------------------------------------------------
  def actual_y_position
    return @actual_y + set_adjust[1]
  end
  #--------------------------------------------------------------------------
  # * Battler effects update
  #--------------------------------------------------------------------------
  def update_effect
    update_mirage_effect
    update_state_animation
    update_blink_effect if @battler_visible
    update_fast_appear if @fast_appear and not @battler_visible and not @battler.invisible
    update_battler_appear unless @battler_visible
    update_invisible_effect if @battler_visible and @battler.invisible
    update_escape_effect if @battler_visible and @battler.hidden
    update_white_flash if @battler_visible and @battler.white_flash
    update_battler_animation if @battler_visible and @battler.animation_id != 0
    update_damage_pop if @battler_visible and @battler.damage_pop
    update_collapse_effect if @battler_visible
  end
  #--------------------------------------------------------------------------
  # * Migare effect update
  #--------------------------------------------------------------------------
  def update_mirage_effect
    update_mirage if @mirage.nitems > 0
    mirage_init if @battler.mirage and not @mirage_init
    @mirage_init = false if @mirage_init and not @battler.mirage
  end
  #--------------------------------------------------------------------------
  # * State animation update
  #--------------------------------------------------------------------------
  def update_state_animation
    if @battler_states != @battler.states
      @battler_states = @battler.states.dup
      @battler.state_animation_id = @battler.state_animation_update
    end
    if @battler_visible and @battler.state_animation_id != @state_animation_id
      @state_animation_id = @battler.state_animation_id
      loop_animation($data_animations[@state_animation_id])
    end
  end
  #--------------------------------------------------------------------------
  # * Blink effect update
  #--------------------------------------------------------------------------
  def update_blink_effect
    if @battler.blink
      blink_on
    else
      blink_off
    end
  end
  #--------------------------------------------------------------------------
  # * Fast appear effect update
  #--------------------------------------------------------------------------
  def update_fast_appear
    fast_appear
    @fast_appear = false
    @battler_visible = true
  end
  #--------------------------------------------------------------------------
  # * Appear effect update
  #--------------------------------------------------------------------------
  def update_battler_appear
    if not @battler.hidden and not @battler.invisible and not (@battler.dead? and not
        check_include(@battler, 'NOCOLLAPSE'))
      appear
      @battler_visible = true
    end
  end
  #--------------------------------------------------------------------------
  # * Invisible effect update
  #--------------------------------------------------------------------------
  def update_invisible_effect
    disappear
    @battler_visible = false
  end
  #--------------------------------------------------------------------------
  # * Escape effect update
  #--------------------------------------------------------------------------
  def update_escape_effect
    $game_system.se_play($data_system.escape_se)
    escape
    @battler_visible = false
  end
  #--------------------------------------------------------------------------
  # * White flash effect update
  #--------------------------------------------------------------------------
  def update_white_flash
    whiten
    @battler.white_flash = false
  end
  #--------------------------------------------------------------------------
  # * Battler animation update
  #--------------------------------------------------------------------------
  def update_battler_animation
    animation($data_animations[@battler.animation_id], @battler.animation_hit, @battler.animation_pos, @battler.animation_mirror)
    @battler.animation_id = 0
    @battler.animation_pos = nil
    @battler.animation_mirror = false
  end
  #--------------------------------------------------------------------------
  # * Damage pop update
  #--------------------------------------------------------------------------
  def update_damage_pop
    damage(@battler.damage, @battler.critical, @battler.sp_damage)
    @battler.damage = nil
    @battler.critical = false
    @battler.damage_pop = false
    @battler.sp_damage = false
  end
  #--------------------------------------------------------------------------
  # * Collapse effect update
  #--------------------------------------------------------------------------
  def update_collapse_effect
    if @battler.damage.nil? and @battler.dead? and not @battler.damaged
      unless @dead
        if check_bc_basic(@battler, 'COLLAPSE')
          battle_cry_basic(@battler, 'COLLAPSE') 
        else
          ext = check_extension(@battler, 'COLLAPSE/')
          if ext.nil?
            if @battler.is_a?(Game_Enemy)
              $game_system.se_play($data_system.enemy_collapse_se)
            else
              $game_system.se_play($data_system.actor_collapse_se)
            end
          end
        end
      end
      @battler.pose_id = set_idle_pose unless @dead
      unless check_include(@battler, 'NOCOLLAPSE')
        collapse
        @battler_visible = false
      end
      @dead = true
    else
      if @dead
        @reste_idle_anim = true
        @move_pose = false
        update_idle_anim
        @battler.target_x = @battler.base_x
        @battler.target_y = @battler.base_y
        @battler.move_pose = true if @battler.moving?
      end
      @dead = false
    end
  end
  #--------------------------------------------------------------------------
  # * Set name initial
  #--------------------------------------------------------------------------
  def set_name_init
    name = @battler_name.dup
    name = name.split('')
    @name_init = name[0]
  end
  #--------------------------------------------------------------------------
  # * Set graphic bitmap
  #--------------------------------------------------------------------------
  def set_graphic_bitmap
    dir = Battle_Style == 3 ? set_battler_direction : ''
    if @name_init == '%'
      begin
        self.bitmap = RPG::Cache.battler(@battler_name + dir + '_' + @pattern, @battler_hue)
      rescue
        self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
      end
    else
      begin
        self.bitmap = RPG::Cache.battler(@battler_name + dir, @battler_hue)
      rescue
        self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set battler direction sufix
  #--------------------------------------------------------------------------
  def set_battler_direction
    case @battler_direction
    when 2
      return '_down'
    when 8
      return '_up'
    end
    return ''
  end
  #--------------------------------------------------------------------------
  # * Set bitmap rectangle
  #--------------------------------------------------------------------------
  def set_bitmap_rect
    return if @_collapse_duration > 0
    self.ox = @frame_width / 2
    self.oy = @frame_height
    self.opacity = 0 if @battler.hidden
    self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height)
  end
  #--------------------------------------------------------------------------
  # * Set fame dimensions
  #--------------------------------------------------------------------------
  def set_frame_dimensions
    if @name_init == '%'
      @frame_width = self.bitmap.width / @frames
      @frame_height = self.bitmap.height
    elsif @name_init == '$'
      @frame_width = self.bitmap.width
      @frame_height = self.bitmap.height
    else
      @frame_width = self.bitmap.width / @b_frames
      @frame_height = self.bitmap.height / @b_poses
    end
  end
  #--------------------------------------------------------------------------
  # * Set battle base pattern
  #--------------------------------------------------------------------------
  def set_battler_patterns
    set_base_pose
    @b_frames = @battler_pose_base[0]
    @b_poses = @battler_pose_base[1]
    @base_move_speed = @battler_pose_base[2]
    pose_direction
  end
  #--------------------------------------------------------------------------
  # * Set battler graphic name
  #--------------------------------------------------------------------------
  def set_battler_name
    return @battler_name
  end
  #--------------------------------------------------------------------------
  # * Set battler base pose
  #--------------------------------------------------------------------------
  def set_base_pose
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name]['Base'] != nil
      @battler_pose_base = Pose_Sprite[name]['Base'].dup
    else
      @battler_pose_base = Base_Sprite_Settings['Base'].dup
    end
  end  
  #--------------------------------------------------------------------------
  # * Set pose direction
  #--------------------------------------------------------------------------
  def pose_direction
    mirror = @battler_pose_base.last
    @battler_mirror = @battler_direction == 4 ? (mirror ? true : false) : (mirror ? false : true)
    @battler_mirror = (mirror ? true : false) if Battle_Style == 2 or @battler_direction == 2 or @battler_direction == 8
  end
  #--------------------------------------------------------------------------
  # * Get pose ID
  #     pose : pose name
  #--------------------------------------------------------------------------
  def set_pose_id(pose)
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name][pose] != nil
      return Pose_Sprite[name][pose]
    end
    return eval("#{pose}_Pose")
  end
  #--------------------------------------------------------------------------
  # * Get sprite X center
  #--------------------------------------------------------------------------
  def center_x
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name]['Center'] != nil
      pose = Pose_Sprite[name]['Center'].dup
      return pose[@battler.pose_id][0] if pose[@battler.pose_id] != nil
      return pose['Base'][0] if pose['Base'] != nil
    end
    return @frame_width / 2
  end
  #--------------------------------------------------------------------------
  # * Get sprite Y center
  #--------------------------------------------------------------------------
  def center_y
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name]['Center'] != nil
      pose = Pose_Sprite[_name]['Center'].dup
      return pose[@battler.pose_id][1] if pose[@battler.pose_id] != nil
      return pose['Base'][1] if pose['Base'] != nil
    end
    return @frame_height / 2
  end
  #--------------------------------------------------------------------------
  # * Set shadow bitmap
  #--------------------------------------------------------------------------
  def set_shadow_bitmap
    battler_shadow
    if @shadow.nil? and @shadow_name != ''
      @shadow = Sprite.new(viewport)
      @shadow.bitmap = RPG::Cache.battler(@shadow_name, 0)
    elsif @shadow != nil and @shadow_name != ''
      @shadow.bitmap = RPG::Cache.battler(@shadow_name, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Set shadow position
  #--------------------------------------------------------------------------
  def battler_shadow
    shadow = set_shadow
    if shadow != nil
      @shadow_name = shadow[0]
      @shadow_ajust_x = shadow[1].nil? ? 0 : shadow[1].to_i
      @shadow_ajust_y = shadow[2].nil? ? 0 : shadow[2].to_i
    else
      @shadow_name = ''
      @shadow_ajust_x = @shadow_ajust_y = 0
    end
  end  
  #--------------------------------------------------------------------------
  # * Verify shadow
  #--------------------------------------------------------------------------
  def set_shadow
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name]['Shadow'] != nil
      return Pose_Sprite[name]['Shadow'].dup
    elsif Base_Sprite_Settings['Shadow'] != nil
      return Base_Sprite_Settings['Shadow'].dup
    elsif All_Shadow
      return Default_Shadow.dup
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Get position adjust
  #--------------------------------------------------------------------------
  def set_adjust
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name]['Adjust'] != nil
      return Pose_Sprite[name]['Adjust'].dup
    elsif Base_Sprite_Settings['Adjust'] != nil
      return Base_Sprite_Settings['Adjust'].dup
    end
    return [0,0]
  end  
  #--------------------------------------------------------------------------
  # * Battler shadow update
  #--------------------------------------------------------------------------
  def update_shadow
    @shadow.ox = @shadow.bitmap.width / 2 - @shadow_ajust_x
    @shadow.oy = @shadow.bitmap.height - @shadow_ajust_y
    @shadow.x = @battler.actual_x
    @shadow.y = @battler.actual_y
    @shadow.z = @shadow.y - 32
    @shadow.opacity = self.opacity - (self.opacity * @jump_adjust / 250.0)
    @shadow.zoom_x = @frame_width * 0.5 / @shadow.bitmap.width
  end
  #--------------------------------------------------------------------------
  # * Battler pose update
  #--------------------------------------------------------------------------
  def update_pose
    if @battler.pose_id != @old_pose
      @old_pose = @battler.pose_id
      change_pose(@battler.pose_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Idle pose update
  #--------------------------------------------------------------------------
  def update_idle_anim
    return unless @battler.pose_sequence.empty?
    @battler.pose_id = set_idle_pose if @battler.idle_pose or @reste_idle_anim
    @battler.pose_id = set_move_pose if @move_pose and @battler.moving?
  end
  #--------------------------------------------------------------------------
  # * Get movement pose ID
  #--------------------------------------------------------------------------
  def set_move_pose
    action = @battler.now_action.nil? ? @battler : @battler.now_action
    ext = check_extension(action, @battler.returning? ? 'RETPOSE/' : 'ADVPOSE/')
    if ext != nil
      ext.slice!(@battler.returning? ? 'RETPOSE/' : 'ADVPOSE/')
      return ext.to_i
    else
      return set_pose_id(@battler.returning? ? 'Return' : 'Advance')
    end
  end
  #--------------------------------------------------------------------------
  # * Get idle pose ID
  #--------------------------------------------------------------------------
  def set_idle_pose
    @reste_idle_anim = false
    if @battler.dead? and check_include(@battler, 'NOCOLLAPSE')
      return set_pose_id('Dead') 
    end
    if $game_temp.battle_victory and @battler.actor? and not @battler.restriction == 4
      pose = set_pose_id('Victory')
      return pose unless pose.nil?
    end
    if $game_temp.party_escaped and @battler.actor? and not @battler.restriction == 4
      pose = set_pose_id('Escape')
      return pose unless pose.nil?
    end
    if @battler.damaged and not @battler.restriction == 4
      return pose = set_pose_id('Hurt')
    end
    if @battler.evaded and not @battler.restriction == 4
      if Danger_Evade_Pose != nil and  @battler.in_danger? and not 
         check_include(@battler, 'NODANGER')
        return set_pose_id('Danger_Evade')
      end
      for i in @battler.states
        if Danger_Evade_Pose != nil and States_Pose[i] == Danger_Pose
          return set_pose_id('Danger_Evade')
        end
      end
      return pose = set_pose_id('Evade')
    end
    if @battler.defense_pose and not @battler.restriction == 4
      if Danger_Defense_Pose != nil and  @battler.in_danger? and not 
         check_include(@battler, 'NODANGER')
        return set_pose_id('Danger_Defense')
      end
      for i in @battler.states
        if Danger_Defense_Pose != nil and States_Pose[i] == Danger_Pose
          return set_pose_id('Danger_Defense')
        end
      end
      return set_pose_id('Defense')
    end
    for i in @battler.states
      return States_Pose[i] unless States_Pose[i].nil? or @battler.active? or @battler.action?
    end
    if Intro_Pose != nil and $game_temp.battle_start and (@battler.actor? or
       (!@battler.actor? and check_include(battler, 'ENEMYINTRO')))
      return set_pose_id('Intro')
    end
    if @battler.in_danger? and not check_include(@battler, 'NODANGER') and not
       @battler.active? and not @battler.action?
      return set_pose_id('Danger')
    end
    return set_pose_id('Idle')
  end
  #--------------------------------------------------------------------------
  # * Pose change
  #     n : pose ID
  #--------------------------------------------------------------------------
  def change_pose(n)
    n = n.nil? ? 1 : n
    pose = battler_pose(n)
    return if pose.nil?
    set_frame_dimensions
    if @name_init == '$'
      change_individual
    elsif @name_init == '%'
      change_multi(pose[0], pose[1], n, pose[2], pose[3])
    else
      change_normal(pose[0], pose[1], @frame_height * (n - 1), pose[2],pose[3])
    end
  end
  #--------------------------------------------------------------------------
  # * Get battler pose values
  #     pose : ID da pose
  #--------------------------------------------------------------------------
  def battler_pose(pose)
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Sprite[name] != nil and Pose_Sprite[name][pose] != nil
      return Pose_Sprite[name][pose]
    end
    return Base_Sprite_Settings[pose] if Base_Sprite_Settings[pose] != nil
    return nil
  end
  #--------------------------------------------------------------------------
  # * Normal battler change pose
  #     frames : number of frames of the pose
  #     delay  : time between the frame change
  #     offy   : postion of the frame rectange
  #     loop   : pose repeat flag
  #     speed  : pose move speed
  #--------------------------------------------------------------------------
  def change_normal(frames = 1, delay = 8, offy = 0, loop = true, speed = nil)
    @frames = [frames, 1].max
    @delay = delay
    @frame_delay = @delay
    @current_frame = 0
    @old_delay = Graphics.frame_count
    @loop = loop
    @pose_move_speed = speed
    @offset_x = @current_frame * @frame_width
    @offset_y = offy
    @animated = true
    update_current_frame(true)
  end
  #--------------------------------------------------------------------------
  # * Multi graphics battle change pose
  #     frames : number of frames of the pose
  #     delay  : time between the frame change
  #     number : pose ID
  #     loop   : pose repeat flag
  #     speed  : pose move speed
  #--------------------------------------------------------------------------
  def change_multi(frames = 1, delay = 0,  number = 1, loop = true, speed = nil)
    @pattern = number.to_s
    uptade_battler_multi_bitmap
    @frames = [frames, 1].max
    @delay = delay
    @frame_delay = @delay
    @current_frame = 0
    @pose_move_speed = speed
    @loop = loop
    @offset_x = @current_frame * @frame_width
    @offset_y = 0
    @animated = true
    update_current_frame(true)
  end
  #--------------------------------------------------------------------------
  # * Bitmap update for multi graphics battlers
  #--------------------------------------------------------------------------
  def uptade_battler_multi_bitmap
    dir = Battle_Style == 3 ? set_battler_direction : ''
    begin
      self.bitmap = RPG::Cache.battler(@battler_name + dir + '_' + @pattern, @battler_hue)
    rescue
      self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
    end
  end
  #--------------------------------------------------------------------------
  # * Individual battler change pose
  #--------------------------------------------------------------------------
  def change_individual
    self.bitmap = RPG::Cache.battler(@battler_name, @battler_hue)
    @offset_x = @offset_y = 0
    @animated = true
    update_current_frame(true)
  end
  #--------------------------------------------------------------------------
  # * Current frame update
  #     forced : forced update flag
  #--------------------------------------------------------------------------
  def update_current_frame(forced = false)
    set_pose_animtion
    if self.bitmap != nil and ((@frame_delay == 0 and @animated) or forced)
      if @start_dead
        @current_frame = @frames - 1
        @start_dead = false
      end
      set_pose_sound
      @frame_delay = @delay
      @offset_x = @current_frame * @frame_width
      set_bitmap_rect
      @current_frame += 1 unless @frames == 0
      @animated = @loop if @current_frame == @frames
      @current_frame %= @frames
    end
    update_current_pose_sequence
    @frame_delay = [@frame_delay - 1, 0].max
  end
  #--------------------------------------------------------------------------
  # * Set animation for poses
  #--------------------------------------------------------------------------
  def set_pose_animtion
    if current_pose_anim != nil and current_pose_anim[@current_frame + 1] != nil
      pose_animation($data_animations[current_pose_anim[@current_frame + 1][0]])
      @current_pose_anim = current_pose_anim
      @pose_anim_singe_loop = !current_pose_anim[@current_frame + 1][1]
    end
  end
  #--------------------------------------------------------------------------
  # * Pose sequence update
  #--------------------------------------------------------------------------
  def update_current_pose_sequence
    if @current_frame == 0 and @frame_delay == 0 and not
       @battler.pose_sequence.empty? and not @battler.pose_sequence.first == 0
      @battler.pose_id = @battler.pose_sequence.shift
    end
  end
  #--------------------------------------------------------------------------
  # * Get current pose sound
  #--------------------------------------------------------------------------
  def current_pose_sound
    return nil if @battler.nil?
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Battle_Cry[name] != nil
      pose = Pose_Battle_Cry[name][@battler.pose_id]
      return pose if pose != nil
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Play current pose sound
  #--------------------------------------------------------------------------
  def set_pose_sound
    if current_pose_sound != nil and current_pose_sound[@current_frame + 1] != nil
      sound = current_pose_sound[@current_frame + 1]
      $game_system.se_play(RPG::AudioFile.new(sound[0], sound[1], sound[2]))
    end
  end
  #--------------------------------------------------------------------------
  # * Set default battler direction
  #--------------------------------------------------------------------------
  def default_battler_direction
    battler_party = @battler.actor? ? $game_troop : $game_party
    avg_x = battler_party.avarage_position[0]
    avg_y = battler_party.avarage_position[1]
    relative_x = @battler.base_x - avg_x
    relative_y = @battler.base_y - avg_y
    if relative_y.abs > relative_x.abs and Battle_Style > 1
      @battler.direction = relative_y < 0 ? 2 : 8
    elsif relative_x.abs >= relative_y.abs
      @battler.direction = relative_x < 0 ? 6 : 4
    end
  end
  #--------------------------------------------------------------------------
  # * Set current action direction
  #--------------------------------------------------------------------------
  def action_battler_direction
    battler_party = @battler.target_battlers
    avg_x = avg_y = 0
    for bt in battler_party
      avg_x += bt.actual_x
      avg_y += bt.actual_y
    end
    avg_x /= [battler_party.size, 1].max
    avg_y /= [battler_party.size, 1].max
    relative_x = @battler.actual_x - avg_x
    relative_y = @battler.actual_y - avg_y    
    if relative_y.abs > relative_x.abs and Battle_Style > 1
      @battler.direction = @battler.returning? ? (relative_y < 0 ? 8 : 2) : (relative_y < 0 ? 2 : 8) 
    elsif relative_x.abs >= relative_y.abs
      @battler.direction = @battler.returning? ? (relative_x < 0 ? 4 : 6) : (relative_x < 0 ? 6 : 4)
    end
  end
  #--------------------------------------------------------------------------
  # * Set battler direction based on the target point
  #--------------------------------------------------------------------------
  def face_battler_direction
    relative_x = @battler.actual_x - @battler.target_x
    relative_y = @battler.actual_y - @battler.target_y  
    if relative_y.abs > relative_x.abs and Battle_Style > 1
      @battler.direction = @battler.returning? ? (relative_y < 0 ? 8 : 2) : (relative_y < 0 ? 2 : 8) 
    elsif relative_x.abs >= relative_y.abs
      @battler.direction = @battler.returning? ? (relative_x < 0 ? 4 : 6) : (relative_x < 0 ? 6 : 4)
    end
  end
  #--------------------------------------------------------------------------
  # * Base pose update
  #--------------------------------------------------------------------------
  def update_base_position
    if (@battler.original_x != @battler.base_x or @battler.original_y != @battler.base_y) and not
       (@battler.active? or @battler.action?)
      @battler.target_x = @battler.original_x
      @battler.target_y = @battler.original_y
      @update_base_position = true
      @battler.move_pose = true
      @battler.idle_pose = false
      face_battler_direction
    end
  end
  #--------------------------------------------------------------------------
  # * Battler movement update
  #--------------------------------------------------------------------------
  def update_movement
    return if @battler.damaged or @battler.evaded or (@battler.move_pose and not @move_set)
    if @battler.attack_locked?
      @moving = false
      @move_pose = false
      @locked_during_move = true
      @battler.idle_pose = true
      @battler.move_pose = false
      update_idle_anim
      return
    elsif @locked_during_move and not @battler.attack_locked?
      @moving = true
      @locked_during_move = false
      @move_pose = true
      @battler.idle_pose = false
      @battler.move_pose = true
    end
    reset_position
    if @battler.target_x != @battler.actual_x or @battler.target_y != @battler.actual_y or
       @jump_count > 0
      update_move_postion
      update_move_jump
    end
  end
  #--------------------------------------------------------------------------
  # * Reset position
  #--------------------------------------------------------------------------
  def reset_position
    if (@battler.actual_x != @battler.base_x or @battler.actual_y != @battler.base_y) and not
       (@battler.active? or @battler.action? or @battler.returning? or @battler.moving? or
        @battler.escaping? or @battler.freeze or @battler.rising or @battler.rised or
        @battler.lifted or @battler.lifting or @battler.heavy_fall > 0 or 
        @battler.dmgwait > 0 or @battler.damage_count > 0 or @battler.shaking > 0 or
        @bounce_count > 0 or @jump_adjust > 0)
      @battler.target_x = @battler.base_x
      @battler.target_y = @battler.base_y
      @battler.move_pose = true
    end
  end
  #--------------------------------------------------------------------------
  # * Battler move postion update
  #--------------------------------------------------------------------------
  def update_move_postion
    @moving = true
    @battler.idle_pose = false
    @move_speed = set_move_speed
    speed = @move_speed / 100.0
    @distance_x = @battler.target_x - @battler.actual_x
    @distance_y = @battler.target_y - @battler.actual_y
    @move_x = @move_y = 1
    if @distance_x.abs < @distance_y.abs
      @move_x = 1.0 / (@distance_y.abs.to_f / @distance_x.abs)
    elsif @distance_y.abs < @distance_x.abs
      @move_y = 1.0 / (@distance_x.abs.to_f / @distance_y.abs)
    end
    @speed_x = speed * (@distance_x == 0 ? 0 : (@distance_x > 0 ? 8 : -8))
    @speed_y = speed * (@distance_y == 0 ? 0 : (@distance_y > 0 ? 8 : -8))
    @battler.actual_x += (@move_x * @speed_x).round
    @battler.actual_y += (@move_y * @speed_y).round
    if @battler.teleport_to_target
      @battler.actual_x = @battler.target_x
      @battler.actual_y = @battler.target_y
      @battler.teleport_to_target = false
    end
  end
  #--------------------------------------------------------------------------
  # * Battler jump position update
  #--------------------------------------------------------------------------
  def update_move_jump
    if (@battler.jumping > 0 or @jump_count > 0 or @jump_adjust > 0) and not @battler.lifted
      @jump_count = [@jump_count - set_jump_speed, 0].max.to_f
      if @jump_count >= @jump_peak
        n = @jump_count - @jump_peak
      else
        return @battler.lifted = true if @battler.lifting
        n = @jump_peak - @jump_count
      end
      adj = @jump_action ? 20 : @battler.jumping
      @jump_adjust = (((@jump_peak ** 2) - (n ** 2)) * adj / 20).to_i
    end
    if @battler.heavy_fall > 0
      @jump_adjust = [@jump_adjust - @battler.heavy_fall, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # * Battler damage move update
  #--------------------------------------------------------------------------
  def update_damage
    @battler.evaded = false if @battler.evaded and @battler.damage_count == 0
    return unless @battler.damaged and @battler.dmgwait == 0
    if @battler.damage_x != @battler.hit_x or @battler.damage_y != @battler.hit_y or
       battler.bouncing > 0
      update_damage_postion
      update_damage_jump
    end
  end
  #--------------------------------------------------------------------------
  # * Battler damage position update
  #--------------------------------------------------------------------------
  def update_damage_postion
    speed = battler.bouncing ? 3.0 : battler.smashing ? 5.0 : 2.0
    @distance_x = @battler.damage_x - @battler.hit_x
    @distance_y = @battler.damage_y - @battler.hit_y
    @move_x = @move_y = 1
    if @distance_x.abs < @distance_y.abs
      @move_x = 1.0 / (@distance_y.abs.to_f / @distance_x.abs)
    elsif @distance_y.abs < @distance_x.abs
      @move_y = 1.0 / (@distance_x.abs.to_f / @distance_y.abs)
    end
    @speed_x = speed * (@distance_x == 0 ? 0 : (@distance_x > 0 ? 8 : -8))
    @speed_y = speed * (@distance_y == 0 ? 0 : (@distance_y > 0 ? 8 : -8))
    @battler.hit_x += (@move_x * @speed_x).round
    @battler.hit_y += (@move_y * @speed_y).round
  end
  #--------------------------------------------------------------------------
  # * Battler damage jump update
  #--------------------------------------------------------------------------
  def update_damage_jump
    if @battler.bouncing > 0 and @bounce_count > 0 and not 
       (@battler.rised or @battler.freeze or @battler.dmgwait > 0) 
      @bounce_count = [@bounce_count - 1, 0].max
      if @bounce_count >= @bounce_peak
        n = @bounce_count - @bounce_peak
      else
        return @battler.rised = true if @battler.rising
        n = @bounce_peak - @bounce_count
      end
      @jump_adjust = (((@bounce_peak ** 2) - (n ** 2)) / 2).to_i
    end
  end
  #--------------------------------------------------------------------------
  # * Movement update
  #--------------------------------------------------------------------------
  def update_moving
    if @battler.damaged or @battler.evaded
      @battler.damage_count = [@battler.damage_count - 1, 0].max
    end
    if @moving and not ((@battler.damaged or @battler.evaded) and not @battler.action?)
      update_normal_movement
      return
    elsif (@battler.damaged or @battler.shaking > 0) and not (@battler.freeze or @battler.rised) and not
       @battler.action?
      update_damage_movement
      return
    elsif (@battler.freeze or @battler.rised) and not @battler.dead?
      update_freeze_movement
      return
    else
      update_normal_position
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Check positions
  #     x : current position
  #     y : target position
  #     z : final position
  #--------------------------------------------------------------------------
  def not_in_distance(x, y, z)
    return (((y < z and not x.between?(y, z)) or (y > z and not x.between?(z, y))) or y == z)
  end
  #--------------------------------------------------------------------------
  # * Normal movement update
  #--------------------------------------------------------------------------
  def update_normal_movement
    @battler.action_one_target if @battler.battler_one_target != nil and @battler.moving?
    @battler.actual_x = @battler.target_x if not_in_distance(@battler.actual_x, @battler.target_x, @battler.initial_x)
    @battler.actual_y = @battler.target_y if not_in_distance(@battler.actual_y, @battler.target_y, @battler.initial_y)
    @actual_x = @battler.hit_x = @battler.damage_x = @battler.actual_x.to_i
    @actual_y = @battler.hit_y = @battler.damage_y = @battler.actual_y.to_i
    update_normal_position
    if @battler.actual_x == @battler.target_x and @battler.actual_y == @battler.target_y
      @battler.initial_x = @battler.actual_x
      @battler.initial_y = @battler.actual_y
      if @jump_count == 0 or @battler.lifted
        @moving = false
        @battler.battler_one_target = nil
        @battler.move_speed = 0
        @battler.jump_speed = 0
        unless @battler.lifted
          @battler.heavy_fall = 0
          @jump_adjust = 0
          @reste_idle_anim = @jump_action
          @jump_action = false
          @battler.jumping = 0
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Damage movement update
  #--------------------------------------------------------------------------
  def update_damage_movement
    @battler.hit_x = @battler.damage_x if not_in_distance(@battler.hit_x, @battler.damage_x, @battler.actual_x)
    @battler.hit_y = @battler.damage_y if not_in_distance(@battler.hit_y, @battler.damage_y, @battler.actual_y)
    @battler.dmgwait = [@battler.dmgwait - 1, 0].max
    @battler.shaking = [@battler.shaking - 1, 0].max
    update_shaking
    @actual_x = @battler.hit_x + @shake_x
    @actual_y = @battler.hit_y + @shake_y
    @actual_y = [@actual_y - @jump_adjust, @battler.actual_y].min
    @actual_z = @battler.actual_y
    if @battler.hit_x == @battler.damage_x and @battler.hit_y == @battler.damage_y
      @battler.initial_x = @battler.actual_x = @battler.hit_x
      @battler.initial_y = @battler.actual_y = @battler.hit_y
      if @battler.damage_count == 0 and @bounce_count == 0 and @battler.shaking == 0
        @battler.bouncing = 0
        @battler.damaged = false
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Normal position update
  #--------------------------------------------------------------------------
  def update_normal_position
    @actual_x = @battler.actual_x
    @actual_y = @battler.actual_y
    @actual_y = [@actual_y - @jump_adjust, @battler.actual_y].min
    @actual_z = @battler.actual_y
  end
  #--------------------------------------------------------------------------
  # * Shaking update
  #--------------------------------------------------------------------------
  def update_shaking
    if @battler.shaking > 0
      while @old_shake == [@shake_x, @shake_y]
        @shake_x = ((rand(4) + 1) * 3) - ((rand(4) + 1) * 3)
        @shake_y = ((rand(4) + 1) * 3) - ((rand(4) + 1) * 3)
      end
      @old_shake = [@shake_x, @shake_y]
    else
      @shake_x = 0
      @shake_y = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Freeze position update
  #--------------------------------------------------------------------------
  def update_freeze_movement
    @actual_x = @battler.hit_x
    @actual_y = @battler.hit_y
    @actual_y = [@actual_y - @jump_adjust, @battler.hit_y].min
    @actual_z = @battler.actual_y
  end
  #--------------------------------------------------------------------------
  # * Get move speed
  #--------------------------------------------------------------------------
  def set_move_speed
    return @battler.move_speed.to_f if @battler.move_speed != 0
    return @pose_move_speed.to_f if @pose_move_speed != nil
    return @base_move_speed.to_f
  end
  #--------------------------------------------------------------------------
  # * Get jump speed
  #--------------------------------------------------------------------------
  def set_jump_speed
    return (@battler.jump_speed / 100.0) if @battler.jump_speed != 0
    return 1
  end
  #--------------------------------------------------------------------------
  # * Move animation update
  #--------------------------------------------------------------------------
  def update_move_anim
    @battler.wait_time = [@battler.wait_time - 1, 0].max
    return if @battler.wait_time > 0 or @battler.dead?
    if @battler.moving? and @battler.move_pose and not @can_move
      movement_start_anim
    elsif @battler.moving? and @can_move and not @move_set
      move_settings
    elsif @move_set and @can_move and not @battler.moving?
      movement_end_anim
    elsif @battler.move_pose and not @battler.moving?
      @battler.move_pose = false
      @battler.pose_id = set_idle_pose
    elsif not @can_move and not @move_set and not @battler.moving? and not
       @battler.action? and not @battler.active? and not @battler.damaged and not
       @battler.evaded
      @battler.idle_pose = true unless @battler.action? or @battler.active? or @battler.returning?
    end
  end
  #--------------------------------------------------------------------------
  # * Set movement start animation
  #--------------------------------------------------------------------------
  def movement_start_anim
    @can_move = true
    @battler.initial_x = @battler.actual_x
    @battler.initial_y = @battler.actual_y
    movement_anim(@battler.returning? ? 'Return_Start' : 'Advance_Start')
  end
  #--------------------------------------------------------------------------
  # * Move settings
  #--------------------------------------------------------------------------
  def move_settings
    @move_set = true
    @move_pose = true
    @battler.jumping = check_jump(@battler.returning? ? 'Return' : 'Advance')
    jump_init if @battler.jumping != 0
  end
  #--------------------------------------------------------------------------
  # * Set movement end animation
  #--------------------------------------------------------------------------
  def movement_end_anim
    if @update_base_position
      @battler.base_x = @battler.actual_x
      @battler.base_y = @battler.actual_y
      @update_base_position = false
    end
    @battler.initial_x = @battler.actual_x
    @battler.initial_y = @battler.actual_y
    movement_anim(@battler.returning? ? 'Return_End' : 'Advance_End')
    @battler.mirage = false
    @move_pose = false
    @move_set = false
    @can_move = false
  end
  #--------------------------------------------------------------------------
  # * Set Movement animation
  #     move : move type
  #--------------------------------------------------------------------------
  def movement_anim(move)
    pose = set_pose_id(move)
    return if pose.nil? or not @battler.movement
    @battler.pose_id = pose
    pose_wait = battler_pose(@battler.pose_id)
    return if pose_wait.nil?
    @battler.wait_time = pose_wait[0] * pose_wait[1]
  end
  #--------------------------------------------------------------------------
  # * Se jumo
  #     direction : jump direction
  #--------------------------------------------------------------------------
  def check_jump(direction)
    pose = Pose_Sprite[@battler_name]
    if pose and pose['Jump'] != nil and pose['Jump'][direction] != nil
      return pose['Jump'][direction]
    end
    ext = check_extension(@battler.now_action, "ADVJUMP/")
    if direction == 'Advance' and ext != nil
      ext.slice!('ADVJUMP/')
      return ext.to_i
    end
    ext = check_extension(@battler.now_action, "RETJUMP/")
    if direction == 'Return' and ext != nil
      ext.slice!('RETJUMP/')
      return ext.to_i
    end
    return All_Jump
  end
  #--------------------------------------------------------------------------
  # * Start jump
  #--------------------------------------------------------------------------
  def jump_init
    x_plus = ((@battler.initial_x.to_f - @battler.target_x.to_f) / 32).abs
    y_plus = ((@battler.initial_y.to_f - @battler.target_y.to_f) / 32).abs
    @jump_peak = Math.sqrt((x_plus ** 2) + (y_plus ** 2)).round
    @jump_count = @jump_peak * 2
  end
  #--------------------------------------------------------------------------
  # * Start jump during actions
  #--------------------------------------------------------------------------
  def jump_action_init
    @jump_action = true
    @jump_peak = @battler.jumping / 10.0
    @jump_count = @jump_peak * 2
  end
  #--------------------------------------------------------------------------
  # * Start throw
  #--------------------------------------------------------------------------
  def bounce_init
    @bounce_peak = @battler.bouncing / 10.0
    @bounce_count = @bounce_peak * 2
  end
  #--------------------------------------------------------------------------
  # * Start mirage effect
  #--------------------------------------------------------------------------
  def mirage_init
    for i in 0...4
      if @mirage[i].nil?
        @mirage[i] = Mirage_Sprite.new(self.viewport)
        @mirage[i].bitmap = self.bitmap
        mirage(@mirage[i])
      end
    end
    @mirage_init = true
  end
  #--------------------------------------------------------------------------
  # * Update mirage graphic
  #     img : mirage graphic
  #--------------------------------------------------------------------------
  def mirage(img)
    img.mirage_count = 15.0
    set_image_color(img)
    img.x = actual_x_position
    img.y = actual_y_position
    img.bitmap = self.bitmap if img.bitmap != self.bitmap
    img.ox = self.ox
    img.oy = self.oy
    img.z = self.z - 2
    img.mirror = self.mirror
    img.zoom_x = self.zoom_x
    img.zoom_y = self.zoom_y
    img.offset_x = self.offset_x
    img.offset_y = self.offset_y
    img.frame_width = self.frame_width
    img.frame_height = self.frame_height
    img.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height)
  end    
  #--------------------------------------------------------------------------
  # * Set mirage color
  #     img : mirage graphic
  #--------------------------------------------------------------------------
  def set_image_color(img)
    color = @battler.mirage_color.empty? ? [0, 0, 0, 0] : @battler.mirage_color
    img.color.set(color[0], color[1], color[2], color[3])
    img.opacity = ((self.opacity / 2) * ((img.mirage_count + 5) / 15)).to_i
    img.mirage_count -= 1
  end
  #--------------------------------------------------------------------------
  # * Mirage update
  #--------------------------------------------------------------------------
  def update_mirage
    for i in 0...@mirage.size
      next if @mirage[i].nil?
      set_image_color(@mirage[i])
      if @mirage_init == false and @mirage[i].mirage_count <= 0
        delete_mirage(@mirage[i])
        @mirage[i] = nil
      end
    end
    mirage(@mirage[0]) if @mirage[0] != nil and @mirage_count == 1
    mirage(@mirage[1]) if @mirage[1] != nil and @mirage_count == 4
    mirage(@mirage[2]) if @mirage[2] != nil and @mirage_count == 7
    mirage(@mirage[3]) if @mirage[3] != nil and @mirage_count == 10
    mirage(@mirage[4]) if @mirage[4] != nil and @mirage_count == 13
    @mirage_count += 1
    @mirage_count = 0 if @mirage_count == 15 or @mirage.nitems == 0
  end
  #--------------------------------------------------------------------------
  # * Delete mirage
  #     img : mirage sprite
  #--------------------------------------------------------------------------
  def delete_mirage(img)
    img.dispose
  end
  #--------------------------------------------------------------------------
  # * Set throw animation
  #     obj    : throw object settings
  #     sprite : target sprite
  #     active : battler sprite
  #--------------------------------------------------------------------------
  def set_throw_object(obj, sprite, active)
    @throw_object << Throw_Sprite.new(self.viewport, obj, active, sprite, @battler, self, false)
  end
  #--------------------------------------------------------------------------
  # * Throw update
  #--------------------------------------------------------------------------
  def update_throw
    for object in @throw_object
      object.update
      if object.throw_end
        object.dispose
        @throw_object.delete(object)
      end
    end
    @throw_object.compact!
  end
  #--------------------------------------------------------------------------
  # * Set throw return animation
  #     obj    : throw object settings
  #     sprite : target sprite
  #     active : battler sprite
  #--------------------------------------------------------------------------
  def set_throw_return(obj, sprite, active)
    @throw_object << Throw_Sprite.new(self.viewport, obj, active, sprite, @battler, self, true)
  end
  #--------------------------------------------------------------------------
  # * Check throwing
  #--------------------------------------------------------------------------
  def throwing?(battler)
    for object in @throw_object
      return true if object.active_battler == battler
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check collapse effect
  #--------------------------------------------------------------------------
  def collapsing?
    return @_collapse_duration > 0
  end
end