#==============================================================================
# Atoa's Active Time Battle Version
# By Atoa
#==============================================================================
# This script adds an CTB System (FFX like)
# The configurations are explained below
#
# For obvious reasons, you can't use together with the "Atoa CTB"
#==============================================================================
module Atoa  
  # Do not remove or change these lines
  Cast_Time = {}
  Action_Cost = {}
  Cast_Cancel = {}
  CTB_Delay = {}
  # Do not remove or change these lines

  # Definition of turn shifting.
  # This definition must be used for the duration of effects and
  # battle event conditions
  # This value does not count to enemies actions conditions
  Custom_Turn_Count = 0
  # 0 = By number of fighters
  # 1 = By number of executed actions
  
  # If 'Custom_Turn_Count = 1', define how many actions are equal to 1 turn
  Action_Turn_Count = 5

  # Name of the Escape Option
  Escape_Name = 'Escape'
  
  #Sound effect played when teh character's turn comes. nil for no sound
  Command_Up_SE = 'saved'
 
  # Escape Message
  Escape_Text = "The party tried to escape..."
  
  # Order Window Postion
  Ctb_Window_Position = [230, 52]

  # Order show style
  Ctb_Order_Style = 2
  # 0 = Vertical Window with the battlers names, if an character start to cast
  #     an skill, the skill name will be shown in the window too
  # 1 = Vertical Window with images that represents each battler
  # 2 = Horizontal Window with images that represents each battler
  # 3 = No exhibition
  # 4 = shows images and names (WIP)

  # Name of the image file shown if an battler do not have an image
  # when 'Ctb_Order_Style' equal 1 or 2.
  # The dimensions of the window are adjusted according to the dimension of
  # this image. It must be on the 'Faces' folder
  Defatult_Ctb_Img = 'default_face'

  # File name extensions for the order images
  Ctb_Img_Ext = '_face'#'_ctb_turn'
  
  # If 'Ctb_Order_Style' equal 1 or 2, you will need the images for the battlers
  # they must be placed on the Faces folder and must have the name equal the
  # battler graphis file name + Ctb_Img_Ext.
  # E.g.: if the battler file name is '001-Fighter01' and Ctb_Img_Ext = '_ctb_turn'
  #  the order image must be named '001-Fighter01_ctb_turn'
  #
  # Optitional Indicators:
  # There's some optional graphics that can be added to show the battler condition.
  # These images are shown *above* the battler turn indicator
  #
  # There's 4 default graphics, plus the ones for the status effects.
  # The default files are:
  # 'Active' + Ctb_Img_Ext = graphic that shows the active battler.
  # 'Cast' + Ctb_Img_Ext = graphic that shows battlers casting skills.
  # 'Conf' + Ctb_Img_Ext = graphic that shows "confused" battlers. (with restritions 2 and 3)
  # 'Stop' + Ctb_Img_Ext = graphic that shows "paralized" battlers (with restriction 4)
  # 
  # You can also make images for the status effects, the file name must be
  # 'State Name' + Ctb_Img_Ext. 
  # Ex.: if the state name is 'Venom' and Ctb_Img_Ext = '_ctb_turn'
  #  the file name must be 'Venom_ctb_turn'
  #
  # Remember that these images are optional, so theres no problem in not using them.
  
  # Shows battler indicator more than one on the action list if they're
  # going to act more than one time on the set interval?
  Ctb_Show_Duplicates = true
  
  # Tipe of "slide" of the turn images
  Ctb_Graphic_Slide = 1
  # 0 = no slide
  # 1 = enemies and actors slide to the same sides
  # 2 = enemies and actors slide to different sides
  
  # Number of Names/Images shown on the order window
  Show_Ctb_Turn = 1

  # Hide windows when a battler is executing an action?
  Hide_During_Action = true
   
  # Order Window Back Opacity
  # (0-255) 0 = transparent, 255 = full opacity
  Ctb_Window_Back_Opacity = 0
  
  # Order Window Border Opacity
  # (0-255) 0 = transparent, 255 = full opacity
  Ctb_Window_Border_Opacity = 0

  # CTB's maximum value, only change if you know what you doing.
  Max_Ctb = 500
  
  # Initial CTB value modifier
  Ctb_Initial_Value = 300

  # Agility Modifier, The higher this value, the lower is the diference between
  # battlers with different agility
  Ctb_Agi_Modifier = 0
  
  # Key that must be pressed to end battler turn
  Cancel_Input = Input::A
  
  # Remember to not leave any equal input
  # Input::A  = Keyborard:Z
  # Input::B  = Keyborard:X
  # Input::C  = Keyborard:C
  # Input::X  = Keyborard:A
  # Input::Y  = Keyborard:S
  # Input::Z  = Keyborard:D
  # Input::L  = Keyborard:Q
  # Input::R  = Keyborard:W

  # Filename of the CTB window background image, must be on the Windowskin fonder
  # Leave nil or '' for no image
  Ctb_Window_Bg = ''
 
  # CTB window background image postion adjust
  # Ctb_Window_Bg_Postion = [Position X, Position Y]
  Ctb_Window_Bg_Postion = [0 , 0]
  
  # Distance in pixels of the images on the CTB window
  Ctb_Image_Distance = 2

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ACTION COST SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  Defense_Cost   = 300 # Defend
  No_Action_Cost = 100 # No action
  Escape_Cost    = 500 # Escape
  
  Attack_Default_Cost = 300 # Default cost for Attacks
  Item_Default_Cost   = 300 # Default cost for Skills
  Skill_Default_Cost  = 300 # Default cost for Items
  
  # Custom Action cost
  # The actions without custom cost will use the default value
  #  
  #   Action_Cost[Action_Type] = {Action_ID => Cost}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for Weapons
  #     Action_ID = ID of the item, skill or weapon
  #     Cost = Action cost, lower vaule = faster action
  #       Recomended values between 100-500
  Action_Cost['Weapon'] = {}
  
  Action_Cost['Skill'] = {1 => 300, 2 => 300, 3 => 300}
  
  Action_Cost['Item'] = {1 => 200, 2 => 350, 3 => 500}
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CAST SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Chanting default pose, if nil, no pose is used.
  Chanting_Pose = nil 

  # To add an pose to an skill or item, add this effect to the setting of the
  # skill or the item.
  # 'Chanting/**'
  #   ** must be the Pose ID.
  
  # To set an chanting pose for an specific graphic, add this to the graphic setting:
  # 'Chanting' => Pose ID.
  
  # Set here the cast time for each item and skill
  # By default all items have the cast speed = 0 (that means, no cast).
  #  
  #   Cast_Time[Action_Type] = {Action_ID => [Speed, status]}
  #     Action_Type = 'Skill' for skills, 'Item' for items
  #     Action_ID = ID of the skill or item
  #     Speed = cast speed, higher value = faster cast
  #       recomended values between 500-100
  #     Status = The status that the cast speed is based
  #       if nil, the cast will have fixed speed
  #       the status can be:
  #         'hp', 'sp', 'level', 'str', 'dex', 'int', 'agi'

  Cast_Time['Skill'] = {1 => [300,'int'], 2 => [400,'int'], 3 => [500,'int'], 
    7 => [300,'int'], 8 => [400,'int'], 9 => [500,'int'], 10 => [300,'int'], 
    11 => [400,'int'], 12 => [500,'int'], 13 => [300,'int'], 14 => [400,'int'], 
    15 => [500,'int'], 16 => [300,'int'], 17 => [400,'int'], 18 => [500,'int'], 
    19 => [300,'int'], 20 => [400,'int'], 21 => [500,'int'], 22 => [300,'int'], 
    23 => [400,'int'], 24 => [500,'int'], 25 => [300,'int'], 26 => [400,'int'], 
    27 => [500,'int'], 28 => [300,'int'], 29 => [400,'int'], 30 => [500,'int']}
  
  Cast_Time['Item'] = {1 => [300,'int'], 2 => [300,'int'], 3 => [300,'int'], 
    7 => [300,'int'], 8 => [300,'int'], 9 => [300,'int'], 10 => [300,'int'], 
    11 => [300,'int'], 12 => [300,'int']}
    
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SETTINGS OF ACTIONS THAT CHANGE THE CTB
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Actions that may cause changes on the target CTB
  
  # Chance that all actions have to cancel skill cast of the target.
  # This value is used for all actions that don't have individual definition.
  Base_Cast_Cancel = 0
    
  # Set here the chance that each action have of canceling the cast of target
  #  
  #   Cast_Cancel[Action_Type] = {Action_ID => Rate}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for weapons
  #     Action_ID = ID of the skill, item or weapon
  #     Rate = chance of calceling cast, increases with damage caused.
  #
  # Important: if tha action is an physical skill, the weapon cancel chance is
  #  also applied (the values aren't added, each one are calculated separatedely)
  
  #--------------------------------------------------------------------------
  # Delay on the CTB bar when recive damage
  # This value is used for all actions that don't have individual definition.
  Base_CTB_Delay = 0
    
  # Set here the actions that will cause CTB delay
  #  
  #   Cast_Cancel[Action_Type] = {Action_ID => Delay}
  #     Action_Type = 'Skill' for skills, 'Item' for items, 'Weapon' for weapons
  #     Action_ID = ID of the skill, item or weapon
  #     Delay = CTB delay value, increases with damage caused.
  #
  # Important: if tha action is an physical skill, the weapon delay is also calculated

