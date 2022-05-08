=begin
#===================================================
# ■ AMS - Advanced Message Script - R4 [Update #2]
#===================================================
# For more infos and update, visit:
# www.dubealex.com (Creation Asylum)
#
# Edited, Fixed and Enhanced by: Dubealex
# Original Script Core by: XRXS Scripter (Jap Dudes)
# HTML Hexadecimal color feature from: Phylomorphis 
#
# Special Thanks:
# Rabu: For enabling the Show Face feature in an encrypted project
#
# To found all my new features, search the following:  #NEW
# To configure the button to skip the dialog, search:  #SKIP_TEXT_CODE
#
# May 18, 2005
#
# List of functions
#
# \P[Event ID] (player is ID 0),(noback is -1)
# \Name[\n[1]] (can put a name here or a variable)
# \% (disable textskip)
# \c[Color ID] (temp)
# \Color[6] (perm)
# \z[Color ID] (perm name color)
# \o[number] (opacity)
# \a[FileName] (text noises perm)
# \. (short wait)
# \| (long wait)
# \> (turn off gradual letters)
# \! (press any key prompt)
# \^ (end message)
# \n[num] (display actor name)
# \m[num] (display monster name)
# \v[num] (display variable)
# \v[inum]
# \\ (display \)
#
#===================================================

LETTER_BY_LETTER_MODE = true   #Set the letter by letter mode ON/OFF          

#===================================================
# ▼ CLASS AMS Begins
#===================================================
class AMS
 
 attr_accessor :name_box_x_offset
 attr_accessor :name_box_y_offset 
 attr_accessor :font_type
 attr_accessor :name_font_type
 attr_accessor :font_size
 attr_accessor :name_font_size
 attr_accessor :message_box_opacity 
 attr_accessor :name_box_skin
 attr_accessor :name_box_text_color
 attr_accessor :message_box_text_color
 attr_accessor :message_box_skin
 attr_accessor :name_box_width
 attr_accessor :name_box_height
 attr_accessor :message_width
 attr_accessor :message_height
 attr_accessor :message_x
 attr_accessor :message_y_bottom
 attr_accessor :message_y_middle
 attr_accessor :message_y_top
 attr_accessor :event_message_x_ofset
 attr_accessor :event_message_y_ofset
  
def initialize
  
 @name_box_x_offset = 0       #Choose the X axis offset of the name bos. default= 0
 @name_box_y_offset = -10    #Choose the Y axis offset of the name bos. default= -10
 @name_box_width = 10           #Choose the width of the Name Box. default= 8  
 @name_box_height = 28        #Choose the height of the Name Box. default= 26
 
 @font_type = "PlopDump"           #Choose the Font Name (Case Sensitive) for message box
 @name_font_type = "PlopDump" #Choose the Font Name (Case Sensitive) for Name Box
 @font_size = 20                      #Choose the default Font Size for message box text
 @name_font_size = 20            #Choose the deafault Font Size for Name Box text
 @name_box_text_color= 4        #Choose the Text Color of the Name Box
 @message_box_text_color=0   #Choose the Text Color of the Message Box
 
 @message_box_opacity = 160            #Choose the opacity of the message window. Default=160
 @message_box_skin = "mainskin"   #Choose the WindowSkin for the Message Box
 @name_box_skin = "mainskin"       #Choose the WindowSkin for the Name Box
 
 @message_width = 480          #Choose the width size of the message box. Default=480
 @message_height = 160         #Choose the height size of the message box. Default=160
 @message_x = 80                  #Choose the X position of the message box. Default=80
 @message_y_bottom = 304    #Choose the Y bottom position of the message box. Default=304
 @message_y_middle = 160    #Choose the Y middle position of the message box. Default=160
 @message_y_top = 16           #Choose the Y top position of the message box. Default=16
 
 @event_message_x_ofset = 0   #Choose the X position offset of the event message. Default=0
 @event_message_y_ofset = 70   #Choose the Y position offset of the event message. Default=48
 
