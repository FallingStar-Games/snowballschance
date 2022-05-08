#==============================================================================
# Atoa Custom Battle System
# by Atoa
#==============================================================================
#
# Hi, this is the battle system "Atoa Custom Battle System".
# This system was based on an Breath of Fire like system i've done before.
# After a lor of modifications, it's now an "Generic" system
# Having a very high level of customization.
# Whit this system you can make side view, front view or isometric battles.
# And all of it without changing one line in the core script
#
# Features:
# - 100% Animated Battle
# - Compatible with battlers of different styles
# - Allows the use of different styles battlers at the same time
# - Very high level of customization
# - A lot of useful built-in systems
# - A lot of add-ons to change the battle.
# - When using an skill withou an assigned animation, it will use the weapon
#   animation automatically
#
#==============================================================================
#
# Thanks:
# - SephirotSpawn - (hbgames.org)
# - SleepingLionheart - (hbgames.org)
# - Charlie Fleed - (rpgrevolution.com)
# - Farenheight - (reinorpg.com)
# - CCOA - (?)
# - RTH - (?)
# - XRXS - (?)
# - KGC - (?)
# - Cogwheel - (?)
#
# Various scripts of these autors were used as study material or as base of
# some functions of the battle system
# 
# - Zeriab - (hbgames.org)
# For his anti-lag that can be used with Chrono Trigger Battle
#
# - XeloX - (hbgames.org)
# - Apocrifis - (hbgames.org)
# - Neoz Kaho - (hbgames.org)
# - No ID/dpoteat - (hbgames.org)
# - MayorAnime - (hbgames.org)
# - Linkei - (santuariorpgmaker.com)
# - NicholasRg - (santuariorpgmaker.com)
# - Darknan - (santuariorpgmaker.com)
# - Megalukes - (santuariorpgmaker.com)
# Help with debug
#
# Special Thanks:
# - DarkLuar - (santuariorpgmaker.com)
# Because she is the most important person in my life.
#
#==============================================================================
# Version History: 
#--------------------------------------------------------------------------
#
# V3.2.3 | 03 - 11 - 2011
#  • Bug fixes.
#
#  • Scripts Updated:
#    - ACBS | Scene Battle 4
#
#  • Add-Ons Updated:
#    - Add | Skill Combination
#
#--------------------------------------------------------------------------
#
# V3.2.2 | 03 - 10 - 2011
#  • Bug fixes.
#
#  • Scripts Updated:
#    - ACBS | Scene Battle 4
#
#  • Add-Ons Updated:
#    - Add | Atoa CTB (only add the setting Escape_Text = "text" on the module)
#    - Add | Two Hands (only add the setting Dual_Hit_Skill = [] on the module)
#    - Add | Skill Conditions
#
#--------------------------------------------------------------------------
#
# V3.2.1 | 03 - 09 - 2011
#  • Bug fixes.
#
#  • Scripts Updated:
#    - ACBS | RPG::Sprite
#    - ACBS | Sprite Battler
#    - ACBS | Game Battler
#    - ACBS | Scene Battle 4
#
#  • Add-Ons Updated:
#    - Add | Atoa CTB
#    - Add | Atoa ATB
#    - Add | Automatic Actions
#    - Add | Skill Combination
#    - Add | Counter Attack
#    - Add | Combo Display
#    - Add | Chrono Trigger Battle
#
#--------------------------------------------------------------------------
#
# V3.2 | 02 - 19 - 2011
#  • Bug Fixes.
#  • Removed the setting for Auto States from the Add | Enemy Advanced Status,
#    these settings are now on an separated add-on.
#  • New basic settings:
#    - Make enemies use another actions if the selected one isn't available,
#      avoid it's losing the turn. (Enemy_Dont_Skip_Action)
#    - Hide SP value for skills that cost 0 SP. (Hide_Zero_SP)
#    - Random move for damage pop (Randon_Move)
#    - Movimento aleatório para exibição de dano (Random_Move)
#    - Set Base critical rate (Base_Critical_Rate)
#    - Set Base critical damage rate (Base_Critical_Damage)
#    - Pose for Evade when in Danger (Danger_Evade_Pose)
#    - Pose for Critical Physical Skill (Critical_Skill_Pose)
#    - Allows battler to act even if it's another battler target(Allow_Enemy_Target)
#    - Allows battler to act even if it's targets are active (Allow_Active_Target)
#  • Changes on the Add | Custom Window Settings:
#    - Hide_Zero_SP removed and added to the basic settings
#  • Changes on Add | Skill Scan:
#    - Scan_Window_Position, Scan_Window_Dimension, Scan_Border_Opacity,
#      Scan_Back_Opacity removed and replaced by Scan_Window_Settings.
#  • New Advanced Settings:
#    - Ignore move settings of the weapon for physical skills ("IGNOREWEAPONMOVE")
#    - Add weapon element for skill damage. ("WEAPONELEMENT")
#    - Add weapon added effects for skill damage. ("WEAPONSTATES")
#    - Add weapon damage variance for skill damage. ("WEAPONVARIANCE")
#    - Battler moves intantly to the target spot ("TELEPORTTOTARGET")
#    - Update movement during combos ("MOVEINCOMBO")
#    - Clear target battler list between hits ("CLEARRANDOM")
#    - Action don't show any animation ("NOANIMATION")
#    - Show animations in actions with multiple hits ("HITSANIMATION")
#    - Shows different animations based on the target or battler direction
#     ("ANIMDIRECTIONCASTER/**", "ANIMDIRECTIONTARGET/**", "ANIMDIRECTIONPOSITION/**")
#    - Centralize screen animations on the targets ("ANIMCENTERTARGET")
#    - Invert animations based on the target or battler direction
#      ("ANIMMIRRORTARGET/**", "ANIMMIRRORCASTER/**")
#    - New critical settings for skills ("CRITICAL/**", "WEAPONCRITICAL/**" ,
#      "CRITICALDAMAGE/**", "CRITICALWEAPONDAMAGE/**")
#
#  • Scripts Updated:
#    - ACBS | Config 1 - Basic
#    - ACBS | Config 2 - Advanced
#    - ACBS | Object
#    - ACBS | RPG::
#    - ACBS | RPG::Sprite
#    - ACBS | Sprite Damage
#    - ACBS | Sprite Battler
#    - ACBS | Spriteset Battle
#    - ACBS | Game Battler
#    - ACBS | Game Actor
#    - ACBS | Game Enemy
#    - ACBS | Game Party
#    - ACBS | Arrow Class
#    - ACBS | Scene Battle 1
#    - ACBS | Scene Battle 2
#    - ACBS | Scene Battle 3
#    - ACBS | Scene Battle 4
#
#  • New Add-Ons
#    - Add | Counter Attack
#    - Add | Custom Damage
#    - Add | States Graphic
#    - Add | Enemy Auto States
#
#  • New Utility/Patches
#    - Utility | FFVIII Draw
#
#  • Add-Ons Updated:
#    - Add | Atoa CTB
#    - Add | Atoa ATB
#    - Add | Status Limit
#    - Add | Equipment Multi Slots
#    - Add | New Status
#    - Add | Two Hands
#    - Add | Advanced Weapons
#    - Add | New Resistenca System
#    - Add | Equipment with Skills
#    - Add | Enemy Advanced Status
#    - Add | Individual Battle Commands
#    - Add | Enemy Name Window
#    - Add | Automatic Actions
#    - Add | Skill Drain
#    - Add | Skill Charge
#    - Add | Skill Blitz
#    - Add | Skill Scan
#    - Add | Skill Combination
#    - Add | Battle Advantages
#    - Add | Atoa Bestiary
#    - Add | Equipment Sprite
#    - Add | Battle Camera
#    - Add | Legaia Combo
#    - Add | Combo Display
#    - Add | Damage Limit
#
#  • Patchs/Utilitátios Updated:
#    - Ultility | Victory Window FF7
#    - Patch | Megalukes Interactive Rotational Arrow
#
#--------------------------------------------------------------------------
#
# V3.1.0 | 12 - 25 - 2010
#  • Bug Fixes.
#  • Changes on the organization of the Battle Main Code, it was divided in various
#    smaller scripts, the code itself didn't had major changes.
#  • New Advanced Settings:
#    - Help window new hide settings ("HELPHIDE" don't show the help window and
#      don't remove any other help window being shown, "HELPDELETE" hides the
#      help window and remove any other being shown
#    - It's now possible to set an action to not change the current pose
#      (leave the value of "ANIME/**" equal 0)
#    - Jump speed control during actions ("JUMPSPEED/**")
#
#  • Scripts Updated:
#    - ACBS | Battle Main Code (was divided in several smaller scripts.)
#
#  • New Add-Ons
#    - Add | Legaia Combo
#    - Add | Combo Display
#
#  • New Utility/Patches
#    - Megalukes Interactive Rotational
#
#  • Add-Ons Updated:
#    (OBS.: all add-ons were edited for the adition of the comments,
#           but only the listed here had changes on the code itself)
#    - Add |Atoa ATB
#    - Add | Atoa CTB
#    - Add | Two Hands
#    - Add | New Resistance System
#    - Add | Enemy Advanced Settings
#    - Add | Individual Battle Commands
#    - Add | Enemy Name Window
#    - Add | Damage Limit
#    - Add | Automatic Actions
#    - Add | Custom Window Settings
#    - Add | Skill Reflect
#    - Add | Skill Overdrive
#    - Add | Skill Charge
#    - Add | Skill Blitz
#    - Add | Skill Auto-Life
#    - Add | Skill Drain
#    - Add | Skill Scan
#    - Add | Skill Combination
#    - Add | Animated Battler Sprite on Windows
#    - Add | Battle Advantage
#    - Add | Weapons for Skills
#    - Add | Consum Items Actions
#    - Add | Atoa Besiary
#    - Add | Atoa Summon
#    - Add | Equipment Sprite
#    - Add | Battle Camera
#    - Add | Chrono Trigger Battle
#
#--------------------------------------------------------------------------
#
# V3.0.2 | 06 - 08 - 2010
#  • Bug Fixes.
#
#  • Scripts Updated:
#    - ACBS | Battle Main Code
#
#  • Add-Ons Updated:
#    - Add | Atoa ATB
#    - Add | Atoa CTB
#    - Add | New Resistance System
#    - Add | Change SP Cost
#    - Add | Custom Window Settings
#    - Add | Enemy Name Window
#    - Add | Battle Camera
#    - Add | Skill Blitz
#    - Add | Skill Combination
#    - Add | Atoa Summon
#
#  • Utilities Updated:
#    - Utility | Easy LvlUp Notifier 
#
#--------------------------------------------------------------------------
# V3.0.1 | 02 - 08 - 2010
#  • Bug Fixes.
#
#  • Scripts Updated:
#    - ACBS | Battle Main Code
#
#--------------------------------------------------------------------------
#
# V3.0 Beta 1 | 08 - 01 - 2010
#  • Total reformulation on the system.
#
#  • New Basic Setting:
#    - Dynamic Actions
#    - Custom Algorithms
#    - Battle Animtions position
#    - New Extra Default Pose (Danger_Defense_Pose)
#
#  • New Advanced Settings:
#    - Battle Animation based on the battler direction ("ANIMATIONDIRECTION/**")
#    - Move options during attacks ("JUMP/**", "LIFT/**", "FALL")
#    - Move options when recive damage ("DMGIMPACT/**" , "DMGBOUNCE/**", "DMGRISE/**",
#      "DMGSHAKE/**", "DMGWAIT/**", "DMGSMASH", "DMGFREEZE", "DMGRELASE", "DMGANIMTIME/**")
#    - Backgroun image during actions ("ACTIONPLANE/**")
#    - Sounds Effects syncronized with poses (Pose_Battle_Cry)
#    - Battle Animations syncronized with poses (Pose_Animation)
#    - Battler graphics relative 'Center' ('Center')
#
#  • Changes on the Advanced Settings:
#    - Total reformulation on the settings of the "THROW" type.
#    - New hide battler options ("HIDE/**")
#    - New settings for the "mirage" effect ("MIRAGEADVANCE/**",
#      "MIRAGERETURN/**", "MIRAGEACTION/**")
#    - New settings for the custom pose ("ANIME/**", "CAST/**")
#
#  • New Add-OnsNovos Add-Ons
#    - Add | Camera Movement
#    - Add | Equipment Sprite
#    - Add | Battle Advantage
#    - Add | Skills Condition
#    - Add | Automatic Actions
#    - Add | Animated Battler Sprite on Windows
#
#  • Scripts Updated
#    - All
#
#--------------------------------------------------------------------------
#
# V2.0 Final | 01 - 20 - 2010
#  • Major Bug fixes
#  • New Settings for 'Individual Battle Commands' and 'Skill Reflect'
#  • Removed some features of the Chrno Trigger Battle caterpillar system (they
#    will be added as separated scripts).
#  • You can use both CT Battle and Normal Battles.
#  • Changes on Basic Config
#    Replaced Constant 'Fast_Battle' with 'Battle_Speed'
#    Added Name window edit constants: 'Name_Window_Position' and 'Name_Window_Custom_Position'
#  
#  • New System added (Advanced Settings):
#    - Hide battlers system
#
#  • New Add-Ons
#    - Add | Custom Windows Settings
#
#  • Scripts Updated:
#    - All
#
#--------------------------------------------------------------------------
#
# V2.0 Beta 2 | 09 - 14 - 2009
#  • Bug fixes
#  • Add-On Actor Advanced Status removed, replaced with several add-ons
#    that reproduce it's functions.
#
#  • New System added (Advanced Settings):
#    - Arrow/Throw System
#    - Mirage Effect.
#
#  • New Add-Ons
#    - Add | Chrono Trigger Battle
#    - Add | Status Limit
#    - Add | Equipment Multi Slot
#    - Add | Two Hands
#    - Add | New Status
#    - Add | Advanced Weapons
#    - Add | New Resistance System
#    - Add | Equipment with skills
#    - Add | Change SP Cost
#    - Add | Equipment Auto States
#    - Add | Custom Windows
#    - Add | Weapons for Skills
#    - Add | Consum Items Actions
#    - Add | Enemy Name Window
#
#  • Scripts Updated:
#    - All
#
#--------------------------------------------------------------------------
#
# V2.0 Beta 1 | 07 - 14 - 2009
#  • Majos change on the script setting system.
#    This changed most of the codes of the script
#  • Added 'Battle Cry' System
#
#  • Scripts Updated:
#    - All
#
#--------------------------------------------------------------------------
# 
# V1.5 | 08 - 05 - 2009
#  • Major Bug fixes
#  • New graphic inversion options
#  • Added 'jump' moving option
#  • Added shadow showing option
#  • New Pose Configurations for the Add-Ons Add-Ons 'ACBS | Atoa ATB' and 'ACBS | Atoa CTB'
#  • New Sonfigurations for the Add-On 'ACBS | Skill Reflect'
#
#  • New Add-Ons:
#    - Add | Skill Drain
#
#  • Scripts Updated:
#    - ACBS | Config 1 - Basic
#    - ACBS | Config 2 - Advanced
#    - ACBS | Battle Main Code
#
#  • Add-Ons Updated:
#    - Add | Atoa ATB
#    - Add | Atoa CTB
#    - Add | Enemy Advanced Status
#    - Add | Individual Battle Commands
#    - Add | Damage Limit
#    - Add | Skill Reflect
#    - Add | Skill Blitz
#    - Add | Skill Combination
#
#--------------------------------------------------------------------------
# 
# V1.4 | 04 - 04 - 2009
#  • Major Bug fixes
#  • Added critical skills, now you can set some skills to cause critical hits
#  • New Pose Configurations
#  • New Features for the Add-On 'Add | Actor Advanced Status'
#  • Better compatibility for skills Add-Ons
#
#  • New Add-Ons:
#    - Add | Skill Scan
#
#  • Scripts Updated:
#    - ACBS | Config 1 - Basic
#    - ACBS | Config 2 - Advanced
#    - ACBS | Battle Main Code
#
#  • Add-Ons Updated:
#    - Add | Atoa ATB
#    - Add | Atoa CTB
#    - Add | Actor Advanced Status
#    - Add | Enemy Advanced Status
#    - Add | Individual Battle Commands
#    - Add | Damage Limit
#    - Add | Skill Reflect
#    - Add | Skill Overdrive
#    - Add | Skill Charge
#    - Add | Skill Blitz
#    - Add | Skill Scan
#    - Add | Skill Combination
#    - Add | Victory Window 3
#    - Add | Summon
#    - Add | Battle Animated Faces
#
#--------------------------------------------------------------------------
# 
# V1.3 | 04 - 01 - 2009
#  • Small bug fixes
#
#  • New Add-Ons:
#    - Add | Skill Scan
#
#  • Scripts Updated:
#    - ACBS | Battle Main Code
#
#  • Add-Ons Updated:
#    - Add | Atoa ATB
#    - Add | Atoa CTB
#    - Add | Actor Advanced Status
#    - Add | Enemy Advanced Status
#    - Add | Individual Battle Commands
#    - Add | Summon
#
#--------------------------------------------------------------------------
#
# V1.2 | 03 - 31 - 2009
#  • Major bug fixes
#  • Change in special features definition, it's now set by the
#    adding action ID on the script, instead of adding elements to them
#
#  • New Add-Ons:
#    - ACBS | Atoa CTB
#
#  • Scripts Updated:
#    - ACBS | Config 1 - Basic
#    - ACBS | Config 2 - Advanced
#    - ACBS | Battle Main Code
#
#  • Add-Ons Updated:
#    - Add | Atoa ATB
#    - Add | Actor Advanced Status
#    - Add | Enemy Advanced Status
#    - Add | Skill Reflect
#    - Add | Skill Overdrive
#    - Add | Skill Charge
#    - Add | Skill Blitz
#    - Add | Skill Combination
#    - Add | Summon
#    - Add | Bestiary
#
#--------------------------------------------------------------------------
#
# V1.1 | 03 - 27 - 2009
#  • Major bug fixes
#  • Added automatic mirror for enemies battle animations
#
#  • Scripts Updated:
#    - ACBS | Config 1 - Basic
#    - ACBS | Config 2 - Advanced
#    - ACBS | Battle Main Code
#
#  • New Add-Ons:
#    - ACBS | Actor Advanced Status
#    - ACBS | Enemy Advanced Status
#    - ACBS | Skill Auto-Life
#    - ACBS | Victory Window 3
#
#  • Add-Ons Updated:
#    - Add | Battle Windows
#    - Add | HP and MP Meter
#    - Add | Atoa ATB
#    - Add | Damage Limit
#    - Add | Skill Reflect
#    - Add | Skill Overdrive
#    - Add | Skill Charge
#    - Add | Skill Blitz
#    - Add | Skill Combination
#    - Add | Summon
#    - Add | Bestiary
#    - Add | Battle Animated Faces
#
#--------------------------------------------------------------------------
#
# V1.0 | 03 - 11 - 2009
# - System Relased
#
#==============================================================================