end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa CTB'] = true

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
# Class that manage skills
#==============================================================================

class RPG::Skill
  #----------------------------------------------------------------------------
  # * Set action cast speed
  #     battler : battler
  #----------------------------------------------------------------------------
  def cast_speed(battler)
    if Cast_Time != nil and Cast_Time['Skill'] != nil and Cast_Time['Skill'][@id] != nil
      cast1 = Cast_Time['Skill'][@id][0]
      if Cast_Time['Skill'][@id][1].nil?
        cast2 = 200
      else
        if Cast_Time['Skill'][@id][1] == 'level'
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") * 2) + 100.0
        elsif Cast_Time['Skill'][@id][1] == 'hp' or Cast_Time['Skill'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 50) + 100.0
        else
          cast2 = (eval("battler.#{Cast_Time['Skill'][@id][1]}") / 5) + 100.0
        end
      end
      return (cast1 * cast2 / 200).to_i
    end
    return 0
  end
end

#==============================================================================
# ** RPG::Item
#------------------------------------------------------------------------------
# Class that manage items
#==============================================================================

class RPG::Item
  #----------------------------------------------------------------------------
  # * Set action cast speed
  #     battler : battler
  #----------------------------------------------------------------------------
  def cast_speed(battler)
    if Cast_Time != nil and Cast_Time['Item'] != nil and Cast_Time['Item'][@id] != nil
      cast1 = Cast_Time['Item'][@id][0]
      if Cast_Time['Item'][@id][1].nil?
        cast2 = 200
      else
        if Cast_Time['Item'][@id][1] == 'level'
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") * 2) + 100.0
        elsif Cast_Time['Item'][@id][1] == 'hp' or Cast_Time['Item'][@id][1] == 'sp' 
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 50) + 100.0
        else
          cast2 = (eval("battler.#{Cast_Time['Item'][@id][1]}") / 5) + 100.0
        end
      end
      return (cast1 * cast2 / 200).to_i
    end
    return 0
  end
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
#  Refer to "$game_temp" for the instance of this class.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :max_escape_count
  attr_accessor :escape_count
  attr_accessor :action_phase
  attr_accessor :active_battler
  attr_accessor :selection_phase
  attr_accessor :battle_start
  attr_accessor :next_battlers
  attr_accessor :action_battler
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_ctb initialize
  def initialize
    initialize_ctb
    @max_escape_count = 0
    @escape_count = 0
  end
  #--------------------------------------------------------------------------
  # * Check battle include on the next battlers list
  #     battler : battler
  #     index   : index
  #--------------------------------------------------------------------------
  def check_include_next(battler, index)
    for i in 0...index
      return true if battler == @next_battlers[i]
    end
    return false
  end
end


