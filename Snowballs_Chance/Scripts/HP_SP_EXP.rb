#==============================================================================
# Add-On: HP/SP/EXP Meter
# by Atoa
# edited by shinyjiggly/lavendersiren
#==============================================================================
# Adds HP/SP/EXP Meters
# Remove this Add-On if you wish to use custom HP/SP/EXP bars
# This Add-On must be always bellow 'ACBS | Battle Windows'
# if you are using it

#==============================================================================

module Atoa
  HP_Meter  = 'hpbarrx2'  # Name of the HP meter graphic file
  HP_Meter2  = 'HPMeter2'  # Name of the vertical HP meter graphic file
  SP_Meter  = 'spoonmeterx2'  # Name of the SP meter graphic file
  EXP_Meter = 'EXPMeter' # Name of the EXP meter graphic file
  MP_Meter = 'MPMeter'
  
  
  # Bars position adjust
  #                [x, y]
  HP_Pos_Adjust  = [20, -20]#[-28, -140]
  SP_Pos_Adjust  = [35, -16]
  EXP_Pos_Adjust = [20, 0]
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  def now_exp
    return @exp - @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
end

#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # * Draw HP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 144)
    # Draw "HP" text string
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.hp)
    # Calculate if there is draw space for MaxHP
    if width - 32 >= 108
      hp_x = x + width - 108
      flag = true
    elsif width - 32 >= 48
      hp_x = x + width - 48
      flag = false
    end
    # Draw HP
    self.contents.font.size = 16
    self.contents.font.color = actor.hp == 0 ? knockout_color :
      actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
    self.contents.draw_text(hp_x, y, 48, 32, actor.hp.to_s, 2)
    # Draw MaxHP
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(hp_x + 48, y, 12, 32, "/", 1)
      self.contents.draw_text(hp_x + 60, y, 48, 32, actor.maxhp.to_s)
      #(hp_x + 60, y, 48, 32, actor.maxhp.to_s)
    end
    self.contents.font.size = $defaultfontsize
  end
  
    #--------------------------------------------------------------------------
  # * Draw SP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_sp(actor, x, y, width = 144)
    # Draw "SP" text string
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 32, 32, $data_system.words.sp)
    # Calculate if there is draw space for MaxHP
    if width - 32 >= 108
      sp_x = x + width - 108
      flag = true
    elsif width - 32 >= 48
      sp_x = x + width - 48
      flag = false
    end
    # Draw SP
    self.contents.font.size = 16
    self.contents.font.color = actor.sp == 0 ? knockout_color :
      actor.sp <= actor.maxsp / 4 ? crisis_color : normal_color
    self.contents.draw_text(sp_x-16, y, 48, 32, actor.sp.to_s, 2)
    # Draw MaxSP
    if flag
      self.contents.font.color = normal_color
      self.contents.draw_text(sp_x + 38, y, 12, 32, "/", 1)#48
      self.contents.draw_text(sp_x + 50, y, 48, 32, actor.maxsp.to_s)
    end
    self.contents.font.size = $defaultfontsize
  end
  
  alias draw_actor_hp_bar draw_actor_hp
  the_setup = true
  if the_setup == true
    def draw_actor_hp(actor, x, y, width = 144) #144
      bar_x = HP_Pos_Adjust[0] + x
      bar_y = HP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
      @skin = RPG::Cache.windowskin(HP_Meter)
      @width  = @skin.width
      @height = @skin.height / 3
      src_rect = Rect.new(0, 0, @width, @height) #edit
      self.contents.blt(bar_x, bar_y, @skin, src_rect)    
      @line   = (actor.hp == actor.maxhp ? 2 : 1)
      @amount = 100 * actor.hp / actor.maxhp
      src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
      self.contents.blt(bar_x, bar_y, @skin, src_rect2)
      draw_actor_hp_bar(actor, x, y, width)
    end
  else #vertical version
    def draw_actor_hp(actor, x, y, width = 144) #draws the numbers
      #global positions of the bars
      bar_x = HP_Pos_Adjust[0] + x + (Font.default_size * 2 /3) 
      #parens thing makes sure it's in the right spot on the menu
      bar_y = HP_Pos_Adjust[1] + y 
      @skin = RPG::Cache.windowskin(HP_Meter2)#the windowskin used
      @width  = @skin.width / 3 #splits it into 3 parts
      @height = @skin.height #basic height
      #these are presumibly used to get a measure for how large to make the bars
      
      src_rect = Rect.new(0, 0, @width, @height) #bar background setup
      #x coords, y coords, image used, rectangle to draw
      self.contents.blt(bar_x, bar_y, @skin, src_rect) #base rectangle for back
      
      @line   = (actor.hp == actor.maxhp ? 2 : 1) #which line is it using
      @amount = 100 * actor.hp / actor.maxhp #percent of hp remaining
      
      #selects the proper bar, selects the y
      src_rect2 = Rect.new(@line * @width , 0 , @width , @height * @amount / 100) #the action rectangle
      self.contents.blt(bar_x, bar_y , @skin, src_rect2) #bacon lettuce tomato 
      #x coord, y coord, bitmap, rectangle
      #important note: this thing drains the bar the wrong way, 
      #even when I've attempted to flip the bar.
	  #that winds up only flipping the graphics
      draw_actor_hp_bar(actor, x, y, width) 
    end
    end
  #--------------------------------------------------------------------------
  alias draw_actor_sp_bar draw_actor_sp
  if the_setup == true
  def draw_actor_sp(actor, x, y, width = 144)
    bar_x = SP_Pos_Adjust[0] + x
    bar_y = SP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(SP_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.sp == actor.maxsp ? 2 : 1)
    @amount = (actor.maxsp == 0 ? 0 : 100 * actor.sp / actor.maxsp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    draw_actor_sp_bar(actor, x, y, width)
  end
    else #vertical version
    def draw_actor_sp(actor, x, y, width = 144) #draws the numbers
      #global positions of the bars
      bar_x = SP_Pos_Adjust[0] + x + (Font.default_size * 2 /3) 
      #parens thing makes sure it's in the right spot on the menu
      bar_y = SP_Pos_Adjust[1] + y 
      @skin = RPG::Cache.windowskin(MP_Meter)#the windowskin used
      @width  = @skin.width / 3 #splits spritesheet into 3 parts
      @height = @skin.height #basic height
      #these are presumibly used to get a measure for how large to make the bars
      
      src_rect = Rect.new(0, 0, @width, @height) #bar background setup
      #x coords, y coords, image used, rectangle to draw
      self.contents.blt(bar_x, bar_y, @skin, src_rect) #base rectangle for back
      
      @line   = (actor.sp == actor.maxsp ? 2 : 1) #which line is it using
      @amount = 100 * actor.sp / actor.maxsp #percent of mp remaining
      
      #selects the proper bar, selects the y
      src_rect2 = Rect.new(@line * @width , 0 , @width , @height * @amount / 100) #the action rectangle
      self.contents.blt(bar_x, bar_y , @skin, src_rect2) #bacon lettuce tomato 

      draw_actor_sp_bar(actor, x, y, width) 
    end
  end
  #--------------------------------------------------------------------------
  alias draw_actor_exp_bar draw_actor_exp
  def draw_actor_exp(actor, x, y)
    bar_x = EXP_Pos_Adjust[0] + x
    bar_y = EXP_Pos_Adjust[1] + y + (Font.default_size * 2 /3)
    @skin = RPG::Cache.windowskin(EXP_Meter)
    @width  = @skin.width
    @height = @skin.height / 3
    src_rect = Rect.new(0, 0, @width, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect)    
    @line   = (actor.now_exp == actor.next_exp ? 2 : 1)
    @amount = (actor.next_exp == 0 ? 0 : 100 * actor.now_exp / actor.next_exp)
    src_rect2 = Rect.new(0, @line * @height, @width * @amount / 100, @height)
    self.contents.blt(bar_x, bar_y, @skin, src_rect2)
    draw_actor_exp_bar(actor, x, y)
  end
end