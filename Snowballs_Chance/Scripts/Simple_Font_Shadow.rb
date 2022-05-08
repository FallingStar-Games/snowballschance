################################################################################
# ■ Super Simple Font Shadow v1.3 by g@Mef@Ce 7/6/2011  www.gameface101.com                            #
################################################################################

#==============================================================================
# ● Customization
#==============================================================================
module G101_FS
#font_shadow horizontal position
FS_X = 2
#font_shadow verticle position
FS_Y = 2
#font_shadow color options
# 1 = black
# 2 = white
# 3 = grey
# 4 = red
# 5 = green
# 6 = blue
# 7 = purple
# 8 = orange
# 9 = brown
#10 = pink
#11 = random
$fs_color = 11
#end of module
end
#==============================================================================
# ■ Bitmap 
#==============================================================================
class Bitmap
#use constants in module  
include G101_FS
#prevent reset over flow 
unless @font_shadow == true
   alias draw_shadow draw_text
   @font_shadow = true
#end unless
end
#==============================================================================
# ● define draw_text method
#==============================================================================
def draw_text(fsx = 0, fsy = 0, fsw = 0, fsh = 0, fss = 0, fsa = 0)
#if draw_text is being used for a rectangle bitmap
   if fsx.is_a?(Rect)
     x = fsx.x
     y = fsx.y
     width = fsx.width
     height = fsx.height     
     string = fsy
     align = fsw
   else
#set variables for arguments
     x = fsx
     y = fsy
     width = fsw
     height = fsh
     string = fss
     align = fsa
   end
#duplicate font color
   @shade = self.font.color.dup
#set font color in module
case ($fs_color)
when 1 #black
   self.font.color = Color.new(0, 0, 0, 200)
when 2 #white
   self.font.color = Color.new(0, 0, 0, 200)
when 3 #grey
   self.font.color = Color.new(0, 0, 0, 200)
when 4 #red
   self.font.color = Color.new(0, 0, 0, 200)
when 5 #green
   self.font.color = Color.new(0, 255, 0, 200)
when 6 #blue
   self.font.color = Color.new(0, 0, 255, 200)
when 7 #purple
   self.font.color = Color.new(160, 32, 240, 200)
when 8 #orange
   self.font.color = Color.new(255, 165, 0, 200)
when 9 #brown
   self.font.color = Color.new(160, 82, 45, 200)
when 10 #pink
   self.font.color = Color.new(255, 192, 203, 200)
when 11 #random
fsr = rand(200) + 55
fsg = rand(200) + 55
fsb = rand(200) + 55
    self.font.color = Color.new(0, 0, 0, 100)
   #self.font.color = Color.new(fsr, fsg, fsb, 200)
# to be continued...?
end
#draw shadow with indent
  draw_shadow(x + FS_X, y + FS_Y, width, height, string, align)
#duplicate font color
   self.font.color = @shade
#draw shadow
draw_shadow(x, y, width, height, string, align)
#end of draw text method
end
#end of Bitmap class
end
#end of script ^,^ 