#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Get idle pose ID
  #--------------------------------------------------------------------------
  alias set_idle_pose_ctb set_idle_pose
  def set_idle_pose
    pose = set_idle_pose_ctb
    unless pose == Dead_Pose or pose == Victory_Pose
      if battler.cast_action != nil
        action = @battler.cast_action
        cast_pose = set_pose_id('Chanting')
        ext = check_extension(action, 'CHANTING/')
        if ext != nil
          ext.slice!('CHANTING/')
          cast_pose = ext.to_i
        end
      end
    end
    return cast_pose.nil? ? pose : cast_pose
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass for the Game_Actor
#  and Game_Enemy classes.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :ctb
  attr_accessor :cast_action
  attr_accessor :casting
  attr_accessor :cast_target
  attr_accessor :turn_count
  attr_accessor :guarding
  attr_accessor :selected_action
  attr_accessor :current_cost
  attr_accessor :escape_attempt
  attr_accessor :all_ctb
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_ctb initialize
  def initialize
    initialize_ctb
    @ctb = 0
    @cast_skill = 0
    @turn_count = 0
    @action_cost = 0
    @guarding = false
    @casting = false
    @escape_attempt = false
    @all_ctb = []
  end
  #--------------------------------------------------------------------------
  # * Casting flag
  #--------------------------------------------------------------------------
  def casting
    return false if self.dead?
    return @casting
  end
  #--------------------------------------------------------------------------
  # * Get Max CTB
  #--------------------------------------------------------------------------
  def max_ctb
    return Max_Ctb
  end
  #--------------------------------------------------------------------------
  # * Set current CTB
  #     n : new ctb
  #--------------------------------------------------------------------------
  def ctb=(n)
    @ctb = [n.to_i, self.max_ctb].min
  end
  #--------------------------------------------------------------------------
  # * CTB Preset
  #--------------------------------------------------------------------------
  def ctb_preset
    preset = self.max_ctb - (((Ctb_Initial_Value + rand(50)) * (total_agi + Ctb_Agi_Modifier)) / 
      (self.agi + Ctb_Agi_Modifier))
    self.ctb = preset 
  end
  #--------------------------------------------------------------------------
  # * Battlers total agility
  #--------------------------------------------------------------------------
  def total_agi
    total = 0
    battlers = 0
    for battler in $game_party.actors + $game_troop.enemies
      next if battler.dead?
      total += battler.agi
      battlers += 1
    end
    total /= [battlers, 1].max
    return total
  end
  #--------------------------------------------------------------------------
  # * CTB full flag
  #--------------------------------------------------------------------------
  def ctb_full?
    return @ctb == self.max_ctb
  end
  #--------------------------------------------------------------------------
  # * Get action cost
  #     cost   : action cost
  #     action : current action
  #--------------------------------------------------------------------------
  def action_cost(cost, action)
    return [cost * (total_agi + Ctb_Agi_Modifier) / (self.agi + Ctb_Agi_Modifier), 1].max
  end
  #--------------------------------------------------------------------------
  # * Get cast cost
  #     cost : action cost
  #     cast : cast speed
  #--------------------------------------------------------------------------
  def cast_cost(cost, cast)
    return [cost * (total_agi + Ctb_Agi_Modifier) / (cast + Ctb_Agi_Modifier), 1].max
  end
  #--------------------------------------------------------------------------
  # * Update CTB
  #     cost   : action cost
  #     action : current action
  #--------------------------------------------------------------------------
  def ctb_update(cost, action)
    if self.cast_action.nil?
      self.ctb -= action_cost(cost, action)
    else
      self.ctb -= cast_cost(cost, @cast_action.cast_speed(self))
    end
  end
  #--------------------------------------------------------------------------
  # * Final damage setting
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  alias set_damage_ctb set_damage
  def set_damage(user, action = nil)
    set_damage_ctb(user, action)
    set_cast_cancel(user, action)
    set_delay_action(user, action)
  end
  #--------------------------------------------------------------------------
  # * Set cast cancel action
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_cast_cancel(user, action)
    if action != nil and Cast_Cancel[action.type_name] != nil and
       Cast_Cancel[action.type_name][action.id] != nil
      cancel_cast(user, Cast_Cancel[action.type_name][action.id], action)
      if action.type_name == 'Skill' and not action.magic? 
        for weapon in weapons
          cancel_cast(user, Cast_Cancel['Weapon'][weapon.id], action)
        end
      end
    else
      cancel_cast(user, Base_Cast_Cancel, action)
    end
  end
  #--------------------------------------------------------------------------
  # * Set CTB delay action
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def set_delay_action(user, action)
    if action != nil and CTB_Delay[action.type_name] != nil and
       CTB_Delay[action.type_name][action.id] != nil
      delay_action(user, CTB_Delay[action.type_name][action.id], action)
      if action.type_name == 'Skill' and not action.magic? 
        for weapon in weapons
          delay_action(user, CTB_Delay['Weapon'][weapon.id], action)
        end
      end
    else
      delay_action(user, Base_CTB_Delay, action)
    end
  end
  #--------------------------------------------------------------------------
  # * No delay flag
  #     user   : user
  #     action : action
  #--------------------------------------------------------------------------
  def cant_delay(user, action)
    return true if check_include(action, "NODAMAGE")
    return true if not user.target_damage[self].numeric?
    return true if user.target_damage[self] < 0
    return false
  end
  #--------------------------------------------------------------------------
  # * Set cast cancel
  #     user   : user
  #     cast   : cancel chance
  #     action : action
  #--------------------------------------------------------------------------
  def cancel_cast(user, cast, action)
    return if cant_delay(user, action)
    rate =  cast + (cast * (user.target_damage[self] * 50.0 / self.maxhp) / 100.0)
    if rate > rand(100) and self.cast_action != nil
      self.cast_action = nil
      self.ctb = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Set ATB delay
  #     user   : user
  #     delay  : delay value
  #     action : action
  #--------------------------------------------------------------------------
  def delay_action(user, delay, action)
    return if cant_delay(user, action)
    rate =  delay + (delay * (user.target_damage[self] * 50.0 / self.maxhp) / 100.0)
    self.ctb -= rate.to_i
  end
  #--------------------------------------------------------------------------
  # * Set battler all CTB
  #--------------------------------------------------------------------------
  def set_battler_all_ctb
    @all_ctb.clear
    info = [self.actor?, self.index]
    for i in 0...Show_Ctb_Turn
      if i == 0
        current_ctb = update_next_ctb(self.ctb, active_selection ? nil : self.selected_action)
        @all_ctb[i] = [self.ctb, info, active_selection ? '' : current_ctb[1], 0, false, i]
        @total_ctb = self.ctb
      elsif i == 1
        current_ctb = update_next_ctb(@total_ctb, active_selection ? self.selected_action : nil)
        @all_ctb[i] = [current_ctb[0], info, active_selection ? current_ctb[1] : '', 0, false, i]
        @total_ctb = current_ctb[0]
      else
        current_ctb = update_next_ctb(@total_ctb)
        @all_ctb[i] = [current_ctb[0], info, '', 0, false, i]
        @total_ctb = current_ctb[0]
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Active battler selection
  #--------------------------------------------------------------------------
  def active_selection
    if Ctb_Show_Duplicates
      return ($game_temp.active_battler != nil and 
              $game_temp.selection_phase and self == $game_temp.active_battler)
    else
      return (($game_temp.active_battler != nil and $game_temp.selection_phase and
        self == $game_temp.active_battler) or ($game_temp.action_battler != nil and
        $game_temp.action_battler == self))
    end
  end
  #--------------------------------------------------------------------------
  # * Update Next CTB
  #     total_ctb : total ctb
  #     action    : current action
  #--------------------------------------------------------------------------
  def update_next_ctb(total_ctb, action = nil)
    cast = 0
    case action
    when 'Attack', nil
      ctb = self.action_cost(Attack_Default_Cost, action)
    when 'Defend'
      ctb = self.action_cost(Defense_Cost, action)
    when 'Escape'
      ctb = self.action_cost(Escape_Cost, action)
    when RPG::Weapon
      if Action_Cost['Attack'] != nil and Action_Cost['Attack'][action.id] != nil
        cost = Action_Cost['Attack'][action.id]
        ctb = self.action_cost(cost, action)
      else
        ctb = self.action_cost(Attack_Default_Cost, action)
      end
    when RPG::Skill
      if Action_Cost['Skill'] != nil and Action_Cost['Skill'][action.id] != nil
        cost = Action_Cost['Skill'][action.id]
      else
        cost = Skill_Default_Cost
      end
      if Cast_Time['Skill'] != nil and Cast_Time['Skill'][action.id] != nil
        cast = action.cast_speed(self)
      end
      if cast != 0
        ctb = self.cast_cost(cost, cast)
      else
        ctb = self.action_cost(cost, action)
      end
    when RPG::Item
      if Action_Cost['Item'] != nil and Action_Cost['Item'][action.id] != nil
        cost = Action_Cost['Item'][action.id]
      else
        cost = Item_Default_Cost
      end
      if Cast_Time['Item'] != nil and Cast_Time['Item'][action.id] != nil
        cast = action.cast_speed(self)
      end
      if cast != 0
        ctb = self.cast_cost(cost, cast)
      else
        ctb = self.action_cost(cost, action)
      end
    else
      cast = 0
      ctb = self.action_cost(Attack_Default_Cost, action)
    end
    cast_name = cast == 0 ? '' : action.name
    return [total_ctb - ctb, cast_name]
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Decide if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    return (self.ctb_full? and super)
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It's used within the Game_Troop class
#  ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Decide if Action is Possible
  #--------------------------------------------------------------------------
  def movable?
    return (self.ctb_full? and super)
  end
  #--------------------------------------------------------------------------
  # * Get Battle Turn
  #--------------------------------------------------------------------------
  def get_battle_turn
    return @turn_count
  end
