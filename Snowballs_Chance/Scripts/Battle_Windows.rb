#==============================================================================
# Add-On: Battle Window EDIT
# by Atoa
#==============================================================================
# This Add-On grants the user a high custmization level of the battle windows
# Allowing font change, size and position of the text on the window.
# And also allowing the change of the position, size and opacity of the window.
#==============================================================================

module Atoa
  
  # Exhibition Type (take a look at the 'IMPORTANT WARNING' just bellow)
  
  Display_Type = 2 #2
  
  # If Display_Type = 0 the character attributes will be shown 
  # on the traditional XPway , horizontaly.
  # Ex.:
  # Ash        Trevor     Monique
  # HP  741    HP  695    HP  486 
  # SP  541    SP  591    SP  661
  #
  # If Display_Type = 1 the character attributes will be shwon 
  # verticaly.
  # Ex.:
  # Ash     HP  741  SP  541
  # Trevor  HP  695  SP  591
  # Monique HP  486  SP  661
  #
  # If 'Display_Type = 2', the position will be custom. Adjust the postions below
  #

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  #                          ***IMPORTANT WARNING**                          #
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  #
  # If you change the value of 'Display_Type', you must readjust *ALL*
  # X/Y coordinates of the texts. The change isn't automatic.
  # Stay alert about this.
  #
  #============================================================================

  # Only valid if 'Display_Type = 0', allows the centralization of the status
  # windows if the group has less then 4 members
  Horizontal_Centralize = false
  
  # Only valid if 'Display_Type = 2', adjust the base position of the attributes
  # of each character
  Custom_Stat_Position = [[440,134],[440,196],[440,268],[512,134],[512,196],[512,268],[584, 106],[584,168],[584,230],[584,292]]
  #[[440,256],[440,318],[440,390],[512,256],[512,318],[512,390],[584, 228],[584,290],[584,352],[584,414]]
  #[[353,180],[353, 258],[353,346],[455,145],[455,223],[455,305],[457,371],[555,180],[555,258],[555,346]]

  # Configuration of the Attributes Battle Window
  # Battle_Window = [Position X, Position Y, Width, Height, Opacity, Trasparent Edge]
  Battle_Window = [0 , 0, 670, 500, 0, true]
  # Leave the last value true to add the opacity to the edge of the window
  # Needed if you wish to make 100% transparent windows
  
  # The text format will be applied to the values in the menu?
  Text_Format_in_Menu = false
  # true = all format config are applied to the values in the menu
  # false = the format configs are valid only in battle
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CONFIGURATION OF THE WINDOW CONTENT                                        #
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  # Configuration of the name exhibition
  # Name_Config = [Position X, Position Y, Font Name, Font Size, Bold]
  Name_Config = [0, 6, 'Arial', 12, false]
  
  # Configuration of the HP text exhibition
  # HP_Text = [Position X, Position Y, Font Name, Font Size, Bold]
  HP_Text = [0, 24, 'Arial', 12, false]
   
  # Configuration of the HP digits exhibition
  # HP_Number = [Font Name, Font Size, Bold, Show Max HP]
  HP_Number = ['Arial', 12, false, true]
  
  # Configuration of the Max HP digits exhibition
  # Max_HP_Number = [Font Name, Font Size, Bold]
  Max_HP_Number = ['Arial', 12, false]   

  # Configuration of the SP text exhibition
  # SP_Text = [Position X, Position Y, Font Name, Font Size, Bold]
  SP_Text = [0, 34, 'Arial', 12, false]
  
  # Configuration of the SP digits exhibition
  # SP_Number = [Font Name, Font Size, Bold, Show Max HP]
  SP_Number = ['Arial', 12, false, true]   
  
  # Configuration of the Max SP digits exhibition
  # Max_SP_Number = [Font Name, Font Size, Bold]
  Max_SP_Number = ['Arial', 12, false]   
  
  # Configuration of the States exhibition
  # State_Config = [Position X, Position Y]
  State_Config = [0, 45]
  # Show Level Up Message in status window?
  Lvl_UP_FLAG = false
  # Level Up Message
  Lvl_Up_Msg = 'LEVEL UP!'
  # The level up message is shown in the same place as the states
 
  # Configuration of the Level exhibition
  Draw_Level = false # Show level in status window?
  Level_Name = 'Lv' # Name of the 'Level' Status shown in the window
  
  # Configuration of the Level text exhibition
  # Level_Text = [Position X, Position Y, Font Name, Font Size, Bold]
  Level_Text = [0, 16, 'Arial', 12, false]
 
  # Configuration of the Level digits exhibition
  # Level_Number = [Font Name, Font Size, Bold]
  Level_Number = ['Arial', 12, false]   
  
  # Configuration of the Exp exhibition:(only in menu when Text_Format_in_Menu = true)
  Exp_Name = 'Exp' # Name of the 'Exp' Status shown in the window

  # Configuration of the Exp text exhibition
  # Exp_Text =  [Font Name, Font Size, Bold]
  Exp_Text = ['Arial', 12, false]
  
  # Configuration of the Exp digits exhibition
  # Exp_Number =  [Font Name, Font Size, Bold]
  Exp_Number = ['Arial', 12, false]
  
  # Configuration of the Next Exp digits exhibition
  # Next_Exp_Number = [Font Name, Font Size, Bold]
  Next_Exp_Number = ['Arial', 12, true]
  
  # Configuration of the Face exhibition
  # To use faces, you must create an folder named 'Faces' in the Graphics folder
  # The face graphic must have the same as the actor character graphic
  # Show Faces? true = show / false = don't show
  Show_Faces = false
  # Face_Config = [Position X, Position Y, Opacity]
  Face_Config = [32, 32, 255]
 
  # Extension for Face file name, use if you want the battle faces file names
  # to be different from the normal faces
  Face_Extension = '_face'
  # The text extension must be add to all faces file names
  # E.g.: Face_Extension = '_bt'
  # 001-Fighter01_bt
  
  # Use the character hue on the face?
  Use_Character_Hue = false
  # true = use the hue
  # true = dont't use the hue
  
  # Configuration of the Char Graphic exhibition
  # Show Char Graphic? true = show / false = don't show
  Show_Char = false
  # Char_Config = [position X, position Y, Transparency, Show only half]
  Char_Config = [96, 60, 255, false]
