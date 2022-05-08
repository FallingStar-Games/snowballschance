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


module Screen
  SnapShot_Key = Input::A # Q key
  @screen = Win32API.new 'screenshot', 'Screenshot', %w(l l l l p l l), ''
  @readini = Win32API.new 'kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 'l'
  @findwindow = Win32API.new 'user32', 'FindWindowA', %w(p p), 'l'
  module_function

  def shot(file = 'Screenshot_', typ = 2)
    
    Audio.se_play('Audio/SE/phshmash', 100, 100)
    
    typname = typ == 0 ? '.bmp' : typ == 1 ? '.jpg' : '.png'
    @file_index = 0
    @file_index += 1 while FileTest.exist?('Snapshots/' + file + @file_index.to_s + typname)
    file_name = 'Snapshots/' + file + @file_index.to_s + typname
    @screen.call(0,0,640,480,file_name,handel,typ)
  end

  def handel
    game_name = "\0" * 256
    @readini.call('Game', 'Title', '', game_name, 255, '.\Game.ini')
    game_name.delete!('\0')
    
    return @findwindow.call('RGSS Player',game_name)
  end
end

module Input
  class << self
    alias new_snop update
  end
  def self.update
    if Input.trigger?(Screen::SnapShot_Key)
      Screen.shot #hahaha, GET IT?
    end
    new_snop
  end
end