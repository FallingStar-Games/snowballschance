#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$game_system" for the instance of 
#  this class.
#
#  NOTE: REMEMBER TO GET THE FMOD LICENCE TO USE THIS!!
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Play Background Music
  #     bgm : background music to be played
  #--------------------------------------------------------------------------
############################################################################
#   ADDED pos (POSITION) AS PARAMETER TO METHOD
############################################################################
  def bgm_play(bgm, pos = 0)
    @playing_bgm = bgm
    if bgm != nil and bgm.name != ""
      Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch, pos)
############################################################################
    else
      Audio.bgm_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Memorize Background Music
  #--------------------------------------------------------------------------
  alias :fmodex_old_system_bgm_memorize :bgm_memorize unless $@
  def bgm_memorize
    fmodex_old_system_bgm_memorize
    @bgm_memorized_position = FMod::bgm_position
  end
  #--------------------------------------------------------------------------
  # * Restore Background Music
  #--------------------------------------------------------------------------
  def bgm_restore
############################################################################
#   ADDED @bgm_memorized_position AS PARAMETER TO METHOD
############################################################################
    bgm_play(@memorized_bgm, @bgm_memorized_position)
############################################################################
  end
  #--------------------------------------------------------------------------
  # * Play Background Sound
  #     bgs : background sound to be played
  #--------------------------------------------------------------------------
############################################################################
#   ADDED pos (POSITION) AS PARAMETER TO METHOD
############################################################################
  def bgs_play(bgs, pos = 0)
    @playing_bgs = bgs
    if bgs != nil and bgs.name != ""
      Audio.bgs_play("Audio/BGS/" + bgs.name, bgs.volume, bgs.pitch, pos)
############################################################################
    else
      Audio.bgs_stop
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Stop Background Sound
  #--------------------------------------------------------------------------
  def bgs_stop
    @playing_bgs = nil
    Audio.bgs_stop
  end
  #--------------------------------------------------------------------------
  # * Memorize Background Sound
  #--------------------------------------------------------------------------
  alias :fmodex_old_system_bgs_memorize :bgs_memorize unless $@
  def bgs_memorize
    fmodex_old_system_bgs_memorize
    @bgs_memorized_position = FMod::bgs_position
  end
  #--------------------------------------------------------------------------
  # * Restore Background Sound
  #--------------------------------------------------------------------------
  def bgs_restore
############################################################################
#   ADDED @bgs_memorized_position AS PARAMETER TO METHOD
############################################################################
    bgs_play(@memorized_bgs, @bgs_memorized_position)
############################################################################
  end
end