end
end
#===================================================
# ▲ CLASS AMS Ends
#===================================================


#===================================================
# ▼ Class Window_Message Begins
#===================================================
class Window_Message < Window_Selectable   

alias xrxs9_initialize initialize

def initialize

@alex_skip = false

xrxs9_initialize

if $soundname_on_speak == nil then
  $soundname_on_speak = "Audio/SE/bip.wav"
end

$gaiji_file = "./Graphics/Gaiji/sample.png"

if FileTest.exist?($gaiji_file)
  @gaiji_cache = Bitmap.new($gaiji_file)
else
  @gaigi_cache = nil
end
@opacity_text_buf = Bitmap.new(32, 32)
end


#--------------------------------------------------------------------------

alias xrxs9_terminate_message terminate_message

def terminate_message
 
if @name_window_frame != nil
  @name_window_frame.dispose
  @name_window_frame = nil
end

if @name_window_text  != nil
  @name_window_text.dispose
  @name_window_text  = nil
end
xrxs9_terminate_message
end

#--------------------------------------------------------------------------

def refresh
 
self.contents.clear #get rid of everything
self.contents.font.color = text_color($ams.message_box_text_color) #color the box
self.contents.font.name = $ams.font_type #make the font right
self.contents.font.size = $ams.font_size
self.windowskin = RPG::Cache.windowskin($ams.message_box_skin) #use the right windowkin
@x = @y = @max_x = @max_y = @indent = @lines = 0 
@face_indent = 0
@opacity = 255
@cursor_width = 0
@write_speed = 0
@write_wait = 0
@mid_stop = false
@face_file = nil
@popchar = -2 #a bunch of settings

if $game_temp.choice_start == 0
  @x = 8
end

