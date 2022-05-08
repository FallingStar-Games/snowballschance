#-------------------------------------- ---- -- -
#  Easy animated pictures v1
#  by lavendersiren and Coelocanth
#-------------------------------------- ---- -- -
# Where to put: between debug and main, most likely near the top of your script list.
# May have some incompatibilities with other scripts that modify how pictures work.
#
# How to use:
# 1. Turn your animation into a horizontal sprite strip.
# 2. Make sure the file name starts with an exclamation point,
# the number of frames, and an underscore. Put whatever you want right after.
#
# Example: !4_firetest.png
#
# 3. Then, just import it into the picture folder and use as usual!
#
# Terms of use:
# Can be used in any project, commercial or noncommercial, with proper credit.
#
#==============================================================================
# ** Sprite_Picture
#------------------------------------------------------------------------------
#  This sprite is used to display the picture.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Picture < Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     picture  : picture (Game_Picture)
  #--------------------------------------------------------------------------
  def initialize(viewport, picture)
    super(viewport)
    @picture = picture
	@picframe = 1
  @delay_count = 3
  @delay_val = @delay_count
  @animated = true
    update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # If picture file name is different from current one
    if @picture_name != @picture.name
      # Remember file name to instance variables
      @picture_name = @picture.name
      # If file name is not empty
      if @picture_name != ""
        # Get picture graphic
        self.bitmap = RPG::Cache.picture(@picture_name)
      end
    end
    # If file name is empty
    if @picture_name == ""
      # Set sprite to invisible
      self.visible = false
      return
    end
	

    # Set sprite coordinates
    self.x = @picture.x
    self.y = @picture.y
    self.z = @picture.number
    # Set zoom rate, opacity level, and blend method
    self.zoom_x = @picture.zoom_x / 100.0
    self.zoom_y = @picture.zoom_y / 100.0
    self.opacity = @picture.opacity
    self.blend_type = @picture.blend_type
    # Set rotation angle and color tone
    self.angle = @picture.angle
    self.tone = @picture.tone
	#------------------------------------
	#  sprite slicinggggggg!!!
	#--------------------------------------
	
	#if the file name string includes a ! sign plus a digit
  if /!(\d+)_/ =~ @picture_name
    @framecount = $1.to_i
    @animated=true
	else
		@framecount = 1
    @animated=false
		#if it doesn't have one, just slice it in 1 piece :b
	end
	if @animated== true
    	  #SLICE IT!!!
        @cw = bitmap.width / @framecount
      @ch = bitmap.height
      sx = @picframe * @cw
	  #set the sx according to which frame you want to start on, 
    #and times that by cw
      sy = 1
	  #keep sy the same, it's just a strip
     self.src_rect.set(sx, sy, @cw, @ch)   
     
   end
   

    # Set transfer starting point
    if @picture.origin == 0
      self.ox = 0
      self.oy = 0
    else
      if @animated==true
		self.ox = @cw / 2
		self.oy = self.bitmap.height / 2
			else
		self.ox = self.bitmap.width / 2
		self.oy = self.bitmap.height / 2
		end
  end
  
      # Set sprite to visible
    self.visible = true
  
	#timinggg!
if @animated==true

  if @delay_val <= 0
  @delay_val = @delay_count
  	if @picframe >= @framecount -1
		@picframe = 0
		else
		@picframe +=1 
		end
	else
		@delay_val -= 1
	end
    end

  end
end
