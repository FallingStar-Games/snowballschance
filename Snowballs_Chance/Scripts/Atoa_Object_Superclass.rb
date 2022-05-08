#==============================================================================
# ** Object
#------------------------------------------------------------------------------
# Superclass of all other classes.
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * Include Settings Module
  #--------------------------------------------------------------------------
  include Atoa
  #--------------------------------------------------------------------------
  # * Check included extension
  #     obj       : object that will have the extension checked
  #     extension : extension checked
  #--------------------------------------------------------------------------
  def check_include(obj, extension)
    return false if obj.nil?
    type = obj.type_name
    id = obj.id
    settings = eval("#{type}_Settings[#{id}]")
    if settings != nil
      for ext in settings
        return true if ext.include?(extension)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Check extension value
  #     obj       : object that will have the extension checked
  #     extension : extension checked
  #--------------------------------------------------------------------------
  def check_extension(obj, extension)
    return nil if obj.nil?
    type = obj.type_name
    id = obj.id
    settings = eval("#{type}_Settings[#{id}]")
    if settings != nil
      for ext in settings
        return ext.dup if ext.include?(extension)
      end
    end
    return nil
  end  
  #--------------------------------------------------------------------------
  # * Basic Battlecry play
  #     battler : battler that will play the sound effect
  #     type    : type of the sound effect
  #--------------------------------------------------------------------------
  def battle_cry_basic(battler, type)
    bc = battler.actor? ? Actor_Battle_Cry : Enemy_Battle_Cry
    if bc[battler.id] != nil and bc[battler.id][type] != nil
      base = bc[battler.id][type].dup
      sound = base[rand(base.size)]
      $game_system.se_play(RPG::AudioFile.new(sound[0], sound[1], sound[2]))
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Advanced Battlecry play
  #     battler : battler that will play the sound effect
  #     type    : type of the sound effect
  #     action  : action that will play the sound effect
  #--------------------------------------------------------------------------
  def battle_cry_advanced(battler, type, action)
    bc = battler.actor? ? Actor_Battle_Cry : Enemy_Battle_Cry
    if bc[battler.id] != nil and bc[battler.id][type] != nil
      if bc[battler.id][type][id] != nil
        base = bc[battler.id][type][id].dup
      else
        base = bc[battler.id][type]['BASE'].dup
      end
      sound = base[rand(base.size)].dup
      Audio.se_play('Audio/SE/' + sound[0], sound[1], sound[2])
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Sound effect check
  #     battler : battler that will play the sound effect
  #     type    : type of the sound effect
  #--------------------------------------------------------------------------
  def check_bc_basic(battler, type)
    bc = battler.actor? ? Actor_Battle_Cry : Enemy_Battle_Cry
    if bc[battler.id] != nil and bc[battler.id][type] != nil
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Battle Speed Modifier
  #--------------------------------------------------------------------------
  def battle_speed
    return 11 - [[Battle_Speed, 1].max, 10].min
  end
  #--------------------------------------------------------------------------
  # * Basic Update Processing
  #--------------------------------------------------------------------------
  def update_basic(input = true, player = false, map = false)
    Graphics.update
    Input.update if input
    $game_player.update if player
    $game_map.update if map
    $game_system.update
    $game_screen.update
    @spriteset.update if @spriteset != nil
    @message_window.update if @message_window != nil
  end
  #--------------------------------------------------------------------------
  # * Wait time
  #     duration : wait duration in frames
  #--------------------------------------------------------------------------
  def wait(duration)
    duration.times do
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # * Action ID verification
  #     action : action that will have the ID verified
  #--------------------------------------------------------------------------
  def action_id(action)
    return action.nil? ? 0 : action.id
  end
  #--------------------------------------------------------------------------
  # * Check if object is an numeric value
  #--------------------------------------------------------------------------
  def numeric?
    return false
  end
end

#==============================================================================
# ** Numeric
#------------------------------------------------------------------------------
# Class that handles numeric values.
#==============================================================================

class Numeric
  #--------------------------------------------------------------------------
  # * Check if object is an numeric value
  #--------------------------------------------------------------------------
  def numeric?
    return true
  end
end