end

#==============================================================================
# ■ Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Battle Windows'] = true

#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  alias battler_window_draw_actor_name draw_actor_name
  def draw_actor_name(actor, x, y)
    if $game_temp.in_battle or Text_Format_in_Menu
      self.contents.font.color = normal_color
      self.contents.font.name = Name_Config[2]
      self.contents.font.size = Name_Config[3]
      self.contents.font.bold = Name_Config[4]
      self.contents.draw_text(x, y, 120, 32, actor.name) #edited
      set_default_font
    else
      battler_window_draw_actor_name(actor, x, y)
    end
  end
  #--------------------------------------------------------------------------
  alias battler_window_draw_actor_level draw_actor_level
  def draw_actor_level(actor, x, y)
    if $game_temp.in_battle or Text_Format_in_Menu
      self.contents.font.color = system_color
      self.contents.font.name = Level_Text[2]
      self.contents.font.size = Level_Text[3]
      self.contents.font.bold = Level_Text[4]
      size = contents.text_size(Level_Name).width
      self.contents.draw_text(x, y, size + 4, 32, Level_Name)
      self.contents.font.color = normal_color
      self.contents.font.name = Level_Number[0]
      self.contents.font.size = Level_Number[1]
      self.contents.font.bold = Level_Number[2]
      self.contents.draw_text(x + size, y, 24, 32, actor.level.to_s, 2)
      set_default_font 
    else
      battler_window_draw_actor_level(actor, x, y)
    end
  end
  #--------------------------------------------------------------------------
  alias battler_window_draw_actor_hp draw_actor_hp
  def draw_actor_hp(actor, x, y, width = 44) #edited 44
    if $game_temp.in_battle or Text_Format_in_Menu
      self.contents.font.color = system_color
      self.contents.font.name = HP_Text[2]
      self.contents.font.size = HP_Text[3]
      self.contents.font.bold = HP_Text[4]
      #self.contents.draw_text(x, y, 32, 32, $data_system.words.hp)
      if width - 32 >= 108
        hp_x = x + width - 108
        flag = true
      elsif width - 32 >= 48
        hp_x = x + width - 48
        flag = false
      end
      self.contents.font.color = actor.hp == 0 ? knockout_color :
        actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
      self.contents.font.name = HP_Number[0]
      self.contents.font.size = HP_Number[1]
      self.contents.font.bold = HP_Number[2]
      #self.contents.draw_text(hp_x-40, y, 48, 32, actor.hp.to_s, 2) #edited
      if flag
        self.contents.font.color = normal_color
        self.contents.font.name = HP_Text[2]
        self.contents.font.size = HP_Text[3]
        self.contents.font.bold = HP_Text[4]
        #self.contents.draw_text(hp_x + 48 -40, y, 12, 32, '/', 1)
        self.contents.font.name = Max_HP_Number[0]
        self.contents.font.size = Max_HP_Number[1]
        self.contents.font.bold = Max_HP_Number[2]
       # self.contents.draw_text(hp_x + 60-40, y, 48, 32, actor.maxhp.to_s)
      end
      set_default_font
    else
      battler_window_draw_actor_hp(actor, x, y, width)
    end
  end
  #--------------------------------------------------------------------------
  alias battler_window_draw_actor_sp draw_actor_sp
  def draw_actor_sp(actor, x, y, width = 144)
    if $game_temp.in_battle or Text_Format_in_Menu
      self.contents.font.color = system_color
      self.contents.font.name = SP_Text[2]
      self.contents.font.size = SP_Text[3]
      self.contents.font.bold = SP_Text[4]
      #self.contents.draw_text(x, y, 32, 32, $data_system.words.sp)
      if width - 32 >= 108
        sp_x = x + width - 108
        flag = true
      elsif width - 32 >= 48
        sp_x = x + width - 48
        flag = false
      end
      self.contents.font.color = actor.sp == 0 ? knockout_color :
        actor.sp <= actor.maxsp / 4 ? crisis_color : normal_color
      self.contents.font.name = SP_Number[0]
      self.contents.font.size = SP_Number[1]
      self.contents.font.bold = SP_Number[2]
      #self.contents.draw_text(sp_x-40, y+3, 48, 32, actor.sp.to_s, 2)
      if flag
        self.contents.font.color = normal_color
        self.contents.font.name = SP_Text[2]
        self.contents.font.size = SP_Text[3]
        self.contents.font.bold = SP_Text[4]
       # self.contents.draw_text(sp_x + 48-40, y+3, 12, 32, '/', 1)
        self.contents.font.name = Max_SP_Number[0]
        self.contents.font.size = Max_SP_Number[1]
        self.contents.font.bold = Max_SP_Number[2]
        #self.contents.draw_text(sp_x + 60-40, y+3, 48, 32, actor.maxsp.to_s)
      end
      set_default_font
    else
      battler_window_draw_actor_sp(actor, x, y, width)
    end
  end
  #--------------------------------------------------------------------------
  alias battler_window_draw_actor_exp draw_actor_exp
  def draw_actor_exp(actor, x, y)
    if Text_Format_in_Menu
      self.contents.font.color = system_color
      self.contents.font.name = Exp_Text[0]
      self.contents.font.size = Exp_Text[1]
      self.contents.font.bold = Exp_Text[2]
      self.contents.draw_text(x, y, 32, 32, Exp_Name)
      self.contents.font.color = normal_color
      self.contents.font.name = Exp_Number[0]
      self.contents.font.size = Exp_Number[1]
      self.contents.font.bold = Exp_Number[2]
      self.contents.draw_text(x + 12, y, 96, 32, actor.exp_s, 2)
      self.contents.font.color = normal_color
      self.contents.font.name = Exp_Text[0]
      self.contents.font.size = Exp_Text[1]
      self.contents.font.bold = Exp_Text[2]
      self.contents.draw_text(x + 108, y, 12, 32, '/', 1)
      self.contents.font.name = Next_Exp_Number[0]
      self.contents.font.size = Next_Exp_Number[1]
      self.contents.font.bold = Next_Exp_Number[2]
      self.contents.draw_text(x + 120, y, 96, 32, actor.next_exp_s)
      set_default_font
    else
      battler_window_draw_actor_exp(actor, x, y)# width) 
    end
  end
  #--------------------------------------------------------------------------
  def draw_actor_battle_face(actor, x, y, opacity = 255)
    begin
      face_hue = Use_Character_Hue ? actor.character_hue : 0
      face = RPG::Cache.picture(actor.character_name + Face_Extension, face_hue)
      fw = face.width
      fh = face.height
      src_rect = Rect.new(0, 0, fw, fh)
      self.contents.blt(x - fw / 23, y - fh, face, src_rect, opacity)
    rescue
    end
  end
  #--------------------------------------------------------------------------
  def draw_actor_battle_graphic(actor, x, y, opacity = 255)
    begin
      bitmap = RPG::Cache.character(actor.character_name, actor.character_hue)
      cw = bitmap.width /  4
      ch = bitmap.height / (Char_Config[3] ? 6 : 4)
      src_rect = Rect.new(0, 0, cw, ch)
      self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect, opacity)
    rescue
    end
  end
  #--------------------------------------------------------------------------
  def set_default_font
    self.contents.font.name = Font.default_name
    self.contents.font.size = 20 #Font.default_size 12
    self.contents.font.bold = false
  end