end

#==============================================================================
# ** Window_Ctb
#------------------------------------------------------------------------------
#  This window displays the battler order
#==============================================================================

class Window_Ctb < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :old_order
  attr_accessor :order_window
  attr_accessor :current_order
  attr_accessor :animation_count
  attr_accessor :forced_update
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @ctb_settings = [Ctb_Window_Position[0], Ctb_Window_Position[1], Show_Ctb_Turn,
                     Ctb_Window_Back_Opacity, Ctb_Window_Border_Opacity, Defatult_Ctb_Img]
    case Ctb_Order_Style
    when 0,3
      w = 160 
      h = 122 + (18 * Show_Ctb_Turn)

    when 1
      w = RPG::Cache.picture(Defatult_Ctb_Img).width + 32
      h = [((RPG::Cache.picture(Defatult_Ctb_Img).height + Ctb_Image_Distance) * Show_Ctb_Turn) + 32, 480].min
    when 2
      w = [((RPG::Cache.picture(Defatult_Ctb_Img).width + Ctb_Image_Distance) * Show_Ctb_Turn) + 32, 640].min
      h = RPG::Cache.picture(Defatult_Ctb_Img).height + 32
    when 4
      w = [((RPG::Cache.picture(Defatult_Ctb_Img).width + Ctb_Image_Distance) * Show_Ctb_Turn) + 32, 640].min
      h = RPG::Cache.picture(Defatult_Ctb_Img).height + 32   
    end
    super(@ctb_settings[0], @ctb_settings[1], w, h)
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    self.back_opacity = @ctb_settings[3]
    self.opacity = @ctb_settings[4]
    self.z = 3900
    self.visible = false
    if Ctb_Window_Bg != nil
      @background_image = Sprite.new
      @background_image.bitmap = RPG::Cache.windowskin(Ctb_Window_Bg)
      @background_image.x = self.x + Ctb_Window_Bg_Postion[0]
      @background_image.y = self.y + Ctb_Window_Bg_Postion[1]
      @background_image.z = self.z - 1
      @background_image.visible = self.visible
    end
    @img_position = 10
    @animation_count = 0
    @advancing = false
    @returning = false
    @animated = false
    @forced_update = false
    @order = []
    @order_window = []
    @current_order = []
    @old_order = []
    @images = {}
    set_bitimaps
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @background_image.dispose if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # Visibilidade da janela
  #     n : valor de visibilidade
  #--------------------------------------------------------------------------
  def visible=(n)
    super
    @background_image.visible = n if @background_image != nil
  end
  #--------------------------------------------------------------------------
  # * Set window images bitmaps
  #--------------------------------------------------------------------------
    def set_bitimaps
    for battler in $game_party.actors #+ $game_troop.enemies
      next if @images[battler] != nil or @images.keys.include?(battler)
      begin; img = RPG::Cache.picture(battler.name + Ctb_Img_Ext)
      rescue; img = RPG::Cache.picture(Defatult_Ctb_Img); end
      @images[battler] = [img, false]
    end
    for battler in @images.keys
      next if @images[battler].nil?
      next if battler.actor? and $game_party.actors.include?(battler)
      #next if !battler.actor? and $game_troop.enemies.include?(battler)
      @images[battler][0].dispose
      @images[battler] = nil
      @images.delete(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh EDITED
  #--------------------------------------------------------------------------
  def refresh
    update_order
    update_text_window if Ctb_Order_Style == 0 or Ctb_Order_Style == 4
  end
  #--------------------------------------------------------------------------
  # * Update window text
  #--------------------------------------------------------------------------
  def update_text_window
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.font.size = 22
    self.contents.font.bold = true
    #self.contents.draw_text(0, 0, 100, 22, 'Next up')
    for i in 0...@order.size
      order =  @order[i]
      battler = set_battler(order[1])
      y = 18 * i
      self.contents.font.size = i == 0 ? 18 : 14
      self.contents.font.bold = i == 0 ? true : false
      self.contents.font.color = normal_color if i == 0
      self.contents.font.color = system_color if i > 0
      name = i == 0 ? '> ' + battler.name : battler.name
      if order[2] != ''
        self.contents.font.color = crisis_color
        name = name + ' > ' + order[2]
      end
      self.contents.font.color = knockout_color if order[3] == 2 or order[3] == 3
      self.contents.font.color = disabled_color if order[3] == 4
      self.contents.draw_text(4, y + 24, self.width - 32, 18, name + "aaaaa")
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if [1,2,4].include?(Ctb_Order_Style)
      if order_comparision(@order_window, @current_order) and not @animated
        @old_order = @current_order.dup
        @animation_count = 20
        @animated = true
      end
      if @animation_count > 0
        if @animation_count > 10
          @img_position = Ctb_Graphic_Slide == 0 ? 10 : [@img_position - 1, 0].max
        elsif @animation_count > 0 and @animation_count <= 10
          @img_position = Ctb_Graphic_Slide == 0 ? 10 : [@img_position + 1, 10].min
        end
        @current_order = @order_window.dup if @animation_count <= 10
        @animation_count = [@animation_count - (Ctb_Graphic_Slide == 0 ? 5 : 1), 0].max
      end
      if order_comparision(@old_order, @current_order) and @animation_count == 0
        @old_order = @current_order.dup
        @animated = false
      end
      update_image_window
      @forced_update = false
    else
      @current_order = @order_window.dup
    end
  end
  #--------------------------------------------------------------------------
  # * Order comparision
  #    old : old order
  #    new : new order
  #--------------------------------------------------------------------------
  def order_comparision(old, new)
    order1 = []
    order2 = []
    for order in old
      order1 << [order[0], order[1], order[2]]
    end
    for order in new
      order2 << [order[0], order[1], order[2]]
    end
    return order1 != order2
  end
  #--------------------------------------------------------------------------
  # * Update wimdow images
  #--------------------------------------------------------------------------
  def update_image_window
    return if @old_order.empty? or @current_order.empty?
    self.contents.clear
    x = y = 0
    for i in 0...@order.size
      battler = set_battler(@current_order[i][1]) if @current_order[i] != nil
      next if (@current_order[i].nil? or @old_order[i].nil? or @order_window[i].nil? or
               @images[battler].nil?)
      if @current_order[i][1] != @old_order[i][1] or
         @current_order[i][2] != @old_order[i][2] or
         @current_order[i][1] != @order_window[i][1] or 
         @current_order[i][2] != @order_window[i][2]
        @old_order[i][4] = true
      end
      @old_order[i][4] = false if @img_position == 10
      @current_order[i][3] = @old_order[i][4] ? @img_position : 10
      img = @images[battler][0].dup
      dist = @current_order[i][3]
      src_rect = Rect.new(0, 0, img.width, img.height)
      if Ctb_Order_Style == 1
        x = (battler.actor? or Ctb_Graphic_Slide == 1) ? 
          img.width * (10 - dist) / 10 : img.width * (dist - 10) / 10
      else
        y = (battler.actor? or Ctb_Graphic_Slide == 1) ?
          img.height * (dist - 10) / 10 : img.height * (10 - dist) / 10 
      end
      rect = Rect.new(0, 0, img.width, img.height)
      draw_ctb_turn(x, y, img, rect, dist, @current_order[i][2] != '', battler, i)
      y += img.height + Ctb_Image_Distance if Ctb_Order_Style == 1
      x += img.width + Ctb_Image_Distance if Ctb_Order_Style == 2
      
      x += img.width + Ctb_Image_Distance if Ctb_Order_Style == 4 #new!
    end
  end
  #--------------------------------------------------------------------------
  # * Draw battler image on windo
  #     x       : draw spot x-coordinate
  #     y       : draw spot y-coordinate
  #     img     : graphic bitmap
  #     rect    : bitmap rectangle
  #     opacity : opacity
  #     cast    : cast value
  #     battler : battler
  #     index   : index
  #--------------------------------------------------------------------------
  def draw_ctb_turn(x, y, img, rect, opacity, cast, battler, index)
    self.contents.blt(x, y, img, rect, 155 + opacity * 10)
    if index == 0
      begin; bit = RPG::Cache.picture('Active' + Ctb_Img_Ext); rescue; end
    elsif cast
      begin; bit = RPG::Cache.picture('Cast' + Ctb_Img_Ext); rescue; end
    elsif [2,3].include?(battler.restriction)
      begin; bit = RPG::Cache.picture('Conf' + Ctb_Img_Ext); rescue; end
    elsif battler.restriction == 4 and not battler.dead?
      begin; bit = RPG::Cache.picture('Stop' + Ctb_Img_Ext); rescue; end
    elsif battler.states.size > 0
      for state in battler.states
        begin
          bit = RPG::Cache.picture($data_states[state].name + Ctb_Img_Ext)
          break if bit != nil
        rescue; end
      end
    end
    if bit != nil
      rect = Rect.new(0, 0, bit.width, bit.height)
      self.contents.blt(x, y, bit, rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Order Update
  #--------------------------------------------------------------------------
  def update_order
    sort_ctb
    $game_temp.next_battlers.clear
    for order in @order
      $game_temp.next_battlers << set_battler(order[1]) if set_battler(order[1]) != nil
    end
    @forced_update = true
  end
  #--------------------------------------------------------------------------
  # * Sort CTB order
  #--------------------------------------------------------------------------
  def sort_ctb
    @animated = false
    @order.clear 
    ctb_members = []
    for i in 0...@current_order.size
      order = @current_order[i].dup
      next if ctb_members.include?(set_battler(order[1])) and not Ctb_Show_Duplicates
      @order << order
      ctb_members << set_battler(order[1]) if i == 0
    end
    set_bitimaps
  end
  #--------------------------------------------------------------------------
  # * Set battler
  #     order : order
  #--------------------------------------------------------------------------
  def set_battler(order)
    return $game_party.actors[order[1]] if order[0]
    return $game_troop.enemies[order[1]]
  end
  #--------------------------------------------------------------------------
  # * Get cast name
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_cast_name(battler)
    action = battler.cast_action
    if action.is_a?(RPG::Skill) or action.is_a?(RPG::Item)
      return battler.cast_action.nil? ? '' : action.name
    end
    return ''
  end
end

#==============================================================================
# ** Interpreter
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #--------------------------------------------------------------------------
  # * Force Action
  #--------------------------------------------------------------------------
  def command_339
    return true unless $game_temp.in_battle
    iterate_battler(@parameters[0], @parameters[1]) do |battler|
      if battler.exist?
        battler.current_action.kind = @parameters[2]
        if battler.current_action.kind == 0
          battler.current_action.basic = @parameters[3]
        else
          battler.current_action.skill_id = @parameters[3]
        end
        if @parameters[4] == -2
          if battler.is_a?(Game_Enemy)
            battler.current_action.decide_last_target_for_enemy
          else
            battler.current_action.decide_last_target_for_actor
          end
        elsif @parameters[4] == -1
          if battler.is_a?(Game_Enemy)
            battler.current_action.decide_random_target_for_enemy
          else
            battler.current_action.decide_random_target_for_actor
          end
        elsif @parameters[4] >= 0
          battler.current_action.target_index = @parameters[4]
        end
        battler.current_action.forcing = true
        if battler.current_action.valid? and @parameters[5] == 1
          $game_temp.forcing_battler = battler
          @index += 1
          return false
        end
      end
    end
    return true
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  alias main_ctb main
  def main
    turn_count_speed  
    @escape_ratio = Escape_Base_Rate
    $game_temp.escape_count = 0
    @escape_type = 0
    @escape_name = Escape_Name
    @input_battlers = []
    @action_battlers = []
    @all_battlers_ctb = []
    @all_ctb = []
    @input_battler = nil
    @update_turn_end = false
    $game_temp.battle_start = true
    $game_temp.action_phase = false
    $game_temp.active_battler = false
    $game_temp.selection_phase = false
    $game_temp.battle_end = false
    $game_temp.next_battlers = []
    main_ctb
  end
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  alias start_ctb start
  def start
    start_ctb
    for battler in $game_party.actors + $game_troop.enemies
      battler.turn_count = 0
      battler.ctb = 0
      battler.ctb_preset
      battler.cast_action = nil
      battler.cast_target = nil
      battler.set_battler_all_ctb
    end
    @ctb_window = Window_Ctb.new
    update_all_ctb
    @ctb_window.old_order = @all_battlers_ctb.dup
    @ctb_window.current_order = @all_battlers_ctb.dup
    @ctb_window.refresh
    @ctb_window.update
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias terminate_ctb terminate
  def terminate
    terminate_ctb
    @ctb_window.dispose
    $game_temp.next_battlers.clear
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_ctb update
  def update
    update_battle_phases
    update_ctb
    update_temp_info
    return $scene = Scene_Gameover.new if $game_temp.gameover
    return if @phase == 5
    return if $game_system.battle_interpreter.running? and $game_temp.forcing_battler.nil?
    update_turn_ending if @update_turn_end
    ctb_update
    input_battler_update
    action_battler_update
  end
  #--------------------------------------------------------------------------
  # * Battle phases update
  #--------------------------------------------------------------------------
  def update_battle_phases
    if @phase == 1
      $game_temp.battle_main_phase = true
      @actor_command_window.opacity = 0
      @phase = 0
    elsif @phase != 5
      @phase = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Update Graphics
  #--------------------------------------------------------------------------
  alias update_graphics_ctb update_graphics
  def update_graphics
    update_graphics_ctb
    ctb_window_update
  end
  #--------------------------------------------------------------------------
  # * Update CTB Window
  #--------------------------------------------------------------------------
  def ctb_window_update
    return if @ctb_window.nil?
    if $game_temp.battle_start or $game_temp.battle_end or Ctb_Order_Style == 3 or
      ($game_temp.action_phase and Hide_During_Action)
      @ctb_window.visible = false
    else
      @ctb_window.visible = true
    end
    @ctb_window.update if (@ctb_window.visible and @ctb_window.animation_count > 0) or @ctb_window.forced_update
  end
  #--------------------------------------------------------------------------
  # * Action battler update
  #--------------------------------------------------------------------------
  def action_battler_update
    if @action_battlers[0] != nil
      @action_battlers.flatten!
      battler = @action_battlers[0]
      battler.ctb = 0 if battler.dead?
    end
    update_phase4
  end
  #--------------------------------------------------------------------------
  # * Update battler inupt
  #--------------------------------------------------------------------------
  def input_battler_update
    check_battler_turn
    set_input_battle
    command_window_setup_update
    clear_disabled_battler
  end
  #--------------------------------------------------------------------------
  # * Check battler turn
  #--------------------------------------------------------------------------
  def check_battler_turn
    for battler in $game_party.actors + $game_troop.enemies
      if battler.ctb_full? and not @action_battlers.include?(battler) and not
         @active_battlers.include?(battler)
        battler_turn(battler)
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set battler input
  #--------------------------------------------------------------------------
  def set_input_battle
    if @input_battlers[0] != nil and @input_battler.nil? and !wait_on
      @input_battlers.flatten!
      @input_battler = @input_battlers[0]
      if @input_battler.current_action.forcing or @input_battler.confused?
        if @input_battler.confused?
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @input_battler.defense_pose = false
        @action_battlers << @input_battlers.shift
        @action_battlers.compact!
        @input_battler = nil
      elsif @input_battler.inputable?
        @actor_index = $game_party.actors.index(@input_battler)
        @input_battler.current_action.clear
      else
        @input_battler.current_cost = no_action_cost(@input_battler)
        @input_battlers.shift
        @input_battler = nil
        @ctb_window.refresh
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update command window
  #--------------------------------------------------------------------------
  def command_window_setup_update
    if @input_battler != nil
      @input_battler.defense_pose = false
      @input_battler.blink = true
      @active_battler = @input_battler
      if @actor_command_window.opacity == 0
        $game_system.se_play(RPG::AudioFile.new(Command_Up_SE)) if @active_battler.cast_action.nil? and Command_Up_SE != nil
        phase3_setup_command_window
      end
      update_phase3
    end
  end
  #--------------------------------------------------------------------------
  # * Clear disbled battlers
  #--------------------------------------------------------------------------
  def clear_disabled_battler
    for battler in $game_party.actors + $game_troop.enemies
      next if battler.exist?
      @input_battlers.delete(battler)
      @action_battlers.delete(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Start battler turn
  #     battler : battler
  #--------------------------------------------------------------------------
  def battler_turn(battler)
    return if @input_battlers.include?(battler)
    battler.turn_count += 1
    if battler.is_a?(Game_Actor)
      if battler.ctb_full? and battler.inputable? and battler.cast_action.nil?
        @input_battlers << battler
        @input_battlers.compact!
      else
        if battler.confused?
          battler.current_action.kind = 0
          battler.current_action.basic = 0
        end
        battler.defense_pose = false
        @action_battlers << battler
        @action_battlers.compact!
      end
    else
      set_enemy_action(battler)
    end
  end
  #--------------------------------------------------------------------------
  # * Set enemy action
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_enemy_action(battler)
    if battler.current_action.forcing or $game_temp.forcing_battler
      battler.current_action.forcing = false
      $game_temp.forcing_battler = nil
    else
      battler.make_action 
    end
    @action_battlers << battler
    @action_battlers.compact!
  end
  #--------------------------------------------------------------------------
  # * Turn Ending
  #--------------------------------------------------------------------------
  def turn_ending
  end  
  #--------------------------------------------------------------------------
  # * Update Turn Ending
  #--------------------------------------------------------------------------
  def update_turn_ending
    slip_damage_all if Slip_Damage_Pop_Time == 2
    @update_turn_end = false
  end
  #--------------------------------------------------------------------------
  # * Update CTB
  #--------------------------------------------------------------------------
  def ctb_update
    @wait_on = wait_on
    return if wait_on
    if @ctb_turn_count >= @abt_turn_speed
      for index in 0...$data_troops[@troop_id].pages.size
        page = $data_troops[@troop_id].pages[index]
        $game_temp.battle_event_flags[index] = false if page.span == 1
      end
      @update_turn_end = true if Slip_Damage_Pop_Time >= 2
      $game_temp.battle_turn += 1
      turn_count_speed
      for battler in $game_party.actors + $game_troop.enemies
        battler.remove_states_auto if battler.exist?
      end
      setup_battle_event
    end
    update_all_ctb if @input_battler.nil? and @action_battlers.empty?
  end
  #--------------------------------------------------------------------------
  # * Same CTB adjus
  #     battler : battler
  #--------------------------------------------------------------------------
  def not_same_ctb(battler)
    for target in $game_party.actors + $game_troop.enemies
      next if target == battler
      battler.ctb -= 1  if battler.ctb == target.ctb
    end
  end
  #--------------------------------------------------------------------------
  # * Update all CTB values
  #--------------------------------------------------------------------------
  def update_all_ctb
    @all_ctb.clear
    for battler in $game_party.actors + $game_troop.enemies
      unless battler.exist?
        battler.cast_action = nil
        battler.ctb = battler.ctb_preset
      end
      battler.cast_action = nil unless battler.exist?
      @all_ctb << battler.max_ctb - battler.ctb if battler.exist?
    end
    @all_ctb.sort!{|a,b| a <=> b}
    for battler in $game_party.actors + $game_troop.enemies
      if battler.exist? and not battler.restriction == 4
        battler.ctb += @all_ctb[0]
        not_same_ctb(battler)
        battler.set_battler_all_ctb
      end
    end
    update_next_ctb
  end
  #--------------------------------------------------------------------------
  # * Update next CTB values
  #--------------------------------------------------------------------------
  def update_next_ctb
    @old_battler_ctb = @all_battlers_ctb.dup
    @all_battlers_ctb.clear
    for battler in $game_party.actors + $game_troop.enemies
      if battler.exist? and not battler.restriction == 4
        @all_battlers_ctb = @all_battlers_ctb | battler.all_ctb
      end
    end
    if @old_battler_ctb != @all_battlers_ctb
      @all_battlers_ctb.sort!{|a,b| b[0] <=> a[0]}
      @all_battlers_ctb.delete_if {|ctb| @all_battlers_ctb.index(ctb) >  Show_Ctb_Turn} 
    else
      @all_battlers_ctb = @old_battler_ctb.dup
    end
    @ctb_window.order_window = @all_battlers_ctb.dup
    @ctb_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Wait flag
  #--------------------------------------------------------------------------
  def wait_on
    return true if $game_temp.battle_end or not allow_next_action
    return false
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Phase
  #--------------------------------------------------------------------------
  def start_phase2
  end
  #--------------------------------------------------------------------------
  # * Set turn speed
  #--------------------------------------------------------------------------
  def turn_count_speed
    @ctb_turn_count = @abt_turn_speed = 0
    case Custom_Turn_Count
    when 0
      for battler in $game_party.actors + $game_troop.enemies
        @abt_turn_speed += 1 if battler.exist?
      end
    when 1
      @abt_turn_speed = Action_Turn_Count
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    windows_dispose
    update_phase2_escape_part2
  end
  #--------------------------------------------------------------------------
  # * Frame Update (party command phase: escape part2)
  #--------------------------------------------------------------------------
  def update_phase2_escape_part2
    @party_command_window.visible = false
    @party_command_window.active = false
    wait(2)
    if rand(100) < set_escape_rate
      $game_temp.battle_end = true
      $game_system.se_play($data_system.escape_se)
      battle_end(1)
      for battler in $game_party.actors
        battler.escape_attempt = false
      end
      play_map_bmg
    else
      @escape_ratio += 3
      phase3_next_actor
      @escape_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Start After Battle Phase
  #--------------------------------------------------------------------------
  alias start_phase5_ctb start_phase5
  def start_phase5
    if @input_battler != nil
      @help_window.visible = false if @help_window != nil
      windows_dispose
      @input_battler.blink = false if @input_battler != nil
    end
    start_phase5_ctb
    update_all_ctb
    @ctb_window.refresh 
  end
  #--------------------------------------------------------------------------
  # * Frame Update (after battle phase)
  #--------------------------------------------------------------------------
  alias update_phase5_ctb update_phase5
  def update_phase5
    windows_dispose
    update_phase5_ctb
  end
  #--------------------------------------------------------------------------
  # * Update temporary info
  #--------------------------------------------------------------------------
  def update_temp_info
    $game_temp.action_phase = @input_battler.nil?
    $game_temp.selection_phase = @input_battler != nil
    $game_temp.active_battler = @active_battler
    $game_temp.action_battler = @active_battlers.first
  end
  #--------------------------------------------------------------------------
  # * Actor Command Window Setup
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    $game_temp.battle_start = false
    update_temp_info
    if @active_battler != nil and @active_battler.cast_action != nil
      @active_battler.blink = false
      return  
    end
    @active_battler.defense_pose = false
    @party_command_window.active = false
    @party_command_window.visible = false
    @actor_command_window.dispose if @actor_command_window != nil
    s1 = $data_system.words.attack
    s2 = $data_system.words.skill
    s3 = $data_system.words.item
    s4 = $data_system.words.guard
    s5 = @escape_name
    if @escape_type == 0
      @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4, s5])  
    else
      @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])  
    end
    command_window_position
    @actor_command_window.back_opacity = Ctb_Window_Back_Opacity
    @actor_command_window.z = 4500
    @active_battler_window.refresh(@active_battler)
    @active_battler_window.visible = Battle_Name_Window
    command_window_position
    set_name_window_position
    @active_battler_window.z = 4500
    @ctb_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : skill selection)
  #--------------------------------------------------------------------------
  alias update_phase3_skill_select_ctb update_phase3_skill_select
  def update_phase3_skill_select
    @active_battler.selected_action = @skill_window.skill
    if @curent_index != @skill_window.index or
       (Ctb_Order_Style == 0 or Ctb_Order_Style == 4 and Graphics.frame_count % 3 == 0)
      update_all_ctb
      @ctb_window.refresh
      @curent_index = @skill_window.index
      @curent_command_index = nil
    end
    update_phase3_skill_select_ctb
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : item selection)
  #--------------------------------------------------------------------------
  alias update_phase3_item_select_ctb update_phase3_item_select
  def update_phase3_item_select
    @active_battler.selected_action = @item_window.item
    if @curent_index != @item_window.index or
       (Ctb_Order_Style == 0 or Ctb_Order_Style == 4 and Graphics.frame_count % 3 == 0)
      update_all_ctb
      @ctb_window.refresh
      @curent_index = @item_window.index
      @curent_command_index = nil
    end
    update_phase3_item_select_ctb
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input for Next Actor
  #--------------------------------------------------------------------------
  def phase3_next_actor
    action_battler = @input_battlers.shift
    @action_battlers << action_battler
    @action_battlers.compact!
    command_input_cancel
    @input_battler = nil
    @actor_index = nil
    @active_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Go to Command Input of Previous Actor
  #--------------------------------------------------------------------------
  def phase3_switch_actor
