#-----------------------------------
#
# Some fancy-ass cooking menu
# By shinyjiggly
#
#------------------------------------

#top
class Window_Cooking < Window_Base 
  
def initialize
    super(0, 0, 640, 64)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    self.contents.clear
    self.contents.font.color = text_color(0)
    self.contents.draw_text(0, 0, width-32, 32, "Recipe Menu",1) 
  end
end

#-------------
#available menu topper
class Window_ava < Window_Base 
  
def initialize
    super(0, 0, 320, 64)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    self.contents.clear
    self.contents.font.color = text_color(6)
    self.contents.draw_text(0, 0, width-32, 32, "Available Recipes",1) 
  end
  
end
#--------------------
#available menu body
class Window_avarec < Window_Selectable
  
def initialize
    super(0, 0, 320, 192)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  
def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil

    end
    
    @data = [] #the array we'll be storing this stuff into
    start = 20
    
      for j in start...$data_armors.size-start
        break if $data_armors[j].name == "--end--" #dynamic end checker
          @data.push($data_armors[j]) 
          #pushes the current loop intex'd armor into the data array
    end
    
    @item_max = @data.size #the size of the data array
      #print @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_meal(i) #draw this many meals
      end
    end
  end
  
  
  def draw_meal(index) #drawwwwww
    meal = @data[index] #meal is now the entry of data that was specified earlier
    @column_max = 1
    
    x = 4 #+ index % 2 * (288 + 32) #sets the x
    y = index * 32 #sets the y (half of the index times 32)
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(meal.icon_name) #icon drawing
  
    opacity = self.contents.font.color == normal_color ? 255 : 128
    #if it's the normal color, full opacity. otherwise, half opacity
    
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, meal.name, 0) #name
  end
end


#-------------
#ingredience title
class Window_ing < Window_Base
  
def initialize
    super(0, 0, 320, 64)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    self.contents.clear
    self.contents.font.color = text_color(6)
    self.contents.draw_text(0, 0, width-32, 32, "Ingredients Used:",1) 
  end
  
end
#-------------------
#ingredience menu body
class Window_ingrec < Window_Base 
  
def initialize
    super(0, 0, 320, 128)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    y=0
    self.contents.clear
    self.contents.font.color = text_color(0)
    #put the enbtire database of required ingredience here
    
    #make this thing better later
    self.contents.draw_text(0, y, width-32, 32, "Ingredient 1") 
    y+=32
    self.contents.draw_text(0, y, width-32, 32, "Ingredient 2") 
    y+=32
    self.contents.draw_text(0, y, width-32, 32, "Ingredient 3") 
    y+=32
  end
  
end
#----
#available menu topper
class Window_ava < Window_Base 
  
def initialize
    super(0, 0, 320, 64)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    self.contents.clear
    self.contents.font.color = text_color(6)
    self.contents.draw_text(0, 0, width-32, 32, "Available Recipes",1) 
  end
  
end

#-----------------
#help menmu thing
class Window_cookhelp < Window_Base 
  
def initialize
    super(0, 0, 640, 128)
    self.contents = Bitmap.new(width-32, height-32)
    refresh
  end
  
def refresh
    self.contents.clear
    self.contents.font.color = text_color(0)
    self.contents.draw_text(0, 0, width-32, 32, "bottom text") 
  end
end

#-----------------------------------------------------------------------

class Scene_Cooking

def main
  @background = Plane.new #background initialization
  @background.bitmap = RPG::Cache.panorama("plaidpattern",0)
  @window_1=Window_Cooking.new #allll of the windows
  @window_2=Window_ava.new
  @window_2.y=64
  @window_3=Window_avarec.new
  @window_3.y=128
  
  @window_4=Window_ing.new
  @window_4.x=320
  @window_4.y=64
  @window_5=Window_ingrec.new
  @window_5.x=320
  @window_5.y=128
  
  @window_6=Window_cookhelp.new
  @window_6.y=352

   Graphics.transition #main loop thing
   loop do
    Graphics.update
    Input.update
    update
    if $scene != self
     break
    end
   end

  Graphics.freeze #disposal
   @window_1.dispose
   @window_2.dispose
   @window_3.dispose
   @window_4.dispose
   @window_5.dispose
   @window_6.dispose
   @background.dispose
  end

def update #exit handling
  @window_3.update #update whichever windows need updating here
  @background.ox -= 1 #move the background here
  @background.oy -= 1
   if Input.trigger?(Input::B)
     $game_system.se_play($data_system.cancel_se)
     $scene = Scene_Menu.new(6)
     #$scene = Scene_Map.new
   end
  end

end