end

#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    super(Battle_Window[0], Battle_Window[1], Battle_Window[2], Battle_Window[3])
    self.contents = Bitmap.new(width - 32, height - 32)
    @level_up_flags = []
    for i in 0...$game_party.actors.size
      @level_up_flags << false
    end
    self.z = 90
    self.back_opacity = Battle_Window[4]
    self.opacity = Battle_Window[4] if Battle_Window[5]
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      self.contents.font.size = 12
      hp_w = HP_Number[3] ? 140 : 80
      sp_w = SP_Number[3] ? 140 : 80
      actor = $game_party.actors[i]
      case Display_Type
      when 0 
        actor_x = Horizontal_Centralize ? 
        ((624 / MAX_MEMBER) * ((4 - $game_party.actors.size)/2.0 + i)).floor : i * (624 / MAX_MEMBER)
        actor_y = 0 
      when 1 
        actor_x = 0
        actor_y = i * 60
      when 2 
        actor_x = Custom_Stat_Position[i][0]
        actor_y = Custom_Stat_Position[i][1]
      end
      #face stuff here
      draw_actor_battle_face(actor, actor_x + Face_Config[0], actor_y + Face_Config[1], Face_Config[2]) if Show_Faces
      
      draw_actor_battle_graphic(actor, actor_x + Char_Config[0], actor_y + Char_Config[1], Char_Config[2]) if Show_Char
      #draw_actor_name(actor, actor_x + Name_Config[0], actor_y + Name_Config[1])
      draw_actor_hp(actor, actor_x + HP_Text[0], actor_y + HP_Text[1], hp_w)
      draw_actor_sp(actor, actor_x + SP_Text[0], actor_y + SP_Text[1], sp_w)
      draw_actor_level(actor, actor_x + Level_Text[0], actor_y + Level_Text[1]) if Draw_Level
      if @level_up_flags[i] and Lvl_UP_FLAG
        self.contents.font.color = normal_color
        #self.contents.draw_text(actor_x + State_Config[0], actor_y + State_Config[1], 132, 32, Lvl_Up_Msg ) #132,32
      else
        #draw_actor_state(actor, actor_x + State_Config[0], actor_y + State_Config[1])
      end
    end
  end
  #--------------------------------------------------------------------------
  def update
    super
  end
end
