#==============================================================================
# Atoa Custom Battle System
# BASIC SETTINGS
#==============================================================================
# Here is the main settings of the script, you can change
# completely the battle style
#
# Take an good look in each option, so you can use the full potential
# of the system
# 
#¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
#                           ***IMPORTANT WARNING***                          #
#¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
#
# The script have hundreds of configurable values, all of them with their
# explanation.
# So, *READ ALL INSTRUCTIONS*
# I won't give support to lasy people who doesn't read them
#
#==============================================================================

module Atoa
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # INITIALING CONSTANTS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Do not remove or change these lines
  constants = ["Pose_Sprite", "Enemy_Steal","Enemy_Drops", "Slip_Pop_State","States_Pose",
    "Actor_Settings", "Enemy_Settings", "Skill_Settings","Weapon_Settings","Item_Settings",
    "Actor_Battle_Cry","Enemy_Battle_Cry","Animation_Setting","Pose_Battle_Cry",
    "Pose_Animation"]
  for i in 0...constants.size
    eval(constants[i] + " = {}") 
  end
  # Do not remove or change these lines

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # BASIC CONFIGURARION
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  # Set Battlers Postion style
  Battle_Style = 0
  # 0 = Sideview
  # 1 = Isometric
  # 2 = Front Battle
  # 3 = 4 Directions
  
  # Automatic set  actors battlers position?
  Auto_Set_Postions = false
  # true = actors battlers will be positioned automatically
  # false = you must set actors battlers postions in "Custom_Postions"
  
  # Max number of members in the party
  Max_Party = 10
  
  # Set here the actors battlers position if "Auto_Set_Postions = false"
  Custom_Postions = [[440,256],[440,318],[440,390],[512,256],[512,318],[512,390],[584, 228],[584,290],[584,352],[584,414]]
  #[[353,280],[353, 358],[353,446],[455,245],[455,323],[455,405],[455,471],[555,280],[555,358],[555,446]]
  
  # You can change the postion of the actors battlers in the screen.
  # Has no effect if "Auto_Set_Postions = false"
  Actor_Position_AdjustX = 0
  Actor_Position_AdjustY = 0

  # You can change the postion of the enemies battlers in the screen.
  # Use only if you want an customized layout for battle
  # (E.g.: you want the battle status window in the top of screen)
  # That's apply to all enemies battlers
  Enemy_Position_AdjustX = 0
  Enemy_Position_AdjustY = 90
  
  # Battle screen dimensions, used to limit the battle viewport
  # Battle_Screen_Dimension = [width, height]
  Battle_Screen_Dimension = [640, 480]
  #set to cover everything to avoid limiting where it can show up
  
  # Battle screen position, used to change the position of the battle viewport
  # Battle_Screen_Position = [X, Y]
  Battle_Screen_Position = [0, 0]
  #offset set to (0,0) for fulll screen overlap

  # Set here all battlers movement
  Move_to_Attack = true
  # true = Battlers will move to the target to attack
  # false = No battlers will move to the target to attack
  
  # Priority of battlers graphics on the screen
  Battler_High_Priority = false
  # true = battlers will be shown above battle status window
  # false = battlers will be shown bellow battle status window
  
  # Set the time between actions
  Battle_Speed = 2
  # Must be an value between 1 and 10, the higher the faster.
  
  # Set if the battlers grapihics will be shown after or before the transition
  # completion
  Show_Graphics_Transition = true
  # true = the graphics appear together the transition effect
  # false = the graphics appear after the transition effect
  
  # Transition speed, the lower, the faster.
  Transition_Speed = 30
  
  # Base rate of escape success. The escape rate are also changed by the battler's
  # agility difference, so even with an value of 100, the ecape can fail
  Escape_Base_Rate = 50
  
  # Set movement during escapes. If true, adds escape animation to the battlers.
  Escape_Move = true

  # EXP Division
  EXP_Share = true
  # true = EXP will be divided among the alive actors in the end of battle
  # false = EXP won't be divided 
  
  # Set if enemy will lose it's turn if try to use an unavailable skill.
  Enemy_Dont_Skip_Action = true
  # If true the enemy won't lose it's turn
  
  # Ivert all battlers graphics
  Invert_All_Battlers = false
  # let it true if you want to inver the battler positions (leaving the enemies
  # on the right and allies on the left) without needing to change the graphics
    
  # Set if all battlers will use jump animation for movement
  All_Jump = 0
  # If the value is higher than 0, all batters will jump to the target.
  # the value sets the jump height. Default is 10.
    
  # Set if all battlers will use shadow graphic
  All_Shadow = false
  # true = all battlers will use shadow graphics
  # false = only the battlers set on the advanced settings will use shadow graphic
  
  # Default file name for the shadow graphic, used if All_Shadow = true and
  # the battler hasn't it's own shadow graphic configurated on the advanced settings
  # Default_Shadow = ['file name', x, y]
  Default_Shadow = ["Shadow00", 0, -6]
  # The shadow graphic must be on the folder Graphics/Battlers
 
  # Animationd Basic settingss
  Intro_Time   = 20   # Intro animation duration. Numeric Value
  Victory_Time = 90   # Victory animation duration. Numeric Value
  
  # Set here the postion of the Battle Command Window
  Command_Window_Position = 3
  # 0 = Above the Actor
  # 1 = Right of the Actor
  # 2 = Left of the Actor
  # 3 = Custom

  # Adjust the command window postion, don't have effect if 'Command_Window_Position = 3'
  Command_Window_Position_Adjust =  [0, -100]
  
  # Set the postion of the command window  if 'Command_Window_Position = 3'
  Command_Window_Custom_Position = [240, 128] #[240, 128]
  
  # Set there the postion of actor name window
  Name_Window_Position = 4
  # 0 = Above command window
  # 1 = Bellow command window
  # 2 = Left of command window
  # 3 = Right of command window
  # 4 = Custom
  
  # Set there the offset coordinates of actor name window. Only if 'Name_Window_Position = 4'
  Name_Window_Custom_Position = [8,-32]

  # Default Value for Windows opacity
  Base_Opacity = 255 #160
  
  # Show actor name window when selecting action?
  Battle_Name_Window = false
  
  # Hide status window when selecting items/skills?
  Status_Window_Hide = true
  # Recomended leave it false if you using custom windows for skill/items
  
  # Hide cost of the skills that costs O SP
  Hide_Zero_SP = true

  # Target Arrow position adjust
  Targer_Arrow_Adjust = [0,0]  
    
  # Set Here the name of Evasion status.
  # By default, it's not shown, but you can add this.
  # The evasion is the parameter type 7 in 'draw_actor_parameter(actor, x, y, type)'
  Status_Evasion = "Evade"
  
  # Miss/Evade Message
  Miss_Message = "Miss"
  
  # Battle Messages. If you want the action battler name to be shown, add
  # {battler_name} in the message
  Guard_Message = "{battler_name} defends!" # Guard Message
  Escape_Message = "{battler_name} escaped?!" # Escape (enemies only)

  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # DYNAMIC ACTIONS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # These settings allow the battlers to execute actions simultaneously if
  # certain conditions are met
  # Recomended don't activate all at the same time, because the battle can become
  # an real mess
  
  # If true, the next battler starts his action before the active battler return to the postion
  Next_Before_Return = false
  
  # If true, the next battler starts his action if his targets are the same of the
  # active battler
  Allow_Same_Target = false
  
  # If true, the next battler starts his action if his targets are different from the
  # active battler
  Allow_Diff_Targets = false
  
  # If true, when an battler mets all conditions to act, he will act even if
  # his target is moving.
  Allow_Moving_Target = false
  
  # If true, when an battler mets all conditions to act, he will act even
  # if he is being targeted by any enemy.
  Allow_Enemy_Target = false
  
  # If true, when an battler mets all conditions to act, he will act even
  # if his targets are active.
  Allow_Active_Target = false
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # DAMAGE ALGORITHM STTTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤  
  # Choose the Damage Alogarithm
  Damage_Algorithm_Type = 0
  # 0 = Default XP Style, no changes
  # 1 = Default XP Modified, def/mdef reduces damage in % ( 10 def = 1% )
  # 2 = Default VX, Vitality replaces Dexterity, the status Attack, P.Def and
  #     M.Def are totally ignored. (Edit the menus script to remove these status)
  # 3 = Customized, an mix of XP e VX alogarithm, Vitality replaces Dexterity
  # 4 = All Custom, you can make your own algorithm
  
  # Base Variance for Normal Attacks
  Base_Variance = 0
  
  # Base critical hit rate
  Base_Critical_Rate = 0
  
  # Base critical damage rate
  Base_Critical_Damage = 100
  
  # Customized damage formula
  
  # Formula for physical attacks
  Custom_Attack_Algorithm = "(({atk} * 3) + ({str} * 5)) - ({def} * 4)"
  
  # Formula for skills
  Custom_Skill_Algorithm = "(({atk} * 3 * skill.atk_f / 100) + ({str} * 5 * skill.str_f / 100) + (user.int * 10 * skill.int_f / 100)) - (({def} * 4 * skill.pdef_f / 100) + (self.mdef * 4 * skill.mdef_f / 100))"
  
  # You can make any math operation and use any script command normally.
  #
  # Use the following commands do set the attaker attack and target defense:
  # {atk} - Attacker's Weapon Attack Power
  # {str} - Attacker's Natural Strenght
  # {def} - Target Physical Defense
  # 
  # Other status can be added using their respective script commands.
  # For normal attacks, use "attacker" for the attacker and "self" for the target
  # Outros atributos podem ser adicionados usando seus respectivos comandos de script.
  # For normal attacks, use "user" for the user and "self" for the target, and "skill" for
  # the skill
  #
  # Be careful when making this setting.
  # If you don't undestand what was explained here, don't use customized formulas.
  # Use one of the pre-defined algorithm

  # Name of the attribute that will show damage resistance, used only if
  # Damage_Algorithm_Type > 1. It will replace the Dexterity attribute
  Status_Vitality = "Vitality"

  
  # Unnamerd Battlers settingss
  Unarmed_Attack    = 20 # Unnarmed Attack Power
  Unarmed_Animation = 4  # Unnarmed Attack Animation ID
    
  # HP % that show low HP Animation
  Danger_Value = 25

  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ANIMATIONS SETTING
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Position adjust for battle animations
  #
  # Animation_Setting[ID] = [X, Y, Z]
  #   ID = ID of the battle animation
  #   X = Position X adjust. Numeric value, default 0.
  #   Y = Position Y adjust. Numeric value, default 0.
  #   Z = Z Axis adjust. Numeric value. If Negative, the animation is shown
  #     bellow the target, if 0 or positive, it's showns above. but bellow
  #     actors in an higher Z axis. If nil animation is shown above all battlers
  
  Animation_Setting[1] = [0, 0, 5]
  Animation_Setting[2] = [0, 0, -5]
  Animation_Setting[131] = [0, -80, 5]
    
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # STATES SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  # State cycle times.
  State_Cycle_Time = 2
  
  # Definition of the moment when the effects of 'slip_damage' 
  #(poison and regeneration) will have effect
  Slip_Damage_Pop_Time = 0
  # 0 = Before actions
  # 1 = After actions
  # 2 = end of turn
  
  # # Use Icons to show states? 
  Icon_States = false
  # true = show states by icons
  # false = show states by text
  
  # States Icon Configuration
  # The States icons must have the same name as the state + '_st'
  # E.g.: The state Venon, must have an icon named 'Venom_st'
  Icon_max = 5   # Max number of icons shown
  Icon_X   = 24  # Width of the icon
  Icon_Y   = 24  # Height of the icon
  X_Adjust = 0   # Position adjusts X
  Y_Adjust = 0   # Position adjusts Y
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # POSES SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can set the poses parameters
  # Recomended to change these values only if you know what you doing
  # IF YOU ARE A NOOB, STAY AWAY FROM HERE!
  
  # The value set here is the 'line' of the pose in the battler graphic.
  # If the value set here is an '3', the third line will be used.
  # So 'Defense_Pose = 4' means that the fourth line will be used for Defense
  
  # Basic Poses
  # if you don't wish to use any of these poses, leave the value = 1
  Idle_Pose    = 1  # Wait pose (Recomended never change, because it can cause funtion losses)
  Hurt_Pose    = 2  # Pose when Taking Damage(Recomended never change, because it can cause funtion losses)
  Danger_Pose  = 3  # Idle pose when HP is low
  Defense_Pose = 4  # Idle pose when guarding
  Advance_Pose = 5  # Moving foward
  Return_Pose  = 6  # Return move pose
  Attack_Pose  = 7  # Pose when attacking
  Skill_Pose   = 7  # Pose when using Physical Skills
  Magic_Pose   = 8  # Pose when using Magical Skills
  Item_Pose    = 8  # Pose when using Items
  Dead_Pose    = 11 # Dead Idle pose
  
  # Extra poses
  # These poses aren't 100% vital for the system. if you wish to not use some
  # of them, leave the value = nil
  Intro_Pose    = 9   # Pose used in the begin of battle
  Victory_Pose  = 10  # Battle Victory pose
  Evade_Pose    = 4   # Pose when evade an attack
  Escape_Pose   = 6   # Pose when escaping from battle
  Critical_Pose = nil # Pose for Critical Attacks
  Advance_Start_Pose  = nil # Pose for advance start
  Advance_End_Pose    = nil # Pose for advance end
  Return_Start_Pose   = nil # Pose for return start
  Return_End_Pose     = nil # Pose for return end
  Magic_Cast_Pose     = nil # Pose for Magic Skill Cast
  Physical_Cast_Pose  = nil # Pose for Physical Skill Cast
  Item_Cast_Pose      = nil # Pose for Item Use Cast
  Danger_Defense_Pose = nil # Pose for Defense when in Danger
  Danger_Evade_Pose   = nil # Pose for Evade when in Danger
  Critical_Skill_Pose = nil # Pose for Critical Physical Skill

  # States Poses Configuration
  # States_Pose[State ID] = Pose ID
  States_Pose[3] = 3  # Venom
  States_Pose[7] = 11 # Sleep
  
  # Remember that all battlers graphics must have the poses set here
  # If the settings isn't right, the battler simply will do nothing
  # So if an battler don't make any move you check here.
  
  # Default Pose Configuration.
  # Base_Sprite_Settings = {Settings}
  # The Settings are the following.
  #  Base Setting - this is the graphic dimensions settings
  #   "Base" => [X, Y, SPD, Mirror]
  #      "Base" = this is the value that sets the base settings, don't change.
  #      X = number of horizontal frames. Numeric value higher than zero. Default 4.
  #      Y = number of vertical frames. Numeric value higher than zero. Default 11.
  #      SDP = Movement Speed. Numeric value higher than zero. Default 200.
  #      Mirror = invert graphic. true or false. Default false.
  #
  #  Pose Settings - These are the setting of each pose.
  #    Pose_ID => [Frames, Time, Loop]
  #      Pose_ID = The Pose ID. Numeric value higher than zero.
  #      Frames = Number of animation frames. Numeric value higher than zero.
  #      Time = Duration of each frame pose.Numeric value higher than zero.
  #      Loop = Animation Loop. true or false.
  #
  #  Extra Settings - These are optional settings.
  #    Remember that if you add these settings here, *all* graphics will have these
  #    settings (except the ones you set individually on the ACBS | Config 2 - Advanced)
  #    The extra settings are "Shadow" and "Jump"
  #   
  #    "Shadow" =>["Name", X, Y]
  #      "Shadow" = this is the value that sets the shadow setting.
  #      "Name" = Name of the shadow graphic file.
  #       X = Shadow position X adjust. Numeric value.
  #       Y = Shadow position Y adjust. Numeric value.
  #     
  #    "Jump" => [Setting]
  #      "Jump" = this is the value that sets the shadow setting.
  #       Setting = here you set wich type of movemente the battler will use the jump.
  #        For that you must add "Advance" and/or "Return" in the Setting array.
  #        "Advance" means that the battler will jump when advancing towards the targert.
  #        "Return" means that the battler will jump when getting away from the target.
  #        You can add only one or both fo them
  #        E.g.: 
  #         "Jump" =>["Return"]
  #         "Jump" =>["Advance","Return"]   
  #
  # Default Settings for graphics that wasn't configurated individually.
  # Don't change unless you're sure about what you doing
  Base_Sprite_Settings = {"Base" => [4,11,200,false],
    1 => [4,8,true], 2 => [4,4,false], 3 => [4,8,true], 4 => [4,4,false], 
    5 => [4,4,true], 6 => [4,4,true], 7 => [4,2,false], 8 => [4,4,false],
    9 => [4,4,false], 10 => [4,4,false], 11 => [4,4,false]}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # DAMAGE DISPLAY SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # You can change here how damage is displayed
  
  # Use Images instead of texts
  Damage_Sprite = false
  # This option allows to make the digitis of damage exhibition to be images
  # instead of text.
  # This option was added because the draw text method is quite slow
  # and may cause slowdown when multiple values are drawn at same time
  # The files must be on the folder "Graphics/Digits" and must have the
  # file name equal the digit.
  # E.g.: The number 1 must have an file named '1'.
  # IF "Damage_Sprite" is set false, you can delet the Digits folder.
  
  # This settings are valid only for draw text exhibition
  #                red blue gren
  Hp_Dmg_Color  = [255, 255, 255] # HP damage color
  Hp_Rec_Color  = [176, 255, 144] # HP heal color
  Sp_Dmg_Color  = [144,  96, 255] # SP damage color
  Sp_Rec_Color  = [255, 144, 255] # HP heal color
  Crt_Dmg_Color = [255, 144,  96] # Critical damage color
  Crt_Txt_Color = [255,  96,   0] # Critical text color
  Mss_Txt_Color = [176, 176, 176] # Erros message color
  Damage_Font   = $defaultfont   # Damage Exhibition font
  Dmg_Font_Size = 24   # Damage Exhibition font size
  
  # This settings are valid only forimage exhibition
  # These valus must be added to the graphic filename
  Hp_Rec_String  = "_heal"   # Filename sufix for HP Heal
  Sp_Dmg_String  = "_sp"     # Filename sufix for SP Damage
  HP_hi_Dmg_String  = "_hi"     # Filename sufix for HP high damage
  Sp_Rec_String  = "_spheal" # Filename sufix for SP Heal
  Crt_Dmg_String = "_crt"    # Filename sufix for Critical damage
  Mss_Txt_String = "_mss"    # Filename sufix for Miss
  # If you don't want to use one of these values, leave it equal ''
  # If an file isn't found, the default file will be used.

  Crt_Message  = "Crit-hit!" # Crical Hit Message
  Dmg_Duration = 40     # Duration time that the damage is diplayed on the screen
  Critic_Text  = true   # Show Critical Hit Message on Critical Hits? true/false
  Critic_Flash = false   # Flash Effect on Critical Hits?
  Multi_Pop    = true  # Use FF damage style? false = normal / true = FF Style
  Pop_Move     = true   # Movement on Damage Display? true/false
  Random_Move  = false  # Random movement for Damage Display? (Only if Pop_Move = true)
  Dmg_Space    = 16     # Space between the damage digits
  Dmg_X_Adjust = 0      # X position adjust
  Dmg_Y_Adjust = 0      # Y position adjust
  Dmg_X_Move   = 2      # X Damage Move (only if Pop_Move = true)
  Dmg_Y_Move   = 6      # Y Damage Move , the height that damage'pops'
  Dmg_Gravity  = 0.95   # Gravity effect, changes the 'pop' effect
                        # Can be decimals
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # STEAL SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

  # The enemies can be stolen more than once?
  Multi_Steal = false
  # true = you can steal enemies until they have no item
  # false = each enemy can be stole only once per battle, even if it has more items
  
  # Steal Base Rate
  Steal_Rate = 50
  # Even if the rate is 100%, that dont't grants 100% of chance of getting an item
  # this value changes with the difference bettwen, the user and target's AGI, and
  # it still necessary to verify the drop rate of each item
  
  # Message if the target has no items
  No_Item = "Nothing worth stealing..."
  
  # Message if the steal attempt fail
  Steal_Fail = "Didn't steal anything..."
  
  # Message of Item steal sucess. {item} is the name of the item, you must add it
  # to the message, or the item name won't be shown
  Steal_Item = "Stole {item}!"
  # E.g:
  # "Stole {item}" - Stole Potion
  # "{item} gained" - Potion gained
  
  #  Message of gold steal sucess. {gold}  is the amount of gold, you must add it
  # to the message, or the amount stole won't be shown
  # {unit} the money unit, use it only if you want
  Steal_Gold = "Stole {gold}{unit}"
  # Exemplos:
  # "Stole {gold}{unit}" - Stole 500G
  # "Stole {gold} coins" - Stole 500 coins
  
  # You can set the steal items on the script "ACBS | Config 2 - Advanced"
  #=============================================================================
end