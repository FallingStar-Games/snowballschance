#==============================================================================
# ** Sprite_Damage
#------------------------------------------------------------------------------
# Class that manages Damage exhibition
#==============================================================================

class Sprite_Damage < Sprite
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     sprite   : damage sprite
  #     init_x   : initial X postion
  #     init_y   : initial Y position
  #     duration : damage duration
  #     mirror   : invert movement
  #     index    : index
  #--------------------------------------------------------------------------
  def initialize(sprite, init_x, init_y, duration, mirror, index)
    super(nil)
    self.bitmap = sprite.bitmap.dup unless sprite.bitmap.nil?
    self.opacity = 255
    self.x = Battle_Screen_Position[0] + sprite.x
    self.y = Battle_Screen_Position[1] + sprite.y
    self.z = 3000
    self.ox = sprite.ox
    self.oy = sprite.oy
    self.opacity = 255
    @damage_mirror = mirror
    @speed_x = init_x
    @speed_y = init_y
    @plus_x = 0.0
    @plus_y = 0.0
    @duration = duration
    @index = index
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @duration -= 1
    return unless @duration <= Dmg_Duration
    super
    n = self.oy + @speed_y
    if n <= 0
      @speed_y *= -1
      @speed_y /=  2
      @speed_x /=  2
    end
    self.oy  = [n, 0].max
    @plus_y += Dmg_Gravity
    speed = @plus_y.to_f
    @speed_y -= speed
    @plus_y -= speed
    @plus_x += @speed_x if @damage_mirror if Pop_Move
    @plus_x -= @speed_x if not @damage_mirror if Pop_Move
    speed = @plus_x.to_f
    self.ox += speed
    @plus_x -= speed
    case @duration
    when 1..10
      self.opacity -= 25
    when 0
      self.dispose
    end
  end
end