if $game_temp.message_text != nil
  @now_text = $game_temp.message_text
  if (/\A\\[Ff]\[(.+?)\]/.match(@now_text))!=nil then
     @face_file = $1 + ".png"
     @x = @face_indent = 128
    if FileTest.exist?("Graphics/Pictures/" + $1 + ".png")
      self.contents.blt(16, 16, RPG::Cache.picture(@face_file), Rect.new(0, 0, 96, 96))
    end
    @now_text.gsub!(/\\[Ff]\[(.*?)\]/) { "" }
  end

  begin
  last_text = @now_text.clone
  @now_text.gsub!(/\\[Vv]\[([IiWwAaSs]?)([0-9]+)\]/) { convart_value($1, $2.to_i) }
  end until @now_text == last_text
  @now_text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
    $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
   end
  
  #NEW
  #Dubealex's Stop Skip Text ON-OFF
  @now_text.gsub!(/\\[%]/) { "\100" }
  #End new command
   
  #NEW
  #Dubealex's Show Monster Name Feature
   @now_text.gsub!(/\\[Mm]\[([0-9]+)\]/) do
   $data_enemies[$1.to_i] != nil ? $data_enemies[$1.to_i].name : ""
   end
   #End new command
   
  #NEW
  #Dubealex's Show Item Price Feature
   @now_text.gsub!(/\\[Pp]rice\[([0-9]+)\]/) do
   $data_items[$1.to_i] != nil ? $data_items[$1.to_i].price : ""
   end
   #End new command
   
  #NEW
  #Dubealex's Show Hero Class Name Feature
   @now_text.gsub!(/\\[Cc]lass\[([0-9]+)\]/) do
   $data_classes[$data_actors[$1.to_i].class_id] != nil ? $data_classes[$data_actors[$1.to_i].class_id].name : ""
   end
   #End new command
   
  #NEW
  #Dubealex's Show Current Map Name Feature
   @now_text.gsub!(/\\[Mm]ap/) do
   $game_map.name    != nil ? $game_map.name    : ""
   end
   #End new command
   
  #NEW
  #Dubealex's Choose Name Box Text Color
   @now_text.gsub!(/\\[Zz]\[([0-9]+)\]/) do
   $ams.name_box_text_color=$1.to_i
   @now_text.sub!(/\\[Zz]\[([0-9]+)\]/) { "" }
   end
   #End new command
   
  name_window_set = false
  if (/\\[Nn]ame\[(.+?)\]/.match(@now_text)) != nil
    name_window_set = true
    name_text = $1
    @now_text.sub!(/\\[Nn]ame\[(.*?)\]/) { "" }
  end

  if (/\\[Pp]\[([-1,0-9]+)\]/.match(@now_text))!=nil then
    @popchar = $1.to_i
    if @popchar == -1
      @x = @indent = 48
      @y = 4
    end
    @now_text.gsub!(/\\[Pp]\[([-1,0-9]+)\]/) { "" }
  end

  @max_choice_x = 0
  if @popchar >= 0
    @text_save = @now_text.clone
    @max_x = 0
    @max_y = 4
    for i in 0..3
      line = @now_text.split(/\n/)[3-i]
      @max_y -= 1 if line == nil and @max_y <= 4-i
      next if line == nil
      line.gsub!(/\\\w\[(\w+)\]/) { "" }
      cx = contents.text_size(line).width
      @max_x = cx if cx > @max_x
      if i >= $game_temp.choice_start
        @max_choice_x = cx if cx > @max_choice_x
      end
    end
    self.width = @max_x + 32 + @face_indent
    self.height = (@max_y - 1) * 32 + 64
    @max_choice_x -= 68
    @max_choice_x -= @face_indent*216/128
  else
    @max_x = self.width - 32 - @face_indent
    for i in 0..3
      line = @now_text.split(/\n/)[i]
      next if line == nil
      line.gsub!(/\\\w\[(\w+)\]/) { "" }
      cx = contents.text_size(line).width
      if i >= $game_temp.choice_start
        @max_choice_x = cx if cx > @max_choice_x
      end
    end
    @max_choice_x += 8
  end
  @cursor_width = 0
  @now_text.gsub!(/\\\\/) { "\000" }
  @now_text.gsub!(/\\[Cc]\[([0123456789ABCDEF#]+)\]/) { "\001[#{$1}]" }
  @now_text.gsub!(/\\[Gg]/) { "\002" }
  @now_text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\003[#{$1}]" }
  @now_text.gsub!(/\\[Aa]\[(.*?)\]/) { "\004[#{$1}]" }
  
   #NEW 
   #Dubealex's Permanent Color Change
   @now_text.gsub!(/\\[Cc]olor\[([0-9]+)\]/) do
     $ams.message_box_text_color= $1.to_i
    @now_text.sub!(/\\[Cc]\[([0-9]+)\]/) { "" }
     end
   #End of new command
   
   #NEW 
   #Dubealex's Font Change Feature
    @now_text.gsub(/\\[Tt]\[(.*?)\]/) do
     buftxt = $1.to_s
     $ams.font_type = buftxt
     @now_text.sub!(/\\[Tt]\[(.*?)\]/) { "" }
     end
   #End of new command
   
  @now_text.gsub!(/\\[.]/) { "\005" }
  @now_text.gsub!(/\\[|]/) { "\006" }
  @now_text.gsub!(/\\[>]/) { "\016" }
  @now_text.gsub!(/\\[<]/) { "\017" }
  @now_text.gsub!(/\\[!]/) { "\020" }
  @now_text.gsub!(/\\[~]/) { "\021" }
  @now_text.gsub!(/\\[Ee]\[([0-9]+)\]/) { "\022[#{$1}]" }
  @now_text.gsub!(/\\[Ii]/) { "\023" }
  @now_text.gsub!(/\\[Oo]\[([0-9]+)\]/) { "\024[#{$1}]" }
  @now_text.gsub!(/\\[Hh]\[([0-9]+)\]/) { "\025[#{$1}]" }
  @now_text.gsub!(/\\[Bb]\[([0-9]+)\]/) { "\026[#{$1}]" }
  @now_text.gsub!(/\\[Rr]\[(.*?)\]/) { "\027[#{$1}]" }
  
  reset_window
  
  if name_window_set
    color=$ams.name_box_text_color
    off_x =  $ams.name_box_x_offset
    off_y =  $ams.name_box_y_offset
    space = 2
    x = self.x + off_x - space / 2
    y = self.y + off_y - space / 2
    w = self.contents.text_size(name_text).width + $ams.name_box_width + space
    h = $ams.name_box_height + space
    @name_window_frame = Window_Frame.new(x, y, w, h)
    @name_window_frame.z = self.z + 1
    x = self.x + off_x + 4
    y = self.y + off_y
    @name_window_text  = Air_Text.new(x, y, name_text, color)
    @name_window_text.z = self.z + 2
  end
end

reset_window

if $game_temp.choice_max > 0
  @item_max = $game_temp.choice_max
  self.active = true
  self.index = 0
end

if $game_temp.num_input_variable_id > 0
  digits_max = $game_temp.num_input_digits_max
  number = $game_variables[$game_temp.num_input_variable_id]
  @input_number_window = Window_InputNumber.new(digits_max)
  @input_number_window.number = number
  @input_number_window.x = self.x + 8
  @input_number_window.y = self.y + $game_temp.num_input_start * 32
end
end

#--------------------------------------------------------------------------

def update
 
super

if @fade_in
  self.contents_opacity += 24
  if @input_number_window != nil
    @input_number_window.contents_opacity += 24
  end
  if self.contents_opacity == 255
    @fade_in = false
  end
  return
end
@now_text = nil if @now_text == "" 

if @now_text != nil and @mid_stop == false
  if @write_wait > 0
    @write_wait -= 1
    return
  end
  text_not_skip = LETTER_BY_LETTER_MODE
  while true
    @max_x = @x if @max_x < @x
    @max_y = @y if @max_y < @y
    if (c = @now_text.slice!(/./m)) != nil
      if c == "\000"
        c = "\\"
      end
      
      if c == "\001"
        @now_text.sub!(/\[([0123456789ABCDEF#]+)\]/, "")
        temp_color = $1
        color = temp_color.to_i
        leading_x = temp_color.to_s.slice!(/./m)
        if leading_x == "#"
          self.contents.font.color = hex_color(temp_color)
          next
        end
        if color >= 0 and color <= 7
          self.contents.font.color = text_color(color)
        end
        next
      end

      if c == "\002"
        if @gold_window == nil and @popchar <= 0
          @gold_window = Window_Gold.new
          @gold_window.x = 560 - @gold_window.width
          if $game_temp.in_battle
            @gold_window.y = 192
          else
            @gold_window.y = self.y >= 128 ? 32 : 384
          end
          @gold_window.opacity = self.opacity
          @gold_window.back_opacity = self.back_opacity
        end
        c = ""
      end

      if c == "\003"
        @now_text.sub!(/\[([0-9]+)\]/, "")
        speed = $1.to_i
        if speed >= 0 and speed <= 19
          @write_speed = speed
        end
        c = ""
      end

      if c == "\004"
        @now_text.sub!(/\[(.*?)\]/, "")
        buftxt = $1.dup.to_s
        if buftxt.match(/\//) == nil and buftxt != "" then
          $soundname_on_speak = "Audio/SE/" + buftxt #edit this
          
        else
          $soundname_on_speak = buftxt.dup
        end
        c = ""
      elsif c == "\004" 
        c = ""
      end
      
      if c == "\005"
        @write_wait += 5
        c = ""
      end
      
      if c == "\006"
        @write_wait += 20
        c = ""
      end
      
      if c == "\016"
        text_not_skip = false
        c = ""
      end
      
      if c == "\017"
        text_not_skip = true
        c = ""
      end
      
      if c == "\020"
        @mid_stop = true
        c = ""
      end
      
      if c == "\021"
        terminate_message
        return
      end
      
      if c == "\023"
        @indent = @x
        c = ""
      end

      if c == "\024"
        @now_text.sub!(/\[([0-9]+)\]/, "")
        @opacity = $1.to_i
        color = self.contents.font.color
        self.contents.font.name = $ams.font_type
        self.contents.font.size = $ams.font_size
        self.contents.font.color = Color.new(color.red, color.green, color.blue, color.alpha * @opacity / 255)
        c = ""
      end

      if c == "\025"
        @now_text.sub!(/\[([0-9]+)\]/, "")
        self.contents.font.size = [[$1.to_i, 6].max, 32].min
        c = ""
      end

      if c == "\026"
        @now_text.sub!(/\[([0-9]+)\]/, "")
        @x += $1.to_i
        c = ""
      end
      
      if c == "\027"
        @now_text.sub!(/\[(.*?)\]/, "")
        @x += ruby_draw_text(self.contents, @x, @y * line_height + (line_height - self.contents.font.size), $1, @opacity)
        if $soundname_on_speak != ""
          Audio.se_play($soundname_on_speak)
        end
      c = ""
      end

      if c == "\030"
        @now_text.sub!(/\[(.*?)\]/, "")
        self.contents.blt(@x , @y * line_height + 8, RPG::Cache.icon($1), Rect.new(0, 0, 24, 24))
        if $soundname_on_speak != ""
          Audio.se_play($soundname_on_speak)
        end
        @x += 24
        c = ""
      end

      if c == "\n"
        @lines += 1
        @y += 1
        @x = 0 + @indent + @face_indent
        if @lines >= $game_temp.choice_start
          @x = 8 + @indent + @face_indent
          @cursor_width = @max_choice_x
        end
        c = ""
      end
      
      if c == "\022"
        @now_text.sub!(/\[([0-9]+)\]/, "")
        @x += gaiji_draw(4 + @x, @y * line_height + (line_height - self.contents.font.size), $1.to_i)
        c = ""
      end
      
      #NEW
      #Dubealex's Text Skip On/OFF Command
       if c == "\100"
          if @alex_skip==false
             @alex_skip=true
          else
            @alex_skip=false
          end
         c = ""
       end  
       #end of new command
                                   
      if c != ""
        self.contents.draw_text(0+@x, 32 * @y, 40, 32, c)
        @x += self.contents.text_size(c).width
        if $soundname_on_speak != "" then
          Audio.se_play($soundname_on_speak)
        end
      end
      
#SKIP_TEXT_CODE

# B = Escape, 0 (On The NumPad), X 
# C = Enter, Space Bar and C
# A = Shift, Z 

  if Input.press?(Input::C) # <-- Change the value on that line
    if @alex_skip==false      
    text_not_skip = false
    end
      end
    else
      text_not_skip = true
      break
    end
    
    if text_not_skip
      break
    end
  end
  @write_wait += @write_speed
  return
end

if @input_number_window != nil
  @input_number_window.update
  if Input.trigger?(Input::C)
    $game_system.se_play($data_system.decision_se)
    $game_variables[$game_temp.num_input_variable_id] =
      @input_number_window.number
    $game_map.need_refresh = true
    @input_number_window.dispose
    @input_number_window = nil
    terminate_message
  end
  return
end

if @contents_showing
  if $game_temp.choice_max == 0
    self.pause = true
  end
  
  if Input.trigger?(Input::B)
    if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
      $game_system.se_play($data_system.cancel_se)
      $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
      terminate_message
    end
  end
  
  if Input.trigger?(Input::C)
    if $game_temp.choice_max > 0
      $game_system.se_play($data_system.decision_se)
      $game_temp.choice_proc.call(self.index)
    end
    if @mid_stop
      @mid_stop = false
      return
    else
      terminate_message
    end
  end
  return
end

if @fade_out == false and $game_temp.message_text != nil
  @contents_showing = true
  $game_temp.message_window_showing = true
  refresh
  Graphics.frame_reset
  self.visible = true
  self.contents_opacity = 0
  if @input_number_window != nil
    @input_number_window.contents_opacity = 0
  end
  @fade_in = true
  return
end

if self.visible
  @fade_out = true
  self.opacity -= 48
  if self.opacity == 0
    self.visible = false
    @fade_out = false
    $game_temp.message_window_showing = false
  end
  return
end
end

#--------------------------------------------------------------------------

def get_character(parameter)

case parameter
when 0  
  return $game_player
else 
  events = $game_map.events
  return events == nil ? nil : events[parameter]
end
end

#--------------------------------------------------------------------------

def reset_window

#MESSAGE_SIZE
#MESSAGE_POSITION

if @popchar >= 0
  events = $game_map.events
  if events != nil
    character = get_character(@popchar)
    x = [[character.screen_x -  $ams.event_message_x_ofset - self.width / 2, 4].max, 636 - self.width].min
    
    if character.screen_y < 190
      y = [[character.screen_y + $ams.event_message_y_ofset + 30 - self.height, 4].max, 476 - self.height].min
    else
      y = [[character.screen_y - $ams.event_message_y_ofset - self.height, 4].max, 476 - self.height].min
    end
    
      #the y is set up so it's at the char's screen position, minus the offset,
#and then minus the height, 
    self.x = x
    self.y = y
  end
elsif @popchar == -1
  self.x = -4
  self.y = -4
  self.width = 648
  self.height = 488
else
  if $game_temp.in_battle
    self.y = 16
  else
    case $game_system.message_position
    when 0  
      self.y = $ams.message_y_top
    when 1  
      self.y = $ams.message_y_middle
    when 2  
      self.y = $ams.message_y_bottom
    end
    self.x = $ams.message_x
    if @face_file == nil
      self.width = $ams.message_width
      self.x = $ams.message_x
    else
      if self.width <= 600
        self.width = 600
        self.x -=60
       end 
    end
    self.height = $ams.message_height
  end
end
self.contents = Bitmap.new(self.width - 32, self.height - 32)
self.contents.font.color = text_color($ams.message_box_text_color)
self.contents.font.name = $ams.font_type
 self.contents.font.size = $ams.font_size
if @face_file != nil
  self.contents.blt(16, 16, RPG::Cache.picture(@face_file), Rect.new(0, 0, 96, 96))
end
if @popchar == -1
  self.opacity = 255
  self.back_opacity = 0
elsif $game_system.message_frame == 0
  self.opacity = 255
  self.back_opacity = $ams.message_box_opacity
else
  self.opacity = 0
  self.back_opacity = $ams.message_box_opacity
end
end

#--------------------------------------------------------------------------

def gaiji_draw(x, y, num)

if @gaiji_cache == nil
  return 0
else
  if @gaiji_cache.width < num * 24
    return 0
  end

  if self.contents.font.size >= 20 and self.contents.font.size <= 24
    size = 24
  else
    size = self.contents.font.size * 100 * 24 / 2200
  end

  self.contents.stretch_blt(Rect.new(x, y, size, size), @gaiji_cache, Rect.new(num * 24, 0, 24, 24))

  if $soundname_on_speak != "" then
    Audio.se_play($soundname_on_speak) #EDIT
  end
  return size
end
end

#--------------------------------------------------------------------------

def line_height
return 32

if self.contents.font.size >= 20 and self.contents.font.size <= 24
  return 32
else
  return self.contents.font.size * 15 / 10
end
end

#--------------------------------------------------------------------------

def ruby_draw_text(target, x, y, str,opacity)

sizeback = target.font.size
target.font.size * 3 / 2 > 32 ? rubysize = 32 - target.font.size : rubysize = target.font.size / 2
rubysize = [rubysize, 6].max
opacity = [[opacity, 0].max, 255].min
split_s = str.split(/,/)
split_s[0] == nil ? split_s[0] = "" : nil
split_s[1] == nil ? split_s[1] = "" : nil

height = sizeback + rubysize
width  = target.text_size(split_s[0]).width

target.font.size = rubysize
ruby_width = target.text_size(split_s[1]).width
target.font.size = sizeback

buf_width = [target.text_size(split_s[0]).width, ruby_width].max

width - ruby_width != 0 ? sub_x = (width - ruby_width) / 2 : sub_x = 0

if opacity == 255
  target.font.size = rubysize
  target.draw_text(x + sub_x, y - target.font.size, target.text_size(split_s[1]).width, target.font.size, split_s[1])
  target.font.size = sizeback
  target.draw_text(x, y, width, target.font.size, split_s[0])
  return width
else
  if @opacity_text_buf.width < buf_width or @opacity_text_buf.height < height
    @opacity_text_buf.dispose
    @opacity_text_buf = Bitmap.new(buf_width, height)
  else
    @opacity_text_buf.clear
  end
  @opacity_text_buf.font.size = rubysize
  @opacity_text_buf.draw_text(0 , 0, buf_width, rubysize, split_s[1], 1)
  @opacity_text_buf.font.size = sizeback
  @opacity_text_buf.draw_text(0 , rubysize, buf_width, sizeback, split_s[0], 1)
  if sub_x >= 0
    target.blt(x, y - rubysize, @opacity_text_buf, Rect.new(0, 0, buf_width, height), opacity)
  else
    target.blt(x + sub_x, y - rubysize, @opacity_text_buf, Rect.new(0, 0, buf_width, height), opacity)
  end
  return width
end
end

#--------------------------------------------------------------------------

def convart_value(option, index)
option == nil ? option = "" : nil
option.downcase!

case option
when "i"
  unless $data_items[index].name == nil
    r = sprintf("\030[%s]%s", $data_items[index].icon_name, $data_items[index].name)
  end
when "w"
  unless $data_weapons[index].name == nil
    r = sprintf("\030[%s]%s", $data_weapons[index].icon_name, $data_weapons[index].name)
  end
when "a"
  unless $data_armors[index].name == nil
    r = sprintf("\030[%s]%s", $data_armors[index].icon_name, $data_armors[index].name)
  end
when "s"
  unless $data_skills[index].name == nil
    r = sprintf("\030[%s]%s", $data_skills[index].icon_name, $data_skills[index].name)
  end
else
  r = $game_variables[index]
end

r == nil ? r = "" : nil
return r
end

#--------------------------------------------------------------------------

def dispose
terminate_message

if @gaiji_cache != nil
  unless @gaiji_cache.disposed?
    @gaiji_cache.dispose
  end
end

unless @opacity_text_buf.disposed?
  @opacity_text_buf.dispose
end

$game_temp.message_window_showing = false
if @input_number_window != nil
  @input_number_window.dispose
end
super
end

#--------------------------------------------------------------------------

def update_cursor_rect
if @index >= 0
  n = $game_temp.choice_start + @index
  self.cursor_rect.set(8 + @indent + @face_indent, n * 32, @cursor_width, 32)
else
  self.cursor_rect.empty
end
end
end
#=========================================
# ▲ CLASS Window_Message Ends
#=========================================


#=========================================
# ▼ Class Window_Frame Begins
#=========================================
class Window_Frame < Window_Base

def initialize(x, y, width, height)
super(x, y, width, height)
self.windowskin = RPG::Cache.windowskin($ams.name_box_skin)
self.contents = nil
end

#--------------------------------------------------------------------------

def dispose
super
end
end
#=========================================
# ▲ CLASS Window_Frame Ends
#=========================================


#=========================================
# ▼ CLASS Game_Map Additional Code Begins
#=========================================
class Game_Map

#Dubealex's Addition (from XRXS) to show Map Name on screen
def name
 $map_infos[@map_id]
end
end
#=========================================
# ▲ CLASS Game_Map Additional Code Ends
#=========================================


#=========================================
# ▼ CLASS Scene_Title Additional Code Begins
#=========================================
class Scene_Title

#Dubealex's Addition (from XRXS) to show Map Name on screen
 $map_infos = load_data("Data/MapInfos.rxdata")
 for key in $map_infos.keys
   $map_infos[key] = $map_infos[key].name
 end
 
 #Dubealex's addition to save data from the AMS in the save files
 $ams = AMS.new
 
end
#=========================================
# ▲ CLASS Scene_Title Additional Code Ends
#=========================================


#=========================================
# ▼ CLASS Window_Base Additional Code Begins
#=========================================
class Window_Base < Window

#Dubealex Addition (from Phylomorphis) to use HTML Hex Code Colors
def hex_color(string)
  red = 0
  green = 0
  blue = 0
  if string.size != 6
    print("Hex strings must be six characters long.")
    print("White text will be used.")
    return Color.new(255, 255, 255, 255)
  end
  for i in 1..6
    s = string.slice!(/./m)
    if s == "#"
      print("Hex color string may not contain the \"#\" character.")
      print("White text will be used.")
      return Color.new(255, 255, 255, 255)
    end
    value = hex_convert(s)
    if value == -1
      print("Error converting hex value.")
      print("White text will be used.")
      return Color.new(255, 255, 255, 255)
    end
    case i
    when 1
      red += value * 16
    when 2
      red += value
    when 3
      green += value * 16
    when 4
      green += value
    when 5
      blue += value * 16
    when 6
      blue += value
    end
  end
  return Color.new(red, green, blue, 255)
end

#--------------------------------------------------------------------------

def hex_convert(character)
  case character
   when "0"
     return 0
  when "1"
     return 1
  when "2"
     return 2
  when "3"
     return 3
  when "4"
     return 4
  when "5"
     return 5
  when "6"
     return 6
  when "7"
     return 7
  when "8"
     return 8
  when "9"
     return 9
  when "A"
     return 10
  when "B"
     return 11
  when "C"
     return 12
  when "D"
     return 13
  when "E"
     return 14
  when "F"
     return 15
   end
  return -1
end
end
#=========================================
# ▲ CLASS Window_Base Additional Code Ends
#=========================================


#=========================================
# ▼ Class Air_Text Begins 
#=========================================
class Air_Text < Window_Base

def initialize(x, y, designate_text, color=0)
 
super(x-16, y-16, 32 + designate_text.size * 12, 56)
self.opacity      = 0
self.back_opacity = 0
self.contents = Bitmap.new(self.width - 32, self.height - 32)
w = self.contents.width
h = self.contents.height
self.contents.font.name = $ams.name_font_type
self.contents.font.size = $ams.name_font_size
self.contents.font.color = text_color(color)
self.contents.draw_text(0, 0, w, h, designate_text)
end

#--------------------------------------------------------------------------

def dispose
self.contents.clear
super
end
end 
#==========================================
# ▲ CLASS Air_Text  Ends
#==========================================


#===================================================
# ▼ CLASS Scene_Save Additional Code Begins
#===================================================
class Scene_Save < Scene_File
 
 alias ams_original_write_save_data write_save_data
 
 def write_save_data(file)
   ams_original_write_save_data(file)
   Marshal.dump($ams, file)
 end
 
end
#===================================================
# ▲ CLASS Scene_Save Additional Code Ends
#=================================================== 


#===================================================
# ▼ CLASS Scene_Load Additional Code Begins
#===================================================
class Scene_Load < Scene_File
 
 alias ams_original_read_save_data read_save_data
 
 def read_save_data(file)
   ams_original_read_save_data(file)
   $ams      = Marshal.load(file)
 end
 
end
#===================================================
# ▲ CLASS Scene_Load Additional Code Ends
#===================================================
=end