=begin
    @input_battler.current_action.clear
    @active_battler.current_cost = no_action_cost(@active_battler)
    @active_battler.ctb_update(@active_battler.current_cost)
    @input_battlers.delete(@input_battler)
    @action_battlers.delete(@input_battler)
    command_input_cancel
    @input_battler = nil
    @actor_index = nil
=end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase)
  #--------------------------------------------------------------------------
  alias update_phase3_ctb update_phase3
  def update_phase3
    if cancel_command?
      if can_act?
        if @input_battler.confused?
          @input_battler.current_action.kind = 0
          @input_battler.current_action.basic = 0
        end
        @action_battlers << @input_battler
        @action_battlers.compact!
      end
      command_input_cancel
      return
    end
    update_phase3_ctb
  end
  #--------------------------------------------------------------------------
  # * Command cancel flag
  #--------------------------------------------------------------------------  
  def cancel_command?
    return false if @input_battler.nil?
    return true if @input_battler.current_action.forcing
    return true if @input_battler.confused?
    return true if @input_battler.restriction == 4
    return true if not $game_party.actors.include?(@input_battler)
    return false
  end
  #--------------------------------------------------------------------------
  # * Can't act flag
  #--------------------------------------------------------------------------  
  def can_act?
    return true if @input_battler.current_action.forcing
    return true if @input_battler.confused?
    return false
  end
  #--------------------------------------------------------------------------
  # * Frame Update (actor command phase : basic command)
  #--------------------------------------------------------------------------
  alias update_phase3_basic_command_ctb update_phase3_basic_command
  def update_phase3_basic_command
    @curent_index = nil
    case @actor_command_window.commands[@actor_command_window.index]
    when $data_system.words.attack
      @active_battler.selected_action = $data_weapons[@active_battler.weapon_id].nil? ?
       'Attack' : $data_weapons[@active_battler.weapon_id]
    when $data_system.words.guard 
      @active_battler.selected_action = 'Defend'
    when @escape_name
      @active_battler.selected_action = 'Escape'
    else
      @active_battler.selected_action = ''
    end
    if @curent_command_index != @actor_command_window.index or
       (Ctb_Order_Style == 0 or Ctb_Order_Style == 4 and Graphics.frame_count % 3 == 0)
      update_all_ctb
      @ctb_window.refresh
      @curent_command_index = @actor_command_window.index
      @curent_index = nil
    end
    if Cancel_Input != nil and Input.trigger?(Cancel_Input)
      $game_system.se_play($data_system.decision_se)
      @selection_phase = false
      phase3_switch_actor
      return
    end
    if Input.trigger?(Input::C)
      case @actor_command_window.commands[@actor_command_window.index]
      when @escape_name
        if $game_temp.battle_can_escape == false
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        @active_battler.escape_attempt = true
        $game_system.se_play($data_system.decision_se)
        @selection_phase = false
        update_phase2_escape
        return
      end
    end
    return if Cancel_Input != nil and Input.trigger?(Cancel_Input)
    update_phase3_basic_command_ctb
  end
  #--------------------------------------------------------------------------
  # * End Actor Selection
  #--------------------------------------------------------------------------
  alias end_actor_select_ctb end_actor_select
  def end_actor_select
    update_temp_info
    end_actor_select_ctb
  end
  #--------------------------------------------------------------------------
  # * End Enemy Selection
  #--------------------------------------------------------------------------
  alias end_enemy_select_ctb end_enemy_select
  def end_enemy_select
    update_temp_info
    end_enemy_select_ctb
  end
  #--------------------------------------------------------------------------
  # * End All Enemies Selection
  #--------------------------------------------------------------------------
  alias end_select_all_enemies_ctb end_select_all_enemies
  def end_select_all_enemies
    update_temp_info
    end_select_all_enemies_ctb
  end
  #--------------------------------------------------------------------------
  # * End All Actors Selection
  #--------------------------------------------------------------------------
  alias end_select_all_actors_ctb end_select_all_actors
  def end_select_all_actors
    update_temp_info
    end_select_all_actors_ctb
  end
  #--------------------------------------------------------------------------
  # * End All Battlers Selection
  #--------------------------------------------------------------------------
  alias end_select_all_battlers_ctb end_select_all_battlers
  def end_select_all_battlers
    update_temp_info
    end_select_all_battlers_ctb
  end
  #--------------------------------------------------------------------------
  # * End Self Selection
  #--------------------------------------------------------------------------
  alias end_select_self_ctb end_select_self
  def end_select_self
    update_temp_info
    end_select_self_ctb
  end
  #--------------------------------------------------------------------------
  # * Cancel command input
  #--------------------------------------------------------------------------
  def command_input_cancel
    windows_dispose
    @input_battler.blink = false
    @input_battlers.delete(@input_battler)
    @input_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Dispose windows
  #--------------------------------------------------------------------------
  def windows_dispose
    @help_window.visible = false if !@escaping
    if @enemy_arrow != nil
      @enemy_arrow.dispose
      @enemy_arrow = nil
    end
    if @actor_arrow != nil
      @actor_arrow.dispose
      @actor_arrow = nil
    end
    if @actor_arrow != nil
      @actor_arrow.dispose
      @actor_arrow = nil
    end
    if @skill_window != nil
      @skill_window.dispose
      @skill_window = nil
    end
    if @item_window != nil
      @item_window.dispose
      @item_window = nil
    end
    if @enemy_arrow_all != nil
      @enemy_arrow_all.dispose
      @enemy_arrow_all = nil
    end
    if @actor_arrow_all != nil
      @actor_arrow_all.dispose
      @actor_arrow_all = nil
    end
    if @battler_arrow_all != nil
      @enemy_arrow_all.dispose
      @enemy_arrow_all = nil
    end
    if @actor_command_window != nil
      @actor_command_window.active = false
      @actor_command_window.visible = false
      @active_battler_window.visible = false
      @actor_command_window.opacity = 0
    end
    @selection_phase = false
    @status_window.visible = true
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 2 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step2_part1_ctb step2_part1
  def step2_part1(battler)
    @ctb_window.refresh
    battler.defense_pose = false
    battler.casting = false
    if battler.cast_action != nil
      active_cast = battler.cast_action
      if active_cast.scope == 1 or active_cast.scope == 3 or active_cast.scope == 5
        battler.current_action.target_index = battler.cast_target
      end
      if active_cast.is_a?(RPG::Skill)
        battler.current_action.kind = 1 
        battler.current_action.skill_id = active_cast.id
      elsif active_cast.is_a?(RPG::Item)  
        battler.current_action.kind = 2 
        battler.current_action.item_id = active_cast.id
      end
      battler.cast_action = nil
    end
    step2_part1_ctb(battler)
    if (battler.now_action.is_a?(RPG::Skill) or battler.now_action.is_a?(RPG::Item)) and 
       battler.cast_action.nil? and active_cast.nil?
      battler.cast_action = battler.now_action
      battler.cast_target = battler.current_action.target_index
      cast_speed = battler.now_action.cast_speed(battler)
      battler.cast_action = nil if cast_speed == 0
      battler.casting = cast_speed != 0
      unless cast_speed == 0
        battler.movement = false 
        battler.current_phase = 'Phase 5-1'
      end
    end
    if cant_use_action(battler) and battler.cast_action != nil
      battler.cast_action = nil
      battler.moviment = false 
      battler.current_phase = 'Phase 5-1'
    end
    set_action_cost(battler)
  end
  #--------------------------------------------------------------------------
  # * Get no action cost
  #     battler : battler
  #--------------------------------------------------------------------------
  def no_action_cost(battler)
    return battler.actor? ? No_Action_Cost : Attack_Default_Cost
  end
  #--------------------------------------------------------------------------
  # * Set action cost
  #     battler : battler
  #--------------------------------------------------------------------------
  def set_action_cost(battler)
    battler.current_cost = no_action_cost(battler)
    if battler.attack? or battler.skip?
      if battler.current_action.basic == 0
        if Action_Cost['Attack'] != nil and Action_Cost['Attack'][now_id(battler)] != nil and 
           battler.now_action.is_a?(RPG::Weapon)
          battler.current_cost = Action_Cost['Attack'][now_id(battler)]
        else
          battler.current_cost = Attack_Default_Cost
        end
      elsif battler.current_action.basic == 1
        battler.current_cost = Defense_Cost
      elsif battler.is_a?(Game_Enemy) and battler.current_action.basic == 2
        battler.current_cost = Escape_Cost
      elsif battler.current_action.basic == 3
        battler.current_cost = battler.escape_attempt ? Escape_Cost : no_action_cost(battler)
      end
    elsif battler.skill_use?
      if Action_Cost['Skill'] != nil and Action_Cost['Skill'][now_id(battler)] != nil and 
         battler.now_action.is_a?(RPG::Skill)
        battler.current_cost = Action_Cost['Skill'][now_id(battler)]
      else
        battler.current_cost = Skill_Default_Cost
      end
    elsif battler.item_use?
      if Action_Cost['Item'] != nil and Action_Cost['Item'][now_id(battler)] != nil and 
         battler.now_action.is_a?(RPG::Item)
        battler.current_cost = Action_Cost['Item'][now_id(battler)]
      else
        battler.current_cost = Item_Default_Cost
      end
    end
    if battler.cast_action != nil
      action = battler.cast_action
      if Action_Cost[action.type_name] != nil and
         Action_Cost[action.type_name][action.id] != nil
        battler.current_cost = Action_Cost[action.type_name][action.id]
      else
        battler.current_cost = eval(action.type_name + "_Default_Cost")
      end
    end
    pop_help(Escape_Text, battler, 4, 1) if @escape_failed and Escape_Text != nil
    @escape_failed = false
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 3 (part 1)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step3_part1_ctb step3_part1
  def step3_part1(battler)
    battler.cast_action = nil
    battler.selected_action = nil
    step3_part1_ctb(battler)
  end
  #--------------------------------------------------------------------------
  # * Update battler phase 5 (part 4)
  #     battler : active battler
  #--------------------------------------------------------------------------
  alias step5_part4_ctb step5_part4
  def step5_part4(battler)
    step5_part4_ctb(battler)
    battler.ctb_update(battler.current_cost, battler.now_action)
    battler.escape_attempt = false
    @ctb_turn_count += 1
    @action_battlers.delete(battler)
    @active_battlers.delete(battler)
    update_temp_info
    @help_window.visible = false if @help_window != nil
    judge
  end
end