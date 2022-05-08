#==============================================================================
# Atoa Custom Battle System
# ADVANCED SETTINGS
#==============================================================================
# These settings were set aside the other settings to makes easier
# in the time of settings
# These settings are more complex than the Basic.
#==============================================================================


module Atoa
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ADDING SPECIAL SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Add special features is quite simple.
  # First you must choose the type of setting that you want to add
  # They are:
  #  Actor_Settings = Settings for actors
  #  Enemy_Settings = Settings for enemies
  #  Skill_Settings = Settings for skills
  #  Weapon_Settings = Settings for weapons
  #  Item_Settings =  Settings for items
  #
  # After that you must set the ID of the setting "target"
  #   Actor_Settings[ID]
  #   in this case I'm making the setting of an actor
  #
  # And finally add the effects.
  #   Actor_Settings[2] = ["NOCOLLAPSE","NODANGER"]
  #   in this I set that the actor ID 2, won't have collapse effect and won't
  #   have custom pose for low HP.
  #
  # IMPORTANT:
  #   Some effects have "sub settings" like "MOVETYPE/**" and "COMBO/**".
  #   In these cases you must replace the "**" with pre-defined values.
  #   These values are shown on the explanation of each effect.
  #   Adding two equals effects, with different sub settings will have no effect,
  #   only the first one will be used.
  #=============================================================================
  
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR ENEMIES
  # These effects is effective only for enemies
  #
  # ----------------------------------------------------------------------------
  # "VICTORYPOSE" : Enemy with Victory Pose.
  # ----------------------------------------------------------------------------
  # "ENEMYINTRO" : Enemy with Battle Intro Pose.
  #
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR ENEMIES AND ACTORS
  # These effects is effective only for enemies or actors
  #
  # "NOCOLLAPSE" : Don't show collapse (shows the actor dead pose)
  #   It's essential add to all actors if you don't want the red fade effect
  #   to be shown when a actor dies.
  # ----------------------------------------------------------------------------
  # "COLLAPSE/**" : Advanced collapse animation, don't work with "NOCOLLAPSE"
  #   ** must be equal the Collapse Effect ID: 1, 2, or 3,
  # -----------------------------------------------------------------------------------
  # "NODANGER" : Don't use the Low HP pose.
  # ----------------------------------------------------------------------------
  # "LOCKMOVE/**" : Set an permanent movement type.
  #   This value ignore all values of "MOVETYPE" from other actions
  #   So all actions will have this type of movement, no matter of their settings
  #   ** must be equal one of the following values:
  #     - NOMOVE : No movement.
  #     - STEPFOWARD : One step foward.
  #
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR SKILLS
  # These effects is effective only for skills
  #
  # ----------------------------------------------------------------------------
  # "CRITICAL" : Skill can cause criticals.
  # -----------------------------------------------------------------------------------
  # "CONSUMEHP" : Skill consume HP instead of SP.
  # -----------------------------------------------------------------------------------
  # "COSTMAX" : Skill cost is based on Max HP/SP.
  # -----------------------------------------------------------------------------------
  # "COSTNOW" : Skill cost is based on Current HP/SP.
  # ----------------------------------------------------------------------------
  # "IGNOREWEAPONMOVE" : Ignore weapon move settings for physical skills.
  # ----------------------------------------------------------------------------
  # "WEAPONELEMENT" : Add weapon element for skill damage.
  # ----------------------------------------------------------------------------
  # "WEAPONSTATES" : Add weapon added effects for skill damage.
  #
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR WEAPONS
  # These effects is effective only for weapons
  #
  # ----------------------------------------------------------------------------
  # "DMGVARIANCE/**" : Sets an custom variance for weapons
  #    an numeric value between 0 and 100, can be decimals.
  # ----------------------------------------------------------------------------
  # "STARTTHROWWEAPON/**" : If an actors is equiped with this effect, all
  #   attacks and physical skills will have this effect added to them, unless
  #   the effect "THROWWEAPONIGNORE" is added to the action
  #   This is one of the most complex configuration of the advanced settings.
  #   Be very careful to avoid erros.
  #   ** must be written this way: 
  #     SOUND, CURVE, DOWN, LEFT, RIGHT, UP, SPEED, X1, Y1, X2, Y2
  #    (the values must be separated by coma.
  #     SOUND = Name of the sound file used on the throw start. leave nil for no sound.
  #     CURVE = Curve angle for the throw. Numeric value, can be decimal.
  #       Default Value for straight throws = 0.
  #       Default Value for angled throws = 10.
  #     DOWN = Animation ID when the battler is facing down
  #     LEFT = Animation ID when the battler is facing left
  #     RIGHT = Animation ID when the battler is facing up
  #     UP = Animation ID when the battler is facing up
  #     SPEED = Objetc speed. Numeric value. Default 300.
  #     X1 = Start X position of the throw. Numeric value. Default 0.
  #     Y1 = Start Y position of the throw. Numeric value. Default 0.
  #     X1 = End Y position of the throw. Numeric value. Default 0.
  #     X2 = End Y position of the throw. Numeric value. Default 0.
  #   Ex.: "STARTTHROWWEAPON/101-Attack13,0,122,123,124,125,300,-20,0,0,0"
  #        "STARTTHROWWEAPON/nil,10,126,126,126,126,200,0,-20,0,0"
  # ----------------------------------------------------------------------------
  # "ENDTHROWWEAPON/**" : If an actors is equiped with this effect, all
  #   attacks and physical skills will have this effect added to them, unless
  #   the effect "THROWWEAPONIGNORE" is added to the action
  #   This is one of the most complex configuration of the advanced settings.
  #   Be very careful to avoid erros.
  #   ** must be written this way: 
  #     SOUND, CURVE, DOWN, LEFT, RIGHT, UP, SPEED, X1, Y1, X2, Y2
  #    (the values must be separated by coma.
  #     SOUND = Name of the sound file used on the throw start. leave nil for no sound.
  #     CURVE = Curve angle for the throw. Numeric value, can be decimal.
  #       Default Value for straight throws = 0.
  #       Default Value for angled throws = 10.
  #     DOWN = Animation ID when the battler is facing down
  #     LEFT = Animation ID when the battler is facing left
  #     RIGHT = Animation ID when the battler is facing up
  #     UP = Animation ID when the battler is facing up
  #     SPEED = Objetc speed. Numeric value. Default 300.
  #     X1 = Start X position of the throw. Numeric value. Default 0.
  #     Y1 = Start Y position of the throw. Numeric value. Default 0.
  #     X1 = End Y position of the throw. Numeric value. Default 0.
  #     X2 = End Y position of the throw. Numeric value. Default 0.
  #   Ex.: "ENDTHROWWEAPON/101-Attack13,0,122,123,124,125,300,-20,0,0,0"
  #        "ENDTHROWWEAPON/nil,10,126,126,126,126,200,0,-20,0,0"
  #
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR SKILLS AND ITEMS
  # These effects is effective only for skills or items
  #
  # ----------------------------------------------------------------------------
  # "HELPHIDE" : Hides window showing item/skill name
  # ----------------------------------------------------------------------------
  # "HELPDELETE" : Remove window showing item/skill name
  # ----------------------------------------------------------------------------
  # "CAST/**" : Action with cast pose different from the default. You can add
  #   more than one value to make the pose random.
  #   ** must be equal the Poses ID, separated by comas.
  #   Ex.: "CAST/9"
  #       "CAST/8,9"
  # ----------------------------------------------------------------------------
  # "MIRAGECAST/**" : Add mirage effect for casting animation
  #   you can set and different color for the images.
  #   ** can be the value of RGB and Alpha. RED, GREEN, BLUE, ALPHA
  #      or nil for no color.
  #      (ALPHA is the opacity level of the color on the sprite)
  #   Ex.: "MIRAGECAST/255,64,0,160"
  #
  #=============================================================================
  #
  # LIST OF EFFECTS EXCLUSIVE FOR WEAPONS, SKILLS AND ITEMS
  # These effects is effective only for weapons, skills or items
  #
  # -----------------------------------------------------------------------------------
  # "STEAL/**" : Action with Steal effect.
  #   ** must be equal one of the following values:
  #     - BOTH : steal item or gold.
  #     - GOLD : steal only gold.
  #     - ITEM : steal only item.
  # ----------------------------------------------------------------------------
  # "SPDAMAGE" : Action causes SP Damage.
  # ----------------------------------------------------------------------------
  # "NODAMAGE" : Action causes no Damage and don't show Miss Message.
  #
  #=============================================================================
  #
  # LIST OF GENERAL EFFECTS
  # These effects don't have any restriction about when you can use them.
  # Note.: for enemies and actors, these effects are applied only during unnarmed
  #   physical attacks for actors or normal attacks for enemies.
  #   In case of skills, items or armed attacks, the setting of skill, item or
  #   weapon will be applied instead.
  #
  # ----------------------------------------------------------------------------
  # "MOVETYPE/**" : Set the action movemente type.
  #   ** must be equal one of the following values:
  #     - NOMOVE : No movement.
  #     - STEPFOWARD : One step foward.
  #     - SCREENCENTER : Moves to screen center.
  #     - MOVETOTARGET : Moves towards the targets.(only for magics)
  # ----------------------------------------------------------------------------
  # "EXCLUDEUSER" : The user will not be target.
  # -----------------------------------------------------------------------------------
  # "INCLUDEUSER" : The user will always be target.
  # -----------------------------------------------------------------------------------
  # "TARGETSWITCH" : Allows to switch targets between actors and enemies.
  # -----------------------------------------------------------------------------------
  # "TARGET/**" : Special target settings.
  #   ** must be equal one of the following values:
  #     - ALLALLIES : Targets all allies.
  #     - ALLENEMIES : Targets all enemies.
  #     - ALLBATTLERS : Targets all battlers.
  # ----------------------------------------------------------------------------
  # "RANDOM" : Random target, can be used toghter with the "TARGET/**" effects.
  # ----------------------------------------------------------------------------
  # "CLEARRANDOM" : Clear random targets list between hits.
  #   Without this setting, multi hit actions with random targets, will kill
  #   the dead targets only at the end of action. Actions with this setting
  #   kills 0 HP targets right after the hit unless it's the last target.
  # -----------------------------------------------------------------------------------
  # "FAST" : Action will be always the first of the turn. (don't work on ATB/CTB)
  # -----------------------------------------------------------------------------------
  # "SLOW" : Action will be always the last of the turn. (don't work on ATB/CTB)
  # -----------------------------------------------------------------------------------
  # "FREEZEATB" : Action stop time bars even if the battle is set to be 100% active
  #    Works only with the ATB
  # -----------------------------------------------------------------------------------
  # "HIDE/**" : Allows to hide battler exhibition during actions
  #     - BATTLER : Hides user graphic.
  #     - PARTY : Hides user party.
  #     - ENEMIES : Hides user enemy party
  #     - OTHERS : Hides all battlers, except the user
  #     - ACTIVE : Hides all battlers, except the user and his targets
  #     - ALL : Hides all battlers
  # -----------------------------------------------------------------------------------
  # "MOVEPOSITION/**" : Action with special movemente settings
  #   ** must be expressed with the following form: X, Y, A, B, SPD (the values must
  #     be separated by comas ",")
  #     X = Initial battler position X, the higher, the more far. Default = 0
  #     X = Initial battler position Y, the higher, the more far. Default = 0
  #     A = Battle X Movement. Default = 0
  #     B = Battle Y Movement. Default = 0
  #     SPD = Movemente Speed. Default = 200
  #   Ex.: "MOVEPOSTION/10,0,50,0,250"
  # -----------------------------------------------------------------------------------
  #  "TELEPORTTOTARGET" : Battler moves intantly to the target spot
  # -----------------------------------------------------------------------------------
  #  "MOVEINCOMBO" : Update movement during multi hit actions and sequences
  # -----------------------------------------------------------------------------------
  #  "NOANIMATION" : Action don't show any animation, no battle animation neither
  #    pose animation.
  # -----------------------------------------------------------------------------------
  # "ANIMDIRECTIONCASTER/**" : Allow to set an different battle animation for
  #    the action based on the active battler direction
  #    ** must be the ID of the battle animation for each direction
  #      with the following form: "ANIMDIRECTIONCASTER/down,left,right,up"
  #    Ex.: "ANIMDIRECTIONCASTER/10,12,14,16"
  # Obs.: Can't be used with "ANIMDIRECTIONTARGET/**", "ANIMDIRECTIONPOSITION/**"
  # -----------------------------------------------------------------------------------
  # "ANIMDIRECTIONTARGET/**" : Allow to set an different battle animation for
  #    the action based on the target battler direction
  #    ** must be the ID of the battle animation for each direction
  #      with the following form: "ANIMDIRECTIONTARGET/down,left,right,up"
  #    Ex.: "ANIMDIRECTIONTARGET/10,12,14,16"
  # Obs.: Can't be used with "ANIMDIRECTIONCASTER/**", "ANIMDIRECTIONPOSITION/**"
  # -----------------------------------------------------------------------------------
  # "ANIMDIRECTIONPOSITION/**" : Allow to set an different battle animation for
  #    the action based on the battler relative position
  #    ** must be the ID of the battle animation for each direction
  #      with the following form: "ANIMDIRECTIONPOSITION/down,left,right,up"
  #    Ex.: "ANIMDIRECTIONPOSITION/10,12,14,16"
  # Obs.: Can't be used with "ANIMDIRECTIONCASTER/**", "ANIMDIRECTIONTARGET/**"
  # -----------------------------------------------------------------------------------
  # "ANIMCENTERTARGET" : Allows to make the animation centralize on the targets.
  #   Affects only animations targeted on the 'Screen'
  # -----------------------------------------------------------------------------------
  # "ANIMMIRRORTARGET/**" : Invert the animation depending on the target direction
  #   ** must be true or false, based on the direction
  #     seguindo este padrão: "ANIMMIRRORTARGET/abaixo,esquerda,direita,acima"
  #    Ex.: "ANIMMIRRORTARGET/true,true,false,false"
  # -----------------------------------------------------------------------------------
  # "ANIMMIRRORCASTER/**" : Inverte a animação dependendo da direção do usuário.
  #   ** deve ser true ou false, de acordo com cada direção
  #     with the following form: "ANIMMIRRORCASTER/abaixo,esquerda,direita,acima"
  #    Ex.: "ANIMMIRRORCASTER/true,true,false,false"
  # -----------------------------------------------------------------------------------
  # "COMBO/**" : Actions with multiple repetitions
  #   ** must be equal the number of hits, for random hits add an min value and
  #      after the max value, separated by "-".
  #   Ex.: "COMBO/5" Combo with 5 hits
  #        "COMBO/3-7" Combo with 3 to 7 hits.
  # -----------------------------------------------------------------------------------
  # "HITS/**" :  Actions with multiple hits.
  #   ** must be equal the number of hits, for random hits add an min value and
  #      after the max value, separated by "-".(like the Combo)
  # -----------------------------------------------------------------------------------
  # "HITSANIMATION" : Repeat battle animation (but not battler pose animation)
  #   for each hit using the setting "HITS/**"
  # -----------------------------------------------------------------------------------
  # "SEQUENCE/**" : Skill sequences.
  #   ** must be equal the IDs that makes part of the sequence, separated by ",".
  #   Ex.: "SEQUENCE/57,58,59" The skills ID 57,58 and 59 will be used after the
  #    action with that effect.
  #   Obs.: Even for actors, enemies, weapons or items, the subsquent acions after
  #    the first will be *always* skills.
  # -----------------------------------------------------------------------------------
  # "ANIME/**" : Action with pose different from the default. You can add
  #   more than one value to make the pose random. Leave 0 for no pose change
  #   ** must be equal the Poses ID, separated by comas.
  #   Ex.: "ANIME/0"
  #        "ANIME/12"
  #        "ANIME/12,13,14"
  # -----------------------------------------------------------------------------------
  # "ADVJUMP/**" : Action with jump during advance movement.
  #   ** must the the jump height modifier. Default 100
  # -----------------------------------------------------------------------------------
  # "RETJUMP/**" : Action with jump during return movement.
  #   ** must the the jump height modifier. Default 100
  # -----------------------------------------------------------------------------------
  # "ADVPOSE/**" : Action with different pose during advance movement.
  #   ** must be equal the Pose ID.
  # -----------------------------------------------------------------------------------
  # "RETPOSE/**" : Action with different pose during return movement.
  #   ** must be equal the Pose ID.
  # -----------------------------------------------------------------------------------
  # "JUMP/**" : Action with jump animation
  #   ** must the the jump height.
  # -----------------------------------------------------------------------------------
  # "JUMPSPEED/**" : Velocidade do salto.
  #   ** must be the jump speed, default is 100. If the value is higher than 100
  #   the speed is increased, if it's bellow 100, it's lower
  # -----------------------------------------------------------------------------------
  # "LIFT/**" :  Action with jump animation, stops when reach the top (and stay floating).
  #   ** ust the the jump height.
  #   The battler will left this position if the next actions have the effect
  #   "FALL", or at the action end
  # -----------------------------------------------------------------------------------
  # "FALL" : Cancels the "LIFT/**" effect.
  # -----------------------------------------------------------------------------------
  # "HEAVYFALL/**" : Cancels the "LIFT/**" effect with an uniform fall
  #   ** Must be the fall speed.
  # -----------------------------------------------------------------------------------
  # "DMGIMPACT/**" :  Set impact movement when recive damage
  #   The target is pushed.
  #     ** must be expressed with the following form: DIRECTION, DISTANCE, EXTRA_X, EXTRA_Y
  #       DIREÇÃO : numeric value that set de direction that the target will be pushed
  #         0 = direction aligned with battler current position
  #         1 = same direction as battler
  #         2 = opposite direction as battler
  #       DISTÂNCIA: distance that the target is pushed
  #       EXTRA_X: Extra X push psition
  #       EXTRA_Y: Extra Y push psition
  #   Ex.: DMGIMPACT/1,50,0,0
  # -----------------------------------------------------------------------------------
  # "DMGBOUNCE/**" :  Set impact movement when recive damage.
  #   The target is lauched up and falls afterwards.
  #     ** numeric value, the distance that the target is launched
  #     recomended values between 1 and 200, above this the target may be launched off screen
  # -----------------------------------------------------------------------------------
  # "DMGRISE/**" :  Set impact movement when recive damage.
  #   The target is lauched up and stops when reach the top (and stay floating)
  #   The battler will left this position if the next actions have the effect
  #   "DMGSMASH" or "DMGRELASE" or at the action end
  #     ** numeric value, the distance that the target is launched
  #     recomended values between 1 and 200, above this the target may be launched off screen
  # -----------------------------------------------------------------------------------
  # "DMGSHAKE/**" : Set impact movement when recive damage.
  #   The target shakes when damaged
  #     ** shake effect duration
  # -----------------------------------------------------------------------------------
  # "DMGWAIT/**" : Set impact movement when recive damage.
  #   The target stay frozen on the position he was when recived the damage
  #   for an set time.
  #   The battler will left this position if the wait time end, if next actions
  #   have the effect "DMGRELASE" or at the action end
  # -----------------------------------------------------------------------------------
  # "DMGSMASH" : Set impact movement when recive damage.
  #   The target is lauchend down, effective only if the target is rised up
  # -----------------------------------------------------------------------------------
  # "DMGFREEZE" : Set impact movement when recive damage.
  #   The target stay frozen on the position he was when recived the damage
  #   The battler will left this position if the next actions have the effect
  #   "DMGRELASE" or at the action end
  # -----------------------------------------------------------------------------------
  # "DMGRELASE" : Set impact movement when recive damage.
  #   Cance the effects of "DMGRISE/**" or "DMGFREEZE"
  # -----------------------------------------------------------------------------------
  # "IMPACTDELAY/**": Wait time between the battle animation and the pose change
  #   ** must be the time in frames.
  #   By default it's ist's varies according to the battle animation duration.
  # -----------------------------------------------------------------------------------
  # "DAMAGEDELAY/**": Wait time between the damage pose change and the damage pop up
  #   ** must be the time in frames.
  #   By default it's ist's varies according to the pose duration.
  # -----------------------------------------------------------------------------------
  # "DMGANIMTIME/**": Duration of the Damage pose.
  #   ** must be the time in frames.
  # -----------------------------------------------------------------------------------
  # "TIMEBEFOREANIM/**" : Wait time between the action pose and the animation show
  #   ** must be the time in frames.
  #   By default it's ist's varies according to the pose duration.
  # -----------------------------------------------------------------------------------
  # "TIMEAFTERANIM/**" : Wait time after the battle animation.
  #   ** must be the time in frames.
  #   By default it's ist's varies according to the animation duration.
  # -----------------------------------------------------------------------------------
  # "MIRAGEADVANCE/**" : Add mirage effect for the advance movement
  #   you can set and different color for the images.
  #   ** can be the value of RGB and Alpha. RED, GREEN, BLUE, ALPHA
  #      or nil for no color.
  #      (ALPHA is the opacity level of the color on the sprite)
  #   Ex. "MIRAGEADVANCE/255,64,0,160"
  # -----------------------------------------------------------------------------------
  # "MIRAGERETURN/**" : Add mirage effect for the return movement
  #   you can set and different color for the images.
  #   ** can be the value of RGB and Alpha. RED, GREEN, BLUE, ALPHA
  #      or nil for no color.
  #      (ALPHA is the opacity level of the color on the sprite)
  #   Ex. "MIRAGERETURN//255,64,0"
  # -----------------------------------------------------------------------------------
  # "MIRAGEACTION/**" : Add mirage effect for the action animation.
  #   you can set and different color for the images.
  #   ** can be the value of RGB and Alpha. RED, GREEN, BLUE, ALPHA
  #      or nil for no color.
  #   Ex. "MIRAGEACTION/255,64,0"
  # -----------------------------------------------------------------------------------
  # "ACTIONPLANE/**": Adds an Plane image (wich loops) during actions.
  #   ** must be expressed with the following form: TYPE, FILENAME, OPACITY, MOV_X, MOV_Y
  #    TYPE = Exhibition type.
  #      - ABOVE: Image is shown above battlers
  #      - BELLOW: Image is shown bellow battlers
  #    FILENAME = Graphic file name, must be on the Pictures folder.
  #    OPACITY = Image opacity, Numeric value from 0 to 255.
  #    MOV_X = Numeric value, X axis movement speed, can be omited.
  #    MOV_Y = Numeric value, Y axis movement speed, can be omited. (only if MOV_X was
  #       also omited)
  #   Ex.: "ACTIONPLANE/ABOVE,black_tone,160"
  #        "ACTIONPLANE/BELLOW,wave_image,255,20"
  # -----------------------------------------------------------------------------------
  # "STARTTHROW/**" : Add throw animation for the action
  #   This is one of the most complex configuration of the advanced settings.
  #   Be very careful to avoid erros.
  #   ** must be written this way: 
  #     SOUND, CURVE, DOWN, LEFT, RIGHT, UP, SPEED, X1, Y1, X2, Y2
  #    (the values must be separated by coma.
  #     SOUND = Name of the sound file used on the throw start. leave nil for no sound.
  #     CURVE = Curve angle for the throw. Numeric value, can be decimal.
  #       Default Value for straight throws = 0.
  #       Default Value for angled throws = 10.
  #     DOWN = Animation ID when the battler is facing down
  #     LEFT = Animation ID when the battler is facing left
  #     RIGHT = Animation ID when the battler is facing up
  #     UP = Animation ID when the battler is facing up
  #     SPEED = Objetc speed. Numeric value. Default 300.
  #     X1 = Start X position of the throw. Numeric value. Default 0.
  #     Y1 = Start Y position of the throw. Numeric value. Default 0.
  #     X1 = End Y position of the throw. Numeric value. Default 0.
  #     X2 = End Y position of the throw. Numeric value. Default 0.
  #   Ex.: "STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0"
  #        "STARTTHROW/nil,10,126,126,126,126,200,0,-20,0,0"
  # -----------------------------------------------------------------------------------
  # "ENDTHROW/**" :  Add throw return animation for the action
  #   This is one of the most complex configuration of the advanced settings.
  #   Be very careful to avoid erros.
  #   ** must be written this way: 
  #     SOUND, CURVE, DOWN, LEFT, RIGHT, UP, SPEED, X1, Y1, X2, Y2
  #    (the values must be separated by comma.
  #     SOUND = Name of the sound file used on the throw start. leave nil for no sound.
  #     CURVE = Curve angle for the throw. Numeric value, can be decimal.
  #       Default Value for straight throws = 0.
  #       Default Value for angled throws = 10.
  #     DOWN = Animation ID when the battler is facing down
  #     LEFT = Animation ID when the battler is facing left
  #     RIGHT = Animation ID when the battler is facing up
  #     UP = Animation ID when the battler is facing up
  #     SPEED = Objetc speed. Numeric value. Default 300.
  #     X1 = Start X position of the throw. Numeric value. Default 0.
  #     Y1 = Start Y position of the throw. Numeric value. Default 0.
  #     X1 = End Y position of the throw. Numeric value. Default 0.
  #     X2 = End Y position of the throw. Numeric value. Default 0.
  #   Ex.: "ENDTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0"
  #        "ENDTHROW/nil,10,126,126,126,126,200,0,-20,0,0"
  # -----------------------------------------------------------------------------------
  # "THROWWEAPONIGNORE" : Action Ignores an setting of "STARTTHROWWEAPON/**" and
  #     "ENDTHROWWEAPON/**"
  #=============================================================================

  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ACTORS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Actor_Settings[ID] = [Effects]
  #  ID = Actor ID
  #  Effects = Special Effects, look the list on the begin to know wich effects are
  #    avaliable for actors.
  
  Actor_Settings[1] = ["NOCOLLAPSE"]
  Actor_Settings[2] = ["NOCOLLAPSE", "JUMP/200"]
  Actor_Settings[3] = ["NOCOLLAPSE"]
  Actor_Settings[4] = ["NOCOLLAPSE"]
  Actor_Settings[5] = ["NOCOLLAPSE"]
  Actor_Settings[6] = ["NOCOLLAPSE"]
  Actor_Settings[7] = ["NOCOLLAPSE"]
  Actor_Settings[8] = ["NOCOLLAPSE"]
  Actor_Settings[9] = ["NOCOLLAPSE"]
  Actor_Settings[10] = ["NOCOLLAPSE"]
  Actor_Settings[11] = ["NOCOLLAPSE"]
  Actor_Settings[12] = ["NOCOLLAPSE"]
  
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ENEMIES SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Enemy_Settings[ID] = [Effects]
  #  ID = Enemy ID
  #  Effects = Special Effects, look the list on the begin to know wich effects are
  #    avaliable for enemies.
  
  Enemy_Settings[1] = ["COLLAPSE/0"]
  Enemy_Settings[2] = ["COLLAPSE/0"]
  Enemy_Settings[3] =["ENEMYINTRO"]
  #Enemy_Settings[4] = ["VICTORYPOSE","ENEMYINTRO","COLLAPSE/1"]
  Enemy_Settings[11] = ["VICTORYPOSE","COLLAPSE/2"]

  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SKILLS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Skill_Settings[ID] = [Effects]
  #  ID = Skill ID
  #  Effects = Special Effects, look the list on the begin to know wich effects are
  #    avaliable for skills.
  
  Skill_Settings[1] = ["MOVETYPE/STEPFOWARD","TARGETSWITCH"] #null skill
  Skill_Settings[2] = ["MOVETYPE/NOMOVE","TARGETSWITCH","ANIMMIRRORCASTER/false, true, false, false"] 
  #single shot
  Skill_Settings[3] = ["MOVETYPE/NOMOVE","TARGETSWITCH","ANIMMIRRORCASTER/false, true, false, false", "COMBO/5"] 
  #5-in-1 shot
  Skill_Settings[4] = ["MOVETYPE/STEPFOWARD","ANIME/7"]
  #gunblitz
  Skill_Settings[5] = ["ANIME/7","MOVETYPE/MOVETOTARGET","ADVJUMP/50", "DMGSHAKE/5", "MIRAGEADVANCE/nil"]
  #lethal strike
  Skill_Settings[6] = ["MOVETYPE/NOMOVE","TARGETSWITCH","ANIMMIRRORCASTER/false, true, false, false","COMBO/1-5"] 
  #5 shot
  Skill_Settings[7] = ["MOVEPOSITION/50,0,150,0,300","MIRAGEADVANCE/nil","MIRAGEACTION/nil","TARGETSWITCH"]
  #test
  
  Skill_Settings[9] = ["STEAL/ITEM"]
  Skill_Settings[10] = ["STEAL/GOLD"]
  
  Skill_Settings[53] = ["MOVETYPE/STEPFOWARD"]
  Skill_Settings[54] = ["MOVETYPE/STEPFOWARD"]
  Skill_Settings[55] = ["MOVETYPE/STEPFOWARD"]
  Skill_Settings[56] = ["MOVETYPE/STEPFOWARD"]
  Skill_Settings[68] = ["TIMEAFTERANIM/40"]
  
  Skill_Settings[73] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                        "MOVETYPE/NOMOVE","ANIME/13"]
  Skill_Settings[74] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                        "MOVETYPE/NOMOVE","ANIME/13"]
  Skill_Settings[75] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                        "MOVETYPE/NOMOVE","ANIME/13"]
  Skill_Settings[76] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                        "MOVETYPE/NOMOVE","ANIME/13"]
  Skill_Settings[77] = ["MOVETYPE/NOMOVE"]
  Skill_Settings[78] = ["MOVETYPE/NOMOVE"]
  Skill_Settings[79] = ["MOVETYPE/NOMOVE"]
  Skill_Settings[80] = ["MOVETYPE/NOMOVE"]

  Skill_Settings[82] = ["STEAL/BOTH","MOVETYPE/MOVETOTARGET"]
  Skill_Settings[92] = ["HITS/5"]
  Skill_Settings[93] = ["COMBO/2-4"]
  Skill_Settings[94] = ["FAST"]
  Skill_Settings[95] = ["SLOW"]
  Skill_Settings[96] = ["RANDOM"]
  Skill_Settings[97] = ["INCLUDEUSER"]
  Skill_Settings[98] = ["MOVETYPE/SCREENCENTER","EXCLUDEUSER","TARGET/ALLBATTLERS"]
  Skill_Settings[99] = ["HIDE/BATTLER","MOVETYPE/NOMOVE"]
  
  Skill_Settings[110] = ["ACTIONPLANE/BELLOW,dark_tone,120,","SEQUENCE/111,112,113,114,115"]
  Skill_Settings[111] = ["ACTIONPLANE/BELLOW,dark_tone,120,","ANIME/13"]
  Skill_Settings[112] = ["ACTIONPLANE/BELLOW,dark_tone,120,","ANIME/14"]
  Skill_Settings[113] = ["ACTIONPLANE/BELLOW,dark_tone,120,","ANIME/15"]
  Skill_Settings[114] = ["ACTIONPLANE/BELLOW,dark_tone,120,","ANIME/16"]
  Skill_Settings[115] = ["ACTIONPLANE/BELLOW,dark_tone,120,","ANIME/17"]
  
  Skill_Settings[126] = ["MOVEPOSITION/40,0,100,0,250","SEQUENCE/127,128","ANIME/12", 
                         "MIRAGEACTION/255,255,0,160", "MIRAGEADVANCE/255,255,0,160",
                         "DMGSHAKE/10"]
  Skill_Settings[127] = ["DMGBOUNCE/140","ANIME/13","MIRAGEACTION/255,255,0,160",
                         "TIMEAFTERANIM/10","DAMAGEDELAY/0","HELPHIDE"]
  Skill_Settings[128] = ["JUMP/120","ANIME/14","DMGSHAKE/15","MIRAGEACTION/255,255,0,160",
                         "TIMEBEFOREANIM/0","IMPACTDELAY/0","DAMAGEDELAY/0","DMGWAIT/15",
                         "HELPHIDE"]
  Skill_Settings[146] = ["MOVEPOSITION/0,0,80,0,300","COMBO/15","ANIME/17","TIMEBEFOREANIM/0",
                         "TIMEAFTERANIM/0","IMPACTDELAY/0","DAMAGEDELAY/0"]
  Skill_Settings[147] = ["MOVETYPE/NOMOVE","ANIME/12","NODAMAGE","SEQUENCE/148,149,150"]
  Skill_Settings[148] = ["MOVETYPE/NOMOVE","ANIME/0","NODAMAGE","HELPHIDE"]
  Skill_Settings[149] = ["MOVETYPE/NOMOVE","ANIME/0","TIMEAFTERANIM/6",
                         "IMPACTDELAY/0","DAMAGEDELAY/0","NODAMAGE","HELPHIDE"]
  Skill_Settings[150] = ["MOVETYPE/NOMOVE","ANIME/0","TIMEAFTERANIM/0",
                         "IMPACTDELAY/0","DAMAGEDELAY/0","HITS/6","HELPHIDE"]
                         
  Skill_Settings[151] = ["RANDOM","TIMEAFTERANIM/0","IMPACTDELAY/0",
                         "SEQUENCE/152,153,154,152,154,153,152,154,153,154,152,153,152,155,156,157"]
  Skill_Settings[152] = ["HELPHIDE","RANDOM","ANIME/12","TELEPORTTOTARGET","MOVEINCOMBO",
                         "TIMEAFTERANIM/0","IMPACTDELAY/0"]
  Skill_Settings[153] = ["HELPHIDE","RANDOM","TELEPORTTOTARGET","MOVEINCOMBO",
                         "TIMEAFTERANIM/0","IMPACTDELAY/0"]
  Skill_Settings[154] = ["HELPHIDE","RANDOM","ANIME/13","TELEPORTTOTARGET","MOVEINCOMBO",
                         "TIMEAFTERANIM/0","IMPACTDELAY/0"]
  Skill_Settings[155] = ["HELPHIDE","MOVEINCOMBO","NODAMAGE","NOANIMATION","MOVETYPE/MOVETOTARGET",
                         "MOVEPOSITION/40,0,0,0,150","TIMEBEFOREANIM/0","TIMEAFTERANIM/0"]
  Skill_Settings[156] = ["HELPHIDE","NODAMAGE","ANIME/0"]
  Skill_Settings[157] = ["HELPHIDE","MOVEPOSITION/0,0,100,0,200"]
              
  Skill_Settings[158] = ["RANDOM","HITS/1-5","HITSANIMATION","CLEARRANDOM","TIMEAFTERANIM/0"]
  
                         
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # WEAPONSS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Weapon_Settings[ID] = [Effects]
  #  ID = Weapon ID
  #  Effects = Special Effects, look the list on the begin to know wich effects are
  #    avaliable for weapons.
  
  Weapon_Settings[1] = [] #Aged Axegun
  Weapon_Settings[2] = [] #Cutlass
  Weapon_Settings[3] = ["ADVJUMP/90"] #Bare Fists
  Weapon_Settings[4] = [] #Rapier
  Weapon_Settings[5] = [] #BETA STICK
  Weapon_Settings[6] = ["HITS/69"] #Knife
  Weapon_Settings[7] = [] #Basic Axe
  Weapon_Settings[8] = [] #Antlers
  Weapon_Settings[9] = [] #Pistol
  Weapon_Settings[10] = []#Rifle
  Weapon_Settings[11] = []#Basic Staff
  Weapon_Settings[12] = []#Simple Mace
  Weapon_Settings[13] = []#Tamer's Whip
  Weapon_Settings[14] = []#Claws
  Weapon_Settings[15] = ["COMBO/69"] #Knives
  Weapon_Settings[16] = ["DMGVARIANCE/0"]
  Weapon_Settings[17] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                         "MOVETYPE/NOMOVE"]
  Weapon_Settings[18] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                         "MOVETYPE/NOMOVE"]
  Weapon_Settings[19] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                         "MOVETYPE/NOMOVE"]
  Weapon_Settings[20] = ["STARTTHROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0",
                         "MOVETYPE/NOMOVE"]
  Weapon_Settings[21] = ["MOVETYPE/STEPFOWARD"]
  Weapon_Settings[22] = ["MOVETYPE/STEPFOWARD"]
  Weapon_Settings[23] = ["MOVETYPE/STEPFOWARD"]
  Weapon_Settings[24] = ["MOVETYPE/STEPFOWARD"]
  
  Weapon_Settings[36] = ["MOVETYPE/NOMOVE"]
  Weapon_Settings[37] = ["MOVETYPE/NOMOVE","TARGET/ALLENEMIES",
                         "THROW/101-Attack13,0,122,123,124,125,300,-20,0,0,0"]
  
  Weapon_Settings[42] = ["MOVETYPE/NOMOVE"]
  
  Weapon_Settings[69] = ["STARTTHROWWEAPON/nil,10,11,11,11,11,200,0,-20,0,0",
                         "ENDTHROWWEAPON/nil,10,11,11,11,11,200,0,-20,0,0",
                         "MOVETYPE/NOMOVE","TARGET/ALLENEMIES","DMGVARIANCE/0"]
  
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # ITEMS SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Item_Settings[ID] = [Effects]
  #  ID = Item ID
  #  Effects = Special Effects, look the list bellow to know wich effects are
  #    avaliable for items.
  
  Item_Settings[1] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[2] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[3] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[4] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[5] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[6] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[7] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[8] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[9] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[10] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[11] = ["MOVETYPE/STEPFOWARD"]
  Item_Settings[12] = ["MOVETYPE/STEPFOWARD"]
  
  Item_Settings[30] = ["MOVETYPE/NOMOVE"]
  
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SOUND EFFECTS/BATTLE CRY SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Here you can configure the sound effects of actors and enemies.
  # The configuration form is very simillar to the other settings.
  #
  # Configuration of Sound effects based on battler poses:
  # Useful for sound effects syncronized with poses 
  #(setep sound, weapon swing and even voices)
  # This one is file based, so all battlers with the same graphic will 
  #have this sounds.
  # Pose_Battle_Cry['File Name'] = {POSE => {FRAME => Settings}}
  #
  # Settings for actors sound effects
  # Actor_Battle_Cry[Actor ID] = {'EFFECT' => Settings}
  #
  # Settings for enemies sound effects
  # Enemy_Battle_Cry[ID do Inimigo] = {'EFFECT' => Settings}
  #
  # Então deverá adicionar os atributos. Porém, a condiguração dos atributos é
  # mais complexa
    
  Pose_Battle_Cry['Leon'] = {7 => {2 => ['ouu',100,100]}, 
   5 => {1 => ['ouu',80,100], 3 => ['ouu',80,100]}, 
   6 => {1 => ['ouu',80,100], 3 => ['ouu',80,100]},}
  
   #how the heck do I get boing noises when jeremiah jumps
  #Pose_Battle_Cry['jeremiahbattlex2'] = 
  #{4 => {2 => ['boingthing', 100, 100]}},
  #{5 => {2 => ['boingthing', 100, 100]}}
     
  Actor_Battle_Cry[1] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[2] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[3] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[4] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[5] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[6] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[7] = {'COLLAPSE' => [['ouu',100,100]]}
  Actor_Battle_Cry[8] = {'COLLAPSE' => [['ouu',100,100]]}
   
  Enemy_Battle_Cry[1] = {'COLLAPSE' => [['ouu',100,100]]}
  Enemy_Battle_Cry[2] = {'COLLAPSE' => [['ouu',100,100]]}
  Enemy_Battle_Cry[3] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[5] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[6] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[7] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[8] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[9] = {'COLLAPSE' => [['ouu',80,100]]}
  Enemy_Battle_Cry[10] = {'COLLAPSE' => [['ouu',80,100]]}
  
  # LIST OF COMMANDS FOR SOUND EFFECT SETTINGS:
  #  All sound configurations follow this sintaxe:
  #    ['file name', volume, potch]
  #  You can add more than one effect, if you add, the effect will be selected randomly.
  # 
  # EFFECTS FOR POSES:
  # These sound effects are used syncronized with poses
  # They're written that way:  POSE => {FRAME => [Settings]}
  # POSE = Pose ID
  # FRAME = Frame wich the sound is played
  # Settings = ['file name', volume, pitch]
  #  Ex.:
  #  7 => {2 => ['shout01', 100, 10], 3 => ['shout02', 100, 10]}
  # On this example, during the 2nd frame from pose ID 7 the sound effect 'sound01' is used,
  #  during the 3rd frame from pose ID 7 the sound effect 'sound01' is used,
  #
  # BASIC EFFECTS:
  # These effects are used on "static" actions.
  # They're written that way: 'EFFECT' => [[Settings]]
  # In this case you must add all the sound effects on the first array.
  #  E.g.:
  #  'INTRO' => [['shout01', 100, 100],['shout02', 100, 100],['shout03', 100, 100]]
  #  The intro sound used will be 'shout01', 'shout02' or 'shout03'.
  #
  # 'INTRO' => [[Settings],[Settings]]
  #   Sound effect for battle intro.
  # -----------------------------------------------------------------------------------
  # 'DAMAGE' => [[Settings],[Settings]]
  #   Sound effect for reciving damage.
  # -----------------------------------------------------------------------------------
  # 'EVADE' => [[Settings],[Settings]]
  #   Sound effect for evade attack.
  # -----------------------------------------------------------------------------------
  # 'DEFENSE' = [[Settings],[Settings]]
  #   Sound effect for start defense.
  # -----------------------------------------------------------------------------------
  # 'COLLAPSE' => [[Settings],[Settings]]
  #   Sound effect for dying.
  # -----------------------------------------------------------------------------------
  # 'VICTORY' => [[Settings],[Settings]]
  #   Sound effect for victory.
  # -----------------------------------------------------------------------------------
  # 'ESCAPE' => [[Settings],[Settings]]
  #   Sound effect for escaping.
  #
  # ADVANCED EFFECTS:
  # These are sound effects that changes according to the base action.
  # Estes são efeitos sonoror que variam de acordo com a ação base.
  # They're written that way: 'EFFECT' => {'BASE' => [Settings], ID => [Settings]}
  # The 'BASE' value must always be added, and will be used if the action don't
  # have it's own settings.
  #  E.g.: 'SKILLUSE' => {
  #       'BASE' => [['skill shout01', 100, 100],['skill shout02', 100, 100]],
  #       1 => [['skill ID1 shout01', 100, 100],['skill ID1 shout02', 100, 100]],
  #       2 => [['skill ID2 shout01', 100, 100],['skill ID2 shout02', 100, 100]]}
  #  The skill ID 1 will have the sounds 'skill ID1 shout01' ou 'skill ID1 shout02',
  #  the skill ID 2 will have the sounds 'skill ID2 shout01' ou 'skill ID2 shout02',
  #  any other skill will have the sounds 'skill shout01' ou 'skill shout02'.
  #
  # 'SKILLCAST' => {'BASE' =>[[Settings],[Settings]], ID =>[[Settings],[Settings]]}
  #   Sound effect for skill cast.
  # 'SKILLUSE' => {'BASE' =>[[Settings],[Settings]], ID =>[[Settings],[Settings]]}
  #   Sound effect for skill use
  # 'WEAPON' => {'BASE' =>[[Settings],[Settings]], ID =>[[Settings],[Settings]]}
  #   Sound effect for weapon attack
  # 'ITEM' => {'BASE' =>[[Settings],[Settings]], ID =>[[Settings],[Settings]]}
  #   Sound effect for items.
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # SLIP DAMAGE CONFIGURAION
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Configuration of the 'slip effects' (poison and regen)
  # Slip_Pop_State[Slip_Type] = { State_ID => [Type, Constant, Rate, Dmg_Pop, Kill]} 
  #   Slip_Type = Order of damage/regen exhibition
  #     Must be equal 'Slip_1' or 'Slip_1'
  #   State_ID = ID of the state
  #   Type = 'hp' for HP effects, 'sp' for SP effects
  #   Constant = Fixed value applied.
  #     Positive values are damage, negative values are healing
  #   Rate = % value applied, based on HP/SP Max.
  #     Positive values are damage, negative values are healing
  #   Dmg_Pop = true/false. The damage/regen will pop?
  #   Kill = true/false. The effect can kill the target?.
  #
  #   There's no real difference between 'Slip_1' and 'Slip_2', since what define the
  #   damage/heal is the value configurated in 'Constant' and 'Rate'.
  #   The difference is in the order that the effect will be applied.
  #   If you create an regen and a poison of the type 'Slip_1' both will be applied
  #   at the same time.
  #
  #   E.g.: You have an poison that deals 49 damage, and an regen that heals 42 HP
  #     the value shown in the screen will be 7 (49 - 42 = 7)
  #
  #   If the effects are of different types, each value will be shown separately
  #
  Slip_Pop_State['Slip_1'] = {3 =>['hp', 0, 10, true, true], 21 =>['sp', 0, 10, true, true]}
  
  Slip_Pop_State['Slip_2'] = {22 =>['hp', 0, -10, true, true], 23 =>['sp', 0, -10, true, true]}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # MULTI DROP ITEMS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Enemy_Drops[ID] = {'ITEM' => RATE}
  #
  # ID = Enemy ID
  # ITEM = Item type and ID. Must be expressed as 'xY'
  #  where x = item type and Y = item ID
  #  x must be 'a' for armors, 'w' for weapons, 'i' for items
  #  E.g.: 'a12' = Armor ID 12
  # RATE = Item drop %. An value between 0 and 100, can be decimals
  #  E.g.: '5.4' = 5.4% drop rate
  #
  # E.g.: Enemy_Drops[15] = {'w6' => 22.5, 'a9' => 12}
  # That means enemy ID 15 (Enemy_Drops[15])
  # has 22,5% of dropping the weapon ID 6 ('w6' => 22.5)
  # and have 12% of dropping the armor ID 9 ('a9' => 12)
  # 
  # Repeated items won't be considered
  #
  #Enemy_Drops[1] = {'a1' => 15.5, 'w1' => 10, 'i2' =>  50}
  #Enemy_Drops[2] = {'i3' => 22.5, 'w2' => 0.5}
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # STEAL ITEMS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Enemy_Steal[ID] = {'ITEM' => RATE}
  #
  # ID = Enemy ID
  # ITEM = Item type and ID. Must be expressed as 'xY'
  #  where x = item type and Y = item ID
  #  x must be 'a' for armors, 'w' for weapons, 'i' for items, 'g' for money
  #  E.g.: 'a12' = Armor ID 12
  # RATE = Item drop %. An value between 0 and 100, can be decimals
  #  E.g.: '5.4' = 5.4% drop rate
  #
  # E.g.: Enemy_Drops[15] = {'w6' => 22.5, 'g900' => 12}
  # That means enemy ID 15 (Enemy_Drops[15])
  # has 22,5% of dropping the weapon ID 6 ('w6' => 22.5) when stole,
  # and have 12% of dropping 900 gold ('g900' => 12) when stole.
  # 
  # Repeated items won't be considered
  #
  Enemy_Steal[1] = {'g100' => 50, 'w1' => 50, 'a1' => 15}
  Enemy_Steal[2] = {'i1' => 22.5, 'w2' => 5}
  #=============================================================================
  
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # POSE BATTLE ANIMATION CONFIG
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # These settings allows you to show battle animations togther with the
  # battlers pose animations
  #
  # Pose_Animation[NOME] = POSE => {FRAME => [Atributos]}
  # NOME = Name of the battler graphic
  # POSE = Pose ID
  # FRAME = Frame wich the animation is played
  # Atributos = [ID, loop]
  #  ID = Animation ID
  #  loop = Looping Amimation. true ou false
  #  Ex.:
  #  Pose_Animation['Test'] = {4 => {1 => [15, true]}, 7 => {2 => [30, false]}}
  #  The battler with filename 'Test', during the 1st frame of the ID 4 pose will
  #  play the animation ID 15, it will repeat until the chages the pose. During
  #  the 2nd frame fo the ID 7 pose will play the animation ID 30 once
  
  #Pose_Animation['FrioFighter'] = {20 => {1 => [128, false]}}

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # CUSTOM GRAPHICS POSES CONFIG
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # Configuration of the poses pattern
  # You can set differen patterns for each pose.
  #
  # Pose_Sprite['Name'] = {Settings}
  # The Settings are the following.
  #  Base Setting - this is the graphic dimensions settings
  #   'Base' => [X, Y, SPD, Mirror]
  #      'Base' = this is the value that sets the base settings, don't change.
  #      X = number of horizontal frames. Numeric value higher than zero. Default 4.
  #      Y = number of vertical frames. Numeric value higher than zero. Default 11.
  #      SDP = Movement Speed. Numeric value higher than zero. Default 200.
  #      Mirror = invert graphic. true or false. Default false.
  #
  #  Pose Settings - These are the setting of each pose.
  #    Pose_ID => [Frames, Time, Loop, Speed]
  #      Pose_ID = The Pose ID. Numeric value higher than zero.
  #      Frames = Number of animation frames. Numeric value higher than zero.
  #      Time = Duration of each frame pose.Numeric value higher than zero.
  #      Loop = Animation Loop. true or false.
  #      Speed = Move Speed, Numeric Value higher than 0, Default 200.
  #        can be omited or nil. If so, the default speed (set on 'Base') is used.
  #
  #  Extra Settings - These are optional settings.
  #    Remember that if you add these settings here, *all* graphics will have these
  #    settings (except the ones you set individually on the ACBS | Config 2 - Advanced)
  #    The extra settings are "Shadow" and "Jump"
  #   
  #    'Shadow' =>['Name', X, Y]
  #      'Shadow' = this is the value that sets the shadow setting.
  #      'Name' = Name of the shadow graphic file.
  #       X = Shadow position X adjust. Numeric value.
  #       Y = Shadow position Y adjust. Numeric value.
  #     
  #    'Jump' => {Direction => Height}
  #      'Jump' = this is the value that sets the shadow setting.
  #      Direction = Here you set wich movement action will have.
  #        Can be one of the following value, or both.
  #        'Advance' the battler will jump during the advanve movement
  #        'Return' the battler will jump during the return movement
  #      Altura = jump height. Numeric Vaule. Default 10
  #     Ex.: 'Jump' =>{'Return' => 10}
  #          'Jump' =>{'Advance' => 12,'Return' => 8}
  #
  #   'Adjust' => [X, Y]
  #      'Adjust' = Value that sets an adjust for battler sprite X/Y position.
  #        Must be used if the battler is not well aligned
  #        X = X position adjust. Numeric Value
  #        Y = Y position adjust. Numeric Value
  #
  #   'ThrowStart' => {Pose =>[X, Y]}
  #      'ThrowStart' = value that set the throw start point.
  #        By default, the start point depends on the frame height.
  #        Must be used if you  have an battler with throw.
  #        If needed, you can set different start points for each pose
  #        Pose = ID of the pose that will be adjusted
  #        X = X position adjust. Numeric Value
  #        Y = Y position adjust. Numeric Value
  #    
  #   'Center' => {Pose =>[X, Y]}
  #      'Center' = Value that sets the sprite "center", used to set the target point
  #        for battle animations and throws.
  #        By default, the center is based on the frame dimensions, but don't take
  #        into consideration the position of the sprite inside the frame
  #        If the sprite is on an uncommon position compared to the center (like an
  #        fying enemy that stays above the center).
  #        Pose = ID of the pose that will be adjusted, can be equal 'Base', setting
  #          the center for all poses by default, unless the pose has it own setting.
  #
  # You don't need to add all values here, only the ones that will be changed.
  # E.g.: 
  #   The sprite with file name "Test Sprite" have 4 horizontal poses and 10 veriticals.
  #   You also want that it have jump when advancing.
  #   All the poses follow the same configuration as the default.
  #   So you just need to add the changed values, in this example "Base" and "Jump"
  #
  # Pose_Sprite['Test Sprite'] = {'Base' =>[4,10,200,false],'Jump' =>['Advance']}
  #
  Pose_Sprite['Leon'] = {'Base' =>[7,15,200,false],
    1 =>[4,10,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,1,true], 5 =>[4,4,true], 
    6 =>[4,4,true], 7 =>[5,2,false], 8 =>[6,4,false], 9 =>[2,4,false], 10 =>[5,4,false],
    11 =>[2,4,false], 12 =>[3,3,false], 13 =>[5,2,false], 14 =>[7,3,false], 15 =>[1,1,false]}

  Pose_Sprite['Leon_Poison'] = {'Base' =>[7,15,200,false],
    1 =>[4,10,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,1,true], 5 =>[4,4,true], 
    6 =>[4,4,true], 7 =>[5,2,false], 8 =>[6,4,false], 9 =>[2,4,false], 10 =>[5,4,false],
    11 =>[2,4,false], 12 =>[3,3,false], 13 =>[5,2,false], 14 =>[7,3,false], 15 =>[1,1,false]}

  Pose_Sprite['Zelos'] = {'Base' =>[9,17,200,false], 
    1 =>[4,8,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[6,4,true], 
    6 =>[6,4,true], 7 =>[5,2,false], 8 =>[7,4,false], 9 =>[1,4,true], 10 =>[9,6,false],
    11 =>[1,4,true], 12 =>[6,3,false], 13 =>[4,2,false], 14 =>[6,2,false], 15 =>[5,2,false],
    16 =>[5,2,false], 17 =>[1,2,false]}

  Pose_Sprite['Chester'] = {'Base' =>[7,14,200,false], 
    1 =>[4,12,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[6,4,false], 8 =>[1,4,true], 9 =>[1,4,true], 10 =>[5,4,false],
    11 =>[1,4,true], 12 =>[6,4,false], 13 =>[7,4,false], 14 =>[6,4,false],
    'ThrowStart' =>{7 =>[10, 14], 13 =>[10, 20], 14 =>[10, 20]}}

  Pose_Sprite['Klarth'] = {'Base' =>[6,11,200,false],
    1 =>[4,16,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true], 
    6 =>[4,4,true], 7 =>[5,3,false], 8 =>[6,4,false], 9 =>[1,4,true], 10 =>[5,8,false],
    11 =>[1,4,true]}
    
  Pose_Sprite['Chelsea'] = {'Base' =>[7,13,200,false],
    1 =>[4,12,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true], 
    6 =>[4,4,true], 7 =>[5,3,false], 8 =>[1,12,false], 9 =>[1,4,true], 10 =>[5,6,true],
    11 =>[1,4,true], 12 =>[5,3,false], 13 =>[7,3,false],
    'ThrowStart' =>{7 =>[-10, 0], 13 =>[-10, 0]}}

  Pose_Sprite['Thanatos'] = {'Base' =>[6,13,200,false], 
    1 =>[6,8,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[4,2,false], 8 =>[3,4,false], 9 =>[1,4,true], 10 =>[4,4,false],
    11 =>[1,4,true], 12 =>[5,4,false], 13 =>[6,4,false], 'Shadow' =>['Shadow00', 0, 0],
    'Jump' =>{'Advance' => 10,'Return' => 10}}

  Pose_Sprite['Ghost 1'] = {'Base' =>[7,11,200,false],
    1 =>[4,8,true], 2 =>[1,4,true], 3 =>[4,12,true], 4  =>[1,4,true], 5 =>[3,4,true],
    6 =>[3,4,true], 7 =>[7,2,false], 8 =>[2,4,false], 9 =>[3,6,true], 10 =>[4,4,false],
    11 =>[5,4,false]}

  Pose_Sprite['Slime 1'] = {'Base' =>[6,11,200,false], 
    1 =>[4,8,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[6,3,false], 8 =>[2,4,false], 9 =>[3,4,false], 10 =>[4,4,false],
    11 =>[1,4,true]}

  Pose_Sprite['Shadow Servant 1'] = {'Base' =>[6,11,200,false],
    1 =>[6,8,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[1,4,true],
    6 =>[1,4,true], 7 =>[5,2,false], 8 =>[4,2,false], 9 =>[1,4,true], 10 =>[1,4,true],
    11 =>[1,4,true]}
 
  Pose_Sprite['%Wenia'] = {'Base' =>[5,13,200,false],
    1 =>[3,8,true], 2 =>[2,4,false], 3 =>[2,12,true], 4 =>[1,4,true], 5 =>[5,4,true],
    6 =>[5,4,true], 7 =>[5,2,false], 8 =>[5,4,false], 9 =>[1,4,true], 10 =>[1,4,true],
    11 =>[1,4,true], 12 =>[5,4,false], 13 =>[1,4,true]}

  Pose_Sprite['%Soldier'] = {'Base' =>[4,12,200,false],
    1 =>[4,10,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[4,2,false], 8 =>[3,4,false], 9 =>[1,4,true], 10 =>[3,6,true],
    11 =>[1,4,true], 12 =>[1,4,true]}

  Pose_Sprite['Lloyd'] = {'Base' =>[10,15,200,false], 'Adjust' => [0,6],
    1 =>[6,6,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[6,4,true],
    6 =>[6,4,true], 7 =>[7,2,false], 8 =>[1,4,true], 9 =>[2,4,false], 10 =>[10,4,false],
    11 =>[1,4,true], 12 =>[6,2,false], 13 =>[5,2,false], 14 =>[7,2,false], 15 =>[7,2,false]}

  Pose_Sprite['Nanaly'] = {'Base' =>[10,13,200,false],
    1 =>[3,12,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[6,4,true],
    6 =>[6,4,true], 7 =>[7,2,false], 8 =>[6,4,false], 9 =>[1,4,true], 10 =>[6,4,false],
    11 =>[1,4,true], 12 =>[7,2,false], 13 =>[10,2,false]}

  Pose_Sprite['Arche Klaine'] = {'Base' =>[6,11,200,false],
    1 =>[4,10,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,6,true],
    6 =>[4,6,true], 7 =>[6,3,false], 8 =>[5,6,false], 9 =>[1,4,true], 10 =>[3,6,false],
    11 =>[1,4,true]}

  Pose_Sprite['Max'] = {'Base' =>[10,14,200,false],
    1 =>[4,10,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,6,true],
    6 =>[4,6,true], 7 =>[4,3,false], 8 =>[8,4,false], 9 =>[1,4,true], 10 =>[8,6,false],
    11 =>[1,4,true], 12 =>[5,3,true], 13 =>[4,3,false], 14 =>[10,4,false]}

  Pose_Sprite['FrioFighter'] = {'Base' =>[5,21,200,false],
    1 =>[4,12,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[4,2,false], 8 =>[4,6,false], 9 =>[1,4,false], 10 =>[3,4,false],
    11 =>[1,4,true], 12 =>[4,2,false], 13 =>[2,3,false], 14 =>[2,3,false], 15 =>[5,2,false],
    16 =>[1,2,false], 17 =>[1,2,false], 18 =>[5,3,false], 19 =>[3,2,false], 20 =>[1,10,false],
    21 =>[2,3,false], 'Focus' => 20}

  Pose_Sprite['Celsius'] = {'Base' =>[7,17,200,false],
    1 =>[4,12,true], 2 =>[1,4,true], 3 =>[1,4,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[7,2,false], 8 =>[2,6,false], 9 =>[5,4,false], 10 =>[1,4,true],
    11 =>[1,4,true], 12 =>[6,4,true], 13 =>[4,2,false], 14 =>[4,2,false], 15 =>[5,2,false],
    16 =>[3,2,false], 17 =>[6,2,false]}
  
  Pose_Sprite['Crono'] = {'Base' =>[4,11,200,false], 
    1 =>[4,6,true], 2 =>[1,4,true], 3 =>[2,14,true], 4 =>[1,4,true], 5 =>[1,4,true],
    6 =>[1,4,true], 7 =>[4,3,false], 8 =>[2,6,false], 9 =>[4,4,false], 10 =>[2,16,true],
    11 =>[1,4,true], 'Escape' => 1, 'Jump' =>{'Advance' => 10}, 'Adjust' => [0,8],
    'Shadow' => ['',0,0]}
  
  Pose_Sprite['Frog'] = {'Base' =>[5,11,200,false], 
    1 =>[2,10,true], 2 =>[1,4,true], 3 =>[1,14,true], 4 =>[1,4,true], 5 =>[1,4,true],
    6 =>[1,4,true], 7 =>[3,3,false], 8 =>[5,4,false], 9 =>[4,4,false], 10 =>[2,16,true],
    11 =>[1,4,true], 'Escape' => 1, 'Jump' =>{'Advance' => 10}, 'Adjust' => [0,36],
    'Shadow' => ['',0,0]}

  Pose_Sprite['Lucca'] = {'Base' =>[3,11,200,false],
    1 =>[2,14,true], 2 =>[1,4,true], 3 =>[2,14,true], 4 =>[1,4,true], 5 =>[1,4,true],
    6 =>[1,4,true], 7 =>[3,3,false], 8 =>[2,6,false], 9 =>[2,4,false], 10 =>[2,16,true],
    11 =>[1,4,true], 'Escape' => 1, 'Adjust' => [0,12],'Shadow' => ['',0,0]}
  
  Pose_Sprite['Magus'] = {'Base' =>[8,11,200,false], 
    'Adjust' => [0,12], 1 =>[3,10,true], 2 =>[1,4,true], 3 =>[5,14,true], 4 =>[1,4,true],
    5 =>[1,4,true], 6 =>[1,4,true], 7 =>[3,3,false], 8 =>[8,6,false], 9 =>[2,4,false],
    10 =>[2,16,true], 11 =>[1,4,true], 'Jump' =>{'Advance' => 10,'Return' => 10},
    'Shadow' => ['',0,0]}
  
  Pose_Sprite['Yakra'] = {'Base' =>[6,11,200,false],  'Adjust' => [0,12],
    1 =>[1,6,true], 2 =>[1,4,true], 3 =>[1,14,true], 4 =>[1,4,true], 5 =>[3,4,true],
    6 =>[3,4,true], 7 =>[2,3,false], 8 =>[8,6,false], 9 =>[2,4,false], 10 =>[2,16,true],
    11 =>[1,4,true], 'Shadow' => ['',0,0]}
  
  Pose_Sprite['Imp'] = {'Base' =>[4,11,200,false], 'Adjust' => [0,12],
    1 =>[3,6,true], 2 =>[1,4,true], 3 =>[4,14,true], 4 =>[1,4,true], 5 =>[4,4,true],
    6 =>[4,4,true], 7 =>[3,3,false], 8 =>[3,6,false], 9 =>[3,4,false], 10 =>[3,16,true],
    11 =>[1,4,true],'Shadow' => ['',0,0]}
     
  Pose_Sprite['Adel'] = {'Jump' =>{'Advance' => 10,'Return' => 10},
    'Shadow' =>['Shadow00', 0, 0]}

  Pose_Sprite['Ziegfred_btl'] = {'Magic' => 9, 'Item' => 9, 'Skill' => 8}
  
  # If a battler have some different pattern from the default you can configure
  # them individually.
  #  E.g.: you set "Defense_Pose = 4", so the defense pose will be the fourth.
  #    But you have a graphic that the defense pose is the seventh.
  #    If you don't want to edit the graphic you can add to the battler setting 
  #    this Setting: 'Defense' => 7
  #    That way, for that battler, the defense pose will be the seventh
  #
  #   'Idle' = Wait pose (Recomended never change, because it can cause funtion losses)
  #   'Hurt' = Pose when Taking Damage(Recomended never change, because it can cause funtion losses)
  #   'Danger' = Idle pose when HP is low
  #   'Defense' = Idle pose when guarding
  #   'Advance' = Moving foward
  #   'Return' = Return move pose
  #   'Attack' = Pose when attacking
  #   'Skill' = Pose when using Physical Skills
  #   'Magic' = Pose when using Magical Skills
  #   'Item' = Pose when using Items
  #   'Dead' = Dead Idle pose
  #   'Intro' = Pose used in the begin of battle
  #   'Victory' = Battle Victory pose
  #   'Evade' = Pose when evade an attack
  #   'Escape' = Pose when escaping from battle
  #   'Critical' = Pose for Critical Attacks
  #   'Advance_Start' = Pose for advance start
  #   'Advance_End' = Pose for advance end
  #   'Return_Start' = Pose for return start
  #   'Return_End' =Pose for return end
  #   'Magic_Cast' = Pose for Magic Skill Cast
  #   'Physical_Cast' = Pose for Physical Skill Cast
  #   'Item_Cast' = Pose for Item Use Cast
  #=============================================================================

  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  # END OF SETTINGS
  #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
end