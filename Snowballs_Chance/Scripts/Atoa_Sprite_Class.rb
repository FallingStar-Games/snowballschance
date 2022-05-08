#==============================================================================
# ** RPG::Sprite
#------------------------------------------------------------------------------
# Class that manages Sprites exhibition
#==============================================================================

class RPG::Sprite < ::Sprite
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :frame_width     # Width of battler frame
  attr_accessor :frame_height    # Heighr of battler frame
  attr_accessor :offset_x        # Battler rectangle X postion
  attr_accessor :offset_y        # Battler rectangle Y postion
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @_whiten_duration = 0
    @_appear_duration = 0
    @_escape_duration = 0
    @_collapse_duration = 0
    @_damage_duration = 0
    @_fastappear_duration = 0
    @_disappear_duration = 0
    @_effect_type = 0
    @_blink = false    
    @_damage_durations = []
    @animation = {}
    @pose_anim_singe_loop = false
    @_damage_color = [0, 0, 0]
    @frame_width = 0
    @frame_height = 0
    @offset_x = 0
    @offset_y = 0
    @anim_index = 0
  end
  #--------------------------------------------------------------------------
  # * Sprite fast appear
  #--------------------------------------------------------------------------
  def fast_appear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    @_appear_duration = 0
  end
  #--------------------------------------------------------------------------
  # * Sprite disappear
  #--------------------------------------------------------------------------
  def disappear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    @_disappear_duration = 32
    @_escape_duration = 0
    @_whiten_duration = 0
    @_appear_duration = 0
    @_collapse_duration = 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    uptate_damage
    update_whiten if @_whiten_duration > 0
    update_appear if @_appear_duration > 0
    update_escape if @_escape_duration > 0
    update_disappear if @_disappear_duration > 0
    update_collapse if @_collapse_duration > 0
    update_animations if have_animation
    update_loop_animation if @_loop_animation != nil
    update_pose_animation if @_pose_animation != nil
    update_blink if @_blink
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    dispose_damage(0...@_damage_durations.size)
    dispose_animations
    dispose_loop_animation
    dispose_pose_animation
    if @damage_sprites != nil
      for damage_sprite in @damage_sprites
        damage_sprite.dispose 
      end
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Set Damage Pop
  #     value     : Damage value
  #     critical  : Critical flag
  #     sp_damage : SP Damage flag
  #--------------------------------------------------------------------------
  def damage(value, critical, sp_damage = nil)
    dispose_damage(0...@_damage_durations.size)
    @_damage_sprites = []
    damage_string = value.numeric? ? value.abs.to_s : value.to_s
    @battler.apply_damage(value, sp_damage)
    for i in 0...damage_string.size
      letter = damage_string[i..i]
      if Damage_Sprite
        if value.numeric? and value < 0
          extension = Hp_Rec_String
          extension = Sp_Rec_String if sp_damage
        elsif value > 60 #nice
          extension = Sp_hi_Dmg_String  if sp_hi_damage
        else
          extension = Sp_Dmg_String  if sp_damage
          extension = Crt_Dmg_String if critical 
          extension = Mss_Txt_String if damage_string == Miss_Message
        end
        begin
          bitmap = RPG::Cache.digits(letter + extension)
        rescue
          bitmap = RPG::Cache.digits(letter)
        end
      else
        if value.numeric? and value < 0 
          #if the amount changed is a number and it's smaller than zero
          #give it the heal colors
          @_damage_color = [Hp_Rec_Color[0],Hp_Rec_Color[1],Hp_Rec_Color[2]]
          @_damage_color = [Sp_Rec_Color[0],Sp_Rec_Color[1],Sp_Rec_Color[2]] if sp_damage
   
        
        elsif value.numeric? and value > 9998 #90
          @_damage_color = [rand(255) ,rand(255),rand(255)]#[Hp_hi_Dmg_Color[0],Hp_hi_Dmg_Color[1],Hp_hi_Dmg_Color[2]]
        elsif value.numeric? and value > 6400 #80
          @_damage_color = [255,30,30]
        elsif value.numeric? and value > 3200 #70
          @_damage_color = [255,30,30]
        elsif value.numeric? and value > 1600 #60
          @_damage_color = [255,30,30]
        elsif value.numeric? and value > 800 #50
          @_damage_color = [255,30,30]  
        elsif value.numeric? and value > 400 #red
          @_damage_color = [255,0,0]  
        elsif value.numeric? and value > 200 #orange
          @_damage_color = [255,128,0]  
        elsif value.numeric? and value > 100 #yellow
          @_damage_color = [250,200,9]  
        elsif value.numeric? and value == 69 #nice
          @_damage_color = [255,50,255]  
          #Audio.se_play("Audio/SE/nice3", 100, 0) #too loud @ _@
          battler.animation_id = 11 #fire
        elsif value.numeric? and value > 50 #pink
          @_damage_color = [255,128,128]  
          
          else
          #if it isn't, give it the damage colors
          @_damage_color = [Hp_Dmg_Color[0],Hp_Dmg_Color[1],Hp_Dmg_Color[2]] #10
          @_damage_color = [Sp_Dmg_Color[0],Sp_Dmg_Color[1],Sp_Dmg_Color[2]] if sp_damage
          @_damage_color = [Crt_Dmg_Color[0],Crt_Dmg_Color[1],Crt_Dmg_Color[2]] if critical 
          @_damage_color = [Mss_Txt_Color[0],Mss_Txt_Color[1],Mss_Txt_Color[2]] if damage_string == Miss_Message
        end
        bitmap = Bitmap.new(160, 48)
        bitmap.font.name = Damage_Font
        bitmap.font.size = Dmg_Font_Size
        bitmap.font.color.set(0, 0, 0)
        battler.animation_id = 11 #fire
        bitmap.draw_text(-1, 12-1,160, 36, letter, 1)
        bitmap.draw_text(+1, 12-1,160, 36, letter, 1)
        bitmap.draw_text(-1, 12+1,160, 36, letter, 1)
        bitmap.draw_text(+1, 12+1,160, 36, letter, 1)
        bitmap.font.color.set(*@_damage_color) 
        bitmap.draw_text(0, 12,160, 36, letter, 1)
        if critical and Critic_Text and i == 0
          x_pop = (damage_string.size - 1) * (Dmg_Space / 2)
          
          #draw a fire!!
          bitmap.font.size = ((Dmg_Font_Size * 2) / 3).to_i
          bitmap.font.color.set(0, 0, 0)
          bitmap.draw_text(-1 + x_pop, -1, 160, 20, Crt_Message, 1)
          bitmap.draw_text(+1 + x_pop, -1, 160, 20, Crt_Message, 1)
          bitmap.draw_text(-1 + x_pop, +1, 160, 20, Crt_Message, 1)
          bitmap.draw_text(+1 + x_pop, +1, 160, 20, Crt_Message, 1)
          color = [Crt_Txt_Color[0],Crt_Txt_Color[1],Crt_Txt_Color[2]] if critical 
          bitmap.font.color.set(*color) if critical 
          bitmap.draw_text(0 + x_pop, 0, 160, 20, Crt_Message, 1)
        end
      end
      if critical and Critic_Flash and value.numeric?
        $game_screen.start_flash(Color.new(255, 255, 255, 255),10)
      end
      dmg_delay = Multi_Pop ? i : 1
      dmg_adjust = Damage_Sprite ? 32 : 96
      @_damage_sprites[i] = ::Sprite.new(self.viewport)
      @_damage_sprites[i].bitmap = bitmap
      @_damage_sprites[i].ox = dmg_adjust
      @_damage_sprites[i].oy = 20
      @_damage_sprites[i].x = self.x + 32 + Dmg_X_Adjust + i * Dmg_Space - (damage_string.size * 8)
      @_damage_sprites[i].y = self.y + Dmg_Y_Adjust - self.oy / 3
      @_damage_sprites[i].z = Dmg_Duration + 3000 + dmg_delay * 2
      @_damage_sprites[i].opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect
  #--------------------------------------------------------------------------
  def collapse
    @_effect_type = 0
    @_collapse_duration = 48
    ext = check_extension(@battler, 'COLLAPSE/')
    if ext != nil
      ext.slice!('COLLAPSE/')
      type = eval(ext)
      if type == 1
        @_effect_type = 1
        @_collapse_duration = 320
      elsif type == 2
        @_effect_type = 2
        @_collapse_duration = 320
      elsif type == 3
        @_effect_type = 3
        @_collapse_duration = 560
      end
    end
    @_whiten_duration = 0
    @_appear_duration = 0
    @_escape_duration = 0
    @_disappear_duration = 0
  end
  #--------------------------------------------------------------------------
  # * Normal Collapse
  #--------------------------------------------------------------------------
  def normal_collapse
    if @_collapse_duration == 46
      self.blend_type = 1
      self.color.set(255, 64, 64, 255)
    end
    self.opacity = 256 - (48 - @_collapse_duration) * 6 if @_collapse_duration <= 46
    @shadow.opacity = self.opacity if @shadow != nil
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 1
  #--------------------------------------------------------------------------
  def boss_collapse
    if @_collapse_duration == 320
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 290
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 250
      $game_system.se_play(RPG::AudioFile.new('explosion',100, 50))
      self.blend_type = 1
      self.color.set(255, 128, 128, 128)
      @original_oy = self.oy 
    end
    if @_collapse_duration < 250
      self.oy -= 1
      @collapse_count = @collapse_count.nil? ? 0 : [@collapse_count + 1, 12].min
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height +
                        @_collapse_duration - 250 - @collapse_count)
      self.opacity = @_collapse_duration - 20
      @shadow.opacity = self.opacity if @shadow != nil
      return if @_collapse_duration < 100
      if @_collapse_duration % 80 == 0
        $game_system.se_play(RPG::AudioFile.new('explosion',100, 50))
      end
      @original_oy = self.oy if @_collapse_duration == 1
    end
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 2
  #--------------------------------------------------------------------------
  def boss_collapse2
    if @_collapse_duration == 320
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 290
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 80))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 250
      $game_system.se_play(RPG::AudioFile.new('explosion',100, 50))
      self.blend_type = 1
      self.color.set(255, 128, 128, 128)
    end
    if @_collapse_duration < 250
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height + @_collapse_duration - 250)
      self.opacity = @_collapse_duration - 20
      @shadow.opacity = self.opacity if @shadow != nil
      return if @_collapse_duration < 100
      $game_system.se_play(RPG::AudioFile.new('explosion',100, 50)) if @_collapse_duration % 80 == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Collapse Effect 3
  #--------------------------------------------------------------------------
  def boss_collapse_advanced
    if @_collapse_duration == 550
      Audio.bgm_fade(2000) 
      Audio.bgs_fade(2000) 
    end
    if @_collapse_duration == 440 or @_collapse_duration == 380 or 
       @_collapse_duration == 280 or @_collapse_duration == 180
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 100))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 420 or @_collapse_duration == 360 or
       @_collapse_duration == 260 or @_collapse_duration == 160
      $game_system.se_play(RPG::AudioFile.new('explosion', 100, 50))
      self.flash(Color.new(255, 255, 255), 60)
      viewport.flash(Color.new(255, 255, 255), 20)
    end
    if @_collapse_duration == 350
      $game_system.se_play(RPG::AudioFile.new('explosion', 80, 50))
      self.blend_type = 1
      self.color.set(255, 255, 255, 128)
      @original_oy = self.oy 
    end
    if @_collapse_duration < 350 and @_collapse_duration > 40
      self.oy -= 1 if @_collapse_duration % 2 == 0
      @collapse_count = @collapse_count.nil? ? 0 : [@collapse_count + 1, 12].min
      self.src_rect.set(@offset_x, @offset_y, @frame_width, @frame_height + @_collapse_duration / 2 - 175 - 
                        @collapse_count)
      self.opacity = @_collapse_duration - 60
      @shadow.opacity = self.opacity if @shadow != nil
      self.color.set(255, 255, 255, @_collapse_duration / 2 - 35)
      viewport.color = Color.new(255, 255, 255, 350 - @_collapse_duration)
      $game_system.se_play(RPG::AudioFile.new('explosion', 80, 50)) if @_collapse_duration % 90 == 0
    end
    $game_system.se_play(RPG::AudioFile.new('explosion', 80, 30)) if @_collapse_duration == 38
    if @_collapse_duration < 40 
      viewport.color = Color.new(255, 255, 255, @_collapse_duration * 6)
    end
    @original_oy = self.oy if @_collapse_duration == 39
  end
  #--------------------------------------------------------------------------
  # * Sprite X Center
  #--------------------------------------------------------------------------
  def center_x
    return self.src_rect.width / 2
  end
  #--------------------------------------------------------------------------
  # * Sprite Y Center
  #--------------------------------------------------------------------------
  def center_y
    return self.src_rect.height / 2
  end
  #--------------------------------------------------------------------------
  # * Set animation sprites
  #     sprites     : animation sprite
  #     cell_data   : cell info
  #     postion     : animation position
  #     animation   : animation info
  #     anim_pos    : animation custom position
  #     anim_mirror : invert animation
  #--------------------------------------------------------------------------
  def animation_set_sprites(sprites, cell_data, position, animation, anim_pos = nil, anim_mirror = false)
    for i in 0..15
      sprite = sprites[i]
      pattern = cell_data[i, 0]
      if sprite == nil or pattern == nil or pattern == -1
        sprite.visible = false if sprite != nil
        next
      end
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
      if position == 3
        if anim_pos != nil
          sprite.x = anim_pos[0]
          sprite.y = anim_pos[1]
        elsif anim_pos.nil? and self.viewport != nil
          sprite.x = self.viewport.rect.width / 2
          sprite.y = self.viewport.rect.height - 320
        else
          sprite.x = 320
          sprite.y = 240
        end
      else
        if $game_temp.in_battle
          sprite.x = self.x - self.ox + self.center_x
          sprite.y = self.y - self.oy if position == 0
          sprite.y = self.y - self.oy + self.center_y if position == 1
          sprite.y = self.y - self.oy + self.frame_height if position == 2
        else
          sprite.x = self.x - self.ox + self.center_x
          sprite.y = self.y - self.oy + self.center_y
          sprite.y -= self.center_x / 2 if position == 0
          sprite.y += self.center_y / 2 if position == 2
        end
      end
      set_sprite_cell_data(sprite, cell_data, i, anim_mirror)
      anim_setting = Animation_Setting[animation.id]
      sprite.z = anim_setting.nil? ? 2000 : self.z + anim_setting[2]
      sprite.x += (anim_setting.nil? ? 0 : anim_mirror ? -anim_setting[0] : anim_setting[0])
      sprite.y += (anim_setting.nil? ? 0 : anim_setting[1])
      sprite.ox = 96 
      sprite.oy = 96
    end
  end
  #--------------------------------------------------------------------------
  # * Set animation frame info
  #     sprite      : animation sprite
  #     cell_data   : cell info
  #     index       : index
  #     anim_mirror : invert animation
  #--------------------------------------------------------------------------
  def set_sprite_cell_data(sprite, cell_data, index, anim_mirror = false)
    sprite.x += anim_mirror ? - cell_data[index, 1] : cell_data[index, 1]
    sprite.y += cell_data[index, 2]
    sprite.zoom_x = cell_data[index, 3] / 100.0
    sprite.zoom_y = cell_data[index, 3] / 100.0
    sprite.angle = cell_data[index, 4]
    sprite.mirror = (cell_data[index, 5] == 1)
    sprite.opacity = cell_data[index, 6] * self.opacity / 255.0
    sprite.blend_type = cell_data[index, 7]
    sprite.mirror = !sprite.mirror if anim_mirror
  end
  #--------------------------------------------------------------------------
  # * Set animation
  #     animation   : animation info
  #     hit         : hit animation
  #     anim_pos    : animation custom position
  #     anim_mirror : invert animation 
  #--------------------------------------------------------------------------
  def animation(animation, hit, anim_pos = nil, anim_mirror = false)
    return if animation == nil
    animation_name = animation.animation_name
    animation_hue = animation.animation_hue
    bitmap = RPG::Cache.animation(animation_name, animation_hue)
    if @@_reference_count.include?(bitmap)
      @@_reference_count[bitmap] += 1
    else
      @@_reference_count[bitmap] = 1
    end
    @anim_index += 1
    anim = [animation, @anim_index]
    @animation[anim] = {'anim' => animation, 'hit' => hit, 'mirror' => anim_mirror,
      'duration' => animation.frame_max, 'position' => anim_pos, 'sprites' => []}
    if animation.position != 3 or not @@_animations.include?(animation)
      for i in 0..15
        sprite = ::Sprite.new(self.viewport)
        sprite.bitmap = bitmap
        sprite.visible = false
        @animation[anim]['sprites'].push(sprite)
      end
      @@_animations.push(animation) unless @@_animations.include?(animation)
    end
    update_animation(@animation[anim])
  end
  #--------------------------------------------------------------------------
  # * Set loop animation
  #     animation : animation info
  #--------------------------------------------------------------------------
  def loop_animation(animation)
    return if animation == @_loop_animation
    dispose_loop_animation
    @_loop_animation = animation
    return if @_loop_animation == nil
    @_loop_animation_index = 0
    animation_name = @_loop_animation.animation_name
    animation_hue = @_loop_animation.animation_hue
    bitmap = RPG::Cache.animation(animation_name, animation_hue)
    if @@_reference_count.include?(bitmap)
      @@_reference_count[bitmap] += 1
    else
      @@_reference_count[bitmap] = 1
    end
    @_loop_animation_sprites = []
    for i in 0..15
      sprite = ::Sprite.new(self.viewport)
      sprite.bitmap = bitmap
      sprite.visible = false
      @_loop_animation_sprites.push(sprite)
    end
    update_loop_animation
  end
  #--------------------------------------------------------------------------
  # * Set pose animation
  #     animation : animation info
  #--------------------------------------------------------------------------
  def pose_animation(animation)
    return if animation == @_pose_animation
    return if animation.nil? and @_pose_animation != nil and @_pose_animation_index != nil and
              @_pose_animation.frame_max - @_pose_animation_index > 1
    dispose_pose_animation
    @_pose_animation = animation
    return if @_pose_animation == nil
    @_pose_animation_index = 0
    animation_name = @_pose_animation.animation_name
    animation_hue = @_pose_animation.animation_hue
    bitmap = RPG::Cache.animation(animation_name, animation_hue)
    if @@_reference_count.include?(bitmap)
      @@_reference_count[bitmap] += 1
    else
      @@_reference_count[bitmap] = 1
    end
    @_pose_animation_sprites = []
    for i in 0..15
      sprite = ::Sprite.new(self.viewport)
      sprite.bitmap = bitmap
      sprite.visible = false
      @_pose_animation_sprites.push(sprite)
    end
  end
  #--------------------------------------------------------------------------
  # * Update whiten
  #--------------------------------------------------------------------------
  def update_whiten
    @_whiten_duration -= 1
    self.color.alpha = 128 - (16 - @_whiten_duration) * 10
  end
  #--------------------------------------------------------------------------
  # * Update appear
  #--------------------------------------------------------------------------
  def update_appear
    @_appear_duration -= 1
    self.opacity = (16 - @_appear_duration) * 16
  end
  #--------------------------------------------------------------------------
  # * Update escape
  #--------------------------------------------------------------------------
  def update_escape
    @_escape_duration -= 1
    self.opacity = 256 - (32 - @_escape_duration) * 10
  end
  #--------------------------------------------------------------------------
  # * Update diaappear
  #--------------------------------------------------------------------------
  def update_disappear
    @_disappear_duration -= 2
    self.opacity = 256 - (32 - @_disappear_duration) * 10
  end
  #--------------------------------------------------------------------------
  # * Update blink
  #--------------------------------------------------------------------------
  def update_blink
    @_blink_count = (@_blink_count + 1) % 32
    alpha = @_blink_count < 16 ? (16 - @_blink_count) * 6 : (@_blink_count - 16) * 6
    self.color.set(255, 255, 255, alpha)
  end
  #--------------------------------------------------------------------------
  # * Update animations
  #--------------------------------------------------------------------------
  def update_animations
    if Graphics.frame_count % 2 == 0
      for anim in @animation.keys
        @animation[anim]['duration'] -= 1
        update_animation(@animation[anim])
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update collapse
  #--------------------------------------------------------------------------
  def update_collapse
    @_collapse_duration -= 1
    case @_effect_type
    when 0
      normal_collapse
    when 1
      boss_collapse
    when 2
      boss_collapse2
    when 3
      boss_collapse_advanced
    end
  end
  #--------------------------------------------------------------------------
  # * Update damage pop
  #--------------------------------------------------------------------------
  def uptate_damage
    @damage_sprites   = [] if @damage_sprites.nil?
    @damage_durations = [] if @damage_durations.nil?
    if @_damage_sprites != nil
      adjust = (Random_Move ? (rand(200) / 100.0) + 0.5  : 1.0)
      for sprite in @_damage_sprites
        if sprite != nil and sprite.visible
          x = Dmg_X_Move * adjust
          y = Dmg_Y_Move
          d = sprite.z - 3000
          m = self.dmg_mirror
          i = @_damage_sprites.index(sprite)
          @damage_sprites << Sprite_Damage.new(sprite, x, y, d, m, i)
          sprite.visible = false
        end
      end
    end
    for damage_sprite in @damage_sprites
      damage_sprite.update
    end
    for i in 0...@damage_sprites.size
      @damage_sprites[i] = nil if @damage_sprites[i].disposed?
    end
    @damage_sprites.compact!
  end
  #--------------------------------------------------------------------------
  # * Animation individual update
  #     animation : animation info
  #--------------------------------------------------------------------------
  def update_animation(animation)
    if animation['duration'] > 0
      anim = animation['anim']
      pos = animation['position']
      mirror = animation['mirror']
      frame_index = anim.frame_max - animation['duration']
      cell_data = anim.frames[frame_index].cell_data
      position = anim.position
      animation_set_sprites(animation['sprites'], cell_data, position, anim, pos, mirror)
      for timing in anim.timings
        animation_process_timing(timing, animation['hit']) if timing.frame == frame_index
      end
    else
      dispose_animation(animation)
    end
  end
  #--------------------------------------------------------------------------
  # * Update loop animation
  #--------------------------------------------------------------------------
  def update_loop_animation
    if Graphics.frame_count % 2 == 0
      @_loop_animation_index += 1
      if not check_state_anim or (@state_animation_id == @_loop_animation.id and
         @_loop_animation_index == (@_loop_animation.frame_max * State_Cycle_Time))
        @state_animation_id = @battler.state_animation_update
        @battler.state_animation_id = @state_animation_id
        loop_animation($data_animations[@state_animation_id])
        return if @_loop_animation.nil?
      end
      @_loop_animation_index %= (@_loop_animation.frame_max * State_Cycle_Time)
    end
    frame_index = @_loop_animation_index % @_loop_animation.frame_max
    cell_data = @_loop_animation.frames[frame_index].cell_data
    position = @_loop_animation.position
    animation_set_sprites(@_loop_animation_sprites, cell_data, position, @_loop_animation)
    for timing in @_loop_animation.timings
      animation_process_timing(timing, true) if timing.frame == frame_index
    end
  end
  #--------------------------------------------------------------------------
  # * Update pose animation
  #--------------------------------------------------------------------------
  def update_pose_animation
    if Graphics.frame_count % 2 == 0
      @_pose_animation_index += 1
      @_pose_animation_index %= @_pose_animation.frame_max
      if @_pose_animation_index == 0 and (@pose_anim_singe_loop or 
         current_pose_anim != @current_pose_anim)
        dispose_pose_animation
        @pose_anim_singe_loop = false
        return
      end
    end
    frame_index = @_pose_animation_index
    cell_data = @_pose_animation.frames[frame_index].cell_data
    position = @_pose_animation.position
    animation_set_sprites(@_pose_animation_sprites, cell_data, position, @_pose_animation)
    for timing in @_pose_animation.timings
      animation_process_timing(timing, true) if timing.frame == frame_index
    end
  end
  #--------------------------------------------------------------------------
  # * Set current pose animation
  #--------------------------------------------------------------------------
  def current_pose_anim
    return nil if @battler.nil?
    name = Pose_Sprite[set_battler_name].nil? ? @battler_name : set_battler_name
    if Pose_Animation[name] != nil
      pose = Pose_Animation[name][@battler.pose_id]
      return pose if pose != nil
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Dispose animations
  #--------------------------------------------------------------------------
  def dispose_animations
    for anim in @animation.keys
      dispose_animation(@animation[anim])
    end
  end
  #--------------------------------------------------------------------------
  # * Individual animation dispose
  #     animation : animation info
  #--------------------------------------------------------------------------
  def dispose_animation(animation)
    if animation['sprites'] != nil
      sprite = animation['sprites'][0]
      if sprite != nil
        @@_reference_count[sprite.bitmap] -= 1
        sprite.bitmap.dispose if @@_reference_count[sprite.bitmap] == 0
      end
      for sprite in animation['sprites']
        sprite.dispose
      end
      @animation.delete(@animation.index(animation))
      @@_animations.delete(animation['anim'])
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose pose animations
  #--------------------------------------------------------------------------
  def dispose_pose_animation
    if @_pose_animation_sprites != nil
      sprite = @_pose_animation_sprites[0]
      if sprite != nil
        @@_reference_count[sprite.bitmap] -= 1
        sprite.bitmap.dispose if @@_reference_count[sprite.bitmap] == 0
      end
      for sprite in @_pose_animation_sprites
        sprite.dispose
      end
      @_pose_animation_index = nil
      @_pose_animation_sprites = nil
      @_pose_animation = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose damage sprites
  #     index : index
  #--------------------------------------------------------------------------
  def dispose_damage(index)
    return if @_damage_sprites.nil?
    if @_damage_sprites[index].is_a?(::Sprite) and @_damage_sprites[index].bitmap != nil
      @_damage_sprites[index].bitmap.dispose
      @_damage_sprites[index].dispose
      @_damage_durations[index] = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Check current state animation
  #--------------------------------------------------------------------------
  def check_state_anim
    for state in @battler.states
      return true if $data_states[state].animation_id == @state_animation_id
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check for animations
  #--------------------------------------------------------------------------
  def have_animation
    for anim in @animation.keys
      return true if @animation[anim] != nil
    end
    return false
  end
end