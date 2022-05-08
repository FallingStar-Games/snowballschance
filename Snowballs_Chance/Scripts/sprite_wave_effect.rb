#========================================
# XP Wave Effect
#----------------------------------------
#by:      zecomeia
#date:    01/03/2010
#for:     RGSS
#version: 1.0
#www.colmeia-do-ze.blogspot.com
#----------------------------------------
=begin
Reproduction of the VX's wave effect
(see the help file of the RPGMaker VX
in the RGSS manual reference topic)
=end

#==============#
# Sprite class #
#==============#
class Sprite
 
  include Math
 
  attr_accessor   :wave_amp
  attr_accessor   :wave_length
  attr_accessor   :wave_speed
  attr_accessor   :wave_phase
  attr_accessor   :temp_bitmap
 
  alias initialize default_initialize rescue nil
  alias default_initialize initialize
  def initialize(viewport=nil)
    @wave_amp = 0 #2
    @wave_length = 72
    @wave_speed = 720
    @wave_phase = 0.25
    default_initialize(viewport)
    @temp_bitmap = nil
  end
 
  alias update default_update rescue nil
  alias default_update update 
  def update()
    # the wave effect only works if wave_amp
    # propertie is a number more than zero
    wave_effect if @wave_amp > 0
    default_update()
  end
 
  # Return the width of image, because when use
  # obj.bitmap.width the value will be more than
  # the original value(because effect)
  def width()
    return (self.bitmap.width - @wave_amp * 2)
  end
   
  #---------------
  # Wave Effect
  #---------------
  def wave_effect()
    return if self.bitmap.nil?
    @temp_bitmap = self.bitmap if @temp_bitmap.nil?
    cw = @temp_bitmap.width + (@wave_amp * 2)
    ch = @temp_bitmap.height
    # Follow the VX wave effect, each horizontal line
    # has 8 pixel of height. This device provides less
    # lag in game.
    divisions = @temp_bitmap.height / 8
    divisions += 1 if @temp_bitmap.height % 8 != 0
    self.bitmap = Bitmap.new(cw, ch)
    for i in 0..divisions
      x = @wave_amp * Math.sin(i * 2 * PI / (@wave_length / 8).to_i + Math.deg_to_rad(@wave_phase))
      src_rect = Rect.new(0, i*8, @temp_bitmap.width, 8)
      dest_rect = Rect.new(@wave_amp + x, i * 8, @temp_bitmap.width, 8)
      self.bitmap.stretch_blt(dest_rect, @temp_bitmap, src_rect)
    end
    # frame rate: VX = 60 | XP = 40
    # wave speed compatibility VX to XP: wave_speed * 60/40
    # then: wave_speed * 1.5
    @wave_phase += @wave_speed * 1.5 / @wave_length
    @wave_phase -= 360 if @wave_phase > 360
    @wave_phase += 360 if @wave_phase < 0
  end
 
end

#=============#
# module Math #
#=============#
module Math
 
  #-------------------------------
  # Conversion Degree to Radian
  #-------------------------------
  def Math.deg_to_rad(deg)
    return (deg * PI) / 180.0
  end
 
end