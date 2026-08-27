#==============================================================================
# Module Screen
#------------------------------------------------------------------------------
# Let you have the function Screenshot when press a button(F5)
# You must have screenshot.dll
#################################################################
# Screenshot V2
# Screenshot Script v1 & screenshot.dll v1 created by: Andreas21
# Screenshot Script v2 created/edited by: cybersam
# Numbered Images created/edited by: MauMau
#===============================================================================
#MKXP version based upon code used in pokemon essentials

  def shot(file = 'Screenshot_', typ = 2)
    
    Audio.se_play('Audio/SE/camera', 100, 100)
    
    typname = typ == 0 ? '.bmp' : typ == 1 ? '.jpg' : '.png'
    @file_index = 0
    @file_index += 1 while FileTest.exist?('Snapshots/' + file + @file_index.to_s + typname)
    file_name = 'Snapshots/' + file + @file_index.to_s + typname
    Graphics.screenshot(file_name) #the new one!
    #@screen.call(0,0,640,480,file_name,handel,typ)
    
        #show special message
    unless $scene.is_a?(Scene_Title) or $scene.is_a?(Scene_Splash)
      $game_temp.common_event_id = 45
    end

  end

  module Input
  class << self
    alias new_snop update
  end
  def self.update
    if Input.trigger?(Input::F5)
      #Keys.trigger?(Screen::SnapShot_Key) 
      shot #hahaha, GET IT?
    end
    new_snop